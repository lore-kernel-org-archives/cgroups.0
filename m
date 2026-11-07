Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023969;
	b=HTiegCSh0OjLvRPDainihirXIezDa7RArpobGZic5edc8dV20EVavXacEyJOvg5oYksx
	 hdRoG76ky/OAwO1GPEYd3t0glFMH2iZYjHuzEbo636Bt7/zU5MDJ/r7EVFQ+OFRxYMKGP
	 TTJo9jwdxWavAbU42yMqjz+IM1bFs5UUtpCxn6cUCqlPyBt/0Fdvq8eaDC4ingzKMtjxJ
	 RHgeNonGLzVjFnFc9uh2a/L0Jy37zsIu3RCOyEHRfRQFLAwJlXrY9HARbCYSKBV0mLp6G
	 /YzAYUUF+pQi2ZuhtgF9Y0PYqWeH8Mkn/7ODl5rUT7pYSLuJTe+xNUiwcnfdH/TNKdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023969;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=EAEthflt2t20HJ71ADyhC30eFYFr66TlnXqMxdpZXW0=;
	b=ariaeIcI9MO7k00Fi+a4sC7CkZhDcEsb6mnmfKwlpjU3GprlceziYPWRsP2nQB4KwLlF
	 96dwDEKz37NQUDN0bqx9BngPQ+i5mMnIZQY/KeKqHxEAMEd4vuGuUIjzha2uB1IozSZR9
	 b7/UOtuzyE9A6FoQb6E5NJybVuC/pSf5uEN+d0Bmli20KHSNDGm/I4OO7ZcF4KHZptM0+
	 c9HiMpOIxdatTPhTvTZS343q5+lsv/S7ofmxB67exKBv6/UI3Bh9TC1CiGabYPcRI6GWx
	 XKTGoaOw1F26JUfVXOGo5hSVarwHQjp3kCJEx8kLa3nzyHUnv4X5/rMKn7RetyISUOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HS5LrA+j;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63102606A32D
	for <cgroups@vger.kernel.org>; Sat,  7 Nov 2026 03:59:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63102606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HS5LrA+j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794023967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EAEthflt2t20HJ71ADyhC30eFYFr66TlnXqMxdpZXW0=;
	b=HS5LrA+j9AnGdEEI6Nt8Jfl1tRwnTpiLvwNu63qt7YkG5GAfKdiuKWplnDR0nmz33Masm1
	/jmElYIYc9jjm3T3CJzyRiS02MY2GFVsEipOK7cdnEO9NP2luabBglBtGSHAC3ddrl4hHg
	bRn8kyXhMKJaWAU1JHDZOqIEGtdQIcI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-306-s6_bW1-nNaeNeuLWb7gmmA-1; Fri,
 06 Nov 2026 22:59:21 -0500
X-MC-Unique: s6_bW1-nNaeNeuLWb7gmmA-1
X-Mimecast-MFC-AGG-ID: s6_bW1-nNaeNeuLWb7gmmA_1794023958
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7913219560AD;
	Sat,  7 Nov 2026 03:59:17 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B83861800446;
	Sat,  7 Nov 2026 03:59:14 +0000 (UTC)
Message-ID: <04c50e9b-954f-4869-a9bd-41b9341bdef8@redhat.com>
Date: Fri, 6 Nov 2026 22:59:13 -0500
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
Subject: Re: [PATCH v2 4/4] cpuset: generalize the validate_partition()
 interface
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Chen Ridong <chenridong@huawei.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261106105538.2915492-1-ridong.chen@linux.dev>
 <20261106105538.2915492-5-ridong.chen@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261106105538.2915492-5-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 11/6/26 5:55 AM, Ridong Chen wrote:
