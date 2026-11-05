Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.78
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793844824;
	b=Kp2bDp11QKpTNBA6Z+08v5dh3DeJliaTxk/Ove4rY97qFAj8vyKNCQH/93TSYBiEs0Kk
	 FqlWA0RNDAPBuj9wfaYI0AC9eCbwyRA0xnqz22D7kOSWiyqMNgO2SGZ+BaAVEf4pCnZHr
	 juIRDI7a39CRUDQ3r+0qrCvKv5AE4iDmQOSCk6elhFN/nosctq7aEER6fBONfO5hjqQMJ
	 4N5FGIRYWjMjmveNJ7XL5dwjREVvDVgBGKTW1IM2qVmkzMj67MrrNxr4iq+JHFiUcRD9B
	 dwCf+WjhI5wqfkcYEwZJgqxfNSfAQm45emc3MKNHgOAyT4tOV+wMhtPhIxVq+Vuab0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793844824;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=hNDLSFapUDH5zg85s2N1cWnGesB/dC3nKW1Zdod/mJM=;
	b=lg4k1j5NgbX4dDmmUryOypwK7ZWqTrp6UBrL+Azk2Xq5g8QTAg100KzUUVKBtUPwUvDE
	 GBJnLXPS4n6PB+tq5xaRj3bOokyX1vjg4IXT+MoVjR60IO5IssZ/pJNUQVNR/5gFkJ9HB
	 d+NIxMofv46Nm+J/+0kxZI1uCb3t7haSe01Utv5nQeqS74BLwXOPJSMlV50ytR136rHlR
	 ZoSj8fUf8iL6YFUEHm6pIdFvHd9zKC9JTGshvXrxnhBVE6luzbnnlCOs5kwI2tz4pZqRB
	 /k6SHh6pm13gBcsIeGIcsrhGi4VUZIZkYO4rnVyishiykTD3/6yxedKKRzM1hAhdRFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GTN47C24;
	arc=none smtp.remote-ip=95.215.58.78
Received: from mta1.migadu.com (out-78.mta1.migadu.com [95.215.58.78])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EE4606A328
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 02:13:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3EE4606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GTN47C24
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8I/giyMs0wqeew5AfRUUOtj+4dlC5TxPYe3tjop4G7Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793844821; v=1; x=1794449621;
 b=GTN47C242OTjxoETwRoDA4BNNMBb96ebNpD8Fs7hcBOuXEfB4UY9tjCqMCMULvNYzHbZTVs9
 rF0xm7EfvvrHIlO+8uqH39Q+2TJFSVheoWh0KNsIYT29D3R3Sxt3FqEfBpj54Vs8kS3zteYOtL/
 UaYoLjy6PfYWWvgx9bN5zOwc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8fb82eb1ffacc0da;
	Thu, 05 Nov 2026 02:13:41 +0000
X-Mizu-Trace-ID: 8fb82eb1ffacc0da
X-Migadu-Flow: FLOW_OUT
Message-ID: <d683135f-e0da-4f1e-b4b4-084931582a24@linux.dev>
Date: Thu, 5 Nov 2026 10:13:33 +0800
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
Subject: Re: [PATCH] cgroup/cpuset: Fail if isolated CPUs don't leave any boot
 domain housekeeping CPU
To: Waiman Long <longman@redhat.com>, Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261104071600.474587-1-guopeng.zhang@linux.dev>
 <cbe741a9-fd0c-4c8f-8591-55ecc70f222a@linux.dev>
 <21cfe1b7-be80-4f3b-8366-cd77afd113b0@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <21cfe1b7-be80-4f3b-8366-cd77afd113b0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/5/2026 2:54 AM, Waiman Long wrote:
