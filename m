From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Thu, 17 Sep 2015 10:53:09 -0400
Message-ID: <20150917145309.GA7205@mtj.duckdns.org>
References: <20150822182916.GE20768@mtj.duckdns.org>
 <CAPM31RKPUzuiwVs3rs=4M1Kt=+c9WX8o84r-iO4semfznvYmHw@mail.gmail.com>
 <20150824213600.GK28944@mtj.duckdns.org>
 <CAPM31RKCO-yxtVf+iUs8FOqk6uGSyixEXtx9zSzxQ1uOGtkDqQ@mail.gmail.com>
 <20150824221935.GN28944@mtj.duckdns.org>
 <CAPM31RK08pC3g9qx+TEw6PQvtHk8idKE3OALQN8cFr_QOuT3FA@mail.gmail.com>
 <20150825210234.GE26785@mtj.duckdns.org>
 <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
 <20150912144007.GA8942@htj.duckdns.org>
 <20150917143527.GJ3604@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Kv3q/mNls07cF68MZ/vdy7B3HE31J7uX3wMN4yTvH0M=;
        b=gzhqGQD4CsJsijwgXvEdv5oRHcfkzMaa92CMdbGgpp9li06j8S+lUi91EE5P6qCUlH
         FtzgC8wxIyUx9RyFyxXMasl9HG1zWAxa6yVSY5KSzsKi51336IJEGhKxUQZ0TBGtX1Ca
         KJ5slf+8yGFkUfMCJ0QjbBk7J8MF2wnTnORnTdmj+FADZ0TA9bdzDu4LbPpxD8nVFIUM
         4JReEHx32oOV57TA76ew5zV4TFysruXr17T3atDBkCRcFzC10XIesBzmFHmQvrkbkKlS
         9vOgd0rfjZq4ac0szQvaCmSmuGBbyQiVWEO9emE6HOkMmY7sUBydssI8ZCW3xFIopedR
         i2Xg==
Content-Disposition: inline
In-Reply-To: <20150917143527.GJ3604-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Thu, Sep 17, 2015 at 04:35:27PM +0200, Peter Zijlstra wrote:
> On Sat, Sep 12, 2015 at 10:40:07AM -0400, Tejun Heo wrote:
> > So, one of the problems is that the kernel can't have tasks w/o
> > runnable CPUs, so we have to some workaround when, for whatever
> > reason, a task ends up with no CPU that it can run on.
> 
> No, just refuse that configuration.

Well, you've been saying that but that's not our behavior on cpu
hotunplug either and it applies the same.  If we reject cpu hotunplugs
while tasks are affined to it, we can do the same in cpuset too.

> > The kernel does not update all CPU affinity masks when a CPU goes down
> > or comes up.
> 
> I'd be happy to fail a CPU down for user tasks where this is the last
> runnable CPU of.

So, yeah, we need to keep these things consistent across global and
cgroup cases.

Thanks.

-- 
tejun
