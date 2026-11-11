Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.253
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794399554;
	b=fM4rgjQDYdwjVNP3FFJAR950RvEEjgAF8nZhlgzvwYlS/Zes0a0rKezNpCf1iwtAseYP
	 YqtRUAYvR64NZb2RssaIbcULOwLrz6Z9aKEJicittM5ILd0JtLP3rTKXVo+qjYtKIQjjI
	 NRSyZqoIhji8q8C2xTd0zL8XtD2L3sooZIyncCyvB0AvFBBDBDxNTlQVcZzL7FhAUsMgT
	 44HFWb8usw0Bb8queojcYy7FLswW3PABzh/r5n7s0deLEWXea9ahWmUXBHfAyp1FgnAVm
	 sbXAEGpeI5jYzT7MoDG8Ye38rNdZ+sU4NwqljgvvQ7yXumJlpZ+fz8ElnguLL6DsLWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794399554;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=FwlCJIPGZELPwpcaZclguO5jJA9pNZllbqwAgK19VHo=;
	b=Bs8oRpvaJWqJlTPqM/idXzMv3ILrgiW8IecwCJmihBly+ky2pUAwKutrVgdhrWn9d14Y
	 5aXOylR0knDxuOV5mbF/XLf/a4mLFGSD3s88GZagWjnngMuVO7t7egDLeYyLV7nC6me1F
	 MUlgvRKN9bo6UYWy0k3DXIUBvNmyvnabXQNKaLz1BcsTQXnBmACqq6V3SscF2Mz7Hg/U2
	 zcNn/DSxCOLeCMbVa996E6gygwEI2D9mVW4a61j7P5bkUuIxOMEWEm5WIxi4L28QMuub1
	 F/kA5t7TSisrrUSclUPgf5tyWN2cST3Fkos0mWQ2VLT101+ssfwfR0DwXUB7V+1tIaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GCtZz5FH;
	arc=none smtp.remote-ip=91.218.175.253
Received: from mta0.migadu.com (out-253.mta0.migadu.com [91.218.175.253])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35EE606A32A
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 12:19:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F35EE606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GCtZz5FH
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3m2GMq0RVL0jhsbb+prdqkpSbIXFKr1HjWNZdvr7VHw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794399552; v=1; x=1795004352;
 b=GCtZz5FHwwdRsqI2CZ8CwhvYkNxeNKxPYqTPvUfGJNyHCDdy7O9CBhW01K05GICMIyNPJEcg
 vOLUXOrKwgsuspjN/Ukg21uQrOJgKaLsTBomROd2R3J7ipXgNLWLK1+5rC6j2+ftwoHpsaBZYeo
 ggLoR6vKJr/RsuYjhFYxdjAY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b1624b5b0c979197;
	Wed, 11 Nov 2026 12:19:12 +0000
X-Mizu-Trace-ID: b1624b5b0c979197
X-Migadu-Flow: FLOW_OUT
Message-ID: <b90235a0-4ac6-49e9-bb2e-fad23c4ab15a@linux.dev>
Date: Wed, 11 Nov 2026 20:19:06 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] cgroup/cpuset: Keep the top sched domain non-empty
 on CPU hotplug
To: Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>,
 Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261110050324.173461-1-guopeng.zhang@linux.dev>
 <20261110050324.173461-4-guopeng.zhang@linux.dev>
 <19708635-67de-45ab-9539-8d686caa7132@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <19708635-67de-45ab-9539-8d686caa7132@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/10 20:55, Ridong Chen 写道:
