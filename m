Received: from mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194842EC083
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 03:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789874924; cv=none; b=b4YfxHMpuoNfmMkfcfc7r/LqZERnNSdShGH8SPMXIhf+lyQZ9iFEk4VaCozfmj9UBm3mS0cVceKr1LVcqjf9YDA7Uc9Twjjo9gSj9DBAfo5hAVFOWzoJnjqgFrxme8Ye9PbQzxqmY/J/TNsrxbD83KgBOFZAUDubFkh2cOXbNt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789874924; c=relaxed/simple;
	bh=yAQgEzKFhwCXr6x9jZsd4tX4V7wS9WlacjQne7IGhXc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=pVetSq/GhVyvkoCor/pbHTX8kDU9K6H3Mqk1XZ3OvRhR6MrVi+i+ETcz9WqQYPdWi87ODhgwsgSGlkfoj6RxKwwU/082FqSMMza83rfRG8DT7kfO+0XR4tviBizu+ECXtrotQ+qnFLu/2BQsW4dkMjhZ6xoJaZ1QTaEciVolokE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VhLdu3JA; arc=none smtp.client-ip=91.218.175.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VhLdu3JA"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yAQgEzKFhwCXr6x9jZsd4tX4V7wS9WlacjQne7IGhXc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789874920; v=1; x=1790479720;
 b=VhLdu3JACapjbLfMbN9JHZoRZcjCW4lSzjZud5kJddn1kBleAbkAQbsnuxSBipB44e8kgWAY
 LPy/I0wLiybJ8Qa33Q0UE95o89DzVwJJRwhl0DUjCSjMpM9bSyiJzm/JMLwVUjUo3L0f8eXhc7d
 r0Ld5kE1qfthGB0bUPVayOUU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id daea2ac8e863aa7c;
	Sun, 20 Sep 2026 03:28:39 +0000
X-Mizu-Trace-ID: daea2ac8e863aa7c
X-Migadu-Flow: FLOW_OUT
Message-ID: <bf72375b-dbaf-4dcd-b6fd-0bf82d92e48d@linux.dev>
Date: Sun, 20 Sep 2026 11:28:35 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Defer sched domain rebuild to common
 unlock path
From: Ridong Chen <ridong.chen@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260918102730.72263-1-guopeng.zhang@linux.dev>
 <e2909c95-8a56-46cc-8ef4-7fa43acdb969@linux.dev>
In-Reply-To: <e2909c95-8a56-46cc-8ef4-7fa43acdb969@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/20/2026 11:26 AM, Ridong Chen wrote:
> 
> 
> On 9/18/2026 6:27 PM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> Both callers of update_prstate(), cpuset_partition_write() and
>> cpuset_css_killed(), call cpuset_update_sd_hk_unlock() immediately
>> afterwards. That helper rebuilds sched domains when force_sd_rebuild is
>> set before releasing the cpuset locks, so the check in update_prstate()
>> is redundant.
>>
>> Commit 3bfe47967191 ("cgroup/cpuset: Move
>> housekeeping_update()/rebuild_sched_domains() together") removed the
>> same check from cpuset_write_resmask(). Remove the remaining one from
>> update_prstate().
>>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 8f24171..d58ecf5 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -3039,8 +3039,6 @@ out:
>>       update_partition_sd_lb(cs, old_prs);
>>       notify_partition_change(cs, old_prs);
>> -    if (force_sd_rebuild)
>> -        rebuild_sched_domains_locked();
>>       free_tmpmasks(&tmpmask);
>>       return 0;
>>   }
> 
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
> Thanks.

Sorry, this was sent by mistake.

-- 
Best regards
Ridong

