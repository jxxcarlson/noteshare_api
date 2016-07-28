require 'spec_helper'


describe DocumentRepository do

  before do
    DocumentRepository.clear
  end

  it 'can find a document by title (t1)' do
    document = NSDocument.new(title: 'Hydrogen', text: 'The lightest element', tags: ['chemistry', 'periodic table'], user_id: 1)
    DocumentRepository.create document
    document2 = DocumentRepository.find_one_by_title 'Hydrogen'
    assert document2.title == 'Hydrogen', 'Document found by title'
  end

  it 'can do a fuzzy find by title (t2)' do

    document = NSDocument.new(title: 'Hydrogen', text: 'The lightest element', tags: ['chemistry', 'periodic table'], user_id: 1)
    DocumentRepository.create document
    documents = DocumentRepository.fuzzy_find_by_title 'hy'
    assert documents.first.title == 'Hydrogen', 'Document found by title'
  end

  it 'can find a document by tag (t3)' do
    document = NSDocument.new(title: 'Hydrogen', text: 'The lightest element', tags: ['chemistry', 'periodic table'], user_id: 1)
    DocumentRepository.create document
    documents = DocumentRepository.find_by_tag 'chemistry'
    assert documents.count == 1, 'Document found by tag'
  end

  it 'can find a document by dict (t4)' do
    document = NSDocument.new(title: 'Hydrogen', text: 'The lightest element', dict: {'foo': 'bar'}, user_id: 1)
    DocumentRepository.create document
    documents = DocumentRepository.find_by_dict 'foo', 'bar'
    assert documents.count == 1, 'Document found by tag'
  end

end


