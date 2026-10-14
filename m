Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8802C53CA7E
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 14:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986554; cv=none; b=tUmSEs14HwTCDicR73+5SraMWcYqv1CfIHhsh4rriLLgkIBIEDx+VuTRf6Y0/NykmPM/VUaz7flrviJ3NSyjNPPXV0klJUjWLueauIoAeZj+jX7Y9Lls/ZJ0S3oislCd01Wxucp9nHgSkMD9DIbgn+Z3h9VLbuJwgUYDsVccc8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986554; c=relaxed/simple;
	bh=ZOTa2J2n/o3PdPYksHZqNoqK9PRU7KuRy4odBUIUGv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T/G7eDchZ97oHnCo0CdVmMj5/kX20PlYiBn5pcICs2yY2i7JOVI663H8OLDgMii9CV1kKua9NSOS3+6wNCcd0ocgKIWGyRLBzwBe7UscnKINesvCGGKBUE2ixSPJ8R+Pu9rfWgFxyIBJ8H2T9Gm56l2ZRMdrgHJPrSPPkxh7atM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=REvo32ws; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="REvo32ws"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791986546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=niLU5mouqSuaOlE5ULQOTK5NB0Zq9HRU3JywpHNKu4U=;
	b=REvo32wsrM7yLu4P3Y01JPKktZhPJq643iPg1Jq1yxdLyonlbcqoO2+bCUFeowAq35Y0Kk
	DC9hqEmUiwtFgi7XjUDWYtlA73fbG1g2eS/oZCLd4Nltydnc0ARcnEu2bFARUlBNiwFZIp
	5bpgE7/ISz170DmW0wXcLovI69rwDpo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-Mue0O8m4NzGte69turW4KA-1; Wed,
 14 Oct 2026 14:02:21 +0000
X-MC-Unique: Mue0O8m4NzGte69turW4KA-1
X-Mimecast-MFC-AGG-ID: Mue0O8m4NzGte69turW4KA_1791986537
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 171811800624;
	Wed, 14 Oct 2026 14:02:17 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 53EF31800495;
	Wed, 14 Oct 2026 14:02:15 +0000 (UTC)
Message-ID: <7bafc4a3-a481-489e-8ff5-4de8e9c99934@redhat.com>
Date: Wed, 14 Oct 2026 10:02:14 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 2/6] cgroup/cpuset: Consider all the exclusive
 CPUs when doing housekeeping check
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Hui Peng <benquike@gmail.com>
References: <20261010221938.243859-1-longman@redhat.com>
 <20261010221938.243859-3-longman@redhat.com>
 <01173fca-b1de-4127-936c-05deae31f894@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <01173fca-b1de-4127-936c-05deae31f894@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 10/11/26 4:34 AM, Guopeng Zhang wrote:
