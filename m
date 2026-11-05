Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883808;
	b=klyvTeg2+ZykO1cS5J4YLqoyd3jaD4PGb8R+YeoOKId79XyW7WImAu8TQ2ekZxMNNsmV
	 aYyzvgAyRielRAdIGCMwIBcVPlsoAzD4YdLJ0PBnjQhqg9Rk5Xg3zboFkElb2t+oS0q/K
	 0mFkx/z7liu1xw6w1xeHGXmKobEBqyi1tt8Yq4vjn8NZFmmYWdDGA4DKu+PAs5IwL+p8n
	 Ip93Z1bU9JaC4RgOYDGXKBN5B92+963YbB5hns2sjOctt2VPsWxjgKFoczjDI/ZSgB8Gh
	 svlHsIdCUj3PTXeNY/SWS4xwylhjADCHGBazEEU1oOwaxw5v7EoYtMjBPeWeLsJpfAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883808;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=/B4p0zYu6vf94H1deUHTjyHQEII4+nCm7USZq9LhQr4=;
	b=V7MB7sxFxYy+P6oBYLWioyEroYmQz/D5AMbxxGZh8O9FikrIBAyPx2OpL/ef8vTDi4KX
	 9ii5iOr4KaNX/ImtgwWeijido0ugF6IBywBTAWoBr3ZiKa3+8rINHUU9rF0WJbg3Md/Hb
	 a41naQR1/pOQIjEYBpKiuldReCmSRw+zdZ6IMdi07xoxb25BEpb6FlID+F4xwVcR1riOO
	 UHIlicwCIvRQdZ/PI9RK8CWnanfwBecF/yv47ZQPv6mR/erkTbc5ngVeG7kYlj8DtldWF
	 eCtuIZ9K3r1ETu3TiiAmROkKBnoKGl7Ip0tqonuB7BKqiTAxhFnEMSOhOrQrc0ljUUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="cFmndGt/";
	arc=none smtp.remote-ip=95.215.58.4
Received: from mta1.migadu.com (out-4.mta1.migadu.com [95.215.58.4])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ABD606A328
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 13:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97ABD606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cFmndGt/
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KVVDnrqqBYKgCokM5aN3M4FBZl2SrgkNlUPUvf8sSow=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793883804; v=1; x=1794488604;
 b=cFmndGt/CixNa++Y0ML1xZfphtpK9fbawRSxccjPRS+vwLkXdZEzvnhWEIm9usvxdAbJ8MdQ
 CsvKqBttSH8Y6jvKoMcTRTAFnq3oXCDAZr6os+6VWrGpD6pv24KLuwna+Sf92ZotolqtTsTZnw2
 +0PUVxNeD1BZaxjLzpXjB/9k=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 881d24b1d490bce2;
	Thu, 05 Nov 2026 13:03:24 +0000
X-Mizu-Trace-ID: 881d24b1d490bce2
X-Migadu-Flow: FLOW_OUT
Message-ID: <4c8f9eee-3988-4e68-aa1a-f1ad788972d6@linux.dev>
Date: Thu, 5 Nov 2026 21:03:16 +0800
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
To: Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261104071600.474587-1-guopeng.zhang@linux.dev>
 <cbe741a9-fd0c-4c8f-8591-55ecc70f222a@linux.dev>
 <21cfe1b7-be80-4f3b-8366-cd77afd113b0@redhat.com>
 <d683135f-e0da-4f1e-b4b4-084931582a24@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <d683135f-e0da-4f1e-b4b4-084931582a24@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/5 10:13, Ridong Chen 写道:
