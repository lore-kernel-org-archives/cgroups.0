Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676A03E49EB
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 15:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790696962; cv=none; b=JRepmWgwrdR4dtcxM85JyAx6ckjArGZhil66QKf1t8yJc+gCaMhKrm4rwbLXpq6bxjT5kT3OMtcWJYOvDnGlkDPl/P495REfAuV6EZFBAhazftUX0mjgVhABQd5/Pf1y/nNt5QqvsOamLcNUJ7geaLBmO8S5MkA7jipEYNya1+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790696962; c=relaxed/simple;
	bh=hfqSadXKzYCOZRlrIClDG8QwzisMRXfTC7gb1kz0cc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b9EZtlqZPVdD5U17lTc8jd5N55yPSmjX15GA/u1M9jamE2yuFez4Y/cFJjVOWGXxPWseQRofPMtu+KH1fnGvOIs4ZgSytuWs9wEUBAvoTjQbdXP/JI1gVhEpIJjFYKSCUO2KrTy4ym1+wwhvAYa5zLihBDbMp3nKTT8KzdniJRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H1H95pHp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H1H95pHp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790696959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+sAysMV0IYJ7rpTH8SIbs7ESaO2lMO4W2Vnw+qB0UCo=;
	b=H1H95pHp9LYU0LhiVkzrywNea5IzIZSmLxN8TLBOF17WGmwfg1/pE8sMcSsp2HstedZdZu
	+GZ6dGPHET0Zdfs0gXc0GTSek7N40HhaX4SvtQdVcDDpKLC+pNzScjrNMrbFQHYtjxRy7T
	0ZmQmg7q1V06XsoZI/70LaaO+kVJGLI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-WOd-ikfhNIazC_UOav6ZvA-1; Tue,
 29 Sep 2026 11:49:12 -0400
X-MC-Unique: WOd-ikfhNIazC_UOav6ZvA-1
X-Mimecast-MFC-AGG-ID: WOd-ikfhNIazC_UOav6ZvA_1790696951
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD898195394C;
	Tue, 29 Sep 2026 15:49:10 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7403E30000E7;
	Tue, 29 Sep 2026 15:49:09 +0000 (UTC)
Message-ID: <8a711efe-075c-48d6-a1b0-4642bce87065@redhat.com>
Date: Tue, 29 Sep 2026 11:49:08 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Properly disable partition when partition
 state switching fails
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Hui Peng <benquike@gmail.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260928235159.515654-1-longman@redhat.com>
 <941e5affde16b803741ddaf87b937f3d@kernel.org>
 <07403332-9fc3-41cf-ba2c-63a1f83a231c@redhat.com>
 <5e658521-1d8f-47bd-87a2-809a79a10186@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <5e658521-1d8f-47bd-87a2-809a79a10186@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4


