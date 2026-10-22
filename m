Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639730;
	b=r2mo7ys8ixRLIoG+PEewxBGMGz4DU24XSR1qgiVReEpL+yJGW+g99AcoJ4TClcioErEP
	 /Mv7CfRDBd/QEftU3AB5075cRxyzESg7/+G4K1K/PD9GdfRHr0rMAXk/wg3kHc8sH0DXD
	 ihi7eASi/8IHJWZx1hvpQGVUcdRzHG9Gwklg38V/eExV4T9C6NaBQug07hX5ovYZ0DaoU
	 Gac4HWGjI1z4g4Bn9TXqulK8xh/ESF82DHsbg6EJ6yE9mLifkfgy/tSyiEKwcM1KfsXbC
	 lL7sbEs6pI6wHHocnTkOc30BHkxjJ7pfHuplAmxKlczPpGUMMeyUpNCjadFVRsRTmGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639730;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=H9Ve5B68zo65xRBzqtn6eQljA3wNJlzrcASRUfTZKOU=;
	b=BTyXduxlaYYgruF6xo7ESYibzEJRhtWYHoRULfAZYlr6zIy0j+ITrz2WRpsM6jogEeey
	 Gy4DFn6YXY5m+G66ijykhRtpinrzyx02bQaVx8NVVOCeU7vgxqgQnph8HdMdN7io/fZWU
	 CyDRz411XSO5QHcXcUhBNkzZUcf0vo9MD963UqHRwWxMgAXZCySRmYS2IQE2estwhqTb8
	 9akZhi1jsyw88bSgCN4JKjfvX9RTtPVdGBEpgsUbxKOXNSuY3aW/FZd40d7X7S2Uo9ghq
	 yU/eVII7EUa2ZG1Y86hj9BHCp3gSQHEmC/e1Eway1fk5vwsiGyGiaLf+F+2dG86DZWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EwQzcxS+;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E85606A31A
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 03:28:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3E85606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EwQzcxS+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792639728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H9Ve5B68zo65xRBzqtn6eQljA3wNJlzrcASRUfTZKOU=;
	b=EwQzcxS+KKhvHzOGt+pBNV61huHo3CtcwXVfDatkFvYY2BdhI+kLqMln0XZf1uEdzRO8uq
	x1pvK4d41t7x3F7DBMUVcVIKa/KPk112mQGgnD4RsnHCBa2cLdq4C5CXWHbV4eXrWD9RCV
	HgI7KZAtxh4tOkkbJibxQXUl6hR39Fs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-b0Gc_evRPBiA7SXomRtCHQ-1; Thu,
 22 Oct 2026 03:28:46 +0000
X-MC-Unique: b0Gc_evRPBiA7SXomRtCHQ-1
X-Mimecast-MFC-AGG-ID: b0Gc_evRPBiA7SXomRtCHQ_1792639724
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E36661955F10;
	Thu, 22 Oct 2026 03:28:43 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8B9D51956087;
	Thu, 22 Oct 2026 03:28:41 +0000 (UTC)
Message-ID: <16db5b91-677e-47ec-b1de-760111b99d23@redhat.com>
Date: Wed, 21 Oct 2026 23:28:40 -0400
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
Subject: Re: [PATCH 2/2] cgroup/cpuset: Fix invalid local partition recovery
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
 Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261010075947.333549-1-guopeng.zhang@linux.dev>
 <20261010075947.333549-3-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261010075947.333549-3-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 10/10/26 3:59 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> An invalid local partition may fail to recover after its exclusive CPU
> list is changed to a valid one.
>
> This can be reproduced on a cgroup v2 system with CPUs 0-7 online:
>
>      cd /sys/fs/cgroup
>      echo +cpuset > cgroup.subtree_control
>      mkdir A
>      echo 0-7 > A/cpuset.cpus
>      echo 0-7 > A/cpuset.cpus.exclusive
>      echo root > A/cpuset.cpus.partition
>      cat A/cpuset.cpus.partition
>      echo 1 > A/cpuset.cpus.exclusive
>      cat A/cpuset.cpus.partition
>
> The first read reports root invalid because all CPUs were requested.
> After the mask is changed to CPU 1, the partition should become valid,
> but it remains invalid with PERR_NOCPUS.
>
> update_exclusive_cpumask() calls partition_cpus_change() before updating
> cs->exclusive_cpus. update_parent_effective_cpumask() then gets the
> old 0-7 mask from user_xcpus() and sets PERR_NOCPUS even though the new
> mask leaves CPUs for the parent.
>
> Move the exclusive_cpus update before partition_cpus_change() so that
> the partition update sees the new mask.
>
> Fixes: 46c521bac592 ("cgroup/cpuset: Enable invalid to valid local partition transition")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index de7553459adc..e96bc66ffa07 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2546,10 +2546,14 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>   		return -ENOMEM;
>   
>   	trialcs->prs_err = PERR_NONE;
> -	partition_cpus_change(cs, trialcs, &tmp);
>   
>   	spin_lock_irq(&callback_lock);
>   	cpumask_copy(cs->exclusive_cpus, trialcs->exclusive_cpus);
> +	spin_unlock_irq(&callback_lock);
> +
> +	partition_cpus_change(cs, trialcs, &tmp);
> +
> +	spin_lock_irq(&callback_lock);
>   	cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
>   	if ((old_prs > 0) && !is_partition_valid(cs))
>   		reset_partition_data(cs);

With the patch series that I have just sent out, I can't reproduce this 
problem. My patch 2 of the series change 
update_parent_effective_cpumask() to not use user_xcpus() anymore. So 
that should fix the problem.

Cheers, Longman

