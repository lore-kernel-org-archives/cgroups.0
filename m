From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v7 1/2] blk-throtl: introduce a new flag
 THROTL_TG_CANCELING
Date: Mon, 7 Feb 2022 16:15:06 +0800
Message-ID: <YgDVCjkjJe1CSVxv@T590>
References: <20220128084522.3169961-1-yukuai3@huawei.com>
 <20220128084522.3169961-2-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644221750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fZCtKdGV/PdaGul2Xel2hTCDnJYx95E5j/0H+d54vhM=;
        b=cYdCKnvXBL9hcdC9e+tOr2P3CvH5Wpdbtu8hne1S5HsOKlVVpe3to3DMMeJhhTp0FoY2Am
        Uo9qW5metTSSb1yVDkvMiO08oFio5lqIDMLslgPLAn3xt/xNNd5fwkIyOFo+A8OmI3NLif
        oyWQ0nOC3sTeYwquzV/hFfcIJN8WQoA=
Content-Disposition: inline
In-Reply-To: <20220128084522.3169961-2-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Fri, Jan 28, 2022 at 04:45:21PM +0800, Yu Kuai wrote:
> If the new flag is set, then the throtl_grp will stop throttling bios.
> Prepare to canceling all throttled bios if the disk is gone.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  block/blk-throttle.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 7c462c006b26..abc5e506c72d 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -43,8 +43,12 @@
>  static struct workqueue_struct *kthrotld_workqueue;
>  
>  enum tg_state_flags {
> -	THROTL_TG_PENDING	= 1 << 0,	/* on parent's pending tree */
> -	THROTL_TG_WAS_EMPTY	= 1 << 1,	/* bio_lists[] became non-empty */
> +	/* on parent's pending tree */
> +	THROTL_TG_PENDING	= 1 << 0,
> +	/* bio_lists[] became non-empty */
> +	THROTL_TG_WAS_EMPTY	= 1 << 1,
> +	/* starts to cancel all bios, will be set if the disk is deleted */
> +	THROTL_TG_CANCELING	= 1 << 2,
>  };
>  
>  #define rb_entry_tg(node)	rb_entry((node), struct throtl_grp, rb_node)
> @@ -871,7 +875,8 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
>  	       bio != throtl_peek_queued(&tg->service_queue.queued[rw]));
>  
>  	/* If tg->bps = -1, then BW is unlimited */
> -	if (bps_limit == U64_MAX && iops_limit == UINT_MAX) {
> +	if ((bps_limit == U64_MAX && iops_limit == UINT_MAX) ||
> +	    tg->flags & THROTL_TG_CANCELING) {
>  		if (wait)
>  			*wait = 0;
>  		return true;
> @@ -974,6 +979,9 @@ static void tg_update_disptime(struct throtl_grp *tg)
>  	unsigned long read_wait = -1, write_wait = -1, min_wait = -1, disptime;
>  	struct bio *bio;
>  
> +	if (tg->flags & THROTL_TG_CANCELING)
> +		goto update;
> +

The above change and the following one in tg_update_disptime() isn't
needed actually.

Also I'd suggest to fold the two into one patch.


Thanks,
Ming

