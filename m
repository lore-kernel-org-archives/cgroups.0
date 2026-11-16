Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.165
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794814661;
	b=qWeiBMV2U6cBu8qw+Y9QcHTBgktlzNyln2+4NXb/Ec+FR/8kig+1cKThNwyRDBZCyhZv
	 IXAA4BOQEDQ2C/KztFx+4opwolU00m+XIDqk+MqG/kZq3J0s+fnKzF2aW65ekSy0jr0a9
	 0pe2Q+ZlxuWHwL99E51KpWluHtMBLl3N9b5pN80fYCDmM78gqNMVXADSN9/d9d9jgsJKL
	 P1GC9bCC8GIGmm6ny1KD/fzg+3yizWAayvH83PUP4258COQ4eewpm6mSkQyb2Pb7fLYrZ
	 5gsknAFDQEYR35OcDFwaBSn0ALESU2BT6uJ/O5eBIA3dTLR+Eq6sYTpU0w8C4v7biyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794814661;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ELGLnivSPBf/XoruTptZjLnaANO/5tU+GX+LXPFFz7o=;
	b=ItWx4rMjneZ4rBkmzi2ued18AKq1KjlR+Ofo9EMg2e4iASo6Y7ON3zhkntkGIJAu3Tlj
	 nY6tsgPa2FkvwESGF7vXlABD9lKjpySi7bIA254aHDG63BxPVJR+CwC4mI6L3/Io4peUT
	 BwQ1Hy5Ole6wKOYOtFUZwuQFBJBURxMIvm+2T+hapU9nNUxVpr3Afkrp3ol60oHtr/oTV
	 BD6TYdaJcqVVOzAmGkbm4/4m89MP3aTUWR0h0ehfSHbNNvjVdI7S5Vgo1CJOLwWblhxZQ
	 9m/5dwWDSNwsSsNRsHJC7kmdrAgnPc/Gulnb6oj4H+7T23KWPxEDCHHIGSxeaD4dqfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vnzW1sV3;
	arc=none smtp.remote-ip=95.215.58.165
Received: from mta1.migadu.com (out-165.mta1.migadu.com [95.215.58.165])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DAC606A323
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 07:37:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95DAC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vnzW1sV3
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=H6p33czRZZWahauFA0Jn1pndKd76EnVuASbuBmHSAtc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794814658; v=1; x=1795419458;
 b=vnzW1sV3OqhljrZMjkJs6X5X2veHGbuRzjf3BuV6u8CbjHGIuZaInqU7ipJffKLDYu8zv7/W
 dRXLuAOoNE59Imocx22u5NYAcpzOxW6oN52dBvPJBngvrkKXrYla/eJ0+5MmgSN/BW4MTYPWqaK
 yJxAV0OaV14TJNacqiNluYgY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9ab298eabfac997d;
	Mon, 16 Nov 2026 07:37:38 +0000
X-Mizu-Trace-ID: 9ab298eabfac997d
X-Migadu-Flow: FLOW_OUT
Message-ID: <8015ad75-0e4d-4928-8e56-8a495d752468@linux.dev>
Date: Mon, 16 Nov 2026 15:37:30 +0800
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
Subject: Re: [PATCH-next v4 2/6] cgroup/cpuset: excpus parameter of
 remote_cpus_update() must have at least 1 active CPU
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Sashiko <sashiko-bot@kernel.org>
References: <20261116012330.2271010-1-longman@redhat.com>
 <20261116012330.2271010-3-longman@redhat.com>
 <e437ac79-7999-43da-9fe8-6cfd475a5196@linux.dev>
 <eb3fd5e1-aafe-4bbd-a9ca-afcdb1554fdb@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <eb3fd5e1-aafe-4bbd-a9ca-afcdb1554fdb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/16/2026 11:34 AM, Waiman Long wrote:
