From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH v6 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Tue, 24 Aug 2021 01:35:33 -0400
Message-ID: <95b72d36-32a9-8356-05b7-2829e4cc29ad@redhat.com>
References: <20210814205743.3039-1-longman@redhat.com>
 <20210814205743.3039-6-longman@redhat.com> <YRqbj5+ZdS+7k0Fn@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629783341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hMA9he3KzhIpa9VL4u2RVLcuo/UfXEbjSwWCQUOA21E=;
        b=WgDL5RAr5yB0fi43/gnecn6/MeMX5arENvJof06wKM4PD/1EcrVq2wZqOlPjS1Rjlk6qCc
        jtTwFuD9MACpZEWG6ABs2SQNVmTJThJM6c2Tw4I4MrpmnqmOdgzkk6UnGRD8FP1o/h9VnJ
        u64z7AsJKfm6MUmj7NcC0oLQr3mwv9k=
In-Reply-To: <YRqbj5+ZdS+7k0Fn@slm.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 8/16/21 1:08 PM, Tejun Heo wrote:
> On Sat, Aug 14, 2021 at 04:57:42PM -0400, Waiman Long wrote:
>> +	A parent partition may distribute all its CPUs to its child
>> +	partitions as long as it is not the root cgroup and there is no
>> +	task directly associated with that parent partition.  Otherwise,
> "there is not task directly associated with the parent partition" isn't
> necessary, right? That's already enforced by the cgroup hierarchy itself.

Sorry for the late reply as I was on vacation last week.

Yes, that is true. I should have de-emphasized that the fact that parent 
partition must have no task.

>
>> +	there must be at least one cpu left in the parent partition.
>> +	A new task cannot be moved to a partition root with no effective
>> +	cpu.
>> +
>> +	Once becoming a partition root, changes to "cpuset.cpus"
>> +	is generally allowed as long as the first condition above
>> +	(cpu exclusivity rule) is true.
> All the above ultimately says is that "a new task cannot be moved to a
> partition root with no effective cpu", but I don't understand why this would
> be a separate rule. Shouldn't the partition just stop being a partition when
> it doesn't have any exclusive cpu? What's the benefit of having multiple its
> own failure mode?
A partition with 0 cpu can be considered as a special partition type for 
spawning child partitions. This can be temporary as the cpus will be 
given back when a child partition is destroyed.
>
>> +	Sometimes, changes to "cpuset.cpus" or cpu hotplug may cause
>> +	the state of the partition root to become invalid when the
>> +	other constraints of partition root are violated.  Therefore,
>> +	it is recommended that users should always set "cpuset.cpus"
>> +	to the proper value first before enabling partition.  In case
>> +	"cpuset.cpus" has to be modified after partition is enabled,
>> +	users should check the state of "cpuset.cpus.partition" after
>> +	making change to it to make sure that the partition is still
>> +	valid.
> So, idk why the this doesn't cover the one above it. Also, this really
> should be worded a lot stronger. It's not just recommended - confirming and
> monitoring the transitions is an integral and essential part of using
> cpuset.
Sure, I will reword it to remove any mention of recommendation
> ...
>> +	An invalid partition is not a real partition even though the
>> +	restriction of the cpu exclusivity rule will still apply.
> Is there a reason we can't bring this in line with other failure behaviors?
The internal flags are kept so that we can easily recover and become a 
valid partition again when the cpus become available. Otherwise, we can 
guarantee that the partition status can be restored even when the cpus 
become available.
>
>> +	In the special case of a parent partition competing with a child
>> +	partition for the only CPU left, the parent partition wins and
>> +	the child partition becomes invalid.
> Given that parent partitions are *always* empty, this rule doesn't seem to
> make sense.
You are right. I will update the wording.
>
> So, I think this definitely is a step in the right direction but still seems
> to be neither here or there. Before, we pretended that we could police the
> input when we couldn't. Now, we're changing the interface so that it
> includes configuration failures as an integral part; however, we're still
> policing some particular inputs while letting other inputs pass through and
> trigger failures and why one is handled one way while the other differently
> seems rather arbitrary.
>
The cpu_exclusive and load_balance flags are attributes associated 
directly with the partition type. They are not affected by cpu 
availability or changing of cpu list. That is why they are kept even 
when the partition become invalid. If we have to remove them, it will be 
equivalent to changing partition back to member and we may not need an 
invalid partition type at all. Also, we will not be able to revert back 
to partition again when the cpus becomes available.

Cheers,
Longman

