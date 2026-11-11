Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.105
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794394440;
	b=U5L1488U7uwDOlGCURJhUnl5VIwKDiK9PtZwai06btzi1h6HqcqApQCpTH0f/FlTAixo
	 fB1LiwfDUlSYc5skm9HV1qDWo9UjeTJPFi5CZb7KIZo6wKdgnmRsCK3wnYElpCU4Kh9Xc
	 dAgULAYgbQrHv1wtKP05FaX+nHPIDAcN2yaE7L/HKGUe/RrzwZVX0U/erxuZxOV8Sr601
	 O1a23bf7yqLifCUrOe4G3Q85UgObkqo7MXfHHG4Yd+uSd04CJ7MVRwHN0+zYTFPXKOAAC
	 6tWZ9WM73cy66MtidsQtfaYghlurRoVhQv1hMfPK6EW2DuIlP6GyP0R9tYVOlTkUN5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794394440;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Cn3ktTNbkDjmuL/zHJ/rjWGXkd/AXBHaRbLAVh2iNbY=;
	b=1ELGk9B7WdEQeYbl7ZfjPk02G7zsP4bra+4OlHk6xMTcjaNbIJ+RrVhDMNCMCO4Fsa20
	 TAooiqqLiHfiVQKuISRxjvVu0VwpoEexqkD6wJMOUB405LIOTF2GU0sdsnR7/iseGi38u
	 OXp2mnl/MlmC4mH+qIDwxGx0Vqr59qgWuiFhzddNFuy0Ej0hrxF6bPRU+DgEWotKn3EE8
	 bI8lfVCiUznayPpgm6jj9BODOnE0LUn26MA4HhwtwRqHvTGJ0pkJSeEcRX5jJU3pDuX+1
	 C5AP7BIBMu6aqfNCD3jqeDyeMj7lB15A6s3m25CHFsqphr0JBoUA5zEpeQPThrNjPtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iJ1FCu61;
	arc=none smtp.remote-ip=91.218.175.105
Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA16606A32A
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 10:53:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FA16606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iJ1FCu61
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JhsjJycj7IJdTmr0NWylTEVWvnpPIv5RGtyr5ZSWPVQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794394437; v=1; x=1794999237;
 b=iJ1FCu61PkVXgm/f5lOcgCWQvcXOA5AaEASA7br9SFwtYVnFOCXaRbIBIH4PRvPrw6/RpLpG
 lWuJSabkQPqrVFqlpuXxIuS78+flyKuMx5618tBXQHYeUh8NiZt5MVfn+7JeSqXEz8sU1qvjr5I
 pk3D3oCfwhqRNKrYWMKiMykY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1f4d43568e68746b;
	Wed, 11 Nov 2026 10:53:56 +0000
X-Mizu-Trace-ID: 1f4d43568e68746b
X-Migadu-Flow: FLOW_OUT
Message-ID: <586335c2-3c46-4723-a139-a60bd601e86b@linux.dev>
Date: Wed, 11 Nov 2026 18:53:50 +0800
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
Subject: Re: [PATCH v3 2/3] cgroup/cpuset: Allow top-level partition CPU
 replacement
To: Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>,
 Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261110050324.173461-1-guopeng.zhang@linux.dev>
 <20261110050324.173461-3-guopeng.zhang@linux.dev>
 <d615a099-5369-4e34-8f48-17152ce000d6@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <d615a099-5369-4e34-8f48-17152ce000d6@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/10 20:11, Ridong Chen 写道:
> 
> 
> On 11/10/2026 1:03 PM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> When replacing a partition's CPUs, tasks_nocpu_error() checks whether
>> the parent's current effective_cpus is a subset of the new exclusive
>> CPU mask. The parent mask does not yet include CPUs being returned by
>> the update, so this can invalidate an otherwise valid partition.
>>
>> For example, on an 8-CPU system without boot isolation:
>>
>>    echo 2-7 > A/cpuset.cpus
>>    echo isolated > A/cpuset.cpus.partition
>>    echo 0-4 > A/cpuset.cpus
>>    cat A/cpuset.cpus.partition
>>    isolated invalid (Parent unable to distribute cpu downstream)
>>
>> The update should return CPUs 5-7 to the parent and leave A as a
>> valid isolated partition.
>>
>> Skip this subset check for top_cpuset. top_cpuset_sd_nocpu() already
>> accounts for returned CPUs and ensures that an active boot domain
>> housekeeping CPU remains.
>>
>> Add a regression test for this case.
>>
>> Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Hi Guopeng,
> 
> Patch 2 depends on patch 1. Skipping the cpumask_subset() check for
> top_cpuset is only safe because top_cpuset_sd_nocpu() added by patch 1
> now covers it. Without patch 1, patch 2 alone would let a partition
> take away all the CPUs of top_cpuset. So patch 2 can't be backported
> on its own, and the two have different Fixes tags. I think it would be
> better to fold patch 2 into patch 1.
> 

Thanks for the review. That makes sense. I hadn't considered the backport implications.

> Also, the fix in patch 2 seems incomplete. The same false PERR_NOCPUS
> happens when the parent is a local partition, as cpumask_subset()
> there doesn't take the CPUs given back by the update into account
> either. On an 8-CPU system:
> 
>     cd /sys/fs/cgroup
>     echo +cpuset > cgroup.subtree_control
>     mkdir A1
>     echo 1-7 > A1/cpuset.cpus
>     echo root > A1/cpuset.cpus.partition
>     echo +cpuset > A1/cgroup.subtree_control
>     mkdir A1/A2
>     echo 3-7 > A1/A2/cpuset.cpus
>     echo isolated > A1/A2/cpuset.cpus.partition
>     sleep 1000 &
>     echo $! > A1/cgroup.procs
>     echo 1-4 > A1/A2/cpuset.cpus
>     cat A1/A2/cpuset.cpus.partition
>     isolated invalid (Parent unable to distribute cpu downstream)
> 

You're right. I'll fix this in the next version.

Thanks，
Guopeng
> A2 takes CPUs 1-2 from A1 and gives CPUs 5-7 back, so A1 still has
> CPUs for its task. Instead of skipping the check for top_cpuset only,
> how about making the check in tasks_nocpu_error() account for the CPUs
> given back by cs for all parents? The hotplug caller would then need
> to not count cs->effective_xcpus as given back, similar to what patch 3
> does for top-level partitions.
> 



