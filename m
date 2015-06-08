From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/8] cfq-iosched: remove @gfp_mask from cfq_find_alloc_queue()
Date: Mon, 08 Jun 2015 15:24:12 -0400
Message-ID: <x498ubuhulf.fsf@segfault.boston.devel.redhat.com>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
	<1433753973-23684-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433753973-23684-6-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> (Tejun Heo's
	message of "Mon, 8 Jun 2015 17:59:30 +0900")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> Even when allocations fail, cfq_find_alloc_queue() always returns a
> valid cfq_queue by falling back to the oom cfq_queue.  As such, there
> isn't much point in taking @gfp_mask and trying "harder" if __GFP_WAIT
> is set.  GFP_ATOMIC allocations don't fail often and even when they do
> the degraded behavior is acceptable and temporary.
>
> After all, the only reason get_request(), which ultimately determines
> the gfp_mask, cares about __GFP_WAIT is to guarantee request
> allocation, assuming IO forward progress, for callers which are
> willing to wait.  There's no reason for cfq_find_alloc_queue() to
> behave differently on __GFP_WAIT when it already has a fallback
> mechanism.
>
> Remove @gfp_mask from cfq_find_alloc_queue() and propagate the changes
> to its callers.  This simplifies the function quite a bit and will
> help making async queues per-cfq_group.

Sorry, I disagree with this patch.  You've changed it so that all cfqq
allocations are GFP_ATOMIC, and most, if not all of them simply don't
need to be.

I'll take it one step further and suggest that we should fix
cfq_find_alloc_queue to pass the gfp_mask to check_ioprio_changed.  That
also shouldn't be using GFP_ATOMIC unconditionally.

NAK

-Jeff