> On 11/15/26 10:07 PM, Ridong Chen wrote:
>>
>>
>> On 11/16/2026 9:23 AM, Waiman Long wrote:
>>> It is reported that remote_cpus_update() fails to invalidate a
>>> populated remote partition when an ancestor cgroup update reduces its
>>> effective_xcpus mask to only offline CPUs.
>>>
>>> When update_cpumasks_hier() updates a descendant remote partition, it
>>> passes the new effective_xcpus mask (excpus) to remote_cpus_update().
>>> Because excpus still contains offline CPUs, cpumask_empty(excpus) is false
>>> and remote_cpus_update() only checks tasks_nocpu_error() when adding CPUs.
>>>
>>> With the partition left valid, update_cpumasks_hier() computes an empty
>>> effective_cpus mask and jumps to get_css. The populated partition stays
>>> valid with no effective CPUs instead of inheriting its parent's CPUs,
>>> and its tasks remain affine to the online CPUs returned to top_cpuset.
>>>
>>> Fix it by invalidating the remote partition if there is no active CPU
>>> available in the given excpus parameter.
>>>
>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>> Link: https://sashiko.dev/#/bug/linux-936b7155-f652-4146-a4ab-ec48fd392a1d
>>> Signed-off-by: Waiman Long <longman@redhat.com>
>>> ---
>>>   kernel/cgroup/cpuset.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>> index 631fb449cef8..195d4e3a283c 100644
>>> --- a/kernel/cgroup/cpuset.c
>>> +++ b/kernel/cgroup/cpuset.c
>>> @@ -1810,7 +1810,8 @@ static void remote_cpus_update(struct cpuset *cs, 
>>> struct cpumask *xcpus,
>>>         WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus));
>>>   -    if (cpumask_empty(excpus)) {
>>> +    /* New effective_xcpus must have at least one active CPU */
>>> +    if (!cpumask_intersects(excpus, cpu_active_mask)) {
>>>           WRITE_ONCE(cs->prs_err, PERR_CPUSEMPTY);
>>>           goto invalidate;
>>>       }
>>
>> This also invalidates a remote partition with no task whose excpus
>> only has offline CPUs. According to cgroup-v2.rst, such a partition
>> is valid: cpuset.cpus.exclusive.effective may contain offline CPUs,
>> and cpuset.cpus.effective can be empty if there is no task in the
>> partition. The hotplug path and tasks_nocpu_error() follow the same
>> rule. How about only invalidating it when it is populated?
>>
>>       if (cpumask_empty(excpus) ||
>>           (!cpumask_intersects(excpus, cpu_active_mask) &&
>>            partition_is_populated(cs, NULL))) {
> 
> A partition can only be created if there are active CPUs in the effective_xcpus. 
> However, such a partition root can distribute its exclusive CPUs down to child 
> local partitions with the results that effective_cpus can be empty if there is 
> no task there. IOW, effective_xcpus must have active CPUs while effective_cpus 
> does not need to have active CPUs if there are child partitions underneath. I am 
> going to clarify that in the doc. I will check the hotplug path and 
> task_nocpu_error() to make sure that it follows this rule. Does that rule make 
> sense to you?
> 

Yes, the rule makes sense to me, and it is clearer.

Note that the hotplug path currently keeps a partition with no task
valid after all its CPUs are offlined, e.g. these test cases in
test_cpuset_prs.sh:

"  C2-3:P1  C3:P1   .      .     O3=0    .      .      .     0 A1:2|A2: A1:P1|A2:P1"
"$SETUP_A123_PARTITIONS    .     O3=0    .      .      .     0 A1:1|A2:2|A3: 
A1:P1|A2:P1|A3:P1"

So the hotplug path and these test cases need to be updated together
with this patch to keep the behavior consistent?

> 
>>
>> Also, it probably needs a Fixes tag, maybe:
>>
>> Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make 
>> update_cpumasks_hier() handle remote partition")
> 
> Yes, I miss the fix tag. Will update that in the next version.
> 
> Cheers,
> Longman

-- 
Best regards
Ridong

