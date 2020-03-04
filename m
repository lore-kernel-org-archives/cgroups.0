From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] sched/cpuset: distribute tasks within affinity masks
Date: Wed, 4 Mar 2020 12:11:51 -0500
Message-ID: <20200304171151.GL189690@mtj.thefacebook.com>
References: <20200228010134.42866-1-joshdon@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kXZ0XxGADAwquLAqrLAfH2eX2Yk3KDxs3aXRaRLxHiQ=;
        b=Zcf1qSNLsGzt1D3Kh6rbWI9JNilJKbWhmur0D8f7GwPUGk2AYjV6rqQPsKmTcadRFe
         TcgN1Yo3crTqWatWOycV0xuUwIPUoO3k0J6bryztcx20U6PXcTSUqWoSDwSrm9FM9aHL
         C+W5ZOH0opIuw3Pf3gJKBSIGDDYyOImxVKXI4Z60ZWzeWA5QA6yKhNkbXyDk3QCAnxeG
         E8bQEje+fzjnQeweLh2kqldp2qUKQZyCf3Dmk530rWM5Ucs7lWPq5Q3hKmTDIfpDGjGQ
         cp3JXAOPh8HdA3RyEIbIoxcIlBIAQ0DTJcUUjMaBinz+tQD3y32+lCQX0OgHRJNzIzwM
         i14w==
Content-Disposition: inline
In-Reply-To: <20200228010134.42866-1-joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Feb 27, 2020 at 05:01:34PM -0800, Josh Don wrote:
> From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Currently, when updating the affinity of tasks via either cpusets.cpus,
> or, sched_setaffinity(); tasks not currently running within the newly
> specified CPU will be arbitrarily assigned to the first CPU within the
> mask.
> 
> This (particularly in the case that we are restricting masks) can
> result in many tasks being assigned to the first CPUs of their new
> masks.
> 
> This:
>  1) Can induce scheduling delays while the load-balancer has a chance to
>     spread them between their new CPUs.
>  2) Can antogonize a poor load-balancer behavior where it has a
>     difficult time recognizing that a cross-socket imbalance has been
>     forced by an affinity mask.
> 
> With this change, tasks are distributed ~evenly across the new mask.  We
> may intentionally move tasks already running on a CPU within the mask to
> avoid edge cases in which a CPU is already overloaded (or would be
> assigned to more times than is desired).
> 
> We specifically apply this behavior to the following cases:
> - modifying cpuset.cpus
> - when tasks join a cpuset
> - when modifying a task's affinity via sched_setaffinity(2)

Looks fine to me. Peter, what do you think?

Thanks.

-- 
tejun
