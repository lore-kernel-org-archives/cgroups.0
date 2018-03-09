From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH v4] cpuset: Enable cpuset controller in default hierarchy
Date: Fri, 09 Mar 2018 18:23:46 +0100
Message-ID: <1520616226.12489.44.camel@gmx.de>
References: <1520609707-16582-1-git-send-email-longman@redhat.com>
         <1520613285.12489.36.camel@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520613285.12489.36.camel@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On Fri, 2018-03-09 at 17:34 +0100, Mike Galbraith wrote:
> On Fri, 2018-03-09 at 10:35 -0500, Waiman Long wrote:
> > Given the fact that thread mode had been merged into 4.14, it is now
> > time to enable cpuset to be used in the default hierarchy (cgroup v2)
> > as it is clearly threaded.
> >=20
> > The cpuset controller had experienced feature creep since its
> > introduction more than a decade ago. Besides the core cpus and mems
> > control files to limit cpus and memory nodes, there are a bunch of
> > additional features that can be controlled from the userspace. Some of
> > the features are of doubtful usefulness and may not be actively used.
>=20
> One rather important features is the ability to dynamically partition a
> box and isolate critical loads. =A0How does one do that with v2?

This still very much in use stuff that started below, not to mention
the nohz_full stuff that=A0Frederic Weisbecker is working on integrating
so it can blossom into a proper dynamic set property.

Author: Dinakar Guniguntala <dino@in.ibm.com>  2005-06-25 23:57:33
Committer: Linus Torvalds <torvalds@ppc970.osdl.org>  2005-06-26 01:24:45
Parent: 37e4ab3f0cba13adf3535d373fd98e5ee47b5410 ([PATCH] Changing RT prior=
ity without CAP_SYS_NICE)
Child:  85d7b94981e2e919697bc235aad7367b33c3864b ([PATCH] Dynamic sched dom=
ains: cpuset changes)
Branches: master, remotes/origin/master and many more (82)
Follows: v2.6.12
Precedes: v2.6.13-rc1

    [PATCH] Dynamic sched domains: sched changes
   =20
    The following patches add dynamic sched domains functionality that was
    extensively discussed on lkml and lse-tech.  I would like to see this a=
dded to
    -mm
   =20
    o The main advantage with this feature is that it ensures that the sche=
duler
      load balacing code only balances against the cpus that are in the sch=
ed
      domain as defined by an exclusive cpuset and not all of the cpus in t=
he
      system. This removes any overhead due to load balancing code trying to
      pull tasks outside of the cpu exclusive cpuset only to be prevented by
      the tasks' cpus_allowed mask.
    o cpu exclusive cpusets are useful for servers running orthogonal
      workloads such as RT applications requiring low latency and HPC
      applications that are throughput sensitive
   =20
    o It provides a new API partition_sched_domains in sched.c
      that makes dynamic sched domains possible.
    o cpu_exclusive cpusets sets are now associated with a sched domain.
      Which means that the users can dynamically modify the sched domains
      through the cpuset file system interface
    o ia64 sched domain code has been updated to support this feature as we=
ll
    o Currently, this does not support hotplug. (However some of my tests
      indicate hotplug+preempt is currently broken)
    o I have tested it extensively on x86.
    o This should have very minimal impact on performance as none of
      the fast paths are affected
   =20
    Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>
    Acked-by: Paul Jackson <pj@sgi.com>
    Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
    Acked-by: Matthew Dobson <colpatch@us.ibm.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>
