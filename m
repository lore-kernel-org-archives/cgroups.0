Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795492740;
	b=RyAbHac+sJZ5w/wqwMAcP1nRKO4xmCMzFBxzn8GQ4rxg0+i/lIwg7zEH6M32Wrqlwam6
	 WLquRAED5wgxM/7GWKBC3rGfddQSlWup4WUYFM3fgbGZJLhKfKhusVoropenPyfxBiVaa
	 EOCgzY2IrXUzIcfq67LlNxmKgnWRAmD44YCOyTp8FuRxQzS1rCE5x5AF02wwxlqPHSvdY
	 N5WoAeuNI1cdnYUMHBBsJt058uYlDUBw6sZSdyM5GLHy7qZx9te7CW2bgTwwFrJ5EPR5g
	 WSnyj6kAxjM0BT02n3sp9jLaECvsu/Oh3E9uhoQykPCR3GxFrWIreggvxEc64mSNDog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795492740;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=0LlVvRFk6XahcsBRIlFOD4A1Grs6+bOXqtlwjKm8+D0=;
	b=j6GEFzTkWm75dfzWC4spxJNrT5weTRfpFaf9M6hH5RfZRjL1LQ64K2iEqJhq+BRgbu3H
	 9BbPJFlWEIIhZf9T4QFuhzfrdk+lfpMvyfZ9xqSIsCiwsVj3JD/vKFiHGWzQGm0AUaAmZ
	 gAWOJPGcZeK4gwLp79GiTO0W0yYlN/ySB43ZyIbGHpNWxTa8lsSep0pZs6naQ3GW5ft2h
	 x4nFr4H/745X+ATBkO54mQqauCxMp4Wr1JaNYnZY784ZUiyxCgYyEE4kWJYu5lrkRY6Ds
	 dO0OkEFfJ59DbujViH+/1B/hKIl0pkxjIAZ6x6UtM/5A1kQ/IjaT3XKpQ44i1YqL/YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Zo+ryPab;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A678606A33A
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 03:58:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A678606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Zo+ryPab
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795492736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0LlVvRFk6XahcsBRIlFOD4A1Grs6+bOXqtlwjKm8+D0=;
	b=Zo+ryPabQcdks64+sxTfyI5XZ7ofddbFE+lTsaix/FLkQiIn/HZCtxw5Xb9/eQ5O00Omzs
	unE06yVJJcslcPMSj00j5GY9A51LDp6RglrAG3DYH/oWgAvGcLSFXL4msD/TZtnO1Q4XGw
	g4z9eVrPMyhPkxfjcei9JxSYe/fnC30=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-228-1DilejH3N4q70oNWZVDrrA-1; Tue,
 24 Nov 2026 03:58:52 +0000
X-MC-Unique: 1DilejH3N4q70oNWZVDrrA-1
X-Mimecast-MFC-AGG-ID: 1DilejH3N4q70oNWZVDrrA_1795492729
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A3E91955F37;
	Tue, 24 Nov 2026 03:58:48 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F388C588;
	Tue, 24 Nov 2026 03:58:43 +0000 (UTC)
Message-ID: <1e0ec514-88cd-4cf0-ba38-18516a651115@redhat.com>
Date: Mon, 23 Nov 2026 22:58:43 -0500
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
Subject: Re: [PATCH-next v2 3/3] cgroup/cpuset: Disallow CPU 0 from being used
 in isolated partition
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Ridong Chen <ridong.chen@linux.dev>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20261123041209.382726-1-longman@redhat.com>
 <20261123041209.382726-4-longman@redhat.com>
 <4175783d-de11-4e73-bfd2-515fd30a3c57@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <4175783d-de11-4e73-bfd2-515fd30a3c57@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On 11/23/26 10:28 PM, Guopeng Zhang wrote:
