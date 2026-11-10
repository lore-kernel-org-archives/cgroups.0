Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.59
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794292617;
	b=F0QWrc90BBqgC5YL7ExoFFE0SiqHJwO/PAC/afjtVi2QX0x9x9j7WXeiNFg0oNuvaJlc
	 TJ3ymIW1uYtomprPokURNTo4m2J7i5Dmhb1MoXvW+hoewCzR5+0WIGu4ZwcStMXF0KDQA
	 p0LG2+zlzf/80XPJjIiB+zqn8CNXvKd7gCCLoxBG4ZQClJmI6CAHcDCxMJjMtedWZu9Lt
	 oZupKDRypz64yg8ft3KxPeWGfVvjhwBDn2Ity+xFoBrKluiuHcQIAhL3HwAhwE9++wXQx
	 Tbs7p82M4p65MrbMpUxJajfdYnDFofFUkZ/8FSq4z6mtu2aUCUc42Z0PlgNOT4pNU+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794292617;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=xI/Mw+wKpfQ51uGssBou6KQdHiosm5ZcBFVWJhhdHVI=;
	b=Ouy1T4GnH2EvDba7sZ4nYfiCZrRjeFgR4dTWlWWhDtKilyWFiTxJldfMlLTCxwsUztyj
	 PZ2oA9AFbNYDBfFbTWEkGfxrcqpVeJijd0RPzL/MQsroCYbIy+8XxPoWdJQUoj3k6PpDq
	 swUgjEhS53WtGzDU5eRwmaPXFSge+rNtOG+aNNixDjqfjisypoWdDH6UKIr0077zxwU2v
	 fVEvjO9xG4Nz0TRQQIgYcNqftGDvgf675/p3mpzipaoQEQF7rLvySGrs/74Jx90YwvklM
	 zRQXd6GIRutPJ2u2dvtukScJ5LR28In5smrW9IC+0maUdINyG0cEswaBv1mSgGqVgbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QC5AJa20;
	arc=none smtp.remote-ip=91.218.175.59
Received: from mta0.migadu.com (out-59.mta0.migadu.com [91.218.175.59])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9BF606A321
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 06:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB9BF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QC5AJa20
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4ldduMkRN9py7oBtMZAvrIPqG9pOjDa0Ze0haB4M5iI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794292612; v=1; x=1794897412;
 b=QC5AJa20qTBqMHA6N/5j4zajfrAS+T+P6qUzg3wdvV3PY2DvqAV9Zdsm7NrLaTqwYQlc2ldF
 0JhGfsbEIN/Fw7zMA31SDxblcbv62sGdQYEK3wEjuGfjU+OZ3mw9G995UsbGaajIqXl7y4Mf4OH
 KKkcKMLpO/bGvCByUgF2Bu8U=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 88cdc0a77461dabf;
	Tue, 10 Nov 2026 06:36:52 +0000
X-Mizu-Trace-ID: 88cdc0a77461dabf
X-Migadu-Flow: FLOW_OUT
Message-ID: <df5c2cbc-6a81-4ac8-8160-9475a9876ef7@linux.dev>
Date: Tue, 10 Nov 2026 14:36:47 +0800
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
Subject: Re: [PATCH v3 4/4] cpuset: generalize the validate_partition()
 interface
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Chen Ridong <chenridong@huawei.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261107120100.3587595-1-ridong.chen@linux.dev>
 <20261107120100.3587595-5-ridong.chen@linux.dev>
 <d37903cd-21bc-4a07-835f-aa074c85660c@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <d37903cd-21bc-4a07-835f-aa074c85660c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/9/2026 10:52 PM, Waiman Long wrote:
