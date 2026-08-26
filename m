Received: from mta1.migadu.com (out-166.mta1.migadu.com [95.215.58.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F499361961
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 05:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787723597; cv=none; b=ehqoY4T5SraB5nQ2/mbGLfxLpIgm9jEp6YXZ1SA2K4OOHr4BFqMHy8cxDiMQ8iHCWTXL1OI0llzKJzhsKSoVXl24UnO+U8tRgWxYP61/mF7mUrEvhqimfF6P9Y8Fq5V/6LJECjW+UIlSfoWPR6qDgo4nYuvocwRioXaCtcT6hOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787723597; c=relaxed/simple;
	bh=zunHTUd/B5IAIhLTXDDR3P+bmjQxTNpU5xbqEoZj1Vc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IVuuGV0lBRs7jMJ7Evb1/v5Ej5MpcsANjIH1DMHpXiXa37+oiSMkbMbRt9Mq6JLYhxuhenZAj/k0YK0OfLC0Uf/r7rd2jUxixEzhaLrvn8eAyCL70Zv5ZX8ePHgOhUWXQbtJCJJRiHbHPTBl6u3prRrboajzUakrncMsBTzNZMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YgbINGfG; arc=none smtp.client-ip=95.215.58.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YgbINGfG"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zunHTUd/B5IAIhLTXDDR3P+bmjQxTNpU5xbqEoZj1Vc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787723594; v=1; x=1788328394;
 b=YgbINGfGl4ailxHrVERs80OvCtvp8pYkiIjNYvLd76PhSLQ1UVY5ejKU44NRSpm83eLg9nLC
 xiZC47hWMor0eFhxTGQV/ewxfHOF+xlUI1jLE2AdR4LxqLI/7e/Qu8J9/vfvzISRVdb/e87GK5u
 RwNfIrbwtjl07IdRY7PIEqKI=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [192.168.109.140] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 89b404ef155b136a;
	Wed, 26 Aug 2026 05:53:14 +0000
X-Mizu-Trace-ID: 89b404ef155b136a
X-Migadu-Flow: FLOW_OUT
Message-ID: <62da6156-138a-4d2e-8384-0bc21481e351@linux.dev>
Date: Wed, 26 Aug 2026 13:53:04 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/17] cgroup/cpuset: Release CPUs when a type change is
 rejected
To: Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
 <20260820124202.517160-9-guopeng.zhang@linux.dev>
 <0a9afea3-bd0c-42af-8c92-6f2d54348d1e@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <0a9afea3-bd0c-42af-8c92-6f2d54348d1e@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/24 22:37, Waiman Long 写道:
> On 8/20/26 8:41 AM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> When a housekeeping check rejects a root-to-isolated or isolated-to-root
>> change, update_prstate() marks the partition invalid but leaves its
>> effective_xcpus allocated. Those CPUs remain missing from the partition
>> which owns the invalidated subtree.
>>
>> Disable a rejected remote partition with remote_partition_disable().
>> For a local partition, return effective_xcpus to its parent before
>> recording the invalid state. Use the complete mask because descendants
>> are invalidated along with the parent and their CPUs return at the same
>> time.
>>
>> Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c | 15 +++++++++++++--
>>   1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 853942c1afeb..a616012927be 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -3020,10 +3020,21 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>           compute_partition_owned_cpumask(cs, tmpmask.new_cpus);
>>           if (((new_prs == PRS_ISOLATED) &&
>>                !isolated_cpus_can_update(tmpmask.new_cpus, NULL)) ||
>> -            prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus))
>> +            prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus)) {
>>               err = PERR_HKEEPING;
>> -        else
>> +            if (is_remote_partition(cs)) {
>> +                WRITE_ONCE(cs->prs_err, err);
> This WRITE_ONCE() is not necessary as it will be done later in the function.
>> +                remote_partition_disable(cs, &tmpmask);
>> +            } else {
>> +                spin_lock_irq(&callback_lock);
>> +                partition_xcpus_del(old_prs, parent, cs->effective_xcpus);
>> +                spin_unlock_irq(&callback_lock);
>> +                cpuset_update_tasks_cpumask(parent, tmpmask.new_cpus);
>> +                update_sibling_cpumasks(parent, cs, &tmpmask);
>> +            }
> 
> This code to disable the partition is duplicating what is being done in the last else clause of the outer if, but in a somewhat different way. That is not good programming practice. You can either jump to the partition disabling code below or separate out the partition disabling code controlled by a separate control flag and set the flag to do it.
> 

Agreed. I removed the redundant WRITE_ONCE() and used a
disable_partition flag to share the existing partition-disable path in
v2.

Thanks,
Guopeng

> Cheers,
> Longman
> 
>> +        } else {
>>               isolcpus_updated = true;
>> +        }
>>       } else {
>>           /*
>>            * Switching back to member is always allowed even if it
> 

