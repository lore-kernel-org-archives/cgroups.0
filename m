Received: from mta1.migadu.com (out-166.mta1.migadu.com [95.215.58.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69BA353EEB
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 07:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790667657; cv=none; b=jG2E1Xz7i3fHHYKHOjBeJcUdiNGYtYnk59gWdaX4tFiw3qOjfvKzqc+b+ygFIGumhl+Rgop6aYl8szf0eUfO2r8Vu0egJ54mHqXJ+AX4/vjuGWkFapwGhVKvx0EkVMNZSVGHWSCPw4eqcBX6zmq6lHdxb07Oryvx70nGlGl5DlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790667657; c=relaxed/simple;
	bh=eBA2dsoEYS/wtSZz82k25VGaT71+syN4FN5MUymZna0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZTAH5HxaaZscnEJke9yuqIzU0eI0NAL1Yb5Tuh2HWPcwP7Z86vBG5y8Irv0hkUUm1Ny0UmLawGBjK30Rkn4HWFHVcJL7poEHL/5he/VoqjVhfdV4WC5XKVqrYGIQqhKflust3xWTBQPiqEgsiSXcbashW14eZpmvjRs8vHMj6k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KNnv5PBA; arc=none smtp.client-ip=95.215.58.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KNnv5PBA"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eBA2dsoEYS/wtSZz82k25VGaT71+syN4FN5MUymZna0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790667652; v=1; x=1791272452;
 b=KNnv5PBAUPHONP872XcsV3YHT2kf3boMwF+KeJBf3DElF3WXfHav1InnYRf0yWu4Z7S/oquS
 AcDw4u2eHJV401uHgP71Ob4pA8MJClASb0t7+BwxLqITp4FCjLSxO1VdpATvzynNUl5lMY9ORIk
 K6bJImb343AIoXG+h+FJHtEI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id df226f34b7057ee0;
	Tue, 29 Sep 2026 07:40:33 +0000
X-Mizu-Trace-ID: df226f34b7057ee0
X-Migadu-Flow: FLOW_OUT
Message-ID: <5e658521-1d8f-47bd-87a2-809a79a10186@linux.dev>
Date: Tue, 29 Sep 2026 15:40:27 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Properly disable partition when partition
 state switching fails
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Hui Peng <benquike@gmail.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260928235159.515654-1-longman@redhat.com>
 <941e5affde16b803741ddaf87b937f3d@kernel.org>
 <07403332-9fc3-41cf-ba2c-63a1f83a231c@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <07403332-9fc3-41cf-ba2c-63a1f83a231c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Hi Waiman, Tejun,
在 2026/9/29 11:16, Waiman Long 写道:
> On 9/28/26 10:07 PM, Tejun Heo wrote:
>> Hello, Waiman.
>>
>> The following is a Claude-generated review.
>>
>> On Mon, Sep 28, 2026 at 07:51:59PM -0400, Waiman Long wrote:
>>> Before commit 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full
>>> don't leave any housekeeping"), the partition state can be freely switched
>>> from "root" to "isolated" and vice versa. After that commit, the switch
>>> from "root" to "isolated" can fail if it exhausts all the housekeeping
>>> CPUs. Later on, the switch from "isolated" to "root" can also fail if
>>> some of the partition CPUs are boot-time isolated by "isolcpus".
>> The isolated -> root failure came from b1034a690129 ("cgroup/cpuset:
>> Ensure domain isolated CPUs stay in root or isolated partition"). Maybe
>> add a Fixes: tag for it too?
> 
> Commit b1034a690129 ("cgroup/cpuset: Ensure domain isolated CPUs stay in root or isolated partition") comes after 103b08709e8a. From my point of view, the first commit is the one that introduces the bug. The second commit comes along assuming the existing code is right. That is why I didn't tag the second one even though the second one is easier to trigger than the first one.
> 
>>> The partition is made invalid when the switch fails. However, the
>>> remote_partition flag for a remote partition can remain set and the CPUs
>>> from the invalidated partition aren't cleared from subpartitions_cpus.
>>> Fix this by properly disable the partition in this case.
>> The reproducer below is a local partition and the fix covers that case
>> too. The CPUs weren't given back to the parent, which is what leaves them
>> in subpartitions_cpus and isolated_cpus in the example. Maybe describe
>> both? Also, "properly disable" -> "disabling".
> OK, will update the commit log.
>>
>>> In the case of remote_partition flag, it should be cleared for a
>>> invalidated remote partition. To be safe, the reset_partition_data() is
>>> now enhanced to always clear the remote_partition flag. So there is no
>>> need to explicitly clear remote_partition in remote_partition_disable().
>> After the update_prstate() change, every path that invalidates a remote
>> partition goes through remote_partition_disable(), so the other
>> reset_partition_data() callers never see the flag set. If one did,
>> clearing only the flag would leave its CPUs in subpartitions_cpus and turn
>> the WARN_ON_ONCE() in partition_xcpus_del() into a silent leak. Maybe drop
>> this part?
> Yes, I can drop this part.
>>> On a x86 test system with boot option "isolcpus=10 cgroup_debug" set
>>> and more than 16 cores, the following commands was executed after boot.
>> "a x86" -> "an x86", "commands was" -> "commands were".
>>
>>> @@ -2946,27 +2947,32 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>>            */
>>>           if (((new_prs == PRS_ISOLATED) &&
>>>                !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
>>> -            prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
>>> +            prstate_housekeeping_conflict(new_prs, cs->effective_xcpus)) {
>>>               err = PERR_HKEEPING;
>>> -        else
>>> +            disable_partition = true;
>> If a root -> isolated switch fails isolated_cpus_can_update() under an
>> isolated parent, partcmd_disable hands the CPUs back to the parent and
>> partition_xcpus_del() adds them to isolated_cpus, which is the state the
>> check just rejected. Switching to member ends up in the same place, so
>> this may be fine as is.
> If the parent is a valid isolated partition before the child partition is created, it had passed the isolated_cpus_can_update() check. So returning the CPUs back to its parent is fine.

However, after the parent is created, the ownership of full housekeeping
CPUs can still change, so passing the check at creation time doesn't seem
to guarantee that returning CPUs later is still safe.

I tested with this patch applied on a 32 vCPU VM booted with:

    nohz_full=1,3 maxcpus=4

CPUs 0-3 are online, and CPU0 and CPU2 are initially available as full
housekeeping CPUs:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control

    mkdir A C
    echo +cpuset > A/cgroup.subtree_control
    mkdir A/B

    echo 0-1 > A/cpuset.cpus
    echo isolated > A/cpuset.cpus.partition   # isolated={0,1}, full HK={2}

    echo 0 > A/B/cpuset.cpus
    echo root > A/B/cpuset.cpus.partition     # isolated={1}, full HK={0,2}

    echo 2 > C/cpuset.cpus
    echo isolated > C/cpuset.cpus.partition   # isolated={1,2}, full HK={0}

At this point, CPU0 is the last CPU that is neither domain-isolated nor in
nohz_full. Then:

    echo isolated > A/B/cpuset.cpus.partition

    cat A/B/cpuset.cpus.partition
    isolated invalid (partition config conflicts with housekeeping setup)

    cat cpuset.cpus.isolated
    0-2

The root -> isolated switch of A/B is rejected as expected, but the new
disable path then hands CPU0 back to the isolated parent A, and
partition_xcpus_del() puts it right back into isolated_cpus.

In the end the domain-isolated CPUs are {0,1,2} and the nohz_full CPUs are
{1,3}, so no full housekeeping CPU is left.

Also, as Tejun pointed out, switching A/B to member leads to the same
problem. What I tried in patches 2-3 of [1] was: if returning CPUs to an
isolated parent would consume the last full housekeeping CPU, invalidate
the outermost isolated ancestor and return its CPUs instead. Maybe this
part can serve as a reference. The implementation there may not be good
enough - it was an earlier idea and I am not sure whether it helps :)

[1] https://lore.kernel.org/all/20260910094546.5852-1-guopeng.zhang@linux.dev/

Thanks,
Guopeng
