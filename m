From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/5] mm: hide laptop_mode_wb_timer entirely behind the
 BDI API
Date: Mon, 9 Aug 2021 17:10:48 +0200
Message-ID: <20210809151048.GE30319@quack2.suse.cz>
References: <20210809141744.1203023-1-hch@lst.de>
 <20210809141744.1203023-2-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1628521851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=atlo+NKpDCTCwZ+7e0Seb6ZvJdkbk7+6VcZA+tEAelY=;
        b=c/zsLCNQKeumCIxTiEcdWgfEDGcQHDy91K994MFxGQ4076JkmRJZlYy8Pma2zcJoGNt73A
        +vjbUfTuU6Pl5Thm5zvxkFVY2fYtIKGsrDmAxnbqDLT+cZtc9qgNh+lM8L7NcNNS2ZJL1w
        ZzOCvYkKEeCQ2KLICXZWRuoH7mr94b0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1628521851;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=atlo+NKpDCTCwZ+7e0Seb6ZvJdkbk7+6VcZA+tEAelY=;
        b=Dwdl7Ioju78ovvw3zBk5O60RylkYJghFcimUW6fMrUywG8vev4HpLDT8neW8a5v/GqlI9a
        xSkpv15AFa2NQwBA==
Content-Disposition: inline
In-Reply-To: <20210809141744.1203023-2-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon 09-08-21 16:17:40, Christoph Hellwig wrote:
> Don't leak the deta=D1=96ls of the timer into the block layer, instead
> initialize the timer in bdi_alloc and delete it in bdi_unregister.
> Note that this means the timer is initialized (but not armed) for
> non-block queues as well now.
>=20
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  block/blk-core.c    | 5 -----
>  mm/backing-dev.c    | 3 +++
>  mm/page-writeback.c | 2 --
>  3 files changed, 3 insertions(+), 7 deletions(-)
>=20
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 04477697ee4b..5897bc37467d 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -394,10 +394,7 @@ void blk_cleanup_queue(struct request_queue *q)
>  	/* for synchronous bio-based driver finish in-flight integrity i/o */
>  	blk_flush_integrity();
> =20
> -	/* @q won't process any more request, flush async actions */
> -	del_timer_sync(&q->backing_dev_info->laptop_mode_wb_timer);
>  	blk_sync_queue(q);
> -
>  	if (queue_is_mq(q))
>  		blk_mq_exit_queue(q);
> =20
> @@ -546,8 +543,6 @@ struct request_queue *blk_alloc_queue(int node_id)
> =20
>  	atomic_set(&q->nr_active_requests_shared_sbitmap, 0);
> =20
> -	timer_setup(&q->backing_dev_info->laptop_mode_wb_timer,
> -		    laptop_mode_timer_fn, 0);
>  	timer_setup(&q->timeout, blk_rq_timed_out_timer, 0);
>  	INIT_WORK(&q->timeout_work, blk_timeout_work);
>  	INIT_LIST_HEAD(&q->icq_list);
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index f5561ea7d90a..cd06dca232c3 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -807,6 +807,7 @@ struct backing_dev_info *bdi_alloc(int node_id)
>  	bdi->capabilities =3D BDI_CAP_WRITEBACK | BDI_CAP_WRITEBACK_ACCT;
>  	bdi->ra_pages =3D VM_READAHEAD_PAGES;
>  	bdi->io_pages =3D VM_READAHEAD_PAGES;
> +	timer_setup(&bdi->laptop_mode_wb_timer, laptop_mode_timer_fn, 0);
>  	return bdi;
>  }
>  EXPORT_SYMBOL(bdi_alloc);
> @@ -928,6 +929,8 @@ static void bdi_remove_from_list(struct backing_dev_i=
nfo *bdi)
> =20
>  void bdi_unregister(struct backing_dev_info *bdi)
>  {
> +	del_timer_sync(&bdi->laptop_mode_wb_timer);
> +
>  	/* make sure nobody finds us on the bdi_list anymore */
>  	bdi_remove_from_list(bdi);
>  	wb_shutdown(&bdi->wb);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 9f63548f247c..c12f67cbfa19 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2010,7 +2010,6 @@ int dirty_writeback_centisecs_handler(struct ctl_ta=
ble *table, int write,
>  	return ret;
>  }
> =20
> -#ifdef CONFIG_BLOCK
>  void laptop_mode_timer_fn(struct timer_list *t)
>  {
>  	struct backing_dev_info *backing_dev_info =3D
> @@ -2045,7 +2044,6 @@ void laptop_sync_completion(void)
> =20
>  	rcu_read_unlock();
>  }
> -#endif
> =20
>  /*
>   * If ratelimit_pages is too high then we can get into dirty-data overlo=
ad
> --=20
> 2.30.2
>=20
--=20
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
