From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 1/3] sched: Use user_cpus_ptr for saving user provided
 cpumask in sched_setaffinity()
Date: Mon, 15 Aug 2022 16:25:50 +0200
Message-ID: <YvpXbofPloXkHWdq@worktop.programming.kicks-ass.net>
References: <20220812203929.364341-1-longman@redhat.com>
 <20220812203929.364341-2-longman@redhat.com>
 <YvoKa3tbOaszsp1y@worktop.programming.kicks-ass.net>
 <401bae73-3063-e0ab-c288-2c6e3be75fc5@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1ak0A9KD/FjrZcz3FKKCRHXNxZoMyEi6sn1tq4sEH4A=; b=Dfu8yp2ZRYkQ/bfgOWouSCakGM
        FjtLjQvxl3pasiUTCcrmRFuGn2zFi7ovA1A2cC9loQ+tZTKkdcp3RUsnWYRsbTttHCmKFBpkzYWDi
        airkFO86qhar9Q3Q7Npcyw/40fMvrGbK60+ILK2kediue/BA8kN/iGVpgj0VgdK7htSUWb5GPwe3o
        tzV1BiMm4b3FA647u8t5sYg/YisnRLNMHqXUV3LORoLBMjefO+T8sOk9/TJ3VbjxAQlWzvaJuX+cb
        Ny2aRkCU0DV64v9NEIT4JiwK3fnN+idFW3Oq1Pbmj46oDAqrCUGeRRXvipGxj5KCN58KZecK+VVKv
        r61XLiGg==;
Content-Disposition: inline
In-Reply-To: <401bae73-3063-e0ab-c288-2c6e3be75fc5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, Aug 15, 2022 at 09:52:27AM -0400, Waiman Long wrote:
> 
> On 8/15/22 04:57, Peter Zijlstra wrote:
> > On Fri, Aug 12, 2022 at 04:39:27PM -0400, Waiman Long wrote:
> > > The user_cpus_ptr field is added by commit b90ca8badbd1 ("sched:
> > > Introduce task_struct::user_cpus_ptr to track requested affinity"). It
> > > is currently used only by arm64 arch due to possible asymmetric cpu
> > > setup. This patch extends its usage to save user provided cpumask when
> > > sched_setaffinity() is called for all arches.
> > > 
> > > To preserve the existing arm64 use case, a new cpus_affinity_set flag is
> > > added to differentiate if user_cpus_ptr is set up by sched_setaffinity()
> > > or by force_compatible_cpus_allowed_ptr(). user_cpus_ptr
> > > set by sched_setaffinity() has priority and won't be
> > > overwritten by force_compatible_cpus_allowed_ptr() or
> > > relax_compatible_cpus_allowed_ptr().
> > What why ?! The only possible case where
> > restrict_cpus_allowed_ptr() will now need that weird new state is when
> > the affinity has never been set before, in that case cpus_ptr should be
> > possible_mask.
> 
> Since I don't have a full history for this particular patch series that add
> user_cpus_ptr, I am hesitant to change the current behavior for arm64
> systems. However, given the statement that user_cpus_ptr is for tracking
> "requested affinity" which I assume is when user applications call
> sched_setaffinity(). It does make sense we may not really need this if
> sched_setaffinity() is never called.

So it comes from the asymmetric arm stuff, where only little cores can
still run arm32 code. This means that on those machines, 32bit code
needs to be contrained so a subset of CPUs.

A direct consequence of that was that if you have any 32bit program in
your process hierarchy, you loose the big cores from you affinity mask.

For some reason that wasn't popular..  Hence the save/restore of cpumasks.

> > Please just make a single consistent rule and don't make weird corner
> > cases like this.
> 
> I will take a closer look to try to simplify the rule here.

I think something like:

	mask = p->user_cpus_ptr;
	if (!mask)
		mask = &init_task.cpus_mask;

	// impose cpuset masks

should 'just-work'.

