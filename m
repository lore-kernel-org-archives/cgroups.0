Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262BE18B0A
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 02:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790218653; cv=none; b=TAbkMInkezp6VnnTgJLtGNVitqepZf5zBcwV8ibhl0oElIunY8AVrSVNywqfme9E4VW6BuUz1Se1X6H+LBrt64ODW7L2epVRZOl2IQDQjmnPEl+VnaHZZjhJFbKA63svyTfkvd7V9eU9eMm/8h8rPjto6fFsXiF/wu4Bn1RqROA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790218653; c=relaxed/simple;
	bh=tbE2UY+5GUhBx4uPek9PPKKqbA11V2Pu1Il178PFe5k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d8ZEdi4eicQcYPk0Je7MWikiZJCbb5JDmdmnXPwIObgYM/bszeE7c8idb6CgH9YJb8anVVVwKIlge4SleFB8brwNL1nbFtCQr3ozI6ehDola/DuTRkU6gzkafL20TzS8DtpHRyA8Dd5UBewzedK1Zac30D162dp7HxfZ6ZNOmrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MDogVrVI; arc=none smtp.client-ip=91.218.175.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MDogVrVI"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tbE2UY+5GUhBx4uPek9PPKKqbA11V2Pu1Il178PFe5k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790218650; v=1; x=1790823450;
 b=MDogVrVIK+fbABzb4/f5k+hajxCBJCQ3pznKQGXQrwKt460wiYGvt3rEbie9JRu0E910z7g8
 laxXGmU+HcKphcZBO4QOOAVCPT43aIAJ/Fs/I11Xz1EwQSxZ0ob9hm8umxaiYbgU2zsVR1dEO+G
 wWcvkMNSQ7mwl5/Wg+oieQgI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dc824f8b89662948;
	Thu, 24 Sep 2026 02:57:30 +0000
X-Mizu-Trace-ID: dc824f8b89662948
X-Migadu-Flow: FLOW_OUT
Message-ID: <e6447c86-ff74-4834-9882-a80668e5f704@linux.dev>
Date: Thu, 24 Sep 2026 10:57:26 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Invalidate remote partition on
 housekeeping conflict
To: Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260923103657.186937-1-guopeng.zhang@linux.dev>
 <935ac366-6571-46d1-acdf-c9eda9da0441@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <935ac366-6571-46d1-acdf-c9eda9da0441@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/24 10:03, Ridong Chen 写道:
> 
> 
> On 9/23/2026 6:36 PM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> Widening an ancestor's exclusive CPU mask can add a boot-isolated CPU
>> to a valid remote partition root without touching the partition's own
>> control files. The partition then load balances that CPU, silently
>> defeating isolcpus=domain for it.
>>
>> This can be reproduced on a 32-CPU system booted with
>> isolcpus=domain,4:
>>
>>      cd /sys/fs/cgroup
>>      echo +cpuset > cgroup.subtree_control
>>      mkdir -p A/B
>>      echo +cpuset > A/cgroup.subtree_control
>>      echo 2-4 > A/cpuset.cpus
>>      echo 2-3 > A/cpuset.cpus.exclusive
>>      echo 2-4 > A/B/cpuset.cpus
>>      echo 2-4 > A/B/cpuset.cpus.exclusive
>>      echo root > A/B/cpuset.cpus.partition
>>      cat A/B/cpuset.cpus.effective               # 2-3
>>      echo 2-4 > A/cpuset.cpus.exclusive
>>      cat A/B/cpuset.cpus.partition               # root
>>      cat A/B/cpuset.cpus.effective               # 2-4
>>
>> The last write returns 0 and leaves the hierarchy in this state:
>>
>>      root (cpuset.cpus.effective=0-1,5-31)
>>      |
>>      \-- A (member):           cpuset.cpus=2-4
>>          |                     cpuset.cpus.exclusive=2-4
>>          \-- B (root, remote): cpuset.cpus=2-4
>>                                cpuset.cpus.effective=2-4
>>
>> B is a remote partition: it takes its CPUs directly from the root
>> cpuset, and A only passes its exclusive list down. Before the last
>> write, that list is 2-3, so B holds 2-3 and CPU 4 stays in the
>> root cpuset as a boot-isolated CPU. The write widens A's exclusive
>> list to 2-4, which additionally grants CPU 4 to B. Nothing rejects
>> the grant: B remains a valid root partition, and CPU 4 is still
>> listed in cpuset.cpus.isolated while sitting in a load-balanced
>> partition.
>>
>> remote_partition_enable() and validate_partition() already call
>> prstate_housekeeping_conflict() before granting CPUs. The ancestor
>> update path in remote_cpus_update() does not. Add the missing check so
>> that the existing prs_err path invalidates the remote partition instead
>> of adding the boot-isolated CPU.
>>
>> Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 753aa65afcd7..362e5b5dccaa 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1699,6 +1699,8 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>>           else if ((prs == PRS_ISOLATED) &&
>>                !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
>>               WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
>> +        else if (prstate_housekeeping_conflict(prs, tmp->addmask))
>> +            WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
>>           if (cs->prs_err)
>>               goto invalidate;
>>       }
> 
> Hi Guopeng,
> 

Hi Ridong,

> Thank you for your test and patch.
> 
> I noticed that this statement existed in remote_partition_enable but was missing from remote_cpus_update. There may be other state leaks here as well.
> 
> In case this happens again, I would like to suggest adding 'validate_remote_partition' as I tried to do before [1]. Could you put some effort into this?
> 

Sure, I'd be happy to. Thanks for the suggestion.

I've also been looking at the validation and state update paths around cpuset partitions recently. The checks are spread across several places, so it's easy to miss cases like this.

Thanks,
Guopeng

> [1] https://lore.kernel.org/cgroups/20251225123058.231765-19-chenridong@huaweicloud.com/
> 

