From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Fri, 17 Aug 2018 21:03:28 -0400
Message-ID: <219817a9-773e-e1ea-9b85-7af15919bbc2@redhat.com>
References: <20180719165201.GU72677@devbig577.frc2.facebook.com>
 <20180720113121.GJ2476@hirez.programming.kicks-ass.net>
 <20180720114549.GY72677@devbig577.frc2.facebook.com>
 <20180720154454.GR2494@hirez.programming.kicks-ass.net>
 <20180720155613.GB1934745@devbig577.frc2.facebook.com>
 <4857a9db-ebf5-24f8-c42d-d795f5c75854@redhat.com>
 <20180720163712.GU2494@hirez.programming.kicks-ass.net>
 <8c655adc-6d9e-b767-1024-5d6941c995a9@redhat.com>
 <20180720174100.GC1934745@devbig577.frc2.facebook.com>
 <446ab203-85cd-32ff-40a9-0ba22d5a2534@redhat.com>
 <20180817155946.GJ3978217@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180817155946.GJ3978217@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 08/17/2018 11:59 AM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Mon, Aug 13, 2018 at 01:56:15PM -0400, Waiman Long wrote:
>> The following restrictions are still imposed on a partition root wrt
>> allowable changes in cpuset.cpus:
>> 1) cpuset.cpus cannot be set to "". There must be at least 1 cpu there.
>> 2) Adding cpus that are not in parent's cpuset.cpus (as well as
>> cpuset.cpus.effective) or that will take all the parent's effective cpus
>> away is not allowed.
>>
>> So are these limitations acceptable?
>>
>> The easiest way to remove those restrictions is to forcefully turn off
>> the cpuset.sched.partition flag in the cpuset as well as any
>> sub-partitions when the user try to do that. With that change, there
>> will be no more new restriction on what you can do on cpuset.cpus.
> I think that'd be the right thing to do.  That's what we do with
> cpuset.cpus and cpuset.mems too.  If there's nothing available, we
> ignore the config and show the settings which are currently in effect.
>
> Thanks.
>
Thanks! I will send out an updated patch after the 4.19 merge window closes.

-Longman

