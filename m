From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/8] cfq-iosched: remove @gfp_mask from
 cfq_find_alloc_queue()
Date: Tue, 9 Jun 2015 12:00:54 +0900
Message-ID: <20150609030054.GJ21465@mtj.duckdns.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
 <1433753973-23684-6-git-send-email-tj@kernel.org>
 <x498ubuhulf.fsf@segfault.boston.devel.redhat.com>
 <x49sia2gd41.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=omFi6wbnj8XXe0wOhWsAfh9ySeB88ae2cBAo6q/1l7Y=;
        b=lzkLlg/4tGNw4VBbAw8CWkdt7c/a/PSFq+UmOil3Ggtn+Rfh2sqcGpYaIZaLTFomUB
         X7VVk0pQGELgWb2xAcUtBOVkBBLla+5NsfwBaaVTDlUcQX2S1Bj/vaJyz3oEk4NDuUdx
         VjWOSLZ0j6KKAD85HVK+HKBBxhoQ5ad14vz+KO8rKfEVweHDTYAFsK1KeZJdYSqD80IA
         ynpZBfMGLAqgzzVICNz2q33zYt16xV24qu+flBFvJ9bJOJ2yvMypj0802qERSG6+hwCq
         b4mQSzLuSyEOb0C+DsJ2/jClwABwFhFpExXC86X9ZTMEA+VdBXMclkbIFjYp5YaqAONn
         FKZw==
Content-Disposition: inline
In-Reply-To: <x49sia2gd41.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hey, Jeff.

On Mon, Jun 08, 2015 at 04:27:10PM -0400, Jeff Moyer wrote:
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

Oh yeah, it's okay to fail these allocations under memory pressure.
GFP_NOWAIT is the better pick here.  It's GFP_ATOMIC mostly due to
historic copy&paste anyway.  I'll change them to GFP_NOWAIT.

Thanks.

-- 
tejun