>
> 在 2026/11/23 12:12, Waiman Long 写道:
>> Domain isolating CPU 0 can be problematic and may even cause panic in
>> some cases. In the near future, we are going to enable dynamic change to
>> the nohz_full CPUs to include the CPUs that are in isolated partitions
>> via the CPU hotplug mechanism. However, CPU 0 can't be made offline
>> for some architectures like x86. IOW, putting CPU 0 in an isolated
>> partition may not have the same degree of isolation than other CPUs
>> in the isolated partition in the future. For all these reasons, it is
>> better to disable its use in an isolated partition.
>>
>> Add a new partition error code to indicate to the users that CPU 0 cannot
>> be used in an isolated partition. The prstate_housekeeping_conflict()
>> function is modified to return the partition error code directly as it
>> can be either PERR_HKEEPING or PERR_ISOLCPU0.
>>
>> Some existing test cases in test_cpuset_prs.sh are modified to remove
>> the use of CPU 0 in isolated partition setup and explicit new test cases
>> are added to test that. The NOHZ_FULL test cases also modified to run if
>> the "nohz_full" parameters includes all the CPUs except CPU 1-7 instead
>> of 0-7. Though it is not recommended to put CPU 0 in the nohz_full boot
>> parameter, it is the only way we can test that the cpuset code is able to
>> correctly disallow isolating the last nohz_full/domain housekeeping CPU.
>>
>> With CPU 0 likely not allowed in the nohz_full list except for powerpc
>> and with CPU 0 also disallowed from being domain isolated and offline,
>> we will likely have CPU 0 being an always present online housekeeping
>> CPU for most kernels. For those kernels, we will not be able to trigger
>> partition invalidation due to using up the last nohz_full/domain
>> housekeeping CPU in an isolated partition and the NOHZ_FULL test cases
>> in test_cpuset_prs.sh will not be run.
>>
>> The cgroup-v2.rst documentation file is also modified to indicate that
>> CPU 0 cannot be used in an isolated partition.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   Documentation/admin-guide/cgroup-v2.rst       |  1 +
>>   kernel/cgroup/cpuset-internal.h               |  1 +
>>   kernel/cgroup/cpuset.c                        | 90 ++++++++++---------
>>   .../selftests/cgroup/test_cpuset_prs.sh       | 43 +++++----
>>   4 files changed, 80 insertions(+), 55 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 9e3c67b02ae2..2f792ff29425 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -2771,6 +2771,7 @@ Cpuset Interface Files
>>   	and excluded from the unbound workqueues.  Tasks placed in such
>>   	a partition with multiple CPUs should be carefully distributed
>>   	and bound to each of the individual CPUs for optimal performance.
>> +	The boot CPU (CPU 0) cannot be used in an isolated partition.
>>   
>>   	A partition root ("root" or "isolated") can be in one of the
>>   	two possible states - valid or invalid.  An invalid partition
>> diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
>> index 1ba94ffaff9d..505682493d81 100644
>> --- a/kernel/cgroup/cpuset-internal.h
>> +++ b/kernel/cgroup/cpuset-internal.h
>> @@ -36,6 +36,7 @@ enum prs_errcode {
>>   	PERR_ACCESS,
>>   	PERR_REMOTE,
>>   	PERR_ISOPARENT,
>> +	PERR_ISOLCPU0,
>>   };
>>   
>>   /* bits in struct cpuset flags field */
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 30af9531acdd..4b90b4c0fba6 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -61,6 +61,7 @@ static const char * const perr_strings[] = {
>>   	[PERR_ACCESS]    = "Enable partition not permitted",
>>   	[PERR_REMOTE]    = "Have remote partition underneath",
>>   	[PERR_ISOPARENT] = "Root partition is not allowed with isolated parent",
>> +	[PERR_ISOLCPU0]  = "Boot CPU (cpu 0) cannot be isolated",
>>   };
>>   
>>   /*
>> @@ -1327,25 +1328,28 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
>>    * @parent_prs: Parent partition root state
>>    * @new_cpus: the set of new effective xcpus in the current cpuset
>>    * @del_cpus: old CPUs going to be removed from current cpuset, can be NULL
>> - * Return: true if there is conflict, false otherwise
>> + * Return: PRS error code if there is a conflict, PERR_NONE otherwise
>>    *
>> - * There are two different housekeeping conflicts to be checked:
>> + * There are three different housekeeping conflicts to be checked:
>>    * 1) If new_prs is PRS_ROOT, none of the @new_cpus can be a boot-time isolated
>>    *    CPU. IOW, the whole @new_cpus must be a subset of HK_TYPE_DOMAIN_BOOT.
>>    * 2) If nohz_full is enabled and we have isolated CPUs, their combination must
>>    *    still leave housekeeping CPUs. This check is only needed if new_prs
>>    *    differs from parent_prs and one of them is PRS_ISOLATED.
>> + * 3) CPU 0 cannot be used in an isolated partition.
>>    */
>> -static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
>> -					  struct cpumask *new_cpus,
>> -					  struct cpumask *del_cpus)
>> +static enum prs_errcode prstate_housekeeping_conflict(int new_prs, int parent_prs,
>> +				struct cpumask *new_cpus, struct cpumask *del_cpus)
>>   {
>>   	cpumask_var_t full_hk_cpus;
>> -	int res;
>> +	int prs_err = PERR_NONE;
>>   
>>   	WARN_ON_ONCE(parent_prs <= 0);
>>   	if (!new_prs)
>> -		return false;
>> +		return PERR_NONE;
>> +
>> +	if ((new_prs == PRS_ISOLATED) && cpumask_test_cpu(0, new_cpus))
>> +		return PERR_ISOLCPU0;
>>   
> Hi Waiman,
>
> The CPU 0 check is missed when an invalid isolated partition becomes valid again.
>
> I reproduced this after applying the complete v2 series on a 32-vCPU x86-64 VM booted with nohz_full=0,8-31:
>
> cd /sys/fs/cgroup
> echo +cpuset > cgroup.subtree_control
> mkdir A
> echo 0-1 > A/cpuset.cpus
> echo isolated > A/cpuset.cpus.partition
> cat A/cpuset.cpus.partition
> # isolated invalid (Boot CPU (cpu 0) cannot be isolated)
>
> echo 0-2 > A/cpuset.cpus
> cat A/cpuset.cpus.partition
> # isolated
> cat A/cpuset.cpus.exclusive.effective
> # 0-2
> cat cpuset.cpus.isolated
> # 0-2
>
> Initially, the partition is marked invalid because it contains CPU 0. However, a subsequent write to cpuset.cpus makes it a valid isolated partition that still contains CPU 0.
> The same sequence also reproduces with isolcpus=domain,managed_irq,0,10-11, where the final global isolated mask is 0-2,10-11.
>
> Here, new_prs can still be PRS_INVALID_ISOLATED (-2), so the check above does not match.
> Would it make sense to move the CPU 0 check after normalizing new_prs?
>
> if (new_prs < 0)
>          new_prs = -new_prs;
>
> if ((new_prs == PRS_ISOLATED) && cpumask_test_cpu(0, new_cpus))
>          return PERR_ISOLCPU0;

Yes, I am aware of this and I am going to move down the statement as 
suggested in v3.

Thanks,
Longman

>
> Best regards,
> Guopeng
>
>>   	/*
>>   	 * For a currently invalid partition root state, do the check assuming
>> @@ -1363,7 +1367,7 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
>>   
>>   	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT) && (new_prs == PRS_ROOT) &&
>>   	    !cpumask_subset(new_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
>> -		return true;
>> +		return PERR_HKEEPING;
>>   
>>   	if (del_cpus && cpumask_empty(del_cpus))
>>   		del_cpus = NULL;
>> @@ -1377,7 +1381,7 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
>>   	 */
>>   	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE) ||
>>   	    (new_prs == parent_prs) || (!del_cpus && (new_prs == PRS_ROOT)))
>> -		return false;
>> +		return PERR_NONE;
>>   
>>   	/*
>>   	 * Now make sure that @new_cpus contains new CPUs to be isolated and
>> @@ -1388,7 +1392,7 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
>>   		swap(new_cpus, del_cpus);
>>   
>>   	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
>> -		return true;
>> +		return PERR_HKEEPING;
>>   
>>   	/*
>>   	 * Check if del_cpus may contain a CPU that can become an active
>> @@ -1398,20 +1402,19 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
>>   		cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
>>   			    housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
>>   		if (cpumask_first_and_and(del_cpus, full_hk_cpus,
>> -					  cpu_active_mask) < nr_cpu_ids) {
>> -			res = false;
>> +					  cpu_active_mask) < nr_cpu_ids)
>>   			goto out;
>> -		}
>>   	}
>>   
>>   	cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
>>   		    housekeeping_cpumask(HK_TYPE_DOMAIN));
>>   	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
>>   	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
>> -	res = !cpumask_weight_andnot(full_hk_cpus, new_cpus);
>> +	if (!cpumask_weight_andnot(full_hk_cpus, new_cpus))
>> +		prs_err = PERR_HKEEPING;
>>   out:
>>   	free_cpumask_var(full_hk_cpus);
>> -	return res;
>> +	return prs_err;
>>   }
>>   
>>   /**
>> @@ -1446,9 +1449,12 @@ static enum prs_errcode validate_partition(struct cpuset *cs,
>>   	if (!parent)
>>   		parent = &top_cpuset;
>>   	parent_prs = parent->partition_root_state;
>> -	if (parent_prs > 0 &&
>> -	    prstate_housekeeping_conflict(new_prs, parent_prs, new_excpus, del))
>> -		return PERR_HKEEPING;
>> +	if (parent_prs > 0) {
>> +		enum prs_errcode err = prstate_housekeeping_conflict(new_prs, parent_prs,
>> +								     new_excpus, del);
>> +		if (err)
>> +			return err;
>> +	}
>>   
>>   	if (tasks_nocpu_error(parent, cs, new_excpus))
>>   		return PERR_NOCPUS;
>> @@ -1715,6 +1721,8 @@ static void compute_effective_nodemask(nodemask_t *new_mems,
>>   static int remote_partition_enable(struct cpuset *cs, int new_prs,
>>   				   struct tmpmasks *tmp)
>>   {
>> +	enum prs_errcode err;
>> +
>>   	/*
>>   	 * The user must have sysadmin privilege.
>>   	 */
>> @@ -1737,8 +1745,9 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>>   		return PERR_INVCPUS;
>>   	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
>>   		return PERR_NOCPUS;
>> -	if (prstate_housekeeping_conflict(new_prs, PRS_ROOT, tmp->new_cpus, NULL))
>> -		return PERR_HKEEPING;
>> +	err = prstate_housekeeping_conflict(new_prs, PRS_ROOT, tmp->new_cpus, NULL);
>> +	if (err)
>> +		return err;
>>   
>>   	spin_lock_irq(&callback_lock);
>>   	partition_xcpus_add(new_prs, NULL, tmp->new_cpus);
>> @@ -1833,14 +1842,16 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>>   	 * left in the top cpuset.
>>   	 */
>>   	if (adding) {
>> +		enum prs_errcode err = prstate_housekeeping_conflict(prs, PRS_ROOT,
>> +							excpus, tmp->delmask);
>> +
>>   		if (!capable(CAP_SYS_ADMIN))
>>   			WRITE_ONCE(cs->prs_err, PERR_ACCESS);
>>   		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
>>   			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
>>   			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
>> -		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
>> -						       excpus, tmp->delmask))
>> -			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
>> +		else if (err)
>> +			WRITE_ONCE(cs->prs_err, err);
>>   		if (cs->prs_err)
>>   			goto invalidate;
>>   	}
>> @@ -2101,16 +2112,16 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>   			 * active housekeeping CPUs.
>>   			 */
>>   			cpumask_andnot(tmp->addmask, cs->effective_xcpus, tmp->delmask);
>> -			if ((parent_prs == PRS_ROOT) && (old_prs == PRS_ISOLATED) &&
>> -			    prstate_housekeeping_conflict(old_prs, parent_prs,
>> -							  tmp->delmask, tmp->addmask)) {
>> -				adding = cpumask_and(tmp->addmask, cs->effective_xcpus,
>> -						     tmp->delmask);
>> -				part_error = PERR_HKEEPING;
>> -			} else {
>> +			if ((parent_prs == PRS_ROOT) && (old_prs == PRS_ISOLATED)) {
>> +				part_error = prstate_housekeeping_conflict(old_prs, parent_prs,
>> +								tmp->delmask, tmp->addmask);
>> +				if (part_error)
>> +					adding = cpumask_and(tmp->addmask, cs->effective_xcpus,
>> +							     tmp->delmask);
>> +			}
>> +			if (!part_error)
>>   				deleting = cpumask_andnot(tmp->delmask, tmp->delmask,
>>   							  cs->effective_xcpus);
>> -			}
>>   		} else if (is_partition_invalid(cs)) {
>>   			struct cgroup_subsys_state *css;
>>   			struct cpuset *child;
>> @@ -2121,11 +2132,11 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>   			 * cpu exclusivity test when cpuset.cpus.exclusive is
>>   			 * empty as well as the housekeeping check.
>>   			 */
>> -			if (prstate_housekeeping_conflict(cs->partition_root_state,
>> -							  parent_prs, tmp->delmask, NULL)) {
>> -				part_error = PERR_HKEEPING;
>> +			part_error = prstate_housekeeping_conflict(cs->partition_root_state,
>> +							parent_prs, tmp->delmask, NULL);
>> +			if (part_error)
>>   				goto write_error;
>> -			}
>> +
>>   			if (cpumask_empty(cs->exclusive_cpus)) {
>>   				rcu_read_lock();
>>   				cpuset_for_each_child(child, css, parent) {
>> @@ -2997,12 +3008,11 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>   		 * A change in load balance state only, no change in cpumasks.
>>   		 * Need to update isolated_cpus.
>>   		 */
>> -		if (prstate_housekeeping_conflict(new_prs, parent_prs,
>> -						  cs->effective_xcpus, NULL))
>> -			err = PERR_HKEEPING;
>> -		else if (parent_prs == PRS_ISOLATED)
>> +		if (parent_prs == PRS_ISOLATED)
>>   			err = PERR_ISOPARENT;	/* old_prs should be isolated */
>> -
>> +		else
>> +			err = prstate_housekeeping_conflict(new_prs, parent_prs,
>> +							    cs->effective_xcpus, NULL);
>>   		if (err) {
>>   			disable_partition = true;
>>   		} else {
>> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> index 1397ec428c46..f297e59d8f00 100755
>> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> @@ -110,8 +110,8 @@ echo "" > test/cpuset.cpus
>>   
>>   #
>>   # If nohz_full CPUs have been reserved at boot time, they should not include
>> -# CPUs 0-7 as that may fail some of the test cases. On the other hand if the
>> -# set of nohz_full CPUs includes all the CPUs except 0-7 in a single range
>> +# CPUs 1-7 as that may fail some of the test cases. On the other hand if the
>> +# set of nohz_full CPUs includes all the CPUs except 1-7 in a single range
>>   # <first>-<last>, we can run a special set of housekeeping CPUs exhaustion
>>   # tests to see if the cpuset code will reject them.
>>   #
>> @@ -123,14 +123,22 @@ NOHZ_FULL_CPUS=
>>   	NOHZ_FULL_CPUS=$(cat /sys/devices/system/cpu/nohz_full)
>>   LAST_PRESENT_CPU=$(cat /sys/devices/system/cpu/present | sed -e "s/.*[,-]//")
>>   [[ -n "$NOHZ_FULL_CPUS" ]] && {
>> -	FIRST_NOHZ_FULL_CPU=$(echo $NOHZ_FULL_CPUS | sed -e "s/[,-].*//")
>> -	LAST_NOHZ_FULL_CPU=$(echo $NOHZ_FULL_CPUS | sed -e "s/,.*//;s/.*[-]//")
>> +	if [[ $(expr $NOHZ_FULL_CPUS : "^0,") -gt 0 ]]
>> +	then
>> +		NOHZ_CPU0=1
>> +		NOHZ_CPUS=$(echo $NOHZ_FULL_CPUS | sed -e "s/^0,//")
>> +	else
>> +		NOHZ_CPUS=$NOHZ_FULL_CPUS
>> +	fi
>> +	FIRST_NOHZ_FULL_CPU=$(echo $NOHZ_CPUS | sed -e "s/[,-].*//")
>> +	LAST_NOHZ_FULL_CPU=$(echo $NOHZ_CPUS | sed -e "s/,.*//;s/.*[-]//")
>>   	echo "Boot nohz_full CPUs: $NOHZ_FULL_CPUS"
>>   }
>>   [[ -n "$FIRST_NOHZ_FULL_CPU" && "$FIRST_NOHZ_FULL_CPU" -le 7 ]] &&
>>   	skip_test "Boot NOHZ_FULL CPUs overlap CPUs to be tested!"
>>   
>>   [[ -n "$FIRST_NOHZ_FULL_CPU" && "$FIRST_NOHZ_FULL_CPU" = 8 &&
>> +   -n "$NOHZ_CPU0" &&
>>      "$LAST_NOHZ_FULL_CPU" = $LAST_PRESENT_CPU ]] && RUN_NOHZ_FULL_TESTS=1
>>   
>>   #
>> @@ -394,8 +402,8 @@ TEST_MATRIX=(
>>   	# Invalid to valid local partition direct transition tests
>>   	" C1-3:P2  X4:P2    .      .      .      .      .      .     0 A1:1-3|XA1:1-3|A2:1-3:XA2: A1:P2|A2:P-2 1-3"
>>   	" C1-3:P2  X4:P2    .      .      .    X3:P2    .      .     0 A1:1-2|XA1:1-3|A2:3:XA2:3 A1:P2|A2:P2 1-3"
>> -	" C0-3:P2    .      .    C4-6   C0-4     .      .      .     0 A1:0-4|B1:5-6 A1:P2|B1:P0"
>> -	" C0-3:P2    .      .    C4-6 C0-4:C0-3  .      .      .     0 A1:0-3|B1:4-6 A1:P2|B1:P0 0-3"
>> +	" C1-3:P2    .      .    C4-6   C1-4     .      .      .     0 A1:1-4|B1:5-6 A1:P2|B1:P0"
>> +	" C1-3:P2    .      .    C4-6 C1-4:C1-3  .      .      .     0 A1:1-3|B1:4-6 A1:P2|B1:P0 1-3"
>>   
>>   	# Local partition invalidation tests
>>   	" C0-3:X1-3:P2 C1-3:X2-3:P2 C2-3:X3:P2 \
>> @@ -506,6 +514,11 @@ TEST_MATRIX=(
>>   	"  CX1-4  CX2-4:P2  .    C5-6      .     .      .   P1:C3-6  0 A1:1|A2:2-4|B1:5-6 \
>>   								       A1:P0|A2:P2:B1:P-1 2-4"
>>   
>> +	# CPU 0 cannot be used in an isolated partition
>> +	"  CX0-4     .      .      .       P2    .      .      .     0 A1:0-4 A1:P-2"
>> +	"  CX0-4  C0-2:P1   .      .       .     P2     .      .     0 A1:0-4|A2:0-2 A2:P-2"
>> +	"  CX0-4  C3-4:P2   .      .       .    C0-2    .      .     0 A1:0-4|A2:0-2 A2:P-2"
>> +
>>   	# When multiple partitions with conflicting cpuset.cpus are created, the
>>   	# latter created ones will only get what are left of the available exclusive
>>   	# CPUs.
>> @@ -525,8 +538,8 @@ TEST_MATRIX=(
>>   
>>   	# A middle isolated parent shrunk below coverage: the released CPUs of
>>   	# an invalidated child stay isolated as a higher ancestor still covers them.
>> -	" CX0-4:P2 CX2-4:P2 CX3-4:P2 .     .     X2     .      .     0 A1:0-1,3-4|A2:2|A3:2 \
>> -								       A1:P2|A2:P2|A3:P-2 0-4"
>> +	" CX1-4:P2 CX2-4:P2 CX3-4:P2 .     .     X2     .      .     0 A1:1,3-4|A2:2|A3:2 \
>> +								       A1:P2|A2:P2|A3:P-2 1-4"
>>   
>>   	# When an isolated partition child with root partition parent is invalidated,
>>   	# its effective xcpus will be removed from isolated_cpus.
>> @@ -618,20 +631,20 @@ ISOLCPUS_TEST_MATRIX=(
>>   	" CX1-2,I:X1,I:P1 . .      .     X1,2,I  .      .      .     0 A1:1-2,I|XA1:1-2,I A1:P-1 ."
>>   )
>>   
>> -# Test matrix to be run when boot time nohz_full CPUs cover all CPUs except CPUs 0-7
>> +# Test matrix to be run when boot time nohz_full CPUs cover all CPUs except CPUs 1-7
>>   # This also means that CPU 8 is available and is a nohz_full CPU.
>>   NOHZ_FULL_TEST_MATRIX=(
>>   	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
>>   	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
>>   	# Using all the nohz_full HK CPUs 0-7 in isolated partition is not allowed
>> -	" C0-7       .      .      .      P2     .      .      .     0 A1:0-7 A1:P-2 ."
>> -	" C2-7:P2    .      .      .     C0-4    .      .      .     0 A1:0-4 A1:P2 0-4"
>> -	" C1-7:P2 C5-7:P2   .      .       .     .      .    C0:P2   0 A1:1-4|A2:5-7|B1:0
>> -								       A1:P2|A2:P2|B1:P-2 1-7"
>> +	" C1-7       .      .      .      P2     .      .      .     0 A1:1-7 A1:P-2 ."
>> +	" C2-7:P2    .      .      .     C1-4    .      .      .     0 A1:1-4 A1:P2 1-4"
>> +	" C2-7:P2 C5-7:P2   .      .       .     .      .    C1:P2   0 A1:2-4|A2:5-7|B1:1
>> +								       A1:P2|A2:P2|B1:P-2 2-7"
>>   	# An isolated child partition cannot grow to take over the last
>>   	# housekeeping CPU when its parent expands the exclusive CPUs.
>> -	" C0-8:X1-8:P1 CX0-8:P2 .  .     X0-7    .      .      .     0 A1:0-7|A2:0-7 A1:P1|A2:P-2 ."
>> -	" C0-8:X0-6:P1 CX0-8:P2 .  .     X2-8    .      .      .     0 A1:|A2:2-8 A1:P1|A2:P2 2-8"
>> +	" C1-8:X1-8:P1 CX1-8:P2 .  .     X1-7    .      .      .     0 A1:1-7|A2:1-7 A1:P1|A2:P-2 ."
>> +	" C1-8:X0-6:P1 CX1-8:P2 .  .     X2-8    .      .      .     0 A1:|A2:2-8 A1:P1|A2:P2 2-8"
>>   )
>>   
>>   #

