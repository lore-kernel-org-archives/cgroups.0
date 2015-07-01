From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 44/51] writeback: implement bdi_wait_for_completion()
Date: Wed, 1 Jul 2015 18:09:18 +0200
Message-ID: <20150701160918.GH7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-45-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-45-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Fri 22-05-15 17:13:58, Tejun Heo wrote:
> If the completion of a wb_writeback_work can be waited upon by setting
> its ->done to a struct completion and waiting on it; however, for
> cgroup writeback support, it's necessary to issue multiple work items
> to multiple bdi_writebacks and wait for the completion of all.
> 
> This patch implements wb_completion which can wait for multiple work
> items and replaces the struct completion with it.  It can be defined
> using DEFINE_WB_COMPLETION_ONSTACK(), used for multiple work items and
> waited for by wb_wait_for_completion().
> 
> Nobody currently issues multiple work items and this patch doesn't
> introduce any behavior changes.

One more thing...

> @@ -161,17 +178,34 @@ static void wb_queue_work(struct bdi_writeback *wb,
>  	trace_writeback_queue(wb->bdi, work);
>  
>  	spin_lock_bh(&wb->work_lock);
> -	if (!test_bit(WB_registered, &wb->state)) {
> -		if (work->done)
> -			complete(work->done);
> +	if (!test_bit(WB_registered, &wb->state))
>  		goto out_unlock;

This seems like a change in behavior. Previously unregistered wbs just
completed the work->done, now you don't complete them. Is that intentional?

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
