From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/5] writeback: laptop_mode_timer_fn() needs
 rcu_read_lock() around bdi_writeback iteration
Date: Fri, 2 Oct 2015 16:13:24 +0200
Message-ID: <20151002141324.GC17746@quack.suse.cz>
References: <1443545274-18787-1-git-send-email-tj@kernel.org>
 <1443545274-18787-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443545274-18787-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue 29-09-15 12:47:50, Tejun Heo wrote:
> laptop_mode_timer_fn() was using bdi_for_each_wb() without the
> required RCU locking leading to the following warning.
> 
>  WARNING: CPU: 0 PID: 0 at include/linux/backing-dev.h:415 laptop_mode_timer_fn+0x106/0x170()
>  ...
>  Call Trace:
>   <IRQ>  [<ffffffff81480cdc>] dump_stack+0x4e/0x82
>   [<ffffffff81051912>] warn_slowpath_common+0x82/0xc0
>   [<ffffffff81051a0a>] warn_slowpath_null+0x1a/0x20
>   [<ffffffff8115f0e6>] laptop_mode_timer_fn+0x106/0x170
>   [<ffffffff810ca8e3>] call_timer_fn+0xb3/0x2f0
>   [<ffffffff810cad25>] run_timer_softirq+0x205/0x370
>   [<ffffffff81056854>] __do_softirq+0xd4/0x460
>   [<ffffffff81056d69>] irq_exit+0x89/0xa0
>   [<ffffffff8185a892>] smp_apic_timer_interrupt+0x42/0x50
>   [<ffffffff81858a44>] apic_timer_interrupt+0x84/0x90
>  ...
> 
> Fix it by adding rcu_read_lock() around the iteration.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Fixes: a06fd6b10228 ("writeback: make laptop_mode_timer_fn() handle multiple bdi_writeback's")

Looks good. You can add:

Reviewed-by: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

								Honza
> ---
>  mm/page-writeback.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 0a931cd..902e5f2 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1965,10 +1965,12 @@ void laptop_mode_timer_fn(unsigned long data)
>  	if (!bdi_has_dirty_io(&q->backing_dev_info))
>  		return;
>  
> +	rcu_read_lock();
>  	bdi_for_each_wb(wb, &q->backing_dev_info, &iter, 0)
>  		if (wb_has_dirty_io(wb))
>  			wb_start_writeback(wb, nr_pages, true,
>  					   WB_REASON_LAPTOP_TIMER);
> +	rcu_read_unlock();
>  }
>  
>  /*
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
