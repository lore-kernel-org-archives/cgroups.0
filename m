Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D95838B123
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 18:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788460442; cv=none; b=j+1h+1CxDM8HKwrOoVKnEKnEr6GHGJS5ETsjChZ9dqnxZ/O4sDnoRz5PeblRuK9tprkwA3qceJNcjJ9BPBIDab4Pa86hLZi5HkHVQbU9LKdmVZX29pyZBXpdbPKkHzOtIaw5LpKFbaXFwFCWie48CwuOU/Qou3WEkDP4B7WPcfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788460442; c=relaxed/simple;
	bh=rYEDqSVs5KWsByB/gKaLKuCfCYtF38rGdj2qCxtEO8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HPX6ZXIUdnCYfjIfxnZDCQwHf6vALyn3cxpcRv23fXzeAv2mX3YdbT6rmga5SjwUgA/ByHWTKmDZt6TKX/WTZP5Oq6egiZiInVIoeJv+hZJ+iCcDd6bvXrm8pfpSnmm9q3D/B9JvoziESICZnRluRwyfpHff4PvVXYOzxhufFP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RJEZTtRa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RJEZTtRa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788460431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hAb38BLLkIQ7vd+VdRyAqRpps7HgXE5a0fJqzLwWo8Y=;
	b=RJEZTtRa+4kOcc7GNgA5Fv4xA/ZoYE2Pyk+R2U+rt+ymXNZmC0Q57th+9uzINGIXQRu7l4
	vp7wpaUczXUxRhCZfQqwonw56IJ06UvAvqZ61d9vpwRNPMKV+j+njLlrpSTj3+ySoHDlQw
	lxqVbJFY8u1XNjvfKE+ptEQ7s8PMS9c=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512-qUrUPf8xNrO1dNKaejVlUw-1; Thu,
 03 Sep 2026 14:33:47 -0400
X-MC-Unique: qUrUPf8xNrO1dNKaejVlUw-1
X-Mimecast-MFC-AGG-ID: qUrUPf8xNrO1dNKaejVlUw_1788460425
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0CFF185CE9B;
	Thu,  3 Sep 2026 18:33:44 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DBF4E1803A51;
	Thu,  3 Sep 2026 18:33:42 +0000 (UTC)
Message-ID: <5842edcd-9283-4a87-afc9-50e51962368e@redhat.com>
Date: Thu, 3 Sep 2026 14:33:41 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] cgroup/cpuset: Factor out child partition
 validation
To: Guopeng Zhang <guopeng.zhang@linux.dev>, cgroups@vger.kernel.org,
 ridong.chen@linux.dev
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260902102615.79189-1-guopeng.zhang@linux.dev>
 <20260902102615.79189-2-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260902102615.79189-2-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 9/2/26 6:26 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> compute_partition_effective_cpumask() checks whether each valid child
> partition remains covered by the parent exclusive CPU mask and whether it
> would consume all remaining CPUs of a populated parent.
>
> Factor these two checks into child_partition_error() so the same rules can
> be reused when evaluating a proposed parent configuration. This is a
> preparatory refactoring with no intended functional change.
>
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c | 38 +++++++++++++++++++++++++++++---------
>   1 file changed, 29 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 8f24171b6055..6994dc75d940 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2085,6 +2085,26 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   	return 0;
>   }
>   
> +/*
> + * Return the error that will invalidate a child partition under a proposed
> + * parent partition configuration.
> + */
> +static enum prs_errcode
> +child_partition_error(struct cpuset *child,
> +		      const struct cpumask *partition_cpus,
> +		      const struct cpumask *remaining_cpus,
> +		      bool parent_populated)
I think you should add some functional comments on what "partition_cpus" 
and "remaining_cpus" are supposed to be so that caller knows what to 
pass into this helper.
> +{
> +	if (!cpumask_subset(child->effective_xcpus, partition_cpus))
> +		return PERR_INVCPUS;
> +
> +	if (parent_populated &&
> +	    cpumask_subset(remaining_cpus, child->effective_xcpus))
> +		return PERR_NOCPUS;
> +
> +	return PERR_NONE;
> +}
> +
>   /**
>    * compute_partition_effective_cpumask - compute effective_cpus for partition
>    * @cs: partition root cpuset
> @@ -2121,6 +2141,8 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>   
>   	rcu_read_lock();
>   	cpuset_for_each_child(child, css, cs) {
> +		enum prs_errcode child_err;
> +
>   		if (!is_partition_valid(child))
>   			continue;
>   
> @@ -2129,15 +2151,13 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>   		 * partition root.
>   		 */
>   		WARN_ON_ONCE(is_remote_partition(child));
> -		WRITE_ONCE(child->prs_err, 0);
> -		if (!cpumask_subset(child->effective_xcpus,
> -				    cs->effective_xcpus))
> -			WRITE_ONCE(child->prs_err, PERR_INVCPUS);
> -		else if (populated &&
> -			 cpumask_subset(new_ecpus, child->effective_xcpus))
> -			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
> -
> -		if (child->prs_err) {
> +		WRITE_ONCE(child->prs_err, PERR_NONE);
> +		child_err = child_partition_error(child, cs->effective_xcpus,
> +						  new_ecpus, populated);
> +		if (child_err)
> +			WRITE_ONCE(child->prs_err, child_err);
> +

You can ignore the inital PERR_NONE write and always write the child_err 
value into child->prs_err.

Not big issue, just some nits.

Cheers,
Longman

> +		if (child_err) {
>   			int old_prs = child->partition_root_state;
>   
>   			/*

