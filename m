From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/8] cfq-iosched: charge async IOs to the appropriate blkcg's instead of the root
Date: Tue, 09 Jun 2015 11:03:15 -0400
Message-ID: <x49pp54sz4c.fsf@segfault.boston.devel.redhat.com>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
	<1433753973-23684-9-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433753973-23684-9-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> (Tejun Heo's
	message of "Mon, 8 Jun 2015 17:59:33 +0900")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> Up until now, all async IOs were queued to async queues which are
> shared across the whole request_queue, which means that blkcg resource
> control is completely void on async IOs including all writeback IOs.
> It was done this way because writeback didn't support writeback and
> there was no way of telling which writeback IO belonged to which
> cgroup; however, writeback recently became cgroup aware and writeback
> bio's are sent down properly tagged with the blkcg's to charge them
> against.
>
> This patch makes async cfq_queues per-cfq_cgroup instead of
> per-cfq_data so that each async IO is charged to the blkcg that it was
> tagged for instead of unconditionally attributing it to root.
>
> * cfq_data->async_cfqq and ->async_idle_cfqq are moved to cfq_group
>   and alloc / destroy paths are updated accordingly.
>
> * cfq_link_cfqq_cfqg() no longer overrides @cfqg to root for async
>   queues.
>
> * check_blkcg_changed() now also invalidates async queues as they no
>   longer stay the same across cgroups.
>
> After this patch, cfq's proportional IO control through blkio.weight
> works correctly when cgroup writeback is in use.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
