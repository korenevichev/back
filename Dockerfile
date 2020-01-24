FROM facesdk-ruby

RUN gem install bundler -v 2.0.1 \
	&& gem update --system \
	&& apt-get install -y libpng-dev \
	&& apt-get install -y zlib1g-dev \
	&& apt-get install -y libpq-dev

COPY . /application
WORKDIR /application
ENV RAILS_ENV development
RUN bundle install

ENTRYPOINT ./entrypoint.sh