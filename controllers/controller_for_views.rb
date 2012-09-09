get '/home' do
	@tags=Tag.all
	@article_list=Block.where(:ParentId=>nil,:Type=>"topic").sort(Updated_on: -1).to_a
	@current_user=session[:current_user]
	haml :home
end

get '/tags/:id' do
	@tags=Tag.all
	@current_user=session[:current_user]
	id=params[:id]
	block_ids=[]
	BlockTag.where(:TagId=>id).all.each do |bt|
		block_ids<<bt.BlockId
	end
	@article_list=Block.in(:Id=>block_ids).all
	haml :home
end

get '/new' do
	@current_user=session[:current_user]
	@tags=Tag.all	
	haml :new
end

get '/post/:id' do
	@current_user=session[:current_user]
	@tags=Tag.all
	@id=params[:id]
	block=Block.where(:Id=>@id).first
	if @current_user
		@is_author=(@current_user.Id.to_s==block.AuthorId.to_s)
	else
		@is_author=false
	end
	haml :post
end

get '/view_article/:id' do
	@current_user=session[:current_user]
	@tags=Tag.all
	@id=params[:id]	
	block=Block.where(:Id=>@id).first
	@title=block.Subject
	@html="<div class=\"component\">"+block.Body+"</div>\n"
	Block.where(:ParentId=>@id).all.sort(Order: 1).each do |block|
		@html=@html+"<div class=\"component\">"+block.Body+"</div>\n"
	end
	haml :view_article
end

get '/edit_post/:id' do
	@current_user=session[:current_user]
	@tags=Tag.all
	@id=params[:id]
	@block=Block.where(:Id=>@id).first
	@tag_string=BlockTag.where(:BlockId=>@id).all.to_a.collect{|bt| Tag.where(:Id=>bt.TagId).first.Name}.join(",")
	haml :edit
end