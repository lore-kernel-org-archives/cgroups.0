Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.235
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794049290;
	b=tVrskYKzXdqKUBa4l2sBOYwXaszRjzoy81JPr1aFxc8WZdWFw+oLhkAniNIdeQNhhlBt
	 s8nvSSoIsZc0QkSUGUZFml6f3uAh3yo+LtB3nGExCeGQfYxLjLx7mijbB5GIgzCzPNGlK
	 OjmyzI75uwys/Zw0lHltWiBBMATMuRb/wU/RiOou90Hb/gADu78wgbbrptcY5BCTERneA
	 qZdihzTm2aSd0T6IhzQw0PiCb9icMtv+vnweYZ+JyLFjzkkjkma9HYyqdQjbwzv8N/LDH
	 ZyKJ5D95QWuTdw8nUpaUNTtjys1aZEKpbuAS49vRZpwxSIjQ+S5ZTJFDRKFh1VlKsBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794049290;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=gT/bSOyRms0CfCv/CcNwivCHN3jSHDK0xrdtvrS0jPw=;
	b=kH8/QaIConsExZe7ppHg6VPNTI3ZPdX8GIypj/WLXFteo2QV7Sg6HEI8AIWkZ7HwQ+0g
	 O6O4JUZArjM3CU3eGDnY5re1r8gBKkeU94vCHbeZa9tGgRFDIDcbri5Z/imJbphcGzL93
	 9JhtfND+S8Jq+yRM8yD9LTDGScaPabVw+nK5K0SjnmXRUnpMfhbNys4zUamlur5j0J+dT
	 Tn5CpXAFaA6mKxn6NliUu8DWLg3oeQaYpfFhP5J0VkSjn8UaFLnYwEiNGU4FRYQptPz2A
	 HXbFrDkB0bCTEkt2RZEFNE1dEEy3Jvxk4aHFBpaxy4DvxfsR3kH1BiMykj1rqpg43Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ed7cvGxx;
	arc=none smtp.remote-ip=91.218.175.235
Received: from mta0.migadu.com (out-235.mta0.migadu.com [91.218.175.235])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1248606A334
	for <cgroups@vger.kernel.org>; Sat,  7 Nov 2026 11:01:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1248606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ed7cvGxx
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=bsbRLEEmYqQAgfdT3XRrDoqlwaUFv3ZiesnIpNY61FQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794049287; v=1; x=1794654087;
 b=Ed7cvGxxxaJIQ7zfV90P+dbCFBAtOan+zRoYzVRhmxl5IrPlx4hHBV4XSrJIpAqa3LPtfNQG
 SV5C7cgPZ8CCs185lC3Sudk404LqBLqfDDjLxFCVvOPyVGHYIlyOIcpqqsZix5dHnrL1O3c05wZ
 xNJT6NtvaB1AJdxoE0JpxJnA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 51fdad1d384e6212;
	Sat, 07 Nov 2026 11:01:27 +0000
X-Mizu-Trace-ID: 51fdad1d384e6212
X-Migadu-Flow: FLOW_OUT
Message-ID: <a9b6c97d-a0c0-4855-ae51-d938b4b9f82d@linux.dev>
Date: Sat, 7 Nov 2026 19:01:22 +0800
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
Subject: Re: [PATCH v2 4/4] cpuset: generalize the validate_partition()
 interface
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Chen Ridong <chenridong@huawei.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261106105538.2915492-1-ridong.chen@linux.dev>
 <20261106105538.2915492-5-ridong.chen@linux.dev>
 <04c50e9b-954f-4869-a9bd-41b9341bdef8@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <04c50e9b-954f-4869-a9bd-41b9341bdef8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/7/2026 11:59 AM, Waiman Long wrote:
> On 11/6/26 5:55 AM, Ridong Chen wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> Refactor validate_partition() to take the parent partition, the new
>> partition root state, the new effective exclusive CPUs and the CPUs to
>> be deleted, instead of a trial cpuset. A NULL parent stands for a
>> remote partition, whose CPUs come from top_cpuset. This makes the
>> interface flexible enough to handle both local and remote partition
>> validation.
>>
>> The housekeeping conflict check is folded into validate_partition(). It
>> is skipped when the parent is not a valid partition root, as @cs can't
>> be a valid local partition in that case.
>>
>> Use the new interface for local partition enablement in
>> update_parent_effective_cpumask() and in partition_cpus_change(),
>> replacing the open-coded checks there. The order of the checks is now
>> the same for both paths: empty CPUs, housekeeping conflict, then no CPU
>> left for tasks.
>>
>> Signed-off-by: Chen Ridong <chenridong@huawei.com>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   kernel/cgroup/cpuset.c | 112 +++++++++++++++++++----------------------
>>   1 file changed, 52 insertions(+), 60 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index a5ab9396eb61..1b0ac4e76ec7 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1434,6 +1434,41 @@ static bool prstate_housekeeping_conflict(int new_prs, 
>> int parent_prs,
>>       return res;
>>   }
>> +/**
>> + * validate_partition - Validate a cpuset partition configuration
>> + * @cs: The cpuset to validate
>> + * @parent: Parent partition of @cs, NULL for remote partition
>> + * @new_prs: The proposed new partition root state
>> + * @new_excpus: The new effective exclusive CPUs mask to validate
>> + * @del: exclusive CPUs to be deleted from @cs, can be NULL
>> + *
>> + * The housekeeping check is skipped if @parent is not a valid partition
>> + * root as @cs can't be a valid local partition in that case.
>> + *
>> + * Return: PRS error code (0 if valid, non-zero error code if invalid)
>> + */
>> +static enum prs_errcode validate_partition(struct cpuset *cs,
>> +        struct cpuset *parent, int new_prs,
>> +        struct cpumask *new_excpus, struct cpumask *del)
>> +{
>> +    int parent_prs = parent ? parent->partition_root_state : PRS_ROOT;
>> +
>> +    if (new_prs == PRS_MEMBER)
>> +        return PERR_NONE;
>> +
>> +    if (cpumask_empty(new_excpus))
>> +        return PERR_INVCPUS;
>> +
>> +    if ((parent_prs > 0) &&
>> +        prstate_housekeeping_conflict(new_prs, parent_prs, new_excpus, del))
>> +        return PERR_HKEEPING;
>> +
>> +    if (tasks_nocpu_error(parent_cs(cs), cs, new_excpus))
>> +        return PERR_NOCPUS;
> 
> For remote partition, the parent should be top_cpuset. I think we should set 
> parent to top_cpuset if NULL and pass it directly to tasks_nocpu_error().
> 

Good catch, thanks. parent_cs(cs) is wrong for a remote partition, since
its CPUs come from top_cpuset rather than its cgroup parent. I'll set
parent to &top_cpuset when it's NULL and pass it to tasks_nocpu_error():
	
	  if (!parent)
			  parent = &top_cpuset;
	  parent_prs = parent->partition_root_state;
	  if (parent_prs > 0 &&
		  prstate_housekeeping_conflict(new_prs, parent_prs, new_excpus, del))
			  return PERR_HKEEPING;
	
	  if (tasks_nocpu_error(parent, cs, new_excpus))
			  return PERR_NOCPUS;

> Other than that, the rests look good to me.
> 

Thanks for the review. Will fix it in v3.

-- 
Best regards
Ridong