On 9/29/26 3:40 AM, Guopeng Zhang wrote:
> Hi Waiman, Tejun,
> 在 2026/9/29 11:16, Waiman Long 写道:
>> On 9/28/26 10:07 PM, Tejun Heo wrote:
>>> Hello, Waiman.
>>>
>>> The following is a Claude-generated review.
>>>
>>> On Mon, Sep 28, 2026 at 07:51:59PM -0400, Waiman Long wrote:
>>>> Before commit 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full
>>>> don't leave any housekeeping"), the partition state can be freely switched
>>>> from "root" to "isolated" and vice versa. After that commit, the switch
>>>> from "root" to "isolated" can fail if it exhausts all the housekeeping
>>>> CPUs. Later on, the switch from "isolated" to "root" can also fail if
>>>> some of the partition CPUs are boot-time isolated by "isolcpus".
>>> The isolated -> root failure came from b1034a690129 ("cgroup/cpuset:
>>> Ensure domain isolated CPUs stay in root or isolated partition"). Maybe
>>> add a Fixes: tag for it too?
>> Commit b1034a690129 ("cgroup/cpuset: Ensure domain isolated CPUs stay in root or isolated partition") comes after 103b08709e8a. From my point of view, the first commit is the one that introduces the bug. The second commit comes along assuming the existing code is right. That is why I didn't tag the second one even though the second one is easier to trigger than the first one.
>>
>>>> The partition is made invalid when the switch fails. However, the
>>>> remote_partition flag for a remote partition can remain set and the CPUs
>>>> from the invalidated partition aren't cleared from subpartitions_cpus.
>>>> Fix this by properly disable the partition in this case.
>>> The reproducer below is a local partition and the fix covers that case
>>> too. The CPUs weren't given back to the parent, which is what leaves them
>>> in subpartitions_cpus and isolated_cpus in the example. Maybe describe
>>> both? Also, "properly disable" -> "disabling".
>> OK, will update the commit log.
>>>> In the case of remote_partition flag, it should be cleared for a
>>>> invalidated remote partition. To be safe, the reset_partition_data() is
>>>> now enhanced to always clear the remote_partition flag. So there is no
>>>> need to explicitly clear remote_partition in remote_partition_disable().
>>> After the update_prstate() change, every path that invalidates a remote
>>> partition goes through remote_partition_disable(), so the other
>>> reset_partition_data() callers never see the flag set. If one did,
>>> clearing only the flag would leave its CPUs in subpartitions_cpus and turn
>>> the WARN_ON_ONCE() in partition_xcpus_del() into a silent leak. Maybe drop
>>> this part?
>> Yes, I can drop this part.
>>>> On a x86 test system with boot option "isolcpus=10 cgroup_debug" set
>>>> and more than 16 cores, the following commands was executed after boot.
>>> "a x86" -> "an x86", "commands was" -> "commands were".
>>>
>>>> @@ -2946,27 +2947,32 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>>>             */
>>>>            if (((new_prs == PRS_ISOLATED) &&
>>>>                 !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
>>>> -            prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
>>>> +            prstate_housekeeping_conflict(new_prs, cs->effective_xcpus)) {
>>>>                err = PERR_HKEEPING;
>>>> -        else
>>>> +            disable_partition = true;
>>> If a root -> isolated switch fails isolated_cpus_can_update() under an
>>> isolated parent, partcmd_disable hands the CPUs back to the parent and
>>> partition_xcpus_del() adds them to isolated_cpus, which is the state the
>>> check just rejected. Switching to member ends up in the same place, so
>>> this may be fine as is.
>> If the parent is a valid isolated partition before the child partition is created, it had passed the isolated_cpus_can_update() check. So returning the CPUs back to its parent is fine.
> However, after the parent is created, the ownership of full housekeeping
> CPUs can still change, so passing the check at creation time doesn't seem
> to guarantee that returning CPUs later is still safe.

With additional thought after my email, I realized that my statement 
isn't quite correct. So invalidating the partition handing the CPUs back 
to its rightful parent may not be right. A simpler way to handle this is 
to keep the status quo and return an error to the users instead.

Cheers,
Longman

> I tested with this patch applied on a 32 vCPU VM booted with:
>
>      nohz_full=1,3 maxcpus=4
>
> CPUs 0-3 are online, and CPU0 and CPU2 are initially available as full
> housekeeping CPUs:
>
>      cd /sys/fs/cgroup
>      echo +cpuset > cgroup.subtree_control
>
>      mkdir A C
>      echo +cpuset > A/cgroup.subtree_control
>      mkdir A/B
>
>      echo 0-1 > A/cpuset.cpus
>      echo isolated > A/cpuset.cpus.partition   # isolated={0,1}, full HK={2}
>
>      echo 0 > A/B/cpuset.cpus
>      echo root > A/B/cpuset.cpus.partition     # isolated={1}, full HK={0,2}
>
>      echo 2 > C/cpuset.cpus
>      echo isolated > C/cpuset.cpus.partition   # isolated={1,2}, full HK={0}
>
> At this point, CPU0 is the last CPU that is neither domain-isolated nor in
> nohz_full. Then:
>
>      echo isolated > A/B/cpuset.cpus.partition
>
>      cat A/B/cpuset.cpus.partition
>      isolated invalid (partition config conflicts with housekeeping setup)
>
>      cat cpuset.cpus.isolated
>      0-2
>
> The root -> isolated switch of A/B is rejected as expected, but the new
> disable path then hands CPU0 back to the isolated parent A, and
> partition_xcpus_del() puts it right back into isolated_cpus.
>
> In the end the domain-isolated CPUs are {0,1,2} and the nohz_full CPUs are
> {1,3}, so no full housekeeping CPU is left.
>
> Also, as Tejun pointed out, switching A/B to member leads to the same
> problem. What I tried in patches 2-3 of [1] was: if returning CPUs to an
> isolated parent would consume the last full housekeeping CPU, invalidate
> the outermost isolated ancestor and return its CPUs instead. Maybe this
> part can serve as a reference. The implementation there may not be good
> enough - it was an earlier idea and I am not sure whether it helps :)
>
> [1] https://lore.kernel.org/all/20260910094546.5852-1-guopeng.zhang@linux.dev/
>
> Thanks,
> Guopeng

