From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v7 0/5] cpuset: Enable cpuset controller in default
 hierarchy
Date: Mon, 23 Apr 2018 10:10:39 -0400
Message-ID: <22ad86e3-0661-6db0-f4f3-5b06f439dcf7@redhat.com>
References: <1524145624-23655-1-git-send-email-longman@redhat.com>
 <20180423130715.GA32341@localhost.localdomain>
 <20180423135756.GC32341@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180423135756.GC32341@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 04/23/2018 09:57 AM, Juri Lelli wrote:
> On 23/04/18 15:07, Juri Lelli wrote:
>> Hi Waiman,
>>
>> On 19/04/18 09:46, Waiman Long wrote:
>>> v7:
>>>  - Add a root-only cpuset.cpus.isolated control file for CPU isolation.
>>>  - Enforce that load_balancing can only be turned off on cpusets with
>>>    CPUs from the isolated list.
>>>  - Update sched domain generation to allow cpusets with CPUs only
>>>    from the isolated CPU list to be in separate root domains.
> Guess I'll be adding comments as soon as I stumble on something unclear
> (to me :), hope that's OK (shout if I should do it differently).
>
> The below looked unexpected to me:
>
> root@debian-kvm:/sys/fs/cgroup# cat g1/cpuset.cpus
> 2-3
> root@debian-kvm:/sys/fs/cgroup# cat g1/cpuset.mems
>
> root@debian-kvm:~# echo $$ > /sys/fs/cgroup/g1/cgroup.threads
> root@debian-kvm:/sys/fs/cgroup# cat g1/cgroup.threads
> 2312
>
> So I can add tasks to groups with no mems? Or is it this only true in my
> case with a single mem node? Or maybe it's inherited from root group
> (slightly confusing IMHO if that's the case).

No mems mean looking up the parents until we find one with non-empty
mems. The mems.effective will show you the actual memory nodes used.

-Longman

