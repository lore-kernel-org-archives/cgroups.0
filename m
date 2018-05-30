From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v9 0/7] Enable cpuset controller in default hierarchy
Date: Wed, 30 May 2018 15:05:55 +0200
Message-ID: <20180530130555.GD3320@localhost.localdomain>
References: <1527601294-3444-1-git-send-email-longman@redhat.com>
 <20180530101317.GB3320@localhost.localdomain>
 <d74c67ea-43c9-cabb-4303-ecff008412df@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d74c67ea-43c9-cabb-4303-ecff008412df@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 30/05/18 08:56, Waiman Long wrote:
> On 05/30/2018 06:13 AM, Juri Lelli wrote:
> > Hi,
> >
> > On 29/05/18 09:41, Waiman Long wrote:
> >> v9:
> >>  - Rename cpuset.sched.domain to cpuset.sched.domain_root to better
> >>    identify its purpose as the root of a new scheduling domain or
> >>    partition.
> >>  - Clarify in the document about the purpose of domain_root and
> >>    load_balance. Using domain_root is th only way to create new
> >>    partition.
> >>  - Fix a lockdep warning in update_isolated_cpumask() function.
> >>  - Add a new patch to eliminate call to generate_sched_domains() for
> >>    v2 when a change in cpu list does not touch a domain_root.
> > I was playing with this and ended up with the situation below:
> >
> >  g1/cgroup.controllers:cpuset
> >  g1/cgroup.events:populated 0
> >  g1/cgroup.max.depth:max
> >  g1/cgroup.max.descendants:max
> >  g1/cgroup.stat:nr_descendants 1
> >  g1/cgroup.stat:nr_dying_descendants 0
> >  g1/cgroup.subtree_control:cpuset
> >  g1/cgroup.type:domain
> >  g1/cpuset.cpus:0-5                   <---
> >  g1/cpuset.cpus.effective:0-5
> >  g1/cpuset.mems.effective:0-1
> >  g1/cpuset.sched.domain_root:1        <---
> >  g1/cpuset.sched.load_balance:1
> >  g1/cpu.stat:usage_usec 0
> >  g1/cpu.stat:user_usec 0
> >  g1/cpu.stat:system_usec 0
> >  g1/g11/cgroup.events:populated 0
> >  g1/g11/cgroup.max.descendants:max
> >  g1/g11/cpu.stat:usage_usec 0
> >  g1/g11/cpu.stat:user_usec 0
> >  g1/g11/cpu.stat:system_usec 0
> >  g1/g11/cgroup.type:domain
> >  g1/g11/cgroup.stat:nr_descendants 0
> >  g1/g11/cgroup.stat:nr_dying_descendants 0
> >  g1/g11/cpuset.cpus.effective:0-5
> >  g1/g11/cgroup.controllers:cpuset
> >  g1/g11/cpuset.sched.load_balance:1
> >  g1/g11/cpuset.mems.effective:0-1
> >  g1/g11/cpuset.cpus:6-11              <---
> >  g1/g11/cgroup.max.depth:max
> >  g1/g11/cpuset.sched.domain_root:0
> >
> > Should this be allowed? I was expecting subgroup g11 should be
> > restricted to a subset of g1's cpus.
> >
> > Best,
> >
> > - Juri
> 
> That shouldn't be allowed.The code is probably missing some checks that
> should have been done. What was the sequence of commands leading to the
> above configuration?

This is a E5-2609 v3 (12 cores) Fedora Server box (with systemd, so
first command is needed to be able to use cpuset controller with v2,
IIUC):

# umount /sys/fs/cgroup/cpuset 
# cd /sys/fs/cgroup/unified/
# echo "+cpuset" >cgroup.subtree_control 
# mkdir g1
# echo 0-5 >g1/cpuset.cpus
# echo 6-11 >init.scope/cpuset.cpus
# echo 6-11 >machine.slice/cpuset.cpus
# echo 6-11 >system.slice/cpuset.cpus
# echo 6-11 >user.slice/cpuset.cpus
# echo 1 >g1/cpuset.sched.domain_root 
# mkdir g1/g11
# echo "+cpuset" > g1/cgroup.subtree_control 
# echo 6-11 >g1/g11/cpuset.cpus
# grep -R . g1/*

That should be it. Am I doing something wrong?

Thanks,

- Juri
