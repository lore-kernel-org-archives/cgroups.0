Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792648676;
	b=ZmntdexemoJuZRnOJZiihDQBJEj1GifSvgQkuDgOe3iprQXYWkSNZsD7xGxLw6+johhA
	 cbOaxZokscHJIoV0aAIS6fkJeO67foVdLLxu74Sg6gNJkETTAek5UO1iXlELtfY/rbHPq
	 dA6pq/2Du8q4u9062rnQtGdQBTfAOZKGLon6thP+/aU/JuPfKm4cvWLlD3d8F6S8HXsMs
	 zokwJ1GuuNeKGzM4e+Tjk967Lf+aJWd74HfNF5ldsx5Pk1WSaBLqKGMKePYCr7nxN+JGy
	 VDkDHhNs1e/B3kqAZ7dxXGi4SewWsgNhcntPwvLzeZeRblR9DeSqrVeOkpaF+JNfTpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792648676;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=y1muRzXbh9xEJli8qmeLMn/g2VS9yM5epSDiKrh66q4=;
	b=y9fR/EQUzLPXtqYoH+oKf5VQco1rwO9uTzFgugAHWOqEnKZlcSoUcxF0Ao96/duXrPke
	 do/6KX4QPywPgm0mDl9Tj/ZDpzVYC0ob7vK5QkwIV6yjMLMpqCJpqNGkU4nxXpXVyglJ4
	 UoGd84d3qEmBtCUevbzEI8mOHVCjC3EFPEZMMk1IGP+dvBfy8YoFhUNyopsLR4YGp9FTL
	 MzvKdJSM0GiqjNCM+Wt1zDxTvNQFU///bR8A36n3WdSiNY5uhpW/RKwFW28iQEaxm2tDg
	 9788W6nnISjbXgMT5Ol/NaQpzi7tqyJP2vHaCu14sNYkh4NovnU+9vh+PMAu3eWohDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=U1gLNmwD;
	arc=none smtp.remote-ip=91.218.175.37
Received: from mta0.migadu.com (out-37.mta0.migadu.com [91.218.175.37])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAE0606A31A
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 05:57:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AAE0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=U1gLNmwD
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PlydeHx41hqXII3ZYHptACB8kpve0J1l4KbAMjAMWaI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792648673; v=1; x=1793253473;
 b=U1gLNmwDwogY1U9ddiF+QQGTn190SA2h2EtxjFtq6k3rrnXWO41TazixWNcdZMEo9Zz04ccm
 nlkB4TjohIjTz4JQw2wMFoyJ0x5vVEU5sd/vv/XKxliLEzb7bfH+6r/lcxzK5Rd9eI8YeHGTy5V
 6me+fyDFzpuYf/0ZSBZUfEa4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ab0e1623da36cf61;
	Thu, 22 Oct 2026 05:57:52 +0000
X-Mizu-Trace-ID: ab0e1623da36cf61
X-Migadu-Flow: FLOW_OUT
Message-ID: <bb11472d-7533-45a2-87cd-a4338e7a0f29@linux.dev>
Date: Thu, 22 Oct 2026 13:57:42 +0800
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
Subject: Re: [PATCH 2/2] cgroup/cpuset: Fix invalid local partition recovery
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261010075947.333549-1-guopeng.zhang@linux.dev>
 <20261010075947.333549-3-guopeng.zhang@linux.dev>
 <16db5b91-677e-47ec-b1de-760111b99d23@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <16db5b91-677e-47ec-b1de-760111b99d23@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/22 11:28, Waiman Long 写道:
> On 10/10/26 3:59 AM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> An invalid local partition may fail to recover after its exclusive CPU
>> list is changed to a valid one.
>>
>> This can be reproduced on a cgroup v2 system with CPUs 0-7 online:
>>
>>      cd /sys/fs/cgroup
>>      echo +cpuset > cgroup.subtree_control
>>      mkdir A
>>      echo 0-7 > A/cpuset.cpus
>>      echo 0-7 > A/cpuset.cpus.exclusive
>>      echo root > A/cpuset.cpus.partition
>>      cat A/cpuset.cpus.partition
>>      echo 1 > A/cpuset.cpus.exclusive
>>      cat A/cpuset.cpus.partition
>>
>> The first read reports root invalid because all CPUs were requested.
>> After the mask is changed to CPU 1, the partition should become valid,
>> but it remains invalid with PERR_NOCPUS.
>>
>> update_exclusive_cpumask() calls partition_cpus_change() before updating
>> cs->exclusive_cpus. update_parent_effective_cpumask() then gets the
>> old 0-7 mask from user_xcpus() and sets PERR_NOCPUS even though the new
>> mask leaves CPUs for the parent.
>>
>> Move the exclusive_cpus update before partition_cpus_change() so that
>> the partition update sees the new mask.
>>
>> Fixes: 46c521bac592 ("cgroup/cpuset: Enable invalid to valid local partition transition")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index de7553459adc..e96bc66ffa07 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2546,10 +2546,14 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>>           return -ENOMEM;
>>         trialcs->prs_err = PERR_NONE;
>> -    partition_cpus_change(cs, trialcs, &tmp);
>>         spin_lock_irq(&callback_lock);
>>       cpumask_copy(cs->exclusive_cpus, trialcs->exclusive_cpus);
>> +    spin_unlock_irq(&callback_lock);
>> +
>> +    partition_cpus_change(cs, trialcs, &tmp);
>> +
>> +    spin_lock_irq(&callback_lock);
>>       cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
>>       if ((old_prs > 0) && !is_partition_valid(cs))
>>           reset_partition_data(cs);
> 
> With the patch series that I have just sent out, I can't reproduce this problem. My patch 2 of the series change update_parent_effective_cpumask() to not use user_xcpus() anymore. So that should fix the problem.
> 

Thanks for checking this issue. I'll also test some other scenarios
with your new patch series applied.

Thanks,
Guopeng

