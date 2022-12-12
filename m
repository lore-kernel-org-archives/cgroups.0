From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2 block/for-6.2] blk-iolatency: Make initialization lazy
Date: Mon, 12 Dec 2022 00:53:26 -0800
Message-ID: <Y5bsBuwjcbHEjhIw@infradead.org>
References: <Y5TQ5gm3O4HXrXR3@slm.duckdns.org>
 <Y5TRU2+s379DhUbj@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UihVLPIukW76e6Gh9tWRjReOJ5OZce6kDic8r4IuSmU=; b=qQfZ2XqQABCzgYROcbAC+dV6vV
        AzZ9femTZMLYhSeXz6ZMH3q3bLXKukUXNn60OdfWE5u5teHQXFA5JGlrFYflhYtplVeRn5uxxl7bO
        mS3bAHKx9NiXUyqNkMI8izrJgxpK4imqcuaw3MbPRBdkUYQFVzUtxNndISwnQanEDHy/Cak7W/pQ4
        VJWAo6B1+AH/stAEuUwC+Lx5mMvyDFWUfVFKgAUkn8t3SLCVGVLuRVSyzmnxdRWxjAgUOpB56mAOC
        3w0n7+9i6g6PCzuaoMZrgeAJFsEU822SKnduSJP+JWTrQbOgkCBEAQrM8fWZ4up4G2v55wXR8j8ld
        3iA0wyXQ==;
Content-Disposition: inline
In-Reply-To: <Y5TRU2+s379DhUbj@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, darklight2357@icloud.com, Josef Bacik <josef@toxicpanda.com>, Linus Torvalds <torvalds@linux-foundation.org>, cgroups@vger.kernel.org

> +static int blk_iolatency_try_init(char *input)
> +{
> +	static DEFINE_MUTEX(init_mutex);
> +	struct block_device *bdev;
> +	int ret = 0;
> +
> +	bdev = blkcg_conf_open_bdev(&input);
> +	if (IS_ERR(bdev))
> +		return PTR_ERR(bdev);

> +retry:
>  	ret = blkg_conf_prep(blkcg, &blkcg_policy_iolatency, buf, &ctx);
> +	if (ret == -EOPNOTSUPP) {
> +		ret = blk_iolatency_try_init(buf);

It's a little sad to do two block device lookups here (even if it
obviously doesn't matter for performance).  I wonder if it would
make sense to explicitly support the lazy init pattern
in blkg_conf_prep somehow.

Otherwise I'm all for the lazy init.
