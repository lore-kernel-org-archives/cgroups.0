Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201419;
	b=IfqRMzLV6ejWEwgg71EaBt9LojJ0zAO85x8j4eTvDpSrbNFf+I0wuugNTXNFOEiU1zpa
	 hBlQYHWY3sLuat1l8QR/7BDHS4zI3PsOpGUtyhGGBRZy6pja91HlWI5Swi1rMpkXOG36q
	 BdsAoSgXOrD/6PjRTAFLjPnQJ0sSy2/UeeNEpq3ITGHICNa9BxO4kZtM2VXgAQfxBOr/A
	 ZkyIHqDhPkq2OkHrekm34CYf39ZtpTIbMV5FV8osWT8P9QDUK+9s7e1vKFxUzcIIwU1sp
	 rKzYi2eE9Qit+QOgnBrDVBnxq4DYglgDvvFKDcjdhQu+SwmVK2Aj2GslYpDAkJTAhEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201419;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=MAQTWY4H9RB4ZcqFVf3zxH8rThYlbf1S7+Z6KzC6prk=;
	b=cec16rwrmtkHaud6/qawaAEM0Xvk3KETQFscdeGhBOaegLhZKkK7WSUh3U39hd2xNCEj
	 0Zb0HwY811ywA2SXP4ORh+JfX10tYzAYwY9kyqR88nJrm/j9NIhks1N1GviE+OtyTZRIO
	 YVADWpfhZg8WDWeMsJe7a+LEIray7ii/f1V/QLndP208S7bW7pAJz3gxI7tSf669PACdb
	 rtGNhVlFpuEXaepD3XrW133l2/zQO3LVSalGBL4avJBcqAcBC01xnLEgiEVQaNHMkaW+p
	 yz2ow2znWvXveaFBmVEXSnLJEYArjMzaZ2DoW6MSGuRGXkiLktipPxFq4qBNJz2PK0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MdNOrfeN;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46705606A31F
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 15:30:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46705606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MdNOrfeN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793201418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MAQTWY4H9RB4ZcqFVf3zxH8rThYlbf1S7+Z6KzC6prk=;
	b=MdNOrfeN7HfMlM90JWe4339IBZEoTf6XsPii2G7y6bQU6+NrR9nlbnDVv1tRvRyOr0ZPOH
	oRrNr5AZ9Rg5RVb247ixgr3i5qcoyh8GURF4kAmT8MWq9qpxRktWuovYPeknFjTGtlzTZY
	aY2e/2wijzkqNmumeLv7WPvSa7In1n0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-573-VMZDg5rTPm2_XuKIOIPHFQ-1; Wed,
 28 Oct 2026 11:30:12 -0400
X-MC-Unique: VMZDg5rTPm2_XuKIOIPHFQ-1
X-Mimecast-MFC-AGG-ID: VMZDg5rTPm2_XuKIOIPHFQ_1793201411
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63D6F1800772;
	Wed, 28 Oct 2026 15:30:10 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 992D01800446;
	Wed, 28 Oct 2026 15:30:08 +0000 (UTC)
Message-ID: <c00f13e5-d048-4d5d-98ea-984ea7ebc13b@redhat.com>
Date: Wed, 28 Oct 2026 11:30:07 -0400
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
Subject: Re: [PATCH] cgroup/cpuset: Fix missing effective_xcpus accounting of
 child partitions
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261027123837.100909-1-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261027123837.100909-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 10/27/26 8:38 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> When a partition root expands its exclusive CPUs, a valid child
> partition will be able to claim more CPUs from its parent. As
> update_cpumasks_hier() always updates a cpuset before its descendants,
> the parent has already been committed when the child partition is
> reached. Its effective_cpus is computed with the child's old
> effective_xcpus subtracted and no further adjustment is made
> after the child commits its new effective_xcpus.
>
> The additional CPUs are thus granted to both the parent and the child
> partitions. generate_sched_domains() then emits the warning below
> about the overlapping sched domains:
>
>    WARNING: kernel/cgroup/cpuset.c:919 at rebuild_sched_domains_locked+0x1ec/0x2e0, CPU#21: bash/1225
>
> Fix that by taking the CPUs newly added to a valid child partition
> away from its parent at the commit point of update_cpumasks_hier()
> right before the new effective_xcpus is committed. The tasks in the
> parent cpuset as well as its other children will be updated if its
> effective_cpus is changed.
>
> A new test case is added to test_cpuset_prs.sh to test this patch.
>
> Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks for reporting this bug. Yes, the current code doesn't handle 
expansion of parent effective_xcpus correctly. I would prefer to handle 
it inside update_parent_effective_cpumask() and try to minimize 
partition related changes in update_cpumasks_hier(). I have posted an 
alternative patch for your review. Let me know how you think about it.

