From: Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v4 1/2] sched/topology: Don't try to build empty sched
 domains
Date: Thu, 24 Oct 2019 18:19:38 +0200
Message-ID: <27d8a51d-a899-67f4-8b74-224281f25cef@arm.com>
References: <20191023153745.19515-1-valentin.schneider@arm.com>
 <20191023153745.19515-2-valentin.schneider@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20191023153745.19515-2-valentin.schneider@arm.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Valentin Schneider <valentin.schneider@arm.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org, morten.rasmussen@arm.com, qperret@google.com, stable@vger.kernel.org

On 23/10/2019 17:37, Valentin Schneider wrote:
> Turns out hotplugging CPUs that are in exclusive cpusets can lead to the
> cpuset code feeding empty cpumasks to the sched domain rebuild machinery.
> This leads to the following splat:

[...]

> The faulty line in question is
> 
>   cap = arch_scale_cpu_capacity(cpumask_first(cpu_map));
> 
> and we're not checking the return value against nr_cpu_ids (we shouldn't
> have to!), which leads to the above.
> 
> Prevent generate_sched_domains() from returning empty cpumasks, and add
> some assertion in build_sched_domains() to scream bloody murder if it
> happens again.
> 
> The above splat was obtained on my Juno r0 with:
> 
>   cgcreate -g cpuset:asym
>   cgset -r cpuset.cpus=0-3 asym
>   cgset -r cpuset.mems=0 asym
>   cgset -r cpuset.cpu_exclusive=1 asym
> 
>   cgcreate -g cpuset:smp
>   cgset -r cpuset.cpus=4-5 smp
>   cgset -r cpuset.mems=0 smp
>   cgset -r cpuset.cpu_exclusive=1 smp
> 
>   cgset -r cpuset.sched_load_balance=0 .
> 
>   echo 0 > /sys/devices/system/cpu/cpu4/online
>   echo 0 > /sys/devices/system/cpu/cpu5/online
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 05484e098448 ("sched/topology: Add SD_ASYM_CPUCAPACITY flag detection")

Sorry for being picky but IMHO you should also mention that it fixes

f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting
information")

Tested it on a hikey620 (8 CPus SMP) with v5.4-rc4 and a local fix for
asym_cpu_capacity_level().
2 exclusive cpusets [0-3] and [4-7], hp'ing out [0-3] and then hp'ing in
[0] again.

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 5a174ae6ecf3..8f83e8e3ea9a 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2203,8 +2203,19 @@ void partition_sched_domains_locked(int
ndoms_new, cpumask_var_t doms_new[],
        for (i = 0; i < ndoms_cur; i++) {
                for (j = 0; j < n && !new_topology; j++) {
                        if (cpumask_equal(doms_cur[i], doms_new[j]) &&
-                           dattrs_equal(dattr_cur, i, dattr_new, j))
+                           dattrs_equal(dattr_cur, i, dattr_new, j)) {
+                               struct root_domain *rd;
+
+                        /*
+                         * This domain won't be destroyed and as such
+                         * its dl_bw->total_bw needs to be cleared.  It
+                         * will be recomputed in function
+                         * update_tasks_root_domain().
+                         */
+                         rd = cpu_rq(cpumask_any(doms_cur[i]))->rd;

We have an issue here if doms_cur[i] is empty.

+                         dl_clear_root_domain(rd);
                          goto match1;


There is yet another similar issue behind the first one
(asym_cpu_capacity_level()).

342 static bool build_perf_domains(const struct cpumask *cpu_map)
 343 {
 344     int i, nr_pd = 0, nr_cs = 0, nr_cpus = cpumask_weight(cpu_map);
 345     struct perf_domain *pd = NULL, *tmp;
 346     int cpu = cpumask_first(cpu_map);          <--- !!!
 347     struct root_domain *rd = cpu_rq(cpu)->rd;  <--- !!!
 348     struct cpufreq_policy *policy;
 349     struct cpufreq_governor *gov;
 ...
 406     tmp = rd->pd;                              <--- !!!

Caught when running hikey620 (8 CPus SMP) with v5.4-rc4 and a local fix
for asym_cpu_capacity_level() with CONFIG_ENERGY_MODEL=y.

There might be other places in build_sched_domains() suffering from the
same issue. So I assume it's wise to not call it with an empty cpu_map
and warn if done so.

[...]
