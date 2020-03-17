From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2] sched/cpuset: distribute tasks within affinity masks
Date: Tue, 17 Mar 2020 20:24:01 +0100
Message-ID: <20200317192401.GE20713@hirez.programming.kicks-ass.net>
References: <20200311010113.136465-1-joshdon@google.com>
 <20200311140533.pclgecwhbpqzyrks@e107158-lin.cambridge.arm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mAb+lK7uiT3ldfeyyLr+kiJibGSBEZhmuX8jrROVGvY=; b=PAbRC8UmjK7Da14hi1EjiZgSxx
        OJRb1TNOFcCb3HMABHjCPKeA3tNzE65fqpxKqBfpRMZgbEAtyeOdEUN+lldTC9RLL0CRyv/FQlYkY
        sTUZV7l8ATDLVp7AONiHPY/pOfUEHfAAdD1MflfG/6rrOh7U1Z7X5MSGybuzH0jcGAXKIkyzGbmlB
        QT9AqrsOjzxsUIJFkgcgNWYBElbplhROrg+e2XL4t9HXeOjtdB53nyTTUiAly3t6dBYnRUx8/7mN2
        OpzxuPZW7p0gldx7C4DHpql4wTFKFPeuHONP62ioXdZLtS4YNuGsJgf6aQ1j2x1/i4Pm13KQQ/CRT
        F5AfgwqQ==;
Content-Disposition: inline
In-Reply-To: <20200311140533.pclgecwhbpqzyrks-AIE2tiYzwxrZROr8t4l/smS4ubULX0JqMm0uRHvK7Nw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
Cc: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Mar 11, 2020 at 02:05:33PM +0000, Qais Yousef wrote:
> On 03/10/20 18:01, Josh Don wrote:
> > From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > 
> > Currently, when updating the affinity of tasks via either cpusets.cpus,
> > or, sched_setaffinity(); tasks not currently running within the newly
> > specified mask will be arbitrarily assigned to the first CPU within the
> > mask.
> > 
> > This (particularly in the case that we are restricting masks) can
> > result in many tasks being assigned to the first CPUs of their new
> > masks.
> > 
> > This:
> >  1) Can induce scheduling delays while the load-balancer has a chance to
> >     spread them between their new CPUs.
> >  2) Can antogonize a poor load-balancer behavior where it has a
> >     difficult time recognizing that a cross-socket imbalance has been
> >     forced by an affinity mask.
> > 
> > This change adds a new cpumask interface to allow iterated calls to
> > distribute within the intersection of the provided masks.
> > 
> > The cases that this mainly affects are:
> > - modifying cpuset.cpus
> > - when tasks join a cpuset
> > - when modifying a task's affinity via sched_setaffinity(2)
> > 
> > Co-developed-by: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> Anyway, for the API.
> 
> Reviewed-by: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
> Tested-by: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>

Thanks guys!
