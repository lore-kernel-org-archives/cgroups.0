Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794235988;
	b=yl97NKgDKPM7pSEjLKn5FU0Or/dFizzMRpmP/ZAO+zyDyriYPEkP2eJoDT8KpoeydOfH
	 7WHxWEIPU348DhVNMc1WES349hLeR70VvovlHg7n/SO2V0082TPC964r7tsw7TzED0NR1
	 C5MIsdhY97MeazvZNM924Na+RsTg73tfbZccE2cxiQW4vfNVNcxYAD+o/D+C0KoYgsF56
	 ZIBEH79P/TJuCh2ZtBmcOhxCzftqU4h63Mjbl3ysbCtpPy8vAlrXB5x3gR3wXM2gBZcDv
	 6Fibk4t9ks0SbGGQepz1u/ZZHowVtTHe5yICBBmu7AUENGHouoRNqPeL9Xp8Odkg64g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794235988;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=+3ccHp+dxclpMhI+JAx+vBwHB1pqGCZbz+PjeLxKEeI=;
	b=oz4CnJ1N2Zm08fVLMInsduK6AI/RO3rN3TrwvgXD1w1UMqkzGJLFsyr/MYxE/b5P8jwP
	 5lZ3sHsbBqXSSrog1lzSA0A5hKU8oeTbwPxQhnY/7JFNIWSG9Wpe5rJ+BHRBLJJJxEzYm
	 fcGldBmFmemYOH07JM2A1l1cZi1GvEaUkc8fmc9bsq/0daMEJIdFDEy0ECNmr/6pfFPt1
	 SJYhOXMuvAQ/SlG9nPlfR+BtO1xqpmaw8m+PQ/NsllghNBpdH+e4H4QjTu1ZFrVK1QSKX
	 kP8R8ddh3ZvC2rK8p3rAdggFbBQBC5e8rWKfhhZGJx9l/xl6M3r+VNoTFICaBP/FzTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CToexEbx;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937A3606A323
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 14:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 937A3606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CToexEbx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794235986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+3ccHp+dxclpMhI+JAx+vBwHB1pqGCZbz+PjeLxKEeI=;
	b=CToexEbxgWX0upaRN+6dHTSze70VmNGim6wSSfI6Hc9eeW2T3tcpci36KgK9Hn3ylS9qCI
	SxIHRM+mpD1B2yExXnhPRXb9msWjROlBqv0dQ0QmJoYCZNLzXz7lm0gc1A2CR6IgtrzJK+
	W0B3XNIfzUL4GZPP9DC+8mYE7oBmntM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-158-dE37GRRrPZWD6X8PdWHeeQ-1; Mon,
 09 Nov 2026 09:53:03 -0500
X-MC-Unique: dE37GRRrPZWD6X8PdWHeeQ-1
X-Mimecast-MFC-AGG-ID: dE37GRRrPZWD6X8PdWHeeQ_1794235981
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 762FA19560A7;
	Mon,  9 Nov 2026 14:53:00 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 06EB718004F5;
	Mon,  9 Nov 2026 14:52:57 +0000 (UTC)
Message-ID: <d37903cd-21bc-4a07-835f-aa074c85660c@redhat.com>
Date: Mon, 9 Nov 2026 09:52:57 -0500
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
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Chen Ridong <chenridong@huawei.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261107120100.3587595-1-ridong.chen@linux.dev>
 <20261107120100.3587595-5-ridong.chen@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261107120100.3587595-5-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 11/7/26 7:01 AM, Ridong Chen wrote:
> From: Chen Ridong <chenridong@huawei.com>
>
> Refactor validate_partition() to take the parent partition, the new
> partition root state, the new effective exclusive CPUs and the CPUs to
> be deleted, instead of a trial cpuset. A NULL parent stands for a
> remote partition, whose CPUs come from top_cpuset. This makes the
> interface flexible enough to handle both local and remote partition
> validation.
>
> The no CPU left for tasks check now uses the given parent instead of
> parent_cs(cs), and top_cpuset for a remote partition, as that is where
> its CPUs are taken from. The cgroup parent of a remote partition does
> not give it any CPU.
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
>   kernel/cgroup/cpuset.c | 119 ++++++++++++++++++++---------------------
>   1 file changed, 59 insertions(+), 60 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index fc9de6e16ff5..0ec20412b3ce 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1414,6 +1414,48 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
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
> + * A remote partition gets its CPUs from top_cpuset, so top_cpuset is used
> + * as the parent when @parent is NULL.
> + *
> + * The housekeeping check is skipped if @parent is not a valid partition
> + * root as @cs can't be a valid local partition in that case.
> + *
> + * Return: PRS error code (0 if valid, non-zero error code if invalid)
> + */
> +static enum prs_errcode validate_partition(struct cpuset *cs,
> +					   struct cpuset *parent, int new_prs,
> +					   struct cpumask *new_excpus,
> +					   struct cpumask *del)
> +{
> +	int parent_prs;
> +
> +	if (new_prs == PRS_MEMBER)
> +		return PERR_NONE;
> +
> +	if (cpumask_empty(new_excpus))
> +		return PERR_INVCPUS;
> +
> +	if (!parent)
> +		parent = &top_cpuset;
> +	parent_prs = parent->partition_root_state;
> +	if (parent_prs > 0 &&
> +	    prstate_housekeeping_conflict(new_prs, parent_prs, new_excpus, del))
> +		return PERR_HKEEPING;
> +
> +	if (tasks_nocpu_error(parent, cs, new_excpus))
> +		return PERR_NOCPUS;
> +
> +	return PERR_NONE;
> +}
> +
>   /*
>    * cpuset_update_sd_hk_unlock - Rebuild sched domains, update HK & unlock
>    *
> @@ -1934,18 +1976,10 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
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
> @@ -2424,32 +2458,6 @@ static int parse_cpuset_cpulist(const char *buf, struct cpumask *out_mask)
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
> @@ -2463,33 +2471,24 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
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

Again, this code change looks good to me. Similar to previous patch, it 
includes both code restructuring and bug fixes.

Cheers,
Longman

