Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A232743B3EF
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 14:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581475; cv=none; b=GWWGJsccon409pDzk569Z113jK3VtEAL2z/GUlXMBM3Anoi5+lq5RXKBgjw+58KmVlJQBpa9FNF82lXYwKZugbsoFMNPRxSk9GwEkLdZdI4UvfLD4roVIQh6l2URvVOPSWSG9k5WUx6/0Bakvg9Ky785RmAqJg0n6RzxotqlkEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581475; c=relaxed/simple;
	bh=TX3Z7I2p7NV3LmYclbuENrvarTcwjRfgJFZ2aJsDwPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=el0UHxw6NGyIQ0afyJNeTMxOZh0XGJArSfgXvMe8Yioo/lMI6RmmgkIJ54zydJqtsRqymy7+smoZ5NASqkoxJK0VN7RxCZtyZVfUzIdOx7lHC6bQJhlfCrjSqbivIsogWdT/nuKFZwCduvfHjPLyu+w7hYNg8tXOdcuaz7HZYDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HDTZZyQa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HDTZZyQa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787581472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MbAPYpkEoXBSzyw3HojdW/4tYJX+OVrYIn3bLjLrhRw=;
	b=HDTZZyQa6Jaq4kNqEd5FPkUCxTDCcqrQlkQMBCbuVHuf/H7OQNypNBXVG0+zqE3l7SzGQH
	Gg0dpk4v55zXjt5xvTS7U0CdgA2NXGPXYyW7I8kyijDyF7Aq9LnVVXeJQo04Mk14LRRPLd
	gYwW6Lt6fcw/BgyxTW1mwXzfPQdVpsg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-375-23tL376nNnubWsFzcz8Iog-1; Mon,
 24 Aug 2026 10:24:26 -0400
X-MC-Unique: 23tL376nNnubWsFzcz8Iog-1
X-Mimecast-MFC-AGG-ID: 23tL376nNnubWsFzcz8Iog_1787581460
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03EDA18601F1;
	Mon, 24 Aug 2026 14:24:20 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1621830002EA;
	Mon, 24 Aug 2026 14:24:17 +0000 (UTC)
Message-ID: <e31d80e4-321e-4259-ba0b-392705a8fad8@redhat.com>
Date: Mon, 24 Aug 2026 10:24:17 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/17] cgroup/cpuset: Limit type-change accounting to
 owned CPUs
To: Guopeng Zhang <guopeng.zhang@linux.dev>, cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
 <20260820124202.517160-5-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260820124202.517160-5-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 8/20/26 8:41 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> effective_xcpus includes CPUs granted to valid child partitions. Passing
> the whole mask to isolated_cpus_update() during a root-to-isolated or
> isolated-to-root change applies the parent's new state to child-owned
> CPUs as well.
>
> Build a mask of CPUs owned by the partition by subtracting the
> effective_xcpus of valid children. Use this mask when updating
> isolated_cpus for a partition type change.
>
> Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c | 30 ++++++++++++++++++++++++++++--
>   1 file changed, 28 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 2538faac9aba..468272baadb2 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2155,6 +2155,30 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>   	rcu_read_unlock();
>   }
>   
> +/*
> + * Compute CPUs owned directly by a partition.
> + *
> + * effective_xcpus includes CPUs granted to valid child partitions. Exclude
> + * those CPUs when changing only this partition's type.
> + */
> +static void compute_partition_owned_cpumask(struct cpuset *cs,
> +					    struct cpumask *owned_cpus)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct cpuset *child;
> +
> +	lockdep_assert_held(&cpuset_mutex);
> +	cpumask_copy(owned_cpus, cs->effective_xcpus);
> +
> +	rcu_read_lock();
> +	cpuset_for_each_child(child, css, cs) {
> +		if (is_partition_valid(child))
> +			cpumask_andnot(owned_cpus, owned_cpus,
> +				       child->effective_xcpus);
> +	}
> +	rcu_read_unlock();
> +}
> +
>   /*
>    * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
>    * @cs:  the cpuset to consider
> @@ -2990,8 +3014,10 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>   	} else if (old_prs && new_prs) {
>   		/*
>   		 * A change in load balance state only, no change in cpumasks.
> -		 * Need to update isolated_cpus.
> +		 * Need to update isolated_cpus for CPUs owned by this partition,
> +		 * excluding CPUs distributed to valid child partitions.
>   		 */
> +		compute_partition_owned_cpumask(cs, tmpmask.new_cpus);
>   		if (((new_prs == PRS_ISOLATED) &&
>   		     !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
>   		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
> @@ -3030,7 +3056,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>   	if (!is_partition_valid(cs))
>   		reset_partition_data(cs);
>   	else if (isolcpus_updated)
> -		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
> +		isolated_cpus_update(old_prs, new_prs, tmpmask.new_cpus);
>   	spin_unlock_irq(&callback_lock);
>   
>   	/* Force update if switching back to member & update effective_xcpus */

Your use of tmpmask.new_cpus in isolated_cpus_update() can be 
problematic. isolcpus_updated can be set when an isolated partition is 
enabled or disabled. In both cases, tmpmask.new_cpus can be used 
temporarily. So the content of this temporary cpumask may not be what we 
want to pass into isolated_cpus_update(). I will suggest you only use 
tmpmask.new_cpus if it is determined to be coming from partition state 
transition instead of enabling/disabling of partition.

Cheers,
Longman