> On 11/4/26 7:58 AM, Ridong Chen wrote:
>>
>>
>> On 11/4/2026 3:16 PM, Guopeng Zhang wrote:
>>> From: Guopeng Zhang<zhangguopeng@kylinos.cn>
>>>
>>> With the "domain" flag of the isolcpus= boot option, the CPUs isolated
>>> at boot are excluded from the sched domains and the remaining CPUs
>>> become the boot domain housekeeping CPUs. An isolated partition is
>>> allowed to use the boot isolated CPUs, but it must not take over all
>>> the boot domain housekeeping CPUs.
>>>
>>> prstate_housekeeping_conflict() checks that rule for root partitions
>>> only. The 2nd check covers the nohz_full case as it is gated by
>>> housekeeping_enabled(HK_TYPE_KERNEL_NOISE) which is not enabled by
>>> isolcpus=domain. So on an isolcpus=domain,<cpus> boot, an isolated
>>> partition can claim all the remaining boot domain housekeeping CPUs.
>>> The state is committed, but the sched domain rebuild at the end of
>>> the write finds no housekeeping CPU left for the boot domain and
>>> hits WARNs and an OOPS in partition_sched_domains().
>>> housekeeping_update() cannot accept the configuration either as it
>>> cannot empty the boot domain housekeeping mask.
>>> With an "isolcpus=domain,10-31" boot where CPUs 0-9 are the boot
>>> domain housekeeping CPUs, for example:
>>>
>>>    # echo 0-9 > A/cpuset.cpus
>>>    # echo isolated > A/cpuset.cpus.partition
>>>    WARNING: kernel/sched/topology.c:3089 at build_sched_domains+...
>>>    WARNING: kernel/cgroup/cpuset.c:1478 at cpuset_update_sd_hk_unlock+...
>>>    RIP: 0010:partition_sched_domains+0x3b8
>>>
>>> Fix that by extending prstate_housekeeping_conflict() to reject an
>>> isolated partition update that would leave no active boot domain
>>> housekeeping CPU outside the isolated CPUs. The CPUs released back
>>> to the boot domain by the same update are taken into account, so
>>> replacing one of the last housekeeping CPUs with another one in a
>>> single update remains allowed. The new check is only performed when
>>> housekeeping_enabled(HK_TYPE_KERNEL_NOISE) is disabled so that the
>>> existing nohz_full behavior is unchanged.
>>>
>>> Add test cases in test_cpuset_prs.sh to verify that taking over all
>>> the boot domain housekeeping CPUs is rejected while swapping one of
>>> them with another one is allowed.
>>
>> Hi Guopeng,
>>
>> Thanks for the report and the reproducer. I can reproduce the WARN and
>> the OOPS in partition_sched_domains() here.
>>
>> However, I don't think prstate_housekeeping_conflict() is the right
>> place to fix it, and the fix doesn't seem complete. The same problem
>> can be triggered with a root partition, which this patch doesn't cover.
>> With an "isolcpus=domain,4-7" boot on an 8-CPU VM:
>>
>>   # echo 0-3 > A/cpuset.cpus
>>   # echo root > A/cpuset.cpus.partition
>>   WARNING: kernel/sched/topology.c:3111 at build_sched_domains+0x2b96/0x5500
>>   Oops: general protection fault, ... [#1] SMP KASAN NOPTI
>>   RIP: 0010:partition_sched_domains+0x10a3/0x1a10
>>
>> The faulting address is in build_perf_domains(), where cpumask_first()
>> on the empty cpu_map returns nr_cpu_ids and cpu_rq() goes out of
>> bounds.
>>
>> The root cause looks like it isn't a housekeeping conflict. Boot time
>> isolated CPUs stay in top_cpuset.effective_cpus by design, and they are
>> only filtered out of the top_cpuset sched domain in
>> generate_sched_domains(). But the checks that make sure the parent
>> still has CPUs left, i.e. tasks_nocpu_error() for local partitions and
>> the cpumask_subset(top_cpuset.effective_cpus, ...) checks in
>> remote_partition_enable()/remote_cpus_update(), only look at
>> top_cpuset.effective_cpus. So any partition, root or isolated, local
>> or remote, can take away all the boot domain housekeeping CPUs as long
>> as some boot isolated CPUs are still left in top_cpuset, which leaves
>> the top_cpuset sched domain empty.
>>
>> So I think the check should be done at the "parent has no CPU left"
>> level instead. Something like the diff below. It is not tested yet;
>> could you give it a try with your reproducer and the test cases?
>> Note that the root partition and remote partition cases should be
>> added to the selftest as well.
>>
>> Without isolcpus=domain, HK_TYPE_DOMAIN_BOOT is cpu_possible_mask and
>> the new check is equivalent to the existing one, so no extra
>> housekeeping_enabled() gating is needed.
>>
>> ---
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 3219f927c35e..fb3e81405f5b 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1180,12 +1180,51 @@ static void update_partition_sd_lb(struct cpuset *cs, 
>> int old_prs)
>>                 cpuset_force_rebuild();
>>  }
>>
>> +/*
>> + * top_cpuset_sd_nocpu - Check if top_cpuset will have no sched domain CPU
>> + * @add_cpus: CPUs to be taken away from top_cpuset
>> + * @del_cpus: CPUs to be given back to top_cpuset, can be NULL
>> + * Return: true if no active CPU will be left in the top_cpuset sched domain
>> + *
>> + * Boot time isolated CPUs stay in top_cpuset.effective_cpus, but they are
>> + * excluded from the sched domain of top_cpuset in generate_sched_domains().
>> + * So checking top_cpuset.effective_cpus alone is not enough to ensure that
>> + * the top_cpuset sched domain won't become empty after @add_cpus are taken
>> + * away from it. The sched domain of top_cpuset must keep at least one
>> + * active boot domain housekeeping CPU.
>> + */
>> +static bool top_cpuset_sd_nocpu(const struct cpumask *add_cpus,
>> +                               const struct cpumask *del_cpus)
>> +{
>> +       const struct cpumask *hk_mask = 
>> housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT);
>> +       int cpu;
>> +
>> +       for_each_cpu_and(cpu, hk_mask, cpu_active_mask) {
>> +               if (cpumask_test_cpu(cpu, add_cpus))
>> +                       continue;
>> +               if (cpumask_test_cpu(cpu, top_cpuset.effective_cpus) ||
>> +                   (del_cpus && cpumask_test_cpu(cpu, del_cpus)))
>> +                       return false;
>> +       }
>> +       return true;
>> +}
>> +
>>  /*
>>   * tasks_nocpu_error - Return true if tasks will have no effective_cpus
>>   */
>>  static bool tasks_nocpu_error(struct cpuset *parent, struct cpuset *cs,
>>                               struct cpumask *xcpus)
>>  {
>> +       /*
>> +        * The top_cpuset always has tasks (kthreads at least), so its sched
>> +        * domain can't be empty. The current effective_xcpus of a valid
>> +        * partition will be given back to top_cpuset if not in @xcpus.
>> +        */
>> +       if ((parent == &top_cpuset) &&
>> +           top_cpuset_sd_nocpu(xcpus, is_partition_valid(cs)
>> +                                      ? cs->effective_xcpus : NULL))
> 
> The del_cpus should normally be (cs->effective_xcpus & ~xcpus), but the 
> top_cpuset_sd_nocpu() helper will skip CPUs that are in xcpus. So it will work 
> in this case. It should be noted in the functional comment of 
> top_cpuset_sd_nocpu() that @del_cpus can include common CPUs that will stay in 
> the partition which will be skipped in the helper so that future change won't 
> accidentally change that behavior.
> 

Thank you for your reply.

Yes, perhaps Guopeng could make the code and comments more readable.

> 
>> + return true;
>> +
>>         /*
>>          * A populated partition (cs or parent) can't have empty effective_cpus
>>          */
>> @@ -1724,7 +1763,7 @@ static int remote_partition_enable(struct cpuset *cs, 
>> int new_prs,
>>          */
>>         compute_excpus(cs, tmp->new_cpus);
>>         if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
>> -           cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
>> +           top_cpuset_sd_nocpu(tmp->new_cpus, NULL))
>>                 return PERR_INVCPUS;
>>         if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
>>                 return PERR_NOCPUS;
>> @@ -1828,7 +1867,7 @@ static void remote_cpus_update(struct cpuset *cs, struct 
>> cpumask *xcpus,
>>                 if (!capable(CAP_SYS_ADMIN))
>>                         WRITE_ONCE(cs->prs_err, PERR_ACCESS);
>>                 else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
>> -                        cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
>> +                        top_cpuset_sd_nocpu(tmp->addmask, tmp->delmask))
>>                         WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
>>                 else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
>>                                                        excpus, tmp->delmask))
>>
> 

-- 
Best regards
Ridong

