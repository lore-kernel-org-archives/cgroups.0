From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/8] cfq-iosched: remove @gfp_mask from
 cfq_find_alloc_queue()
Date: Mon, 8 Jun 2015 17:19:30 -0400
Message-ID: <20150608211930.GA20918@redhat.com>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
 <1433753973-23684-6-git-send-email-tj@kernel.org>
 <x498ubuhulf.fsf@segfault.boston.devel.redhat.com>
 <x49sia2gd41.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <x49sia2gd41.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon, Jun 08, 2015 at 04:27:10PM -0400, Jeff Moyer wrote:
> Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> 
> > Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
> >
> >> Even when allocations fail, cfq_find_alloc_queue() always returns a
> >> valid cfq_queue by falling back to the oom cfq_queue.  As such, there
> >> isn't much point in taking @gfp_mask and trying "harder" if __GFP_WAIT
> >> is set.  GFP_ATOMIC allocations don't fail often and even when they do
> >> the degraded behavior is acceptable and temporary.
> >>
> >> After all, the only reason get_request(), which ultimately determines
> >> the gfp_mask, cares about __GFP_WAIT is to guarantee request
> >> allocation, assuming IO forward progress, for callers which are
> >> willing to wait.  There's no reason for cfq_find_alloc_queue() to
> >> behave differently on __GFP_WAIT when it already has a fallback
> >> mechanism.
> >>
> >> Remove @gfp_mask from cfq_find_alloc_queue() and propagate the changes
> >> to its callers.  This simplifies the function quite a bit and will
> >> help making async queues per-cfq_group.
> >
> > Sorry, I disagree with this patch.  You've changed it so that all cfqq
> > allocations are GFP_ATOMIC, and most, if not all of them simply don't
> > need to be.
> 
> It occurs to me that replacing GFP_ATOMIC with GFP_NOWAIT in your patch
> would address my concerns, and patches 6-8 would apply almost as-is.
> What do you think about that?

Whatever we end up using, may be it is a good idea to use same policy
for block group allocation too. Right now we use GFP_ATOMIC for blkcg
allocation.

So this will be equivalent of that when memory is low, we don't provide
service differentiation.

Thanks
Vivek
