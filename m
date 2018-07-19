From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Thu, 19 Jul 2018 13:38:13 -0400
Message-ID: <468d70b2-c3d8-53c6-bbda-050106bcf60d@redhat.com>
References: <1529825440-9574-8-git-send-email-longman@redhat.com>
 <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <20180719135224.GE2494@hirez.programming.kicks-ass.net>
 <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
 <20180719153045.GT72677@devbig577.frc2.facebook.com>
 <de6f931d-613a-3e6a-2a4d-0e49b3bfe2e5@redhat.com>
 <20180719165201.GU72677@devbig577.frc2.facebook.com>
 <69903192-8711-6a1e-0cd0-fbb249a4204b@redhat.com>
 <20180719172551.GW72677@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180719172551.GW72677@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 07/19/2018 01:25 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Thu, Jul 19, 2018 at 01:22:36PM -0400, Waiman Long wrote:
> ...
>> Do you want a way at the parent level to take CPUs away from child
>> partitions? The "cpus.subpart" file can probably be used also for this
>> purpose, but we have to decide what taking CPUs away from child
>> partition means. Does that mean automatically turn off the partition
>> flag in the children if there is no CPU left in the partition? There are
> Yeah, I think so.  That's what we do when cpuset.cpus or mems go empty
> - ignoring the config.
>
>> some implementation details that need to be fleshed out. I would prefer
>> not doing this as this will complicate the code without too much benefit
>> that I can see.
> So, given how long this has been dragging along and it isn't yet super
> clear to me why this needs to be fully hierarchical, I'd actually
> prefer just restricting it to the first level children.
>
> Thanks.
>
Yes, I would prefer to check in the v11 cpuset patch as it is today,
including the incremental patch to limit partition to first level child
minus the debug patch. I do need to make cpuset v2 enabled ASAP.

This will give me more times to work on extending partition to be
hierarchical if the need arises as well as other cpuset v2 features. We
usually can't get all the things right in one single step.

Peter, are you OK with that? I can promise you that I will work to make
this happen at a later date if you really want it.

Cheers,
Longman


