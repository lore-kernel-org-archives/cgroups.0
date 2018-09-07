From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Fri, 7 Sep 2018 10:54:04 -0400
Message-ID: <20180907145404.GB11088@cmpxchg.org>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
 <20180828172258.3185-9-hannes@cmpxchg.org>
 <20180907102458.GP24106@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aKXhT6dgRY4iCFlFoD4xbTkI/eQwmUIY+/zNex8lHDk=;
        b=hb0zCfdCJWwxfqPfjlaYsbZD0Qnjj3b2siGVNw1E7tjzT2SKRZuH8Zae2fUbT6yoeB
         5u/KLdk2wy4FDZKETzmAPztBfX6o8qRje8VpORKjgBruIHXkb/R/N1fcSMiPaNZvOjF8
         mcY/xoH2v6fsQqRyJL5A+xbMdVwwIh+N6FYKSvVfLXqxU65IzbgR2xy21z2CiQqRB9PN
         Khzb8UXshGhXmFA1kIEhYiGyTOkSTCgGaJB0RqAzQ1XTlHfn5v2oFadZ2ZbzqE0I5X2g
         j7fXK9jAJ4sty8o5CSElHfAV2LhT/GHgDrxX2GLBGZSDKvCFmDdvqI2VrhEel5RK4xMx
         Vv9g==
Content-Disposition: inline
In-Reply-To: <20180907102458.GP24106@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Sep 07, 2018 at 12:24:58PM +0200, Peter Zijlstra wrote:
> On Tue, Aug 28, 2018 at 01:22:57PM -0400, Johannes Weiner wrote:
> > +static void psi_clock(struct work_struct *work)
> > +{
> > +	struct delayed_work *dwork;
> > +	struct psi_group *group;
> > +	bool nonidle;
> > +
> > +	dwork = to_delayed_work(work);
> > +	group = container_of(dwork, struct psi_group, clock_work);
> > +
> > +	/*
> > +	 * If there is task activity, periodically fold the per-cpu
> > +	 * times and feed samples into the running averages. If things
> > +	 * are idle and there is no data to process, stop the clock.
> > +	 * Once restarted, we'll catch up the running averages in one
> > +	 * go - see calc_avgs() and missed_periods.
> > +	 */
> > +
> > +	nonidle = update_stats(group);
> > +
> > +	if (nonidle) {
> > +		unsigned long delay = 0;
> > +		u64 now;
> > +
> > +		now = sched_clock();
> > +		if (group->next_update > now)
> > +			delay = nsecs_to_jiffies(group->next_update - now) + 1;
> > +		schedule_delayed_work(dwork, delay);
> > +	}
> > +}
> 
> Just a little nit; I would expect a function called *clock() to return a
> time.

Fair enough, let's rename this. How about this on top?

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 92489e66840b..0f07749b60a4 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -154,7 +154,7 @@ static struct psi_group psi_system = {
 	.pcpu = &system_group_pcpu,
 };
 
-static void psi_clock(struct work_struct *work);
+static void psi_update_work(struct work_struct *work);
 
 static void group_init(struct psi_group *group)
 {
@@ -163,7 +163,7 @@ static void group_init(struct psi_group *group)
 	for_each_possible_cpu(cpu)
 		seqcount_init(&per_cpu_ptr(group->pcpu, cpu)->seq);
 	group->next_update = sched_clock() + psi_period;
-	INIT_DELAYED_WORK(&group->clock_work, psi_clock);
+	INIT_DELAYED_WORK(&group->clock_work, psi_update_work);
 	mutex_init(&group->stat_lock);
 }
 
@@ -347,7 +347,7 @@ static bool update_stats(struct psi_group *group)
 	return nonidle_total;
 }
 
-static void psi_clock(struct work_struct *work)
+static void psi_update_work(struct work_struct *work)
 {
 	struct delayed_work *dwork;
 	struct psi_group *group;