>
> 在 2026/10/11 06:19, Waiman Long 写道:
>> When prstate_housekeeping_conflict() is called to perform housekeeping
>> check with cpumask changes, the exclusive CPUs owned by child partitions
>> are excluded. If the current cpuset is an isolated partition with root
>> partition children. It is possible the cpumask change will still leave
>> active housekeeping CPUs but then no housekeeping CPUs will be left when
>> the child partitions are disabled or invalidated.
>>
>> To protect against this possibility, all the exclusive CPUs of the
>> cpuset should be considered to be owned by the current cpuset when doing
>> housekeeping check. Do that by calling prstate_housekeeping_conflict()
>> in partition_cpus_change() and passing in the add_cpus and del_cpus
>> parameters as if the cpuset owns all the exclusive CPUs.
>>
>> With this change, the prstate_housekeeping_conflict() call in
>> update_parent_effective_cpumask() with partcmd_update and newmask
>> is now duplicative and can be removed. The housekeeping check in
>> remote_cpus_update(), however, will still be useful as this function can
>> be called directly from update_cpumasks_hier() without going through
>> partition_cpus_change(). The update_parent_effective_cpumask() call
>> from update_cpumasks_hier() is partcmd_update with no cpumask which
>> still have the housekeeping check and so is covered.
>>
>> In the case of partition state switch from isolated to root and vice
>> versa, the set of exclusive CPUs are recomputed to include those
>> transferred to child paritions as well.
>>
>> Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   kernel/cgroup/cpuset.c | 26 +++++++++++++++++---------
>>   1 file changed, 17 insertions(+), 9 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index f3cebb277a68..1c0441fa3bea 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1907,14 +1907,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>   					       parent->effective_xcpus);
>>   		}
>>   
>> -		/*
>> -		 * Check for housekeeping conflicts
>> -		 */
>> -		if (is_partition_valid(cs) &&
>> -		    prstate_housekeeping_conflict(old_prs, parent_prs,
>> -						  tmp->delmask, tmp->addmask))
>> -			part_error = PERR_HKEEPING;
>> -
>>   		/*
>>   		 * The new CPUs to be removed from parent's effective CPUs
>>   		 * must be present.
>> @@ -2398,6 +2390,21 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
>>   		return;
>>   
>>   	prs_err = validate_partition(cs, trialcs);
>> +	if (!prs_err) {
>> +		int parent_prs = is_remote_partition(cs)
>> +			       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
>> +		/*
>> +		 * Check for housekeeping CPUs conflict assuming that all the
>> +		 * exclusive CPUs belong to the current cpuset.
>> +		 */
>> +		compute_excpus(trialcs, tmp->new_cpus);
>> +		cpumask_andnot(tmp->addmask, tmp->new_cpus, cs->effective_xcpus);
>> +		cpumask_andnot(tmp->delmask, cs->effective_xcpus, tmp->new_cpus);
> I ran a few local tests on v2 and still found the following gaps in the
> housekeeping checks.
>
> With CPUs 0-15 online and nohz_full=2-15:
>
>      # cd /sys/fs/cgroup
>      # echo +cpuset > cgroup.subtree_control
>      # mkdir A
>      # echo 1 > A/cpuset.cpus
>      # echo isolated > A/cpuset.cpus.partition
>      # echo 0-1 > A/cpuset.cpus
>      # cat A/cpuset.cpus.partition
>      isolated
>      # cat A/cpuset.cpus.exclusive.effective
>      0-1
>      # cat cpuset.cpus.isolated
>      0-1
> The check computes delmask={1}, although CPU 1 is still isolated after the
> update. That lets it isolate CPU 0, the last remaining housekeeping CPU.
>
> On a fresh boot with the same nohz_full setting:
>
>      # cd /sys/fs/cgroup
>      # echo +cpuset > cgroup.subtree_control
>      # mkdir A B
>      # echo 1 > A/cpuset.cpus
>      # echo 1 > A/cpuset.cpus.exclusive
>      # echo isolated > A/cpuset.cpus.partition
>      # echo +cpuset > A/cgroup.subtree_control
>      # mkdir A/C
>      # echo 1 > A/C/cpuset.cpus
>      # echo root > A/C/cpuset.cpus.partition
>      # echo 0 > B/cpuset.cpus
>      # echo isolated > B/cpuset.cpus.partition
>      # echo 1-2 > A/cpuset.cpus
>      # echo 1-2 > A/cpuset.cpus.exclusive
>      # cat cpuset.cpus.isolated
>      0,2
>      # echo member > A/C/cpuset.cpus.partition
>      # cat A/cpuset.cpus.partition
>      isolated
>      # cat cpuset.cpus.isolated
>      0-2
>
> CPU 1 is present in both masks and cancels out of addmask while the root
> child owns it. With nohz_full=2-15 and B isolating CPU 0, CPU 1 was the last
> remaining housekeeping CPU; disabling the child leaves none.
> This also reproduces before the series, so it is an existing issue.
This is again a corner case of creating root partition under an isolated 
partition.
>> +		if (prstate_housekeeping_conflict(cs->partition_root_state,
>> +						  parent_prs, tmp->addmask,
>> +						  tmp->delmask))
>> +			prs_err = PERR_HKEEPING;
>> +	}
> An invalid root with an explicit exclusive mask can retain effective_xcpus
> without owning those CPUs. Subtracting this mask skips checking them when
> the partition becomes valid again.
>
> With CPUs 0-15 online and isolcpus=domain,10-11, on a fresh boot:
>
>      # cd /sys/fs/cgroup
>      # echo +cpuset > cgroup.subtree_control
>      # mkdir A
>      # echo 10 > A/cpuset.cpus
>      # echo 10 > A/cpuset.cpus.exclusive
>      # echo root > A/cpuset.cpus.partition
>      # cat A/cpuset.cpus.partition
>      root invalid (partition config conflicts with housekeeping setup)
>      # cat A/cpuset.cpus.exclusive.effective
>      10
>      # echo 10,12 > A/cpuset.cpus
>      # cat A/cpuset.cpus.partition
>      root
>      # cat A/cpuset.cpus.effective
>      10
>      # cat cpuset.cpus.effective
>      0-9,11-15
>
> addmask is empty here, so boot-isolated CPU 10 is allocated to the now-valid
> root without being checked.
>
> Should an invalid partition be checked against the full mask it will
> acquire, rather than these deltas?

There are bugs in patch 2 of the v2 patch. I can't reproduce this 
problem with the new version that I have.

Cheers,
Longman

>
> Thanks,
> Guopeng
>>   	if (prs_err) {
>>   		WRITE_ONCE(cs->prs_err, prs_err);
>>   		trialcs->prs_err = prs_err;
>> @@ -2897,8 +2904,9 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>   		 * A change in load balance state only, no change in cpumasks.
>>   		 * Need to update isolated_cpus.
>>   		 */
>> +		compute_excpus(cs, tmpmask.new_cpus);
>>   		if (prstate_housekeeping_conflict(new_prs, parent_prs,
>> -						  cs->effective_xcpus, NULL))
>> +						  tmpmask.new_cpus, NULL))
>>   			err = PERR_HKEEPING;
>>   		else
>>   			isolcpus_updated = true;