Thanks,
Longman

> ---
>   kernel/cgroup/cpuset.c                        | 25 +++++++++++++++++++
>   .../selftests/cgroup/test_cpuset_prs.sh       |  4 +++
>   2 files changed, 29 insertions(+)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3219f927c35e..ec0ef3ad0726 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2241,6 +2241,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>   		struct cpuset *parent = parent_cs(cp);
>   		bool remote = is_remote_partition(cp);
>   		bool update_parent = false;
> +		bool xcpus_added = false;
>   
>   		old_prs = new_prs = cp->partition_root_state;
>   
> @@ -2356,6 +2357,19 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>   		}
>   
>   		spin_lock_irq(&callback_lock);
> +		/*
> +		 * A child partition may claim more CPUs when its parent expands
> +		 * the exclusive CPUs. Take the newly granted CPUs away from the
> +		 * parent which was committed earlier in this walk.
> +		 */
> +		if (!remote && new_prs > 0) {
> +			compute_excpus(cp, tmp->addmask);
> +			if (cpumask_andnot(tmp->delmask, tmp->addmask,
> +					   cp->effective_xcpus)) {
> +				partition_xcpus_add(new_prs, parent, tmp->delmask);
> +				xcpus_added = true;
> +			}
> +		}
>   		cpumask_copy(cp->effective_cpus, tmp->new_cpus);
>   		cp->partition_root_state = new_prs;
>   		/*
> @@ -2375,6 +2389,17 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>   
>   		cpuset_update_tasks_cpumask(cp, tmp->new_cpus);
>   
> +		/*
> +		 * The parent's effective_cpus may have been changed by
> +		 * partition_xcpus_add() above. Update the tasks in the parent
> +		 * cpuset and its other children, if necessary.
> +		 */
> +		if (xcpus_added) {
> +			cpumask_copy(tmp->addmask, parent->effective_cpus);
> +			cpuset_update_tasks_cpumask(parent, tmp->addmask);
> +			update_sibling_cpumasks(parent, cp, tmp);
> +		}
> +
>   		/*
>   		 * On default hierarchy, inherit the CS_SCHED_LOAD_BALANCE
>   		 * from parent if current cpuset isn't a valid partition root
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 83ef6c781af3..09e430570815 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -437,6 +437,10 @@ TEST_MATRIX=(
>   	" CX1-4:P1 CX3-4:P1 .     .     X1-2     .      .      .     0 A1:1-2|A2:1-2|XA2: A1:P1|A2:P-1"
>   	" CX1-4:P1 CX3-4:P1 .     .  X1-2:X1-4   .      .      .     0 A1:1-2|A2:3-4|XA2:3-4 A1:P1|A2:P1"
>   
> +	# The extra CPUs gained by a child partition when its parent expands the
> +	# exclusive CPUs have to be taken away from the parent.
> +	" C2-6:X2-5:P1 C3-6:X3-6:P1 .      .      X2-6     .      .      .     0 A1:2|A2:3-6|XA2:3-6 A1:P1|A2:P1 ."
> +
>   	# Taking away all CPUs from parent or itself if there are tasks
>   	# will make the partition invalid.
>   	"  C2-3:P1   C3:P1  .      .      T     C2-3    .      .     0 A1:2-3|A2:2-3 A1:P1|A2:P-1"

