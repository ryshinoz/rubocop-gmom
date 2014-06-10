require 'spec_helper'

describe RuboCop::Cop::Style::NoSpaceInsideBlockPipes do
  subject(:cop) { RuboCop::Cop::Style::NoSpaceInsideBlockPipes.new }

  context 'ブロック内に仮引数がない場合' do
    it '違反は見つからない' do
      inspect_source(cop, ['before_validation do',
                           ' if resource',
                           '   puts resource',
                           ' end',
                           'end'])
      expect(cop.offenses.size).to eq(0)
    end
  end


  context '左の|の後ろに半角スペースがある場合' do
    context '{}' do
      it '違反が見つかる' do
        inspect_source(cop, ['[1, 2, 3].each { | item, ab| p item }'])
        expect(cop.offenses.size).to eq(1)
        expect(cop.messages).to eq(['Space inside | (left) detected.'])
      end
    end

    context 'do-end' do
      it '違反が見つかる' do
        inspect_source(cop, ['Proc.new do | x, string|',
                             '  p string * x',
                             'end'])
        expect(cop.offenses.size).to eq(1)
        expect(cop.messages).to eq(['Space inside | (left) detected.'])
      end
    end
  end

  context '右の|の前に半角スペースがある場合' do
    context '{}' do
      it '違反が見つかる' do
        inspect_source(cop, ['[1, 2, 3].each { |item, ab | p item }'])
        expect(cop.offenses.size).to eq(1)
        expect(cop.messages).to eq(['Space inside | (right) detected.'])
      end
    end

    context 'do-end' do
      it '違反が見つかる' do
        inspect_source(cop, ['Proc.new do |x, string |',
                             '  p string * x',
                             'end'])
        expect(cop.offenses.size).to eq(1)
        expect(cop.messages).to eq(['Space inside | (right) detected.'])
      end
    end
  end

  context '左と|の後に右の|の前に半角スペースがある' do
    context '{}' do
      it '違反が見つかる' do
        inspect_source(cop, ['[1, 2, 3].each { | item, ab | p item }'])
        expect(cop.offenses.size).to eq(2)
        expect(cop.messages).to eq(['Space inside | (left) detected.', 'Space inside | (right) detected.'])
      end
    end
    context 'do-end' do
      it '違反が見つかる' do
        inspect_source(cop, ['Proc.new do |  x, string |',
                             '  p string * x',
                             'end'])
        expect(cop.offenses.size).to eq(2)
        expect(cop.messages).to eq(['Space inside | (left) detected.', 'Space inside | (right) detected.'])
      end
    end
  end

  context '正常な場合' do
    context '{}' do
      it '違反は見つからない' do
        inspect_source(cop, ['[1, 2, 3].each { |item, ab| p item }'])
        expect(cop.offenses.size).to eq(0)
      end
    end

    context 'do-end' do
      it '違反が見つからない' do
        inspect_source(cop, ['Proc.new do |x, string|',
                             '  p string * x',
                             'end'])
        expect(cop.offenses.size).to eq(0)
      end
    end
  end
end
