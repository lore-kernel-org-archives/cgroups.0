From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v4] cpuset: Enable cpuset controller in default hierarchy
Date: Mon, 12 Mar 2018 10:20:32 -0400
Message-ID: <12ef7f60-5b14-8e09-2478-1453a3071f21@redhat.com>
References: <1520609707-16582-1-git-send-email-longman@redhat.com>
 <1520613285.12489.36.camel@gmx.de>
 <1c3fe7b0-2600-c46d-1527-d3aaf024bb91@redhat.com>
 <1520619426.27998.18.camel@gmx.de>
 <55809fe4-98ba-5566-86ed-457acfef0e1c@redhat.com>
 <1520624424.27998.76.camel@gmx.de>
 <53de9683-01b7-bac4-8b70-dc1f93ede600@redhat.com>
 <20180309221736.GB5926@hirez.programming.kicks-ass.net>
 <f0fca497-e4e7-3dbd-1e5c-a7f502c05dcb@redhat.com>
 <20180310131647.GB4043@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180310131647.GB4043@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 03/10/2018 08:16 AM, Peter Zijlstra wrote:
> On Fri, Mar 09, 2018 at 06:06:29PM -0500, Waiman Long wrote:
>> So you are talking about sched_relax_domain_level and
> That one I wouldn't be sad to see the back of.
>
>> sched_load_balance.
> This one, that's critical. And this is the perfect time to try and fix
> the whole isolcpus issue.
>
> The primary issue is that to make equivalent functionality available
> through cpuset, we need to basically start all tasks outside the root
> group.
>
> The equivalent of isolcpus=xxx is a cgroup setup like:
>
>         root
> 	/  \
>   system    other
>
> Where other has the @xxx cpus and system the remainder and
> root.sched_load_balance = 0.

I saw in the kernel-parameters.txt file that the isolcpus option was
deprecated - use cpusets instead. However, there doesn't seem to have
document on the right way to do it. Of course, we can achieve similar
results with what you have outlined above, but the process is more
complex than just adding another boot command line argument with
isolcpus. So I doubt isolcpus will die anytime soon unless we can make
the alternative as easy to use.

> Back before cgroups (and the new workqueue stuff), we could've started
> everything in the !root group, no worry. But now that doesn't work,
> because a bunch of controllers can't deal with that and everything
> cgroup expects the cgroupfs to be empty on boot.

AFAIK, all the processes belong to the root cgroup on boot. And the root
cgroup is usually special that the controller may not exert any control
for processes in the root cgroup. Many controllers become active for
processes in the child cgroups only. Would you mind elaborating what
doesn't quite work currently?

 
> It's one of my biggest regrets that I didn't 'fix' this before cgroups
> came along.
>
>> I have not removed any bits. I just haven't exposed
>> them yet. It does seem like these 2 control knobs are useful from the
>> scheduling perspective. Do we also need cpu_exclusive or just the two
>> sched control knobs are enough?
> I always forget if we need exclusive for load_balance to work; I'll
> peruse the document/code.

I think the cpu_exclusive feature can be useful to enforce that CPUs
allocated to the "other" isolated cgroup cannot be used by the processes
under the "system" parent.

I know that there are special code to handle the isolcpus option. How
about changing it to create a exclusive cpuset automatically instead.
Applications that need to run in those isolated CPUs can then use the
standard cgroup process to be moved into the isolated cgroup. For example,

isolcpus=<cpuset-name>,<cpu-id-list>

or

isolcpuset=<cpuset-name>[,cpu:<cpu-id-list>][,mem:<memory-node-list>]

We can then retire the old usage and encourage users to use the cgroup
API to manage it.

Cheers,
Longman


