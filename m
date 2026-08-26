Received: from mta1.migadu.com (out-79.mta1.migadu.com [95.215.58.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19052BDC0F
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 05:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787723310; cv=none; b=Z/1gWWrFWRGagzA05u98tyhr6P9LZbszbdAumEDABSEbSvynEkrXX0pv2LdxqWxQ5RBovS+ohgrcoJ9tUx4MAEvI1REXoid2/PVx5ShR7Lby9CCW/El/DDdV16AlsIApxG28h/GLJQTtwd72r5vSSBu2mq2SyRi4FctyE262Q74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787723310; c=relaxed/simple;
	bh=dCAB/kGopKF/xLrIWZUXau3HiNnYHXcxYc4PCt8v7os=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R3xRGPAYmfpMVWunNSIm5cJKxUGvzsdCCPIcaBc+FCjZ1oT/s02NclGL3671efRP1C4z1ubQH71yQk/x79qjixt191AtRUTnyrNY9+hTSSFSMf/C9faFs7UaoSpbil2vjLKh8EmEi4YpkwZ47d9Fz+EgD5JGU4UivbXs7Gj8iL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kFRCJGVS; arc=none smtp.client-ip=95.215.58.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kFRCJGVS"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dCAB/kGopKF/xLrIWZUXau3HiNnYHXcxYc4PCt8v7os=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787723306; v=1; x=1788328106;
 b=kFRCJGVSBP9CXTwpEcHf5tNPNpugCUq+QrV36EGOxkBxloS2WkAPy96yVg/JYPnaTFlsJjYP
 LPYXK32pMVmKPSyZueZw2Y/NC94+sAjqi7id7v3xh96rXgkzZHjaPUAiFl0MmsSn5kUY0ClLdFe
 KRA+XIMFsppK2244znj0TgOU=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [192.168.109.140] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 8e7d7052388d4aa0;
	Wed, 26 Aug 2026 05:48:26 +0000
X-Mizu-Trace-ID: 8e7d7052388d4aa0
X-Migadu-Flow: FLOW_OUT
Message-ID: <bfd6a2f3-a94f-4dfe-9608-171d0d0942fe@linux.dev>
Date: Wed, 26 Aug 2026 13:48:21 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/17] cgroup/cpuset: Validate type changes against owned
 CPUs
To: Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
 <20260820124202.517160-7-guopeng.zhang@linux.dev>
 <b782170f-2b8e-4b1f-bdc1-f8fa632aec98@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <b782170f-2b8e-4b1f-bdc1-f8fa632aec98@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/24 22:25, Waiman Long 写道:
> On 8/20/26 8:41 AM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> update_prstate() checks effective_xcpus against the housekeeping masks
>> before changing a partition between root and isolated. effective_xcpus
>> also contains CPUs granted to valid child partitions, although those
>> CPUs are not affected by the parent's type change. A child-owned CPU can
>> therefore reject an otherwise valid change.
>>
>> Run the nohz_full and boot-domain housekeeping checks against the mask
>> of CPUs owned by the partition instead.
>>
>> Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
>> Fixes: b1034a690129 ("cgroup/cpuset: Ensure domain isolated CPUs stay in root or isolated partition")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 468272baadb2..853942c1afeb 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -3019,8 +3019,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>            */
>>           compute_partition_owned_cpumask(cs, tmpmask.new_cpus);
>>           if (((new_prs == PRS_ISOLATED) &&
>> -             !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
>> -            prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
>> +             !isolated_cpus_can_update(tmpmask.new_cpus, NULL)) ||
>> +            prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus))
>>               err = PERR_HKEEPING;
>>           else
>>               isolcpus_updated = true;
> 
> This can be merged into patch 4. This is basically the same change as in patch 4.
> 

That makes sense. I have folded the two changes together in v2.

Thanks,
Guopeng
