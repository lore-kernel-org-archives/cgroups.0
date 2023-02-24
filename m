From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3] sched: cpuset: Don't rebuild root domains on
 suspend-resume
Date: Fri, 24 Feb 2023 16:14:51 +0100
Message-ID: <5f087dd8-3e39-ce83-fe24-afa5179c05d9@arm.com>
References: <20230206221428.2125324-1-qyousef@layalina.io>
 <20230223153859.37tqoqk33oc6tv7o@airbuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <20230223153859.37tqoqk33oc6tv7o@airbuntu>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On 23/02/2023 16:38, Qais Yousef wrote:

IMHO the patch title is misleading since what you want to avoid in
certain cases is that the RD DL accounting is updated.

> On 02/06/23 22:14, Qais Yousef wrote:
>> Commit f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
>> enabled rebuilding root domain on cpuset and hotplug operations to
>> correct deadline accounting.
>>
>> Rebuilding root domain is a slow operation and we see 10+ of ms delays
>> on suspend-resume because of that (worst case captures 20ms which
>> happens often).
>>
>> Since nothing is expected to change on suspend-resume operation; skip
>> rebuilding the root domains to regain the some of the time lost.
>>
>> Achieve this by refactoring the code to pass whether dl accoutning needs
>> an update to rebuild_sched_domains(). And while at it, rename
>> rebuild_root_domains() to update_dl_rd_accounting() which I believe is
>> a more representative name since we are not really rebuilding the root
>> domains, but rather updating dl accounting at the root domain.
>>
>> Some users of rebuild_sched_domains() will skip dl accounting update
>> now:
>>
>> 	* Update sched domains when relaxing the domain level in cpuset
>> 	  which only impacts searching level in load balance

This one is cpuset related. (1)

>> 	* update sched domains when cpufreq governor changes and we need
>> 	  to create the perf domains

This one is drivers/base/arch_topology.c [arm/arm64/...] related. (2)

There are several levels of passing this `update_dl_accounting`
information through. I guess it looks like this:

					update_dl_accounting

arm/arm64/riscv/parisc specific:
update_topology_flags_workfn()		true
rebuild_sched_domains_energy()		false (2)

cpuset_hotplug_workfn()                 cpus_updated ||
                         force_rebuild == CPUSET_FORCE_REBUILD_PRS_ERROR

->rebuild_sched_domains(update_dl_accounting)

  update_cpumasks_hier()		true
  update_relax_domain_level()		false (1)
  update_flag()				true
  update_prstate()			true

  ->rebuild_sched_domains_locked(update_dl_accounting)

    ->partition_and_rebuild_sched_domains(..., update_dl_accounting)

        if (update_dl_accounting)
          update_dl_rd_accounting()


There is already a somehow hidden interface for `sd/rd rebuild`

  int __weak arch_update_cpu_topology(void)

which lets partition_sched_domains_locked() figure out whether sched
domains have to be rebuild..

But in your case it is more on the interface `cpuset/hotplug -> sd/rd
rebuild` and not only `arch -> `sd/rd rebuild``.

IMHO, it would be still nice to have only one way to tell `sd/rd
rebuild` what to do and what not to do during sd/rd/(pd) rebuild.

[...]

