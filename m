From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/5] writeback: fix bdi_writeback iteration in
 wakeup_dirtytime_writeback()
Date: Fri, 2 Oct 2015 16:12:55 +0200
Message-ID: <20151002141255.GB17746@quack.suse.cz>
References: <1443545274-18787-1-git-send-email-tj@kernel.org>
 <1443545274-18787-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443545274-18787-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue 29-09-15 12:47:51, Tejun Heo wrote:
> wakeup_dirtytime_writeback() walks and wakes up all wb's of all bdi's;
> unfortunately, it was always waking up bdi->wb instead of the wb being
> walked.  Fix it.

Looks good. You can add:

Reviewed-by: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

								Honza

> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Fixes: 001fe6f617b1 ("writeback: make wakeup_dirtytime_writeback() handle multiple bdi_writeback's")
> ---
>  fs/fs-writeback.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 091a364..d0da306 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1897,8 +1897,8 @@ static void wakeup_dirtytime_writeback(struct work_struct *w)
>  		struct wb_iter iter;
>  
>  		bdi_for_each_wb(wb, bdi, &iter, 0)
> -			if (!list_empty(&bdi->wb.b_dirty_time))
> -				wb_wakeup(&bdi->wb);
> +			if (!list_empty(&wb->b_dirty_time))
> +				wb_wakeup(wb);
>  	}
>  	rcu_read_unlock();
>  	schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
> -- 
> 2.4.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