> 
> 
> On 11/5/2026 2:54 AM, Waiman Long wrote:
>> On 11/4/26 7:58 AM, Ridong Chen wrote:
>>>
>>>
>>> On 11/4/2026 3:16 PM, Guopeng Zhang wrote:
>>>> From: Guopeng Zhang<zhangguopeng@kylinos.cn>
>>>>
>>>> With the "domain" flag of the isolcpus= boot option, the CPUs isolated
>>>> at boot are excluded from the sched domains and the remaining CPUs
>>>> become the boot domain housekeeping CPUs. An isolated partition is
>>>> allowed to use the boot isolated CPUs, but it must not take over all
>>>> the boot domain housekeeping CPUs.
>>>>
>>>> prstate_housekeeping_conflict() checks that rule for root partitions
>>>> only. The 2nd check covers the nohz_full case as it is gated by
>>>> housekeeping_enabled(HK_TYPE_KERNEL_NOISE) which is not enabled by
>>>> isolcpus=domain. So on an isolcpus=domain,<cpus> boot, an isolated
>>>> partition can claim all the remaining boot domain housekeeping CPUs.
>>>> The state is committed, but the sched domain rebuild at the end of
>>>> the write finds no housekeeping CPU left for the boot domain and
>>>> hits WARNs and an OOPS in partition_sched_domains().
>>>> housekeeping_update() cannot accept the configuration either as it
>>>> cannot empty the boot domain housekeeping mask.
>>>> With an "isolcpus=domain,10-31" boot where CPUs 0-9 are the boot
>>>> domain housekeeping CPUs, for example:
>>>>
>>>>    # echo 0-9 > A/cpuset.cpus
>>>>    # echo isolated > A/cpuset.cpus.partition
>>>>    WARNING: kernel/sched/topology.c:3089 at build_sched_domains+...
>>>>    WARNING: kernel/cgroup/cpuset.c:1478 at cpuset_update_sd_hk_unlock+...
>>>>    RIP: 0010:partition_sched_domains+0x3b8
>>>>
>>>> Fix that by extending prstate_housekeeping_conflict() to reject an
>>>> isolated partition update that would leave no active boot domain
>>>> housekeeping CPU outside the isolated CPUs. The CPUs released back
>>>> to the boot domain by the same update are taken into account, so
>>>> replacing one of the last housekeeping CPUs with another one in a
>>>> single update remains allowed. The new check is only performed when
>>>> housekeeping_enabled(HK_TYPE_KERNEL_NOISE) is disabled so that the
>>>> existing nohz_full behavior is unchanged.
>>>>
>>>> Add test cases in test_cpuset_prs.sh to verify that taking over all
>>>> the boot domain housekeeping CPUs is rejected while swapping one of
>>>> them with another one is allowed.
>>>
>>> Hi Guopeng,
>>>
>>> Thanks for the report and the reproducer. I can reproduce the WARN and
>>> the OOPS in partition_sched_domains() here.
>>>
>>> However, I don't think prstate_housekeeping_conflict() is the right
>>> place to fix it, and the fix doesn't seem complete. The same problem
>>> can be triggered with a root partition, which this patch doesn't cover.
>>> With an "isolcpus=domain,4-7" boot on an 8-CPU VM:
>>>
>>>   # echo 0-3 > A/cpuset.cpus
>>>   # echo root > A/cpuset.cpus.partition
>>>   WARNING: kernel/sched/topology.c:3111 at build_sched_domains+0x2b96/0x5500
>>>   Oops: general protection fault, ... [#1] SMP KASAN NOPTI
>>>   RIP: 0010:partition_sched_domains+0x10a3/0x1a10
>>>
>>> The faulting address is in build_perf_domains(), where cpumask_first()
>>> on the empty cpu_map returns nr_cpu_ids and cpu_rq() goes out of
>>> bounds.
>>>
>>> The root cause looks like it isn't a housekeeping conflict. Boot time
>>> isolated CPUs stay in top_cpuset.effective_cpus by design, and they are
>>> only filtered out of the top_cpuset sched domain in
>>> generate_sched_domains(). But the checks that make sure the parent
>>> still has CPUs left, i.e. tasks_nocpu_error() for local partitions and
>>> the cpumask_subset(top_cpuset.effective_cpus, ...) checks in
>>> remote_partition_enable()/remote_cpus_update(), only look at
>>> top_cpuset.effective_cpus. So any partition, root or isolated, local
>>> or remote, can take away all the boot domain housekeeping CPUs as long
>>> as some boot isolated CPUs are still left in top_cpuset, which leaves
>>> the top_cpuset sched domain empty.
>>>
>>> So I think the check should be done at the "parent has no CPU left"
>>> level instead. Something like the diff below. It is not tested yet;
>>> could you give it a try with your reproducer and the test cases?
>>> Note that the root partition and remote partition cases should be
>>> added to the selftest as well.
>>>
>>> Without isolcpus=domain, HK_TYPE_DOMAIN_BOOT is cpu_possible_mask and
>>> the new check is equivalent to the existing one, so no extra
>>> housekeeping_enabled() gating is needed.
>>>
>>> ---
>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>> index 3219f927c35e..fb3e81405f5b 100644
>>> --- a/kernel/cgroup/cpuset.c
>>> +++ b/kernel/cgroup/cpuset.c
>>> @@ -1180,12 +1180,51 @@ static void update_partition_sd_lb(struct cpuset *cs, int old_prs)
>>>                 cpuset_force_rebuild();
>>>  }
>>>
>>> +/*
>>> + * top_cpuset_sd_nocpu - Check if top_cpuset will have no sched domain CPU
>>> + * @add_cpus: CPUs to be taken away from top_cpuset
>>> + * @del_cpus: CPUs to be given back to top_cpuset, can be NULL
>>> + * Return: true if no active CPU will be left in the top_cpuset sched domain
>>> + *
>>> + * Boot time isolated CPUs stay in top_cpuset.effective_cpus, but they are
>>> + * excluded from the sched domain of top_cpuset in generate_sched_domains().
>>> + * So checking top_cpuset.effective_cpus alone is not enough to ensure that
>>> + * the top_cpuset sched domain won't become empty after @add_cpus are taken
>>> + * away from it. The sched domain of top_cpuset must keep at least one
>>> + * active boot domain housekeeping CPU.
>>> + */
>>> +static bool top_cpuset_sd_nocpu(const struct cpumask *add_cpus,
>>> +                               const struct cpumask *del_cpus)
>>> +{
>>> +       const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT);
>>> +       int cpu;
>>> +
>>> +       for_each_cpu_and(cpu, hk_mask, cpu_active_mask) {
>>> +               if (cpumask_test_cpu(cpu, add_cpus))
>>> +                       continue;
>>> +               if (cpumask_test_cpu(cpu, top_cpuset.effective_cpus) ||
>>> +                   (del_cpus && cpumask_test_cpu(cpu, del_cpus)))
>>> +                       return false;
>>> +       }
>>> +       return true;
>>> +}
>>> +
>>>  /*
>>>   * tasks_nocpu_error - Return true if tasks will have no effective_cpus
>>>   */
>>>  static bool tasks_nocpu_error(struct cpuset *parent, struct cpuset *cs,
>>>                               struct cpumask *xcpus)
>>>  {
>>> +       /*
>>> +        * The top_cpuset always has tasks (kthreads at least), so its sched
>>> +        * domain can't be empty. The current effective_xcpus of a valid
>>> +        * partition will be given back to top_cpuset if not in @xcpus.
>>> +        */
>>> +       if ((parent == &top_cpuset) &&
>>> +           top_cpuset_sd_nocpu(xcpus, is_partition_valid(cs)
>>> +                                      ? cs->effective_xcpus : NULL))
>>
>> The del_cpus should normally be (cs->effective_xcpus & ~xcpus), but the top_cpuset_sd_nocpu() helper will skip CPUs that are in xcpus. So it will work in this case. It should be noted in the functional comment of top_cpuset_sd_nocpu() that @del_cpus can include common CPUs that will stay in the partition which will be skipped in the helper so that future change won't accidentally change that behavior.
>>
> 
> Thank you for your reply.
> 
> Yes, perhaps Guopeng could make the code and comments more readable.
> 
Thanks for the suggestions. I'll update this in v2.

Cheers,
Guopeng
