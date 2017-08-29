From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: Implement cgroup2 basic CPU usage accounting
Date: Tue, 29 Aug 2017 17:59:13 +0200
Message-ID: <20170829155913.4u2giegzujqidkog@hirez.programming.kicks-ass.net>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170811163754.3939102-4-tj@kernel.org>
 <20170829143252.6zoes63bwfflukjy@hirez.programming.kicks-ass.net>
 <20170829152426.GL491396@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3rSabnt4jk4PSRmkGYDViCviG6EzXy6+8hbmLLGwlBc=; b=FQ2VtusRq1vL8wwUHMkU8iCAs
        GlvfOZvfISQW5F7PZxaAvwA+MU0qqfBTMahARRpNjINdy5McaWDOuKjbQAsXvLTTBtLY5HzfnGAvR
        eTv1J9JnD2VWGmimoXg4T11sgf5tEZr3PCsbZc9VbYT/aCJSDaPrKJbiQvTqIDld99RLV0aaK0cIL
        IHkjDwa7Qn5qNJddn76F2/GPV2UPe3Z+Y63a8LHD3jZ0LKF3mQ+wLJL4za68VI63fdMyqGlzCqr1L
        1/a+H+MXIph7CGG+mu8s6Kimox4h5sIPOsW9jxmqczB6stwxyuu9n4thvAr+pHbQxU6YLMrS6KRmK
    
Content-Disposition: inline
In-Reply-To: <20170829152426.GL491396-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On Tue, Aug 29, 2017 at 08:24:27AM -0700, Tejun Heo wrote:
> Hello, Peter.
> 
> On Tue, Aug 29, 2017 at 04:32:52PM +0200, Peter Zijlstra wrote:
> > So I mostly like. On accounting it only adds to the immediate cgroup (if
> > it has a parent, aka !root).
> > 
> > On update it does a DFS of all sub-groups and propagates the deltas up
> > to the requested group.
> ...
> > What I don't get is why you need cgroup_cpu_stat_updated(). That is, I
> > see you use it to keep the keep the DFS 'stack' up-to-date, but what I
> > don't see is why you'd need that.
> 
> That is to make reading stats O(number of descendants which have been
> active since last read) instad of O(number of all descendants) as
> there can be a lot of not-too-active cgroups in a system.  Stat
> reading can be frequent, so the combination can get really bad.  By
> keeping the updated list separate, increasing read frequency decreases
> the cost of each read.

Hmm, and when its never read, we only do the O(depth) thing _once_,
right?