> 
> 
> On 11/10/2026 1:03 PM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> In cpuset_hotplug_update_tasks(), the local partition check passes only
>> the partition's own effective CPUs to tasks_nocpu_error(). For a
>> top-level partition with children, top_cpuset_sd_nocpu() treats the
>> children's CPUs as being returned, although hotplug does not return
>> them. This can leave the top sched domain empty when its last boot
>> domain housekeeping CPU goes offline.
>>
>> For example, on a 32-CPU system with isolcpus=domain,10-31:
>>
>>    echo 0,2-9 > A/cpuset.cpus
>>    echo root > A/cpuset.cpus.partition
>>    echo 5-9 > A/B/cpuset.cpus
>>    echo root > A/B/cpuset.cpus.partition
>>    echo 0 > /sys/devices/system/cpu/cpu1/online
>>    Oops: general protection fault
>>    RIP: 0010:build_perf_domains+...
>>
>> The remote hotplug path does not check whether the top sched domain
>> is empty.
>>
>> Check the full effective_xcpus of top-level local and remote partitions
>> without assuming any CPUs have been returned. Only invalidate a
>> partition to restore the top domain if it can return an active boot
>> domain housekeeping CPU. Partitions holding only boot-isolated or
>> offline housekeeping CPUs cannot do that.
>>
>> Add hotplug regression tests.
>>
>> Fixes: 9b496a8bbed9 ("cgroup/cpuset: Prevent leakage of isolated CPUs into sched domains")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c                        | 23 ++++++++++++++++---
>>   .../selftests/cgroup/test_cpuset_prs.sh       | 19 +++++++++++++++
>>   2 files changed, 39 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 8b6831983803..0b392d50df27 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -4043,6 +4043,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>>       static nodemask_t new_mems;
>>       bool cpus_updated;
>>       bool mems_updated;
>> +    bool nocpu;
>>       int partcmd = -1;
>>       struct cpuset *parent;
>>   @@ -4054,9 +4055,24 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>>       if (!tmp || !cs->partition_root_state)
>>           goto update_tasks;
>>   +    if (parent == &top_cpuset || is_remote_partition(cs)) {
>> +        /*
>> +         * Hotplug does not return CPUs held by child partitions. Only
>> +         * invalidate a partition for an empty top sched domain if it
>> +         * can return an active boot domain housekeeping CPU.
>> +         */
>> +        cpumask_and(tmp->addmask, cs->effective_xcpus,
>> +                housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
>> +        nocpu = cpumask_intersects(tmp->addmask, cpu_active_mask) &&
>> +            top_cpuset_sd_nocpu(cs->effective_xcpus, NULL);
>> +        nocpu |= cpumask_empty(&new_cpus) &&
>> +             partition_is_populated(cs, NULL);
>> +    } else {
>> +        nocpu = tasks_nocpu_error(parent, cs, &new_cpus);
>> +    }
>> +
>>       if (is_remote_partition(cs) && (cpumask_empty(subpartitions_cpus) ||
>> -                       (cpumask_empty(&new_cpus) &&
>> -                    partition_is_populated(cs, NULL)))) {
>> +                       nocpu)) {
>>           WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
>>           remote_partition_disable(cs, tmp);
>>           compute_effective_cpumask(&new_cpus, cs, parent);
>> @@ -4069,10 +4085,11 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>>        * 2) parent is invalid or doesn't grant any cpus to child
>>        *    partitions.
>>        * 3) subpartitions_cpus is empty.
>> +     * 4) top_cpuset needs an active boot domain housekeeping CPU from cs.
>>        */
>>       if (is_local_partition(cs) &&
>>           (!is_partition_valid(parent) ||
>> -         tasks_nocpu_error(parent, cs, &new_cpus) ||
>> +         nocpu ||
>>            cpumask_empty(subpartitions_cpus)))
>>           partcmd = partcmd_invalidate;
>>       /*
>> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> index ee4d57b7e35b..f345696e5b53 100755
>> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> @@ -648,8 +648,27 @@ ISOLCPUS_DOMAIN_TEST_MATRIX=(
>>         # An invalid partition can recover once it leaves a top-level HK CPU.
>>       " C0-9:P1   .      .      .    C0-6,8-9 .      .      .     0 A1:0-6,8-9 A1:P1 7|"
>> +
>> +    # A local root must not count its child's CPUs as already returned.
>> +    " C0,2-9:P1 C5-9:P1 . . O1=0 . . . 0 A1:0,2-9|A2:5-9 A1:P-1|A2:P-1 1|"
>> +
>> +    # A remote root must return CPUs when the top domain loses its last HK CPU.
>> +    " X0,2-9 CX0,2-9:P1 . . O1=0 . . . 0 A2:0,2-9 A2:P-1 1|"
>>   )
>>   +# Keep an online boot-isolated CPU at the top so hotplug does not
>> +# clear subpartitions_cpus before checking the individual partitions.
>> +if [[ "$ONLINE_LAST" -gt 10 ]]; then
>> +    ISOLCPUS_DOMAIN_TEST_MATRIX+=(
>> +        # An offline HK CPU cannot restore the top domain. Keep this local
>> +        # partition valid while its sibling returns active HK CPUs.
>> +        " O2=0:C2,10:P2 . . C0,3-9:P1 O1=0 . . . 0 A1:10|B1:0,3-9 A1:P2|B1:P-1 1-2|2"
>> +
>> +        # Check the same active-CPU rule for a remote partition.
>> +        " O2=0:X2,10 CX2,10:P2 . C0,3-9:P1 O1=0 . . . 0 A2:10|B1:0,3-9 A2:P2|B1:P-1 1-2|2"
>> +    )
>> +fi
>> +
>>   # Test matrix to be run when boot time nohz_full CPUs cover all CPUs except CPUs 0-7
>>   # This also means that CPU 8 is available and is a nohz_full CPU.
>>   NOHZ_FULL_TEST_MATRIX=(
> 
> Hi Guopeng,
> 
> Looking at patches 1-3, the same check is changed back and forth in
> several places, and the places don't do it in the same way. I'd prefer
> a single helper that is unified and easy to understand, so that every
> place can just call it.
> 
> As tasks_nocpu_error() is shared by the CPU mask update paths and the
> hotplug path, patches 1-3 end up checking the same thing in several
> places with different masks. How about making tasks_nocpu_error() take
> the CPUs to be returned as an explicit argument, the same way as
> top_cpuset_sd_nocpu() does, and use it for all parents? Something like
> the following (not tested):
> 
> /*
> * tasks_nocpu_error - Return true if tasks will have no effective_cpus
> * @parent: parent partition, NULL for a remote partition
> * @cs: the partition
> * @xcpus: exclusive CPUs that @cs will hold after the update
> * @del_cpus: exclusive CPUs to be returned to @parent, can be NULL
> *
> * @del_cpus may include CPUs that are also in @xcpus and will stay in
> * @cs. They are skipped by the @xcpus check, so callers can pass the
> * current effective_xcpus of @cs without masking it first.
> *
> * top_cpuset always has tasks, and its sched domain needs an active boot
> * domain housekeeping CPU.
> */
> static bool tasks_nocpu_error(struct cpuset *parent, struct cpuset *cs,
>                             const struct cpumask *xcpus,
>                             const struct cpumask *del_cpus)
> {
>     const struct cpumask *mask = cpu_possible_mask;

Hi，Ridong

I made a small adjustment to your suggested code. For non-top parents, I used parent->effective_xcpus instead of cpu_possible_mask.
An ancestor update may have removed some CPUs from the parent's grant. Counting those CPUs as returned could allow the child to remain valid while leaving a populated parent with no effective CPUs.

Thanks，
Guopeng
>     int cpu;
> 
>     /* A populated @cs must have an active CPU in @xcpus */
>     if (!cpumask_intersects(xcpus, cpu_active_mask) &&
>         partition_is_populated(cs, NULL))
>             return true;
> 
>     /*
>      * A populated @parent must keep an active CPU in @mask, either from
>      * its effective_cpus or from @del_cpus, that isn't taken by @cs.
>      */
>     if (!parent)
>           parent = &top_cpuset;
> 
>     if (parent == &top_cpuset)
>           mask = housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT);
>     else if (!partition_is_populated(parent, cs))
>           return false;
>        
>     for_each_cpu_and(cpu, mask, cpu_active_mask) {
>           if (cpumask_test_cpu(cpu, xcpus))
>                   continue;
>           if (cpumask_test_cpu(cpu, parent->effective_cpus) ||
>               (del_cpus && cpumask_test_cpu(cpu, del_cpus)))
>                   return false;
>     }
>     return true;
> }
> 
> The callers then become:
> 
> /* update_parent_effective_cpumask() */
> nocpu = tasks_nocpu_error(parent, cs, tmp->delmask,
>             is_partition_valid(cs) ? cs->effective_xcpus : NULL);
>                        
> /* validate_partition() */
> if (tasks_nocpu_error(is_remote_partition(cs) ? NULL : parent, cs,
>             trialcs->effective_xcpus,
>             is_partition_valid(cs) ? cs->effective_xcpus : NULL))
>                    
> /* remote_partition_enable(), instead of top_cpuset_sd_nocpu() */
> tasks_nocpu_error(NULL, cs, tmp->new_cpus, NULL)
> 
> /* remote_cpus_update(), instead of top_cpuset_sd_nocpu() */
> tasks_nocpu_error(NULL, cs, excpus, cs->effective_xcpus)
> 
> /* cpuset_hotplug_update_tasks(), hotplug returns nothing */
> nocpu = tasks_nocpu_error(is_remote_partition(cs) ? NULL : parent, cs,
>                         &new_cpus, NULL);
>                            
> In the hotplug path, @del_cpus is NULL as nothing is returned to the
> parent. new_cpus can be used as @xcpus for both checks, as the CPUs of
> the child partitions of cs are not in the parent's effective_cpus
> anyway. The check that cs can return an active boot domain housekeeping
> CPU before invalidating it can stay there.
> 
> This also covers the local parent case I mentioned in patch 2, so
> patch 2 won't be needed. Could you give it a try with your test cases
> and that reproducer?
> 