> From: Chen Ridong <chenridong@huawei.com>
>
> Refactor validate_partition() to take the parent partition, the new
> partition root state, the new effective exclusive CPUs and the CPUs to
> be deleted, instead of a trial cpuset. A NULL parent stands for a
> remote partition, whose CPUs come from top_cpuset. This makes the
> interface flexible enough to handle both local and remote partition
> validation.
>
> The housekeeping conflict check is folded into validate_partition(). It
> is skipped when the parent is not a valid partition root, as @cs can't
> be a valid local partition in that case.
>
> Use the new interface for local partition enablement in
> update_parent_effective_cpumask() and in partition_cpus_change(),
> replacing the open-coded checks there. The order of the checks is now
> the same for both paths: empty CPUs, housekeeping conflict, then no CPU
> left for tasks.
>
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   kernel/cgroup/cpuset.c | 112 +++++++++++++++++++----------------------
>   1 file changed, 52 insertions(+), 60 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index a5ab9396eb61..1b0ac4e76ec7 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1434,6 +1434,41 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
>   	return res;
>   }
>   
> +/**
> + * validate_partition - Validate a cpuset partition configuration
> + * @cs: The cpuset to validate
> + * @parent: Parent partition of @cs, NULL for remote partition
> + * @new_prs: The proposed new partition root state
> + * @new_excpus: The new effective exclusive CPUs mask to validate
> + * @del: exclusive CPUs to be deleted from @cs, can be NULL
> + *
> + * The housekeeping check is skipped if @parent is not a valid partition
> + * root as @cs can't be a valid local partition in that case.
> + *
> + * Return: PRS error code (0 if valid, non-zero error code if invalid)
> + */
> +static enum prs_errcode validate_partition(struct cpuset *cs,
> +		struct cpuset *parent, int new_prs,
> +		struct cpumask *new_excpus, struct cpumask *del)
> +{
> +	int parent_prs = parent ? parent->partition_root_state : PRS_ROOT;
> +
> +	if (new_prs == PRS_MEMBER)
> +		return PERR_NONE;
> +
> +	if (cpumask_empty(new_excpus))
> +		return PERR_INVCPUS;
> +
> +	if ((parent_prs > 0) &&
> +	    prstate_housekeeping_conflict(new_prs, parent_prs, new_excpus, del))
> +		return PERR_HKEEPING;
> +
> +	if (tasks_nocpu_error(parent_cs(cs), cs, new_excpus))
> +		return PERR_NOCPUS;

For remote partition, the parent should be top_cpuset. I think we should 
set parent to top_cpuset if NULL and pass it directly to 
tasks_nocpu_error().

Other than that, the rests look good to me.

Cheers,
Longman

> +
> +	return PERR_NONE;
> +}
> +
>   /*
>    * cpuset_update_sd_hk_unlock - Rebuild sched domains, update HK & unlock
>    *
> @@ -1954,18 +1989,10 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   	if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
>   		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
>   
> -		/*
> -		 * Enabling partition root is not allowed if its
> -		 * effective_xcpus is empty.
> -		 */
> -		if (cpumask_empty(tmp->delmask))
> -			return PERR_INVCPUS;
> -
> -		if (prstate_housekeeping_conflict(new_prs, parent_prs, tmp->delmask, NULL))
> -			return PERR_HKEEPING;
> -
> -		if (nocpu)
> -			return PERR_NOCPUS;
> +		part_error = validate_partition(cs, parent, new_prs,
> +						tmp->delmask, NULL);
> +		if (part_error)
> +			return part_error;
>   
>   		/*
>   		 * This function will only be called when all the preliminary
> @@ -2444,32 +2471,6 @@ static int parse_cpuset_cpulist(const char *buf, struct cpumask *out_mask)
>   	return 0;
>   }
>   
> -/**
> - * validate_partition - Validate a cpuset partition configuration
> - * @cs: The cpuset to validate
> - * @trialcs: The trial cpuset containing proposed configuration changes
> - *
> - * If any validation check fails, the appropriate error code is set in the
> - * cpuset's prs_err field.
> - *
> - * Return: PRS error code (0 if valid, non-zero error code if invalid)
> - */
> -static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *trialcs)
> -{
> -	struct cpuset *parent = parent_cs(cs);
> -
> -	if (cs_is_member(trialcs))
> -		return PERR_NONE;
> -
> -	if (cpumask_empty(trialcs->effective_xcpus))
> -		return PERR_INVCPUS;
> -
> -	if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus))
> -		return PERR_NOCPUS;
> -
> -	return PERR_NONE;
> -}
> -
>   /**
>    * partition_cpus_change - Handle partition state changes due to CPU mask updates
>    * @cs: The target cpuset being modified
> @@ -2483,33 +2484,24 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
>   				  struct tmpmasks *tmp)
>   {
>   	enum prs_errcode prs_err;
> -	int parent_prs = is_remote_partition(cs)
> -		       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
> +	struct cpuset *parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
>   
>   	if (cs_is_member(cs))
>   		return;
>   
> -	prs_err = validate_partition(cs, trialcs);
> -	if (!prs_err && (parent_prs > 0) &&
> -	    !cpumask_empty(trialcs->effective_xcpus)) {
> -		int prs = cs->partition_root_state;
> -
> -		/*
> -		 * Check for housekeeping conflict by passing the whole
> -		 * effective_xcpus as well as those CPUs that are to be
> -		 * removed from cs as delmask.
> -		 */
> -		if (prs > 0)
> -			cpumask_andnot(tmp->delmask, cs->effective_xcpus,
> -				       trialcs->effective_xcpus);
> -		else
> -			cpumask_clear(tmp->delmask);
> -
> -		if (prstate_housekeeping_conflict(prs, parent_prs,
> -						  trialcs->effective_xcpus, tmp->delmask))
> -			prs_err = PERR_HKEEPING;
> -	}
> +	/*
> +	 * Check for housekeeping conflict by passing the whole
> +	 * effective_xcpus as well as those CPUs that are to be
> +	 * removed from cs as delmask.
> +	 */
> +	if (is_partition_valid(cs))
> +		cpumask_andnot(tmp->delmask, cs->effective_xcpus,
> +			       trialcs->effective_xcpus);
> +	else
> +		cpumask_clear(tmp->delmask);
>   
> +	prs_err = validate_partition(cs, parent, trialcs->partition_root_state,
> +				     trialcs->effective_xcpus, tmp->delmask);
>   	if (prs_err) {
>   		WRITE_ONCE(cs->prs_err, prs_err);
>   		trialcs->prs_err = prs_err;

