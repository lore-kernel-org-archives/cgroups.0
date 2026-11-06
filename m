Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.27
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793939715;
	b=DsYiTkpLW8SWKbmBEDxJHaxxJUtYfe5U8mu4juHOabwHzWoNJusewE5vJKzWZmW+7MHR
	 h3tUDmiwfL2EE5J4sDQMED+jMHUrb2xpTrg9DNKlLynM1VXXGqYGyw/HoXe74OP84vVmJ
	 Mf89Lxwu71lLThQSyqqhkFsgqxuJ0SoHd7QlJimnPvzY984g9sMt2Qkl43ziGcWTdJbt3
	 TARob2XAv5dxFoZ0F3oEHktm2d4d+RYtSV2zkAQ2hYQLR7nxakYJ0HryGLn0TX8OmEZ1q
	 UTw9IY7ZnMcrKznuXACqtQuYRo1tl6DOIF0QUEKRVI1iwC0tQm80IgFTegUt5y3G2Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793939715;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=BwiuTehFb0l7eRC5B4m7NryifiwaQ9TTfvkXePFUYCM=;
	b=J0pxHv0AwOHKcjPDiyVYRjSVASAAT9ojhDLLu4cX4cUNL17DWfR3dzOV5UvfQGEpgAWf
	 hvnKvhg5qUbsX6qvmCirx6avEsFY7BaAuJ0EQXWPStTyBBzBeKI311XhnkgF7qKEEfGi9
	 0OQEqT5sCzR32tIuA/GKuOn0wIU+YH0Sa8d253/BbjKsgcHm6sjcgLvGTJy33VNzHjOug
	 B347iyU9DZ6pQ9Ru8+DF74BOBe5VLBM7OX6VKAgDNWyGWL7CIijjRJcFdgn9LA+jWGrsr
	 +EeTmL3QTiQoJkLAJbvk01U536vuJIjkyobEoIwYsJuERUjmXmE0RiwLbQb3e8IQhAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EpqItgjM;
	arc=none smtp.remote-ip=95.215.58.27
Received: from mta1.migadu.com (out-27.mta1.migadu.com [95.215.58.27])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CFF606A31B
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 04:35:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9CFF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EpqItgjM
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JwjmUZdfumXvV/jk+c2Ggo5iBE+Tmy51gA2vd7MMA6U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793939711; v=1; x=1794544511;
 b=EpqItgjMQGnLi/dl7QCtaK2xf1ahA1KeijGNiyaa4VtjU8t8ZLuA18D4jWx/+QpxPICA8WL2
 RfB2VVYH8VqWMqwd28E1X6lhqe640CWkvcLvMrLlZ0ujlxwl4yIYGlV/bWM7ilRgEJfubyP4uyL
 lr6t+MNO90LNrtppAt3RrQKA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bcb0b3e0b1c637ea;
	Fri, 06 Nov 2026 04:35:10 +0000
X-Mizu-Trace-ID: bcb0b3e0b1c637ea
X-Migadu-Flow: FLOW_OUT
Message-ID: <41a6de2b-e7eb-4574-a698-b4ff8af316fa@linux.dev>
Date: Fri, 6 Nov 2026 12:35:04 +0800
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
Subject: Re: [PATCH v2 3/3] cgroup/cpuset: Release isolated CPUs when the
 parent is invalid
To: Guopeng Zhang <guopeng.zhang@linux.dev>, longman@redhat.com, tj@kernel.org
Cc: hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261105130344.664336-1-guopeng.zhang@linux.dev>
 <20261105130344.664336-4-guopeng.zhang@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261105130344.664336-4-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/5/2026 9:03 PM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> An isolated partition can be invalidated after its parent has already
> become invalid. update_parent_effective_cpumask() then skips returning
> CPUs to the parent, but also skips removing them from isolated_cpus.
> The invalid child continues to isolate CPUs that no longer belong to
> any valid isolated partition.
> 
> For example, on a 32-CPU system with all CPUs online and without
> isolcpus= or nohz_full= boot parameters:
> 
>    cd /sys/fs/cgroup
>    echo +cpuset > cgroup.subtree_control
>    mkdir A
>    echo 0,2-31 > A/cpuset.cpus
>    echo root > A/cpuset.cpus.partition
>    echo +cpuset > A/cgroup.subtree_control
>    mkdir A/B
>    echo 2-3 > A/B/cpuset.cpus
>    echo isolated > A/B/cpuset.cpus.partition
>    cat cpuset.cpus.isolated
>    2-3
>    echo 0 > /sys/devices/system/cpu/cpu1/online
>    cat A/B/cpuset.cpus.partition
>    isolated invalid
>    cat cpuset.cpus.isolated
>    2-3
> 
> Release the invalidated child's isolated CPUs when its parent is no
> longer a valid partition. Use isolated_cpus_release() to preserve CPUs
> still covered by a valid isolated ancestor and by boot isolation.
> 
> After this fix, cpuset.cpus.isolated is empty for this reproducer.
> 
> Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index fc5454c2740f..f3b808cea51c 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1976,10 +1976,15 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   		/*
>   		 * Make the current partition invalid.
>   		 */
> -		if (is_partition_valid(parent))
> +		if (is_partition_valid(parent)) {
>   			adding = cpumask_and(tmp->addmask,
>   					     cs->effective_xcpus,
>   					     parent->effective_xcpus);
> +		} else if (old_prs == PRS_ISOLATED) {
> +			/* No valid parent will release these isolated CPUs. */
> +			cpumask_copy(tmp->addmask, cs->effective_xcpus);
> +			isolated_cpus_release(cs, tmp->addmask);
> +		}
>   		if (old_prs > 0)
>   			new_prs = -old_prs;
>   

Hi Guopeng,

Thanks for the fix. Could you try this patch to see if it fixes the
issue?

https://lore.kernel.org/cgroups/20261105125215.2205892-4-ridong.chen@linux.dev/T/#u

I'm concerned about whether the related issue has been fixed in all
the places that need fixing. In your reproducer, CPUs 2-3 are already
wrong when A becomes invalid: partition_xcpus_del() only updates
isolated_cpus when the old state differs from the parent's state, so
the CPUs that A gave back but had distributed to the isolated child B
are left in isolated_cpus. This patch only cleans them up later, when
B is invalidated with an invalid parent. Other paths that give back
CPUs of an isolated descendant may have the same problem.

My patch makes partition_xcpus_del() always set the isolation state of
the given back CPUs, including those of the descendants, to the state
of the parent that receives them. With it, isolated_cpus_release()
should no longer be needed.

It would also be good to add your reproducer to test_cpuset_prs.sh.
It can be expressed with O1=0 in the test matrix.

-- 
Best regards
Ridong

