From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/4] blk-throtl: don't warn in tg_drain_bios()
Date: Mon, 29 Nov 2021 03:46:45 -0800
Message-ID: <YaS9pfngMscOM3XA@infradead.org>
References: <20211127101059.477405-1-yukuai3@huawei.com>
 <20211127101059.477405-3-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FkF4T6LyDRZD+GT3vXQ9zF5ShtYF3Ys/OCkZGkfK2+Y=; b=05kuobI0TGEk0Qbh2JIN2BdBtk
        CqhqbxF/F4RxxjZmgIxQ17t05TFxBI2DIYlsZo+x2ZJBZ6oYxPf3BjASshWrwLLKP+L0Guy+RQX7P
        Iyj5dx5ilKdakTfO2dDgqmfzdDxXjBLlsUwQe5XC/ANV43WhIdFt5S+Bng0EhR37RcHIFJMWPUDu6
        +8bMZJe56139yfO0kXStJsbxFaCJ2ptvcc0hmjeMHboMOEGNVeXgXmULYCnmLbP64IROmon3Mg3aX
        CDd2NY0oDsu0UfseR0I4SmQ1JMH7BJzs/S9yyVe4uLoLtBmqoA0SXbbVFJn92CjE7cpV+6Eizj5Ii
        T6OCnfGw==;
Content-Disposition: inline
In-Reply-To: <20211127101059.477405-3-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sat, Nov 27, 2021 at 06:10:57PM +0800, Yu Kuai wrote:
> tg_drain_bios() will iterate until throtl_rb_first() return NULL,
> don't warn in such situation.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  block/blk-throttle.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 230e300c5856..25822c88bea1 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -497,12 +497,13 @@ static void throtl_pd_free(struct blkg_policy_data *pd)
>  }
>  
>  static struct throtl_grp *
> -throtl_rb_first(struct throtl_service_queue *parent_sq)
> +throtl_rb_first(struct throtl_service_queue *parent_sq, bool warn)
>  {
>  	struct rb_node *n;
>  
>  	n = rb_first_cached(&parent_sq->pending_tree);
> -	WARN_ON_ONCE(!n);
> +	if (warn)
> +		WARN_ON_ONCE(!n);
>  	if (!n)
>  		return NULL;

Just shift then WARN_ON_ONCE into the callers that care.
