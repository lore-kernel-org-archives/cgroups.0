Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F393845B0
	for <cgroups@vger.kernel.org>; Wed, 13 May 2026 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778684593; cv=none; b=USgz2UxPtZ1xVcTzfGGW25PXVBkuRp5f45RNWE9IoVRUmSFjdXGsbVMPQ1YOQ4CzuBh6R0x/mBo0g9oorjb2JM5u6tGPaTm5tSRm5GjB9zJSqBeX6oax0RBLrMXymGLGnnFNP2JAUMuelUV1fRTC5+Su/kwxJ/3WwOpcuZPqGxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778684593; c=relaxed/simple;
	bh=rA4hz6NqsZGRvQlVfW+7tNAC36iTHQXv6lbllRA3cT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NHCES8kuLg3+C67AGRZxbhnJTBfXE+kPMMaM6FtRlZp1Y6M/9wNXpP3hNyHL7mWqHTEdIYm3YL1oGLBJkeoIx8cE1Y2xYaG4fTlOagVVsnTmJuV1Kaerbe9JcQfX87/8NSRgw9SSbr7Uxyhacw9b7hrhGmVUmLJGtn713cKPmtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GimnFuVa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GimnFuVa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778684591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PjC2ai7+A27XPHo7DI+ICIj6oHotLvV9af2iaGp5xE8=;
	b=GimnFuVaQH+PDe/+GbdCCl6vixQJCuZ8mk+bhpBLBnMQ+M4i3ee8pH6l2agSEOv/x7g+QU
	GeCf5M9gA/iArDz58g8jFbseC9XIny3u2ul/AFTjH1v9vNMxkhdUfk42Yl1VRIjkslY4Ea
	dw5cubytT4b4vs+czPGAFTCCg9fwcNM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-x4xgXha6N6OrLW8ir5eQbQ-1; Wed,
 13 May 2026 11:03:07 -0400
X-MC-Unique: x4xgXha6N6OrLW8ir5eQbQ-1
X-Mimecast-MFC-AGG-ID: x4xgXha6N6OrLW8ir5eQbQ_1778684583
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E1F44195605F;
	Wed, 13 May 2026 15:03:01 +0000 (UTC)
Received: from [10.2.17.34] (unknown [10.2.17.34])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 07F871800465;
	Wed, 13 May 2026 15:02:59 +0000 (UTC)
Message-ID: <8325838a-0e30-43d6-a04c-1ecdf42867cb@redhat.com>
Date: Wed, 13 May 2026 11:02:58 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: Return only actually allocated CPUs
 during partition invalidation
To: Sun Shaojie <sunshaojie@kylinos.cn>,
 Chen Ridong <chenridong@huaweicloud.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260513103738.442779-1-sunshaojie@kylinos.cn>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260513103738.442779-1-sunshaojie@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 5/13/26 6:37 AM, Sun Shaojie wrote:
> From: sunshaojie <sunshaojie@kylinos.cn>
>
> In update_parent_effective_cpumask() with partcmd_invalidate, the CPUs
> to return to the parent are computed as:
>
>      adding = cpumask_and(tmp->addmask, xcpus, parent->effective_xcpus);
>
> where xcpus = user_xcpus(cs) which returns cs->exclusive_cpus (if set)
> or cs->cpus_allowed. When exclusive_cpus is not set, user_xcpus(cs) can
> contain CPUs that were never actually granted to the partition due to
> sibling exclusion in compute_excpus(). Consequently, the invalidation
> may return CPUs to the parent that remain in use by sibling partitions,
> causing overlapping effective_cpus and triggering the
> WARN_ON_ONCE(1) in generate_sched_domains().
>
> Use cs->effective_xcpus instead, which reflects the CPUs actually
> granted to this partition.
>
> Reproducer (on a 4-CPU machine):
>
>      cd /sys/fs/cgroup
>      mkdir a1 b1
>
>      # a1 becomes partition root with CPUs 0-1
>      echo "0-1" > a1/cpuset.cpus
>      echo "root" > a1/cpuset.cpus.partition
>
>      # b1 becomes partition root with CPUs 1-2, but sibling exclusion
>      # reduces its effective_xcpus to CPU 2 only
>      echo "1-2" > b1/cpuset.cpus
>      echo "root" > b1/cpuset.cpus.partition
>
>      # b1 changes cpus_allowed to 0-1 -> partition invalidation
>      echo "0-1" > b1/cpuset.cpus
>
>      # Expected: CPUs 2-3  (only CPU 2 returned from b1)
>      # Actual:   CPUs 1-3  (CPU 0-1 returned, overlapping with a1)
>      cat cpuset.cpus.effective
>
> dmesg will also show a WARNING from generate_sched_domains() reporting
> overlapping partition root effective_cpus.
>
> Fixes: 2a3602030d80 ("cgroup/cpuset: Don't invalidate sibling partitions on cpuset.cpus conflict")
> Signed-off-by: sunshaojie <sunshaojie@kylinos.cn>
> Test-by: Chen Ridong <chenridong@huaweicloud.com>
> Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
>
> ---
> Changes in v2:
> - Updated Fixes tag per review by Chen Ridong
> ---
>   kernel/cgroup/cpuset.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 1335e437098e..2311470ef077 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1715,7 +1715,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   		 */
>   		if (is_partition_valid(parent))
>   			adding = cpumask_and(tmp->addmask,
> -					     xcpus, parent->effective_xcpus);
> +					     cs->effective_xcpus,
> +					     parent->effective_xcpus);
>   		if (old_prs > 0)
>   			new_prs = -old_prs;
>   

Thanks for catching this bug.

Reviewed-by: Waiman Long <longman@redhat.com>

