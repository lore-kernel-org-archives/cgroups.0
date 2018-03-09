From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v4] cpuset: Enable cpuset controller in default hierarchy
Date: Fri, 9 Mar 2018 18:06:29 -0500
Message-ID: <f0fca497-e4e7-3dbd-1e5c-a7f502c05dcb@redhat.com>
References: <1520609707-16582-1-git-send-email-longman@redhat.com>
 <1520613285.12489.36.camel@gmx.de>
 <1c3fe7b0-2600-c46d-1527-d3aaf024bb91@redhat.com>
 <1520619426.27998.18.camel@gmx.de>
 <55809fe4-98ba-5566-86ed-457acfef0e1c@redhat.com>
 <1520624424.27998.76.camel@gmx.de>
 <53de9683-01b7-bac4-8b70-dc1f93ede600@redhat.com>
 <20180309221736.GB5926@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180309221736.GB5926@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 03/09/2018 05:17 PM, Peter Zijlstra wrote:
> On Fri, Mar 09, 2018 at 03:43:34PM -0500, Waiman Long wrote:
>> The isolcpus= parameter just reduce the cpus available to the rests of
>> the system. The cpuset controller does look at that value and make
>> adjustment accordingly, but it has no dependence on exclusive cpu/mem
>> features of cpuset.
> The isolcpus= boot param is donkey shit and needs to die. cpuset _used_
> to be able to fully replace it, but with the advent of cgroup 'feature'
> this got lost.
>
> And instead of fixing it, you're making it _far_ worse. You completely
> removed all the bits that allow repartitioning the scheduler domains.
>
> Mike is completely right, full NAK on any such approach.

So you are talking about sched_relax_domain_level and
sched_load_balance. I have not removed any bits. I just haven't exposed
them yet. It does seem like these 2 control knobs are useful from the
scheduling perspective. Do we also need cpu_exclusive or just the two
sched control knobs are enough?

Cheers,
Longman


