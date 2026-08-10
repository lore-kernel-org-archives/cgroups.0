Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A4D4218B1
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 15:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786375358; cv=none; b=pxN9MPKC4zhSG9/o3KvqMB/CLwht/Xgzpk/mhMtZ+vfagDrt+jPhQw2cjeeP8G4YzCXyE4v2t5GICAmyiB/oy8c0ltKePm64kHFfKp0O/7f97Kg73l5QiKbMcp3Wu+Vl4i1rFkGCGRYbFUGAc+LfreyVB51f81a7uVh0SObC2H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786375358; c=relaxed/simple;
	bh=AG1KFLu0YUzF2vIe+16SM+HkyGUnzCWfuXjySfauVh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uPd7gZLHrCcPz9QYQg0VTH9FddZb667gpPa+arBU3LyjMTofsL3rYosexZR7OSS30DxmC9yHRhgEjGLJxGOT/bj/8yNKSzTP0IbXkuGn/My+FjvPNd5gwF/LZV+J3rQWPb1w6lAgZX8sojKYFM1KoF8XHU0/WZ4jCXBvH0NI9Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SndHAHfz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SndHAHfz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786375355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vgSqdkMdCbkHVG9RJzbG/SYod9z/UaBH5M3QLsrcI3E=;
	b=SndHAHfzDacK+IN+6w7ALnkuANFQh6nMHfezc2qOBK9WuX+JztaOdcSgH1ui+mEC7+zOCE
	pvRJYqaPolRgL1fHb39ktPXqFpdk/pa85zX1dHcdGeCk0P6i9q5I4P0pmhKzGUqakQsTwP
	nl/BEeXw9k+gFnAq/sdAxt8dMFQy0xk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-Bx6mxNntNS6txXWwv-MhnA-1; Mon,
 10 Aug 2026 11:22:31 -0400
X-MC-Unique: Bx6mxNntNS6txXWwv-MhnA-1
X-Mimecast-MFC-AGG-ID: Bx6mxNntNS6txXWwv-MhnA_1786375349
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D0B31800651;
	Mon, 10 Aug 2026 15:22:29 +0000 (UTC)
Received: from [10.22.80.220] (unknown [10.22.80.220])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9D4433001D38;
	Mon, 10 Aug 2026 15:22:26 +0000 (UTC)
Message-ID: <ae497c54-cc58-4524-b2a6-e92519ee22bb@redhat.com>
Date: Mon, 10 Aug 2026 11:22:25 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Use WRITE_ONCE() for shared prs_err
 updates
To: Guopeng Zhang <guopeng.zhang@linux.dev>, ridong.chen@linux.dev,
 cgroups@vger.kernel.org
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260810095559.77345-1-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260810095559.77345-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 8/10/26 5:55 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> cpuset_partition_show() reads cs->prs_err without cpuset_mutex using
> READ_ONCE(). The field is documented as not lock protected, but several
> updates to live cpusets still use plain stores.
>
> Convert the remaining prs_err stores on live cpusets to WRITE_ONCE().
>
> Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
> Assisted-by: LLM
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c | 24 +++++++++++++-----------
>   1 file changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 0a0fffb5673c..2f7faa795664 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1587,7 +1587,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>   	cpumask_copy(cs->effective_xcpus, tmp->new_cpus);
>   	spin_unlock_irq(&callback_lock);
>   	cpuset_force_rebuild();
> -	cs->prs_err = 0;
> +	WRITE_ONCE(cs->prs_err, 0);
>   
>   	/*
>   	 * Propagate changes in top_cpuset's effective_cpus down the hierarchy.
> @@ -1661,7 +1661,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>   	WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus));
>   
>   	if (cpumask_empty(excpus)) {
> -		cs->prs_err = PERR_CPUSEMPTY;
> +		WRITE_ONCE(cs->prs_err, PERR_CPUSEMPTY);
>   		goto invalidate;
>   	}
>   
> @@ -1676,13 +1676,13 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>   	if (adding) {
>   		WARN_ON_ONCE(cpumask_intersects(tmp->addmask, subpartitions_cpus));
>   		if (!capable(CAP_SYS_ADMIN))
> -			cs->prs_err = PERR_ACCESS;
> +			WRITE_ONCE(cs->prs_err, PERR_ACCESS);
>   		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
>   			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
> -			cs->prs_err = PERR_NOCPUS;
> +			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
>   		else if ((prs == PRS_ISOLATED) &&
>   			 !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
> -			cs->prs_err = PERR_HKEEPING;
> +			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
>   		if (cs->prs_err)
>   			goto invalidate;
>   	}
> @@ -2110,13 +2110,13 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>   		 * partition root.
>   		 */
>   		WARN_ON_ONCE(is_remote_partition(child));
> -		child->prs_err = 0;
> +		WRITE_ONCE(child->prs_err, 0);
>   		if (!cpumask_subset(child->effective_xcpus,
>   				    cs->effective_xcpus))
> -			child->prs_err = PERR_INVCPUS;
> +			WRITE_ONCE(child->prs_err, PERR_INVCPUS);
>   		else if (populated &&
>   			 cpumask_subset(new_ecpus, child->effective_xcpus))
> -			child->prs_err = PERR_NOCPUS;
> +			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
>   
>   		if (child->prs_err) {
>   			int old_prs = child->partition_root_state;
> @@ -2420,8 +2420,10 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
>   		return;
>   
>   	prs_err = validate_partition(cs, trialcs);
> -	if (prs_err)
> -		trialcs->prs_err = cs->prs_err = prs_err;
> +	if (prs_err) {
> +		WRITE_ONCE(cs->prs_err, prs_err);
> +		trialcs->prs_err = prs_err;
> +	}
>   
>   	if (is_remote_partition(cs)) {
>   		if (trialcs->prs_err)
> @@ -3944,7 +3946,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   	if (remote && (cpumask_empty(subpartitions_cpus) ||
>   			(cpumask_empty(&new_cpus) &&
>   			 partition_is_populated(cs, NULL)))) {
> -		cs->prs_err = PERR_HOTPLUG;
> +		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
>   		remote_partition_disable(cs, tmp);
>   		compute_effective_cpumask(&new_cpus, cs, parent);
>   		remote = false;

LGTM

Reviewed-by: Waiman Long <longman@redhat.com>

