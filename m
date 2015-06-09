From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4.5/8] blkcg, cfq-iosched: use GFP_NOWAIT instead of GFP_ATOMIC for non-critical allocations
Date: Tue, 09 Jun 2015 10:27:59 -0400
Message-ID: <x497frdt0r4.fsf@segfault.boston.devel.redhat.com>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
	<20150609042131.GN21465@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150609042131.GN21465-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org> (Tejun Heo's message of
	"Tue, 9 Jun 2015 13:21:31 +0900")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> From b848495d2c987e960d1f7794966d82c05fcefc6d Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Tue, 9 Jun 2015 13:19:40 +0900
>
> blkcg performs several allocations to track IOs per cgroup and enforce
> resource control.  Most of these allocations are performed lazily on
> demand in the IO path and thus can't involve reclaim path.  Currently,
> these allocations use GFP_ATOMIC; however, blkcg can gracefully deal
> with occassional failures of these allocations by punting IOs to the
> root cgroup and there's no reason to reach into the emergency reserve.
>
> This patch replaces GFP_ATOMIC with GFP_NOWAIT for the following
> allocations.
>
> * bdi_writeback_congested and blkcg_gq allocations in blkg_create().
>
> * radix tree node allocations for blkcg->blkg_tree.
>
> * cfq_queue allocation on ioprio changes.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Suggested-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Suggested-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks, Tejun!

Reviewed-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