> On 11/7/26 7:01 AM, Ridong Chen wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> Refactor validate_partition() to take the parent partition, the new
>> partition root state, the new effective exclusive CPUs and the CPUs to
>> be deleted, instead of a trial cpuset. A NULL parent stands for a
>> remote partition, whose CPUs come from top_cpuset. This makes the
>> interface flexible enough to handle both local and remote partition
>> validation.
>>
>> The no CPU left for tasks check now uses the given parent instead of
>> parent_cs(cs), and top_cpuset for a remote partition, as that is where
>> its CPUs are taken from. The cgroup parent of a remote partition does
>> not give it any CPU.
>>
>> The housekeeping conflict check is folded into validate_partition(). It
>> is skipped when the parent is not a valid partition root, as @cs can't
>> be a valid local partition in that case.
>>
>> Use the new interface for local partition enablement in
>> update_parent_effective_cpumask() and in partition_cpus_change(),
>> replacing the open-coded checks there. The order of the checks is now
>> the same for both paths: empty CPUs, housekeeping conflict, then no CPU
>> left for tasks.
>>
>> Signed-off-by: Chen Ridong <chenridong@huawei.com>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   kernel/cgroup/cpuset.c | 119 ++++++++++++++++++++---------------------
>>   1 file changed, 59 insertions(+), 60 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index fc9de6e16ff5..0ec20412b3ce 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1414,6 +1414,48 @@ static bool prstate_housekeeping_conflict(int new_prs, 
>> int parent_prs,
>>       return res;
>>   }
>> +/**
>> + * validate_partition - Validate a cpuset partition configuration
>> + * @cs: The cpuset to validate
>> + * @parent: Parent partition of @cs, NULL for remote partition
>> + * @new_prs: The proposed new partition root state
>> + * @new_excpus: The new effective exclusive CPUs mask to validate
>> + * @del: exclusive CPUs to be deleted from @cs, can be NULL
>> + *
>> + * A remote partition gets its CPUs from top_cpuset, so top_cpuset is used
>> + * as the parent when @parent is NULL.
>> + *
>> + * The housekeeping check is skipped if @parent is not a valid partition
>> + * root as @cs can't be a valid local partition in that case.
>> + *
>> + * Return: PRS error code (0 if valid, non-zero error code if invalid)
>> + */
>> +static enum prs_errcode validate_partition(struct cpuset *cs,
>> +                       struct cpuset *parent, int new_prs,
>> +                       struct cpumask *new_excpus,
>> +                       struct cpumask *del)
>> +{
>> +    int parent_prs;
>> +
>> +    if (new_prs == PRS_MEMBER)
>> +        return PERR_NONE;
>> +
>> +    if (cpumask_empty(new_excpus))
>> +        return PERR_INVCPUS;
>> +
>> +    if (!parent)
>> +        parent = &top_cpuset;
>> +    parent_prs = parent->partition_root_state;
>> +    if (parent_prs > 0 &&
>> +        prstate_housekeeping_conflict(new_prs, parent_prs, new_excpus, del))
>> +        return PERR_HKEEPING;
>> +
>> +    if (tasks_nocpu_error(parent, cs, new_excpus))
>> +        return PERR_NOCPUS;
>> +
>> +    return PERR_NONE;
>> +}
>> +
>>   /*
>>    * cpuset_update_sd_hk_unlock - Rebuild sched domains, update HK & unlock
>>    *
>> @@ -1934,18 +1976,10 @@ static int update_parent_effective_cpumask(struct 
>> cpuset *cs, int cmd,
>>       if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
>>           new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
>> -        /*
>> -         * Enabling partition root is not allowed if its
>> -         * effective_xcpus is empty.
>> -         */
>> -        if (cpumask_empty(tmp->delmask))
>> -            return PERR_INVCPUS;
>> -
>> -        if (prstate_housekeeping_conflict(new_prs, parent_prs, tmp->delmask, 
>> NULL))
>> -            return PERR_HKEEPING;
>> -
>> -        if (nocpu)
>> -            return PERR_NOCPUS;
>> +        part_error = validate_partition(cs, parent, new_prs,
>> +                        tmp->delmask, NULL);
>> +        if (part_error)
>> +            return part_error;
>>           /*
>>            * This function will only be called when all the preliminary
>> @@ -2424,32 +2458,6 @@ static int parse_cpuset_cpulist(const char *buf, struct 
>> cpumask *out_mask)
>>       return 0;
>>   }
>> -/**
>> - * validate_partition - Validate a cpuset partition configuration
>> - * @cs: The cpuset to validate
>> - * @trialcs: The trial cpuset containing proposed configuration changes
>> - *
>> - * If any validation check fails, the appropriate error code is set in the
>> - * cpuset's prs_err field.
>> - *
>> - * Return: PRS error code (0 if valid, non-zero error code if invalid)
>> - */
>> -static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset 
>> *trialcs)
>> -{
>> -    struct cpuset *parent = parent_cs(cs);
>> -
>> -    if (cs_is_member(trialcs))
>> -        return PERR_NONE;
>> -
>> -    if (cpumask_empty(trialcs->effective_xcpus))
>> -        return PERR_INVCPUS;
>> -
>> -    if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus))
>> -        return PERR_NOCPUS;
>> -
>> -    return PERR_NONE;
>> -}
>> -
>>   /**
>>    * partition_cpus_change - Handle partition state changes due to CPU mask 
>> updates
>>    * @cs: The target cpuset being modified
>> @@ -2463,33 +2471,24 @@ static void partition_cpus_change(struct cpuset *cs, 
>> struct cpuset *trialcs,
>>                     struct tmpmasks *tmp)
>>   {
>>       enum prs_errcode prs_err;
>> -    int parent_prs = is_remote_partition(cs)
>> -               ? PRS_ROOT : parent_cs(cs)->partition_root_state;
>> +    struct cpuset *parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
>>       if (cs_is_member(cs))
>>           return;
>> -    prs_err = validate_partition(cs, trialcs);
>> -    if (!prs_err && (parent_prs > 0) &&
>> -        !cpumask_empty(trialcs->effective_xcpus)) {
>> -        int prs = cs->partition_root_state;
>> -
>> -        /*
>> -         * Check for housekeeping conflict by passing the whole
>> -         * effective_xcpus as well as those CPUs that are to be
>> -         * removed from cs as delmask.
>> -         */
>> -        if (prs > 0)
>> -            cpumask_andnot(tmp->delmask, cs->effective_xcpus,
>> -                       trialcs->effective_xcpus);
>> -        else
>> -            cpumask_clear(tmp->delmask);
>> -
>> -        if (prstate_housekeeping_conflict(prs, parent_prs,
>> -                          trialcs->effective_xcpus, tmp->delmask))
>> -            prs_err = PERR_HKEEPING;
>> -    }
>> +    /*
>> +     * Check for housekeeping conflict by passing the whole
>> +     * effective_xcpus as well as those CPUs that are to be
>> +     * removed from cs as delmask.
>> +     */
>> +    if (is_partition_valid(cs))
>> +        cpumask_andnot(tmp->delmask, cs->effective_xcpus,
>> +                   trialcs->effective_xcpus);
>> +    else
>> +        cpumask_clear(tmp->delmask);
>> +    prs_err = validate_partition(cs, parent, trialcs->partition_root_state,
>> +                     trialcs->effective_xcpus, tmp->delmask);
>>       if (prs_err) {
>>           WRITE_ONCE(cs->prs_err, prs_err);
>>           trialcs->prs_err = prs_err;
> 
> Again, this code change looks good to me. Similar to previous patch, it includes 
> both code restructuring and bug fixes.
> 
Hi Longman,

Thanks for the review. Yes, besides the restructuring, it fixes a false
PERR_NOCPUS error for remote partitions. The no CPU left for tasks check
in partition_cpus_change() is done against the cgroup parent, but the
CPUs of a remote partition come from top_cpuset, not from its parent.

It can be reproduced on a 4-CPU system:

	cd /sys/fs/cgroup
	echo +cpuset > cgroup.subtree_control
	mkdir P
	echo 2-3 > P/cpuset.cpus
	echo 2-3 > P/cpuset.cpus.exclusive
	echo +cpuset > P/cgroup.subtree_control
	mkdir P/C
	echo 2-3 > P/C/cpuset.cpus
	echo 2 > P/C/cpuset.cpus.exclusive
	echo root > P/C/cpuset.cpus.partition
	sleep 1000 &
	echo $! > P/cgroup.procs
	echo 2-3 > P/C/cpuset.cpus.exclusive
	cat P/C/cpuset.cpus.partition
	root invalid (Parent is not a partition root)

The effective_cpus of P is 3, a subset of the new exclusive CPUs 2-3 of
C, and P has a task, so the expansion is rejected. However, P is not a
partition root and does not give any CPU to C, and top_cpuset still has
CPUs 0-1 for the task. Enabling C directly with exclusive CPUs 2-3
succeeds, as remote_partition_enable() checks top_cpuset instead. With
this patch, the expansion succeeds too:

	cat P/C/cpuset.cpus.partition
	root

The issue has been there since remote partitions were introduced. I
reproduced it on commit 181c8e091aae as well, so I'd like to describe
it in the commit message and add

	Fixes: 181c8e091aae ("cgroup/cpuset: Introduce remote partition")

in the next version.

Does that look OK to you? Please let me know if you are referring to something else.

-- 
Best regards
Ridong

