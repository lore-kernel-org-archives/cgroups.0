From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 1/2] blk-throtl: move WARN_ON_ONCE() from
 throtl_rb_first() to it's caller
Date: Mon, 29 Nov 2021 22:43:13 -0800
Message-ID: <YaXIAaMRG7J0sHib@infradead.org>
References: <20211130011730.2584339-1-yukuai3@huawei.com>
 <20211130011730.2584339-2-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LbNjrOn/TR2DrlvunPAnXmZeUtVG1jTEm/amQL+7ym4=; b=uwQm3elvRY63sSd28fQaOo6GSO
        qwcqB7PI3Ee+ZNwfoKvARal12tj6fXqox/uqPWdZWzgjas0nWpkw2DPFGmLwha8f6qLIZbmiU5ykM
        SFCaAlohCL+RqZoejpKVHS64SiqmklbW5mzgofKxuzyCAoFPOOGi/OP6zJyvfCy8BaZ2kqRbnhFeP
        zc7DjA4qJa1Y1GmVqwL825mt9Tpok0yOWV1yqzj5ij4/yWqj0xlAtC6rqJqrJQBQBohzjZctdytMr
        iU2HwGIBPSGgPyisnozso/6UaFFR0sigr/lE9CFLBbBqFR3zHbYVv20DJCryAVAQO3YvclMdml6kr
        19EJViHA==;
Content-Disposition: inline
In-Reply-To: <20211130011730.2584339-2-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue, Nov 30, 2021 at 09:17:29AM +0800, Yu Kuai wrote:
> Prepare to reintroduce tg_drain_bios(), which will iterate until
> throtl_rb_first() return NULL.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  block/blk-throttle.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 39bb6e68a9a2..f7244190cb2f 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -502,7 +502,6 @@ throtl_rb_first(struct throtl_service_queue *parent_sq)
>  	struct rb_node *n;
>  
>  	n = rb_first_cached(&parent_sq->pending_tree);
> -	WARN_ON_ONCE(!n);
>  	if (!n)
>  		return NULL;
>  	return rb_entry_tg(n);
> @@ -521,8 +520,10 @@ static void update_min_dispatch_time(struct throtl_service_queue *parent_sq)
>  	struct throtl_grp *tg;
>  
>  	tg = throtl_rb_first(parent_sq);
> -	if (!tg)
> +	if (!tg) {
> +		WARN_ON_ONCE(1);
>  		return;

	if (WARN_ON_ONCE(!tg))
		return;

>  		tg = throtl_rb_first(parent_sq);
> -		if (!tg)
> +		if (!tg) {
> +			WARN_ON_ONCE(1);
>  			break;
> +		}

Same here.
