From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v9 2/7] cpuset: Add new v2 cpuset.sched.domain_root flag
Date: Wed, 30 May 2018 10:57:46 -0400
Message-ID: <044bbb35-fda6-de23-90a3-6b53d4326b5d@redhat.com>
References: <1527601294-3444-1-git-send-email-longman@redhat.com>
 <1527601294-3444-3-git-send-email-longman@redhat.com>
 <20180530141804.GG3320@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530141804.GG3320@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 05/30/2018 10:18 AM, Juri Lelli wrote:
> Hi,
>
> On 29/05/18 09:41, Waiman Long wrote:
>
> [...]
>
>> +  cpuset.sched.domain_root
>> +	A read-write single value file which exists on non-root
>> +	cpuset-enabled cgroups.  It is a binary value flag that accepts
>> +	either "0" (off) or "1" (on).  This flag is set by the parent
>> +	and is not delegatable.
>> +
>> +	If set, it indicates that the current cgroup is the root of a
>> +	new scheduling domain or partition that comprises itself and
>> +	all its descendants except those that are scheduling domain
>> +	roots themselves and their descendants.  The root cgroup is
>> +	always a scheduling domain root.
>> +
>> +	There are constraints on where this flag can be set.  It can
>> +	only be set in a cgroup if all the following conditions are true.
>> +
>> +	1) The "cpuset.cpus" is not empty and the list of CPUs are
>> +	   exclusive, i.e. they are not shared by any of its siblings.
>> +	2) The parent cgroup is also a scheduling domain root.
>> +	3) There is no child cgroups with cpuset enabled.  This is
>> +	   for eliminating corner cases that have to be handled if such
>> +	   a condition is allowed.
>> +
>> +	Setting this flag will take the CPUs away from the effective
>> +	CPUs of the parent cgroup.  Once it is set, this flag cannot
>> +	be cleared if there are any child cgroups with cpuset enabled.
>> +	Further changes made to "cpuset.cpus" is allowed as long as
>> +	the first condition above is still true.
> IIUC, with the configuration below
>
>  cpuset.cpus.effective:6-11
>  cgroup.controllers:cpuset
>  cpuset.mems.effective:0-1
>  cgroup.subtree_control:cpuset
>  g1/cpuset.cpus.effective:0-5
>  g1/cgroup.controllers:cpuset
>  g1/cpuset.sched.load_balance:1
>  g1/cpuset.mems.effective:0-1
>  g1/cpuset.cpus:0-5
>  g1/cpuset.sched.domain_root:1
>  user.slice/cpuset.cpus.effective:6-11
>  user.slice/cgroup.controllers:cpuset
>  user.slice/cpuset.sched.load_balance:1
>  user.slice/cpuset.mems.effective:0-1
>  user.slice/cpuset.cpus:6-11
>  user.slice/cpuset.sched.domain_root:0
>  init.scope/cpuset.cpus.effective:6-11
>  init.scope/cgroup.controllers:cpuset
>  init.scope/cpuset.sched.load_balance:1
>  init.scope/cpuset.mems.effective:0-1
>  init.scope/cpuset.cpus:6-11
>  init.scope/cpuset.sched.domain_root:0
>  system.slice/cpuset.cpus.effective:6-11
>  system.slice/cgroup.controllers:cpuset
>  system.slice/cpuset.sched.load_balance:1
>  system.slice/cpuset.mems.effective:0-1
>  system.slice/cpuset.cpus:6-11
>  system.slice/cpuset.sched.domain_root:0
>  machine.slice/cpuset.cpus.effective:6-11
>  machine.slice/cgroup.controllers:cpuset
>  machine.slice/cpuset.sched.load_balance:1
>  machine.slice/cpuset.mems.effective:0-1
>  machine.slice/cpuset.cpus:6-11
>  machine.slice/cpuset.sched.domain_root:0
>
> I should be able to
>
>  # echo 0-4 >g1/cpuset.cpus
>
> ?
>
> It doesn't let me.

It should allow that. I will fix this issue.

>
> I'm not sure we actually want to allow that, but that's what would I
> expect as per your text above.
>
> Thanks,
>
> - Juri
>
> BTW: thanks a lot for your prompt feedback and hope it's OK if I keep
> playing and asking questions. :)

Of course. I appreciate your help in looking for issue in the patch that
I might have overlooked.

Thanks,
Longman

