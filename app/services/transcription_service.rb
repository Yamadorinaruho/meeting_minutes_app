# frozen_string_literal: true

class TranscriptionService
  class Error < StandardError; end

  def initialize(meeting_minute)
    @meeting_minute = meeting_minute
  end

  def call
    validate_audio!
    validate_api_key!

    @meeting_minute.update!(transcription_status: :processing)

    transcription = transcribe_audio
    @meeting_minute.update!(
      transcription: transcription,
      transcription_status: :completed
    )

    transcription
  rescue Error => e
    @meeting_minute.update!(transcription_status: :failed)
    Rails.logger.error("Transcription failed: #{e.message}")
    raise
  rescue StandardError => e
    @meeting_minute.update!(transcription_status: :failed)
    Rails.logger.error("Transcription failed: #{e.message}")
    raise Error, e.message
  end

  private

  def validate_audio!
    raise Error, "音声ファイルがありません" unless @meeting_minute.audio.attached?
  end

  def validate_api_key!
    raise Error, "GEMINI_API_KEY が設定されていません" if api_key.blank?
  end

  def api_key
    ENV.fetch("GEMINI_API_KEY", "AIzaSyDnGcN8a5MYKwA4FyUxV6RAvEmKypEg330")
  end

  def transcribe_audio
    # 音声ファイルをダウンロード
    audio_data = @meeting_minute.audio.download
    content_type = @meeting_minute.audio.content_type

    # Gemini クライアントを初期化
    client = Gemini.new(
      credentials: { service: "generative-language-api", api_key: api_key },
      options: { model: "gemini-2.0-flash-exp", server_sent_events: true }
    )

    # Base64エンコード
    base64_audio = Base64.strict_encode64(audio_data)

    # 音声ファイルを送信して文字起こし
    result = client.generate_content({
      contents: [
        {
          role: "user",
          parts: [
            {
              inline_data: {
                mime_type: content_type,
                data: base64_audio
              }
            },
            {
              text: <<~PROMPT
                この音声を文字起こししてください。
                以下のフォーマットで出力してください：
                - 話者が識別できる場合は「話者A:」「話者B:」のように表記
                - 話者が識別できない場合はそのまま文字起こし
                - 句読点を適切に入れる
                - 段落分けを適切に行う
              PROMPT
            }
          ]
        }
      ]
    })

    # レスポンスからテキストを抽出
    extract_text(result)
  end

  def extract_text(result)
    return "" if result.nil?

    if result.is_a?(Array)
      result.map { |r| extract_text(r) }.join
    elsif result.is_a?(Hash)
      if result.dig("candidates", 0, "content", "parts", 0, "text")
        result.dig("candidates", 0, "content", "parts", 0, "text")
      elsif result["text"]
        result["text"]
      else
        ""
      end
    else
      result.to_s
    end
  end
end
