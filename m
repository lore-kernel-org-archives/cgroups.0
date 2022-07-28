From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup/cpuset: Keep current cpus list if cpus
 affinity was explicitly set
Date: Thu, 28 Jul 2022 11:39:19 -1000
Message-ID: <YuMCB86fH2K3NcqM@slm.duckdns.org>
References: <20220728005815.1715522-1-longman@redhat.com>
 <YuLF+xXaCzwWi2BR@slm.duckdns.org>
 <1ae1cc6c-dca9-4958-6b22-24a5777c5e8d@redhat.com>
 <YuLdX7BYGvo57LNU@slm.duckdns.org>
 <606ed69e-8ad0-45d5-9de7-48739df7f48d@redhat.com>
 <YuL1NijxSEv2xadk@slm.duckdns.org>
 <c470d3f7-f0f8-b8e6-4a95-7b334f0a824b@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=0lIhra6yGQrlkyIbM2bnb9XhkYHXW96sQs23+tnYMHU=;
        b=bMTdPhbS4m1DiyFWNkkBtZa1qNMP0zCUSede5bxmA3r7760mQ3YV3FcYK0DUHenJXn
         1wA0avWFIn0aX1lTswRj4MICETJAiKoPkD7IIneoaJ9Cr6a+pERInxXKcjPByREiIom7
         nJKbTeYpyMRnBzxz2TmUMuotGG7kViVgVm9vTC3n7TaalPpopl+QoL2njeOUfEkPIiEP
         iov33KDjYhfXS+Qb+rXWVtJnPldHSKC1iLQrMuMbJWbMOcAxTf1cDl35Rnotadymwqp9
         TylyVen9uEcpdDbAqQHCOxFPFze21b0ZJ8us7LrmsVP1+4NzXD5hAQE8ZLJdmROwzBgY
         m6ZA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c470d3f7-f0f8-b8e6-4a95-7b334f0a824b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Waiman.

On Thu, Jul 28, 2022 at 05:04:19PM -0400, Waiman Long wrote:
> > So, the patch you proposed is making the code remember one special aspect of
> > user requested configuration - whether it configured it or not, and trying
> > to preserve that particular state as cpuset state changes. It addresses the
> > immediate problem but it is a very partial approach. Let's say a task wanna
> > be affined to one logical thread of each core and set its mask to 0x5555.
> > Now, let's say cpuset got enabled and enforced 0xff and affined the task to
> > 0xff. After a while, the cgroup got more cpus allocated and its cpuset now
> > has 0xfff. Ideally, what should happen is the task now having the effective
> > mask of 0x555. In practice, tho, it either would get 0xf55 or 0x55 depending
> > on which way we decide to misbehave.
> 
> OK, I see what you want to accomplish. To fully address this issue, we will
> need to have a new cpumask variable in the the task structure which will be
> allocated if sched_setaffinity() is ever called. I can rework my patch to
> use this approach.

Yeah, we'd need to track what user requested separately from the currently
effective cpumask. Let's make sure that the scheduler folks are on board
before committing to the idea tho. Peter, Ingo, what do you guys think?

Thanks.

-- 
tejun
