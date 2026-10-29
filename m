Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793297083;
	b=hHDXSTOA6offTKw5BUuRIc9T03yQTA4WQDGbKzB4mXldBFG4ZCENl4epetLahSVApUOI
	 y5lEjG/WMvw324PiTEOWw4+iCULY5NiLiOkzPmimseShkSCXdklcbH+StVPwY6DJ4RChc
	 WbSp8FjBizCUAfFagtKR1BNLij1RdCDCOjrnV0iUwhodj2+pXDbcZcTsGfG14Hsn/Wkt8
	 8JcKicHKg+MoCIPbyj3sd3wvvIL9K2iepIGpDlV/9vZ0BXmBlZyb09MA/pEtbj3lk77M4
	 b72imeXyVf+jREj84+/O+CIuQQ/DuleKvageLTX4e1FbZMbPRSCgFODEn/1p/e1RH/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793297083;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=dGTHaUD5kbfXafKpZr4Gwijm/14k8Ydj5B6tav1S8CY=;
	b=18q64Pl3orSrXevBjVy94dkila6kbYLNyqFwPy4N/ZPWEtKezNUhyTqnIfToz2+5TDrF
	 DhHBUK25D8JhAJCwYQWklKTTj75Zcu6godGc3NlNinCTaO+SwacY9GeOpf79+ghNO260F
	 45ooAbxQvkvSU2uUL8VQxZhnq8gButUtHdmSl+ze9QrUxEQMxqknWWjwatBeyPQHKmgto
	 jzXo9fMtuvJ7fF2zbhVOcZj/3i9iE7xZDcOZsF6meybjUB+At1f0vQIubK6jtJzoq1yEC
	 M61jjxHvqCaqIG5F2DczIr3wrPZLJkh1wZDZDi035NQwM855jxI9Eoj89Xbj5i/XsCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hPxZ9b2i;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C124606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 18:04:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C124606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hPxZ9b2i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793297081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dGTHaUD5kbfXafKpZr4Gwijm/14k8Ydj5B6tav1S8CY=;
	b=hPxZ9b2iOgQOmGyrGHXxRykcJV+sZHhv4tt3txynnaZ5IKe7JaNS2Gcnxvxt2uMmlmvG1W
	vUqKlrHnXn50HMH20OsyypCqN7W0CxBSbFOkFXlbtrqvR3jFunlbRLbRgQpyrg63mgED6P
	sXNOGqzH6xx7zZnX1l5g96hHGbfBnIc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-kxG7bvfzO7ymwFD1gpytYg-1; Thu,
 29 Oct 2026 14:04:35 -0400
X-MC-Unique: kxG7bvfzO7ymwFD1gpytYg-1
X-Mimecast-MFC-AGG-ID: kxG7bvfzO7ymwFD1gpytYg_1793297074
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 250221955DBF;
	Thu, 29 Oct 2026 18:04:34 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8E2941800643;
	Thu, 29 Oct 2026 18:04:32 +0000 (UTC)
Message-ID: <f7482836-d18b-41b9-be9a-4c4ea867c6ad@redhat.com>
Date: Thu, 29 Oct 2026 14:04:31 -0400
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
Subject: Re: [PATCH-next] cgroup/cpuset: Fix incorrect CPU accounting with
 parent's effective_xcpus expansion
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261028152608.648427-1-longman@redhat.com>
 <661486ab-4879-47cd-8035-ae0d7a7d7462@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <661486ab-4879-47cd-8035-ae0d7a7d7462@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111


