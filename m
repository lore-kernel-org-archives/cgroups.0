From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 1/3] sched: Use user_cpus_ptr for saving user provided
 cpumask in sched_setaffinity()
Date: Mon, 15 Aug 2022 10:57:15 +0200
Message-ID: <YvoKa3tbOaszsp1y@worktop.programming.kicks-ass.net>
References: <20220812203929.364341-1-longman@redhat.com>
 <20220812203929.364341-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xGKSHpBSrA7bGy9HtaNlBZ6jRySHti4Z3/bSYrzElsk=; b=QfHLyNs2Gnm/SW58wQjhG43d4m
        YtpYmGgwiw73SbX4veuzmapH8DV7A/3SrrNvsYp3sGIWUlJb/GP8afoCxYTKA8DXbu7hVeQfKLnoj
        hBGXrJ+L7xHjybZuRnrduifHmMhYTDTmUPCKl/ByqVv5VVd9DQjBWn4HSMHudfi3VHRWBDun+CmdG
        YseHXJ4cDfrGck+Tz1Xv31Hzsoxozc4iUOksmCJ48lksoc5+64RuVPVOrKYbfT/5187aWI1iYF0h7
        rE6WodEhc+cSnV2XVz60fOqJXKONiC/HUZKoCktmpIMC0uNKek0Zqa3X8x+cyycjXHnt/oySgeHPC
        SRLQGj6A==;
Content-Disposition: inline
In-Reply-To: <20220812203929.364341-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Fri, Aug 12, 2022 at 04:39:27PM -0400, Waiman Long wrote:
> The user_cpus_ptr field is added by commit b90ca8badbd1 ("sched:
> Introduce task_struct::user_cpus_ptr to track requested affinity"). It
> is currently used only by arm64 arch due to possible asymmetric cpu
> setup. This patch extends its usage to save user provided cpumask when
> sched_setaffinity() is called for all arches.
> 
> To preserve the existing arm64 use case, a new cpus_affinity_set flag is
> added to differentiate if user_cpus_ptr is set up by sched_setaffinity()
> or by force_compatible_cpus_allowed_ptr(). user_cpus_ptr
> set by sched_setaffinity() has priority and won't be
> overwritten by force_compatible_cpus_allowed_ptr() or
> relax_compatible_cpus_allowed_ptr().

What why ?! The only possible case where
restrict_cpus_allowed_ptr() will now need that weird new state is when
the affinity has never been set before, in that case cpus_ptr should be
possible_mask.

Please just make a single consistent rule and don't make weird corner
cases like this.
