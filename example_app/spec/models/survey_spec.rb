require 'spec_helper'

describe Survey do
  it { should validate_presence_of(:title) }
  it { should belong_to(:author).class_name('User') }
  it { should have_many(:completions) }
  it { should have_many(:questions) }
end

describe Survey, '#summarize' do
  it 'applies the given summarizer to each question' do
    questions = [build_stubbed(:question), build_stubbed(:question)]
    survey = build_stubbed(:survey, questions: questions)
    summarizer = stub('summarizer', summarize: 'result')

    result = survey.summarize(summarizer)

    should_summarize_questions questions, summarizer
    result.map(&:title).should == questions.map(&:title)
    result.map(&:value).should == %w(result result)
  end

  def should_summarize_questions(questions, summarizer)
    questions.each do |question|
      summarizer.should have_received(:summarize).with(question)
    end
  end
end
