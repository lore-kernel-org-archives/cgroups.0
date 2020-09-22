From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 04/13] aoe: set an optimal I/O size
Date: Tue, 22 Sep 2020 10:45:17 +0200
Message-ID: <20200922084517.GB16464@quack2.suse.cz>
References: <20200921080734.452759-1-hch@lst.de>
 <20200921080734.452759-5-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200921080734.452759-5-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Coly Li <colyli@suse.de>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Justin Sanders <justin@coraid.com>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Mon 21-09-20 10:07:25, Christoph Hellwig wrote:
> aoe forces a larger readahead size, but any reason to do larger I/O
> is not limited to readahead.  Also set the optimal I/O size, and
> remove the local constants in favor of just using SZ_2G.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/block/aoe/aoeblk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
> index 5ca7216e9e01f3..d8cfc233e64b93 100644
> --- a/drivers/block/aoe/aoeblk.c
> +++ b/drivers/block/aoe/aoeblk.c
> @@ -347,7 +347,6 @@ aoeblk_gdalloc(void *vp)
>  	mempool_t *mp;
>  	struct request_queue *q;
>  	struct blk_mq_tag_set *set;
> -	enum { KB = 1024, MB = KB * KB, READ_AHEAD = 2 * MB, };
>  	ulong flags;
>  	int late = 0;
>  	int err;
> @@ -407,7 +406,8 @@ aoeblk_gdalloc(void *vp)
>  	WARN_ON(d->gd);
>  	WARN_ON(d->flags & DEVFL_UP);
>  	blk_queue_max_hw_sectors(q, BLK_DEF_MAX_SECTORS);
> -	q->backing_dev_info->ra_pages = READ_AHEAD / PAGE_SIZE;
> +	q->backing_dev_info->ra_pages = SZ_2M / PAGE_SIZE;
> +	blk_queue_io_opt(q, SZ_2M);
>  	d->bufpool = mp;
>  	d->blkq = gd->queue = q;
>  	q->queuedata = d;
> -- 
> 2.28.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
