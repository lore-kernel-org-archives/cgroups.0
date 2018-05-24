From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v8 4/6] cpuset: Make generate_sched_domains() recognize
 isolated_cpus
Date: Thu, 24 May 2018 10:04:30 +0100
Message-ID: <20180524090430.GZ30654@e110439-lin>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-5-git-send-email-longman@redhat.com>
 <20180523173453.GY30654@e110439-lin>
 <bf4cb72b-9ff3-eb8b-ca2c-f6c4fee5c123@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bf4cb72b-9ff3-eb8b-ca2c-f6c4fee5c123@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On 23-May 16:18, Waiman Long wrote:
> On 05/23/2018 01:34 PM, Patrick Bellasi wrote:
> > Hi Waiman,
> >
> > On 17-May 16:55, Waiman Long wrote:
> >
> > [...]
> >
> >> @@ -672,13 +672,14 @@ static int generate_sched_domains(cpumask_var_t **domains,
> >>  	int ndoms = 0;		/* number of sched domains in result */
> >>  	int nslot;		/* next empty doms[] struct cpumask slot */
> >>  	struct cgroup_subsys_state *pos_css;
> >> +	bool root_load_balance = is_sched_load_balance(&top_cpuset);
> >>  
> >>  	doms = NULL;
> >>  	dattr = NULL;
> >>  	csa = NULL;
> >>  
> >>  	/* Special case for the 99% of systems with one, full, sched domain */
> >> -	if (is_sched_load_balance(&top_cpuset)) {
> >> +	if (root_load_balance && !top_cpuset.isolation_count) {
> > Perhaps I'm missing something but, it seems to me that, when the two
> > conditions above are true, then we are going to destroy and rebuild
> > the exact same scheduling domains.
> >
> > IOW, on 99% of systems where:
> >
> >    is_sched_load_balance(&top_cpuset)
> >    top_cpuset.isolation_count = 0
> >
> > since boot time and forever, then every time we update a value for
> > cpuset.cpus we keep rebuilding the same SDs.
> >
> > It's not strictly related to this patch, the same already happens in
> > mainline based just on the first condition, but since you are extending
> > that optimization, perhaps you can tell me where I'm possibly wrong or
> > which cases I'm not considering.
> >
> > I'm interested mainly because on Android systems those conditions
> > are always true and we see SDs rebuilds every time we write
> > something in cpuset.cpus, which ultimately accounts for almost all the
> > 6-7[ms] time required for the write to return, depending on the CPU
> > frequency.
> >
> > Cheers Patrick
> >
> Yes, that is true. I will look into how to further optimize this. Thanks
> for the suggestion.

FWIW, following is my take on top of your series.

With the following patch applied I see a reduction of the average
execution time for a rebuild_sched_domains_locked() from 1.4[ms] to
40[us] while running 60 /tg1/cpuset.cpus switches in a loop on an
JunoR2 Arm board using the performance cpufreq governor.

---8<---
From 84bb8137ce79f74849d97e30871cf67d06d8d682 Mon Sep 17 00:00:00 2001
From: Patrick Bellasi <patrick.bellasi@arm.com>
Date: Wed, 23 May 2018 16:33:06 +0100
Subject: [PATCH 1/1] cgroup/cpuset: disable sched domain rebuild when not
 required

The generate_sched_domains() already addresses the "special case for 99%
of systems" which require a single full sched domain at the root,
spanning all the CPUs. However, the current support is based on an
expensive sequence of operations which destroy and recreate the exact
same scheduling domain configuration.

If we notice that:

 1) CPUs in "cpuset.isolcpus" are excluded from load balancing by the
    isolcpus= kernel boot option, and will never be load balanced
    regardless of the value of "cpuset.sched_load_balance" in any
    cpuset.

 2) the root cpuset has load_balance enabled by default at boot and
    it's the only parameter which userspace can change at run-time.

we know that, by default, every system comes up with a complete and
properly configured set of scheduling domains covering all the CPUs.

Thus, on every system, unless the user explicitly disables load balance
for the top_cpuset, the scheduling domains already configured at boot
time by the scheduler/topology code and updated in consequence of
hotplug events, are already properly configured for cpuset too.

This configuration is the default one for 99% of the systems,
and it's also the one used by most of the Android devices which never
disable load balance from the top_cpuset.

Thus, while load balance is enabled for the top_cpuset,
destroying/rebuilding the scheduling domains at every cpuset.cpus
reconfiguration is a useless operation which will always produce the
same result.

Let's anticipate the "special" optimization within:

   rebuild_sched_domains_locked()

thus completely skipping the expensive:

   generate_sched_domains()
   partition_sched_domains()

for all the cases we know that the scheduling domains already defined
will not be affected by whatsoever value of cpuset.cpus.

The proposed solution is the minimal variation to optimize the case for
systems with load balance enabled at the root level and without isolated
CPUs. As soon as one of these conditions is not more valid, we fall back
to the original behavior.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>,
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Turner <pjt@google.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 kernel/cgroup/cpuset.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8f586e8bdc98..cff14be94678 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -874,6 +874,11 @@ static void rebuild_sched_domains_locked(void)
 	   !cpumask_subset(top_cpuset.effective_cpus, cpu_active_mask))
 		goto out;
 
+	/* Special case for the 99% of systems with one, full, sched domain */
+	if (!top_cpuset.isolation_count &&
+	    is_sched_load_balance(&top_cpuset))
+		goto out;
+
 	/* Generate domain masks and attrs */
 	ndoms = generate_sched_domains(&doms, &attr);
 
-- 
2.15.1
---8<---


-- 
#include <best/regards.h>

Patrick Bellasi
