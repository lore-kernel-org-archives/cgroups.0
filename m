From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v6 2/2] cpuset: Add cpuset.sched_load_balance to v2
Date: Tue, 27 Mar 2018 10:23:33 -0400
Message-ID: <e20484c9-e901-9737-d856-783a6eba1604@redhat.com>
References: <1521649309-26690-1-git-send-email-longman@redhat.com>
 <1521649309-26690-3-git-send-email-longman@redhat.com>
 <20180322084120.GE7231@localhost.localdomain>
 <e754e128-0a93-800e-e71b-2c8dc316ba8a@redhat.com>
 <20180323075952.GA4763@localhost.localdomain>
 <a8860a42-31b5-4620-7b23-b7515ee11d7d@redhat.com>
 <20180326124711.GE5942@localhost.localdomain>
 <bf79b45e-7716-65af-03ca-7112dc367371@redhat.com>
 <20180327140259.GN1840639@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180327140259.GN1840639@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 03/27/2018 10:02 AM, Tejun Heo wrote:
> Hello,
>
> On Mon, Mar 26, 2018 at 04:28:49PM -0400, Waiman Long wrote:
>> Maybe we can have a different root level flag, say,
>> sched_partition_domain that is equivalent to !sched_load_balnace.
>> However, I am still not sure if we should enforce that no task should be
>> in the root cgroup when the flag is set.
>>
>> Tejun and Peter, what are your thoughts on this?
> I haven't looked into the other issues too much but we for sure cannot
> empty the root cgroup.
>
> Thanks.
>
Now, I have a different idea. How about we add a special root-only knob,
say, "cpuset.cpus.isolated" that contains the list of CPUs that are
still owned by root, but not participated in load balancing. All the
tasks in the root are load-balanced among the remaining CPUs.

A child can then be created that hold some or all the CPUs in the
isolated set. It will then have a separate root domain if load balancing
is on, or an isolated cpuset if load balancing is off.

Will that idea work?

Cheers,
Longman


