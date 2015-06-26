From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/6] blkcg: add blkg_[rw]stat->aux_cnt and replace
 cfq_group->dead_stats with it
Date: Fri, 26 Jun 2015 09:35:40 -0400
Message-ID: <20150626133540.GA15805@mtj.duckdns.org>
References: <1435268337-1738-1-git-send-email-tj@kernel.org>
 <1435268337-1738-3-git-send-email-tj@kernel.org>
 <20150626132702.GA14803@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ujSRraNih0b7RyQlGB+4Q0M5EmLTO9aAxoVEdtybM5s=;
        b=Lxdki+w30Mxlvau6hUFx4xirP0JKFyo9ZrVOke/XocWC6xJn/dSAQpLlWLnGtfEkPp
         /m6PVRIi3P1BLLnfSXMyujOFYuziNkT+b5XQxIAV+43HfHo2PBIg6BD6nDTnuSF1a9oY
         R8BnIMxeqMarFzeyCGauYSPZBtwR3Of3gPb+ZcFbqK+9rcvfQRpHThhqMx17vyXV00yX
         0UT8H1y3060BndHKefttZJzSRYHyZCERmIrLXNInKBoJXAr7MHIVdVBt/0LcUxdWO7Mz
         3gF8jLV4xD4JLCeERmel5s0icDjS0knbhauCk8ommY2Utj4PmEymdrxP7Y0ZiwEyChOw
         Sfng==
Content-Disposition: inline
In-Reply-To: <20150626132702.GA14803-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Jun 26, 2015 at 09:27:02AM -0400, Vivek Goyal wrote:
> On Thu, Jun 25, 2015 at 05:38:53PM -0400, Tejun Heo wrote:
> 
> [..]
> > It's planned that the core stats will be moved to blkcg_gq, so we want
> > to move the mechanism for keeping track of the stats of dead children
> > from cfq to blkcg core.  This patch adds blkg_[rw]stat->aux_cnt which
> > are atomic64_t's keeping track of auxiliary counts which are excluded
> > when reading local counts but included for recursive.
> 
> Hi Tejun,
> 
> So aux_cnt is atomic64_t as updation is not the hot path hence there is
> not much value in keeping it as per cpu?

I'm not following.  aux_cnt isn't per-cpu.

Thanks.

-- 
tejun