On 10/29/26 5:42 AM, Guopeng Zhang wrote:
>
> 在 2026/10/28 23:26, Waiman Long 写道:
>> Commit ec0254b9eb49 ("cgroup/cpuset: Release invalid isolated CPUs with
>> a shrunk root partition parent") fixes incorrect isolated_cpus accounting
>> when contraction of a parent's effective_xcpus can cause a child partition
>> to lose isolated CPUs. Expansion of parent's effective_cpus can also allow
>> a child partition to gain more effective_xcpus. However, the current code
>> doesn't handle this case correctly leading to incorrect effective_cpus
>> and isolated_cpus accounting. Fix that by looking for this possible
>> expansion of effective_xcpus and perform the proper accounting action.
>>
>> New test cases are added to test this effective_xcpus expansion scenarios.
>>
>> Reported-by: Guopeng Zhang <guopeng.zhang@linux.dev>
>> Link: https://lore.kernel.org/lkml/20261027123837.100909-1-guopeng.zhang@linux.dev
>> Signed-off-by: Waiman Long <longman@redhat.com>
> I have tested this patch. In the scenarios I tested, the double grant
> and the isolated_cpus accounting after the expansion are now correct.
>
>> ---
>>   kernel/cgroup/cpuset.c                            | 12 ++++++++++++
>>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 15 +++++++++++++++
>>   2 files changed, 27 insertions(+)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 3219f927c35e..39c81a0a8ab9 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2097,6 +2097,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>   							     parent->effective_xcpus);
>>   			if (!cpumask_empty(tmp->addmask))
>>   				isolated_cpus_release(cs, tmp->addmask);
>> +			/* Expansion of parent's effective_xcpus is handled below */
>>   		}
>>   		if (nocpu) {
>>   			part_error = PERR_NOCPUS;
>> @@ -2106,11 +2107,22 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>   						     parent->effective_xcpus);
>>   		} else if ((parent_prs == PRS_ISOLATED) &&
>>   			   ((old_prs == PRS_ROOT) || (old_prs == -PRS_ROOT))) {
>> +			/* Parent partition state changed to PRS_ISOLATED */
>>   			part_error = PERR_ISOPARENT;
>>   			if (old_prs == PRS_ROOT) {
>>   				cpumask_copy(tmp->addmask, cs->effective_xcpus);
>>   				adding = true;
>>   			}
>> +		} else if (is_partition_valid(cs) &&
>> +			   !cpumask_equal(tmp->delmask, cs->effective_xcpus)) {
> The branch is also entered when the freshly computed effective xcpus
> shrink, e.g. after a parent contraction. The cpumask_andnot() then
> computes an empty delta and it doesn't seem to cause any harm. Do we
> need to tighten the condition?

I intentionally made it simpler. For the shrink case, deleting will be 
false and nothing will be done.

>
>> +			/*
>> +			 * If there is an expansion of parent's effective_xcpus,
>> +			 * we may take more xcpus from parent. The parent's
>> +			 * effective_cpus should still have active CPUs or nocpu
>> +			 * should have been set.
>> +			 */
>> +			deleting = cpumask_andnot(tmp->delmask, tmp->delmask,
>> +						  cs->effective_xcpus);
>>   		} else if (is_partition_invalid(cs)) {
>>   			struct cgroup_subsys_state *css;
>>   			struct cpuset *child;
>> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> index 83ef6c781af3..844efdf029cd 100755
>> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> @@ -531,6 +531,21 @@ TEST_MATRIX=(
>>   	" C1-4:P1 C3-4:P2   .      .    T:C4-6   .      .      .     0 A1:5-6|A2:4 A1:P1|A2:P2 4"
>>   	" C1-4:P1 C1-2:P2   .      .    T:C4-6   .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
>>   
>> +	# The extra CPUs gained by a child partition when its parent expands the
>> +	# exclusive CPUs have to be taken away from the parent.
>> +	" C2-6:X2-5:P1 CX3-6:P1 \
>> +	                    .      .    X2-6     .      .      .     0 A1:2|A2:3-6|XA2:3-6 A1:P1|A2:P1 ."
>> +	" C2-6:X2-5:P1 CX3-6:P2 \
>> +	                    .      .    X2-6     .      .      .     0 A1:2|A2:3-6|XA2:3-6 A1:P1|A2:P2 3-6"
>> +
>> +	# Both expansion and contraction of parent's effective_xcpus will be
>> +	# correctly handled in child partition and the child can be invalidated
>> +	# if a populated parent could lose all its effective_cpus.
>> +	" C2-6:X2-5:P1 CX3,5-6:P2 \
>> +	                    .      .    X4-6     .      .      .     0 A1:4|A2:5-6|XA2:5-6 A1:P1|A2:P2 5-6"
>> +	" C2-6:X2-5:P1 CX3-6:P2 \
>> +	                    .      .   T:X4-6    .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
>> +
>>   	#
>>   	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
>>   	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
> BTW, about the housekeeping check issue from my previous email.
> I verified it with the session below on a nohz_full=8-31 boot where
> CPUs 0-7 are the housekeeping CPUs:
>
>    # cat /sys/devices/system/cpu/nohz_full
>    8-31
>    # cd /sys/fs/cgroup
>    # echo +cpuset > cgroup.subtree_control
>    # mkdir -p A/B
>    # echo 0-7 > A/cpuset.cpus
>    # echo 1-7 > A/cpuset.cpus.exclusive
>    # echo root > A/cpuset.cpus.partition
>    # echo +cpuset > A/cgroup.subtree_control
>    # echo 0-7 > A/B/cpuset.cpus
>    # echo 0-7 > A/B/cpuset.cpus.exclusive
>    # echo isolated > A/B/cpuset.cpus.partition
>    # cat /sys/fs/cgroup/cpuset.cpus.isolated
>    1-7
>    # cat A/B/cpuset.cpus.exclusive.effective
>    1-7
>    # echo 0-7 > A/cpuset.cpus.exclusive
>    # cat A/B/cpuset.cpus.partition
>    isolated
>    # cat /sys/fs/cgroup/cpuset.cpus.isolated
>    0-7
>
> B stays a valid isolated partition holding all the housekeeping CPUs
> and there is no warning at all.
>
> If the housekeeping issue is going to be addressed in this series, is
> a test case like the one below worth adding?
>
> +	# An isolated child partition cannot grow to take over the last
> +	# housekeeping CPU when its parent expands the exclusive CPUs.
> +	" C0-7:X1-7:P1 C0-7:X0-7:P2 .      .      X0-7     .      .      .     0 A1:0-7 A1:P1|A2:P-2 ."
>
>
I will fix that with another patch.

Cheers,
Longman

