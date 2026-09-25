Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9C2439F9E
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 18:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360116; cv=none; b=Zfm8k1y3rW89/f5acDcsdjevQHjQ7t9Z/4UlyY8RV+qk5+72WSg1XdcJAfqNSlT55XZJ6tIO7UPvMGbH/qew0tRcID54EHxbGwzC4hJw7u5XSMR/TtRIrNqUEP5KxXs+rUTzER/3WF7LnJWxljx71IZiK7Kd+0HpSKMvC/FCbis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360116; c=relaxed/simple;
	bh=uaknK4i6Uxo+da9FS2fQxyCZWRXsqMN62zjONHtIOcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e0jK0iMIBoJdQD09j620g8JQcMikYh+4m/co2SACeigHHhClLvPCW6O+bDON2YNNuCZW3iPVNBhWtJyVjoOT4Sfwd0r0w5VNZV/z4rBa9zRLJABxbo3P97lgJGugzUTWHtf7XkRSdtkjHl+j78cu/A6jrzDg1MUgArcNvkPSPS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cstSu6SU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cstSu6SU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790360113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jDT9mKU6Iwxz9TaPNpA8qD94LgkSUP+ggQleTcu41iU=;
	b=cstSu6SUUm+NT+he9G9pWrcEekJupjXVEUhjOt0il62IP1ihmUPUmekkW/bswCBKEtt5Xt
	FNcRR4KT54KFKFOyBtzDs/A6X3aP/jO82ePbdPLsLU8peHzMVclyd+YMtYR8VYLBiUL6CR
	FxtKAx1gJ1ISpYDP9pquMtIewz8Rh6M=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-dM-Zc1SMNjyVepFKCeSxtg-1; Fri,
 25 Sep 2026 14:15:09 -0400
X-MC-Unique: dM-Zc1SMNjyVepFKCeSxtg-1
X-Mimecast-MFC-AGG-ID: dM-Zc1SMNjyVepFKCeSxtg_1790360108
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE9B119539A9;
	Fri, 25 Sep 2026 18:15:07 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2F14F1800348;
	Fri, 25 Sep 2026 18:15:05 +0000 (UTC)
Message-ID: <aee7c185-938e-41fd-b0c5-5099f2769fdc@redhat.com>
Date: Fri, 25 Sep 2026 14:15:05 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Invalidate remote partition on
 housekeeping conflict
To: Ridong Chen <ridong.chen@linux.dev>,
 Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260923103657.186937-1-guopeng.zhang@linux.dev>
 <935ac366-6571-46d1-acdf-c9eda9da0441@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <935ac366-6571-46d1-acdf-c9eda9da0441@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 9/23/26 10:03 PM, Ridong Chen wrote:
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
>> Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() 
>> & make update_cpumasks_hier() handle remote partition")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 753aa65afcd7..362e5b5dccaa 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1699,6 +1699,8 @@ static void remote_cpus_update(struct cpuset 
>> *cs, struct cpumask *xcpus,
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
> Thank you for your test and patch.
>
> I noticed that this statement existed in remote_partition_enable but 
> was missing from remote_cpus_update. There may be other state leaks 
> here as well.
>
> In case this happens again, I would like to suggest adding 
> 'validate_remote_partition' as I tried to do before [1]. Could you put 
> some effort into this?
>
> [1] 
> https://lore.kernel.org/cgroups/20251225123058.231765-19-chenridong@huaweicloud.com/
>
I agreed that we should consolidate similar code into common helper that 
will make the code to easier to maintain and debug and avoid this kind 
of missing check problem.

Cheers,
Longman

