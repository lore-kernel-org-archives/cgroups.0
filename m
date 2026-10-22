Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.161
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792679011;
	b=E825bICykjrayVD0MAv6bdrk8YKuAWru5qkKDnZJleB8GnBegZB1mr4r/YQN17S8jnSs
	 L3eiapYwfkD1NECrO2rxmU6z9fJjmSqXgkvewjWQ5xYqv6ZXOycnCp9el3KR191oYNrtf
	 CtDxkraG28paLGCj3MMbo4SoNh35R1yVAZmGq6rvPSXAYvLIWvI0HlTAESmm4886vB3NE
	 eRvPahRaeR3w4VkG+3CDM58EZVA5nWg6EzXgiYdWWoB+kJqjDdAq65TRnGNmYpxU+v7U5
	 w0v8qWemFvMwx0/hnVh6eMZDvU5zmji5Qz+MdWgzpZWanfohfcRUG1UnCKvVNXZg0fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792679011;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=l4pPJAHIzCiz4ik/sPvwtmYl98ivKUwHi/L5wDE89bM=;
	b=Cmi6yo9MgrxoZ6OIUuGISzmWNPVjQjeqGuo7xkNV8cRmcNR+ifHyVBL4LsBtr0YBh5FH
	 N1fJDNbTIINiNHVH6SrZfuEq8ZJhcOlr29LGRibHUsaclvSXuRWy03YWRLe6xN88mgJQ4
	 wFAK66bOw+n/qRO4+AqWOrazDp6mmZovPwpbTo9128xN3tnFkARZnu6NSUDo1I93A8Nuf
	 dUXKtWZrz76ukCG9X1Rkw1uHXWVgA2raRNWgjfuMa9dObWZSipIjk4IGT/UIDTmgzy9gF
	 Y01jBWaH2IRpveBzXHiZYfS1piEVaz+66lR8X9xXNbpMCUcb7Q8xKWmMEkLSCWZn4Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MAXTKOWN;
	arc=none smtp.remote-ip=91.218.175.161
Received: from mta0.migadu.com (out-161.mta0.migadu.com [91.218.175.161])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005AA606A328
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 14:23:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 005AA606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MAXTKOWN
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=u+IWVqBqxlupddJdL1ZfQ+qoMepjEEQs03oihWDurP0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792679007; v=1; x=1793283807;
 b=MAXTKOWN14PvtPFaLEzQWYPGDvFojHG/SdtlALC4OOP9h3N5KcK3RV6dEE2f6bvjmAC33dCa
 Bt0vXa2/izycxVGsbCDERQ4Ht6bPMPCrmigvO30LxoJ2bh4pWy6JTnUSbh2cMcOyPkdIB9Fb+Hl
 jk8eXdi0wm5Nx8MQUIGQt96U=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d588a8abfc2b5b3c;
	Thu, 22 Oct 2026 14:23:27 +0000
X-Mizu-Trace-ID: d588a8abfc2b5b3c
X-Migadu-Flow: FLOW_OUT
Message-ID: <d2e1f385-6730-4ce4-8be9-1de3d830eeef@linux.dev>
Date: Thu, 22 Oct 2026 22:23:24 +0800
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
Subject: Re: [PATCH-next 6/6] cgroup/cpuset: Prevent recursive call of
 remote_cpus_update() via update_cpumasks_hier()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261022031643.1351877-1-longman@redhat.com>
 <20261022031643.1351877-7-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261022031643.1351877-7-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/22 11:16, Waiman Long 写道:
> Guopeng reports that changing the cpumask of a remote partition root
> may set the effective_cpus of the top_cpuset incorrectly. It is
> due to the following call sequence:
> 
>   update_cpumask()
>    -> partition_cpus_change()
>     -> remote_cpus_update()
>      -> update_sibling_cpumasks()
>       -> update_cpumasks_hier()
>        -> remote_cpus_update()
> 
> The second remote_cpus_update() call passes in the cs->effective_xcpus
> instead of the trialcs->effective_xcpus of the first remote_cpus_update()
> call.  As a result, the second call can revert what has been done in
> the first call leading to incorrect effective_cpus of the top_cpuset
> as well as subpartitions_cpus.
> 
> Fix that by adding a new remote_partition_updating flag into the cpuset
> structure to indicate that a remote partition is being updated and
> update_cpumasks_hier() should skip the whole subtree as update_cpumask()
> or update_exclusive_cpumask() which calls partition_cpus_change()
> will eventually calls update_cpumasks_hier() for that subtree anyway.
> 
> This new flag is currently set only in remote_cpus_update() to prevent
> recursive call of remote_cpus_update() on the same cpuset.
> 
> A test case is added to test_cpuset_prs.sh to verify this change.
> 
> Reported-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> Link: https://lore.kernel.org/lkml/20261010075947.333549-2-guopeng.zhang@linux.dev
> Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset-internal.h                   |  5 +++++
>  kernel/cgroup/cpuset.c                            | 13 +++++++++----
>  tools/testing/selftests/cgroup/test_cpuset_prs.sh |  1 +
>  3 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
> index 2e44dc8634dc..1ba94ffaff9d 100644
> --- a/kernel/cgroup/cpuset-internal.h
> +++ b/kernel/cgroup/cpuset-internal.h
> @@ -161,6 +161,11 @@ struct cpuset {
>  	 */
>  	bool remote_partition;
>  
> +	/*
> +	 * Set to true when a remote partition is undergoing update.
> +	 */
> +	bool remote_partition_updating;
> +
>  	/*
>  	 * number of SCHED_DEADLINE tasks attached to this cpuset, so that we
>  	 * know when to rebuild associated root domain bandwidth information.
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 6e1bef12f86d..952b31246d62 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1736,6 +1736,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>  			goto invalidate;
>  	}
>  
> +	cs->remote_partition_updating = true;
>  	spin_lock_irq(&callback_lock);
>  	if (adding)
>  		partition_xcpus_add(prs, NULL, tmp->addmask);
> @@ -1757,6 +1758,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>  	 */
>  	cpuset_update_tasks_cpumask(&top_cpuset, tmp->new_cpus);
>  	update_sibling_cpumasks(&top_cpuset, NULL, tmp);
> +	cs->remote_partition_updating = false;
>  	return;
>  
>  invalidate:
> @@ -2208,16 +2210,19 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>  		old_prs = new_prs = cp->partition_root_state;
>  
>  		/*
> -		 * For child remote partition root (!= cs), we need to call
> -		 * remote_cpus_update() if effective_xcpus will be changed.
> -		 * Otherwise, we can skip the whole subtree.
> +		 * For a child remote partition with remote_partition_updating
> +		 * set, we can skip the whole subtree as the this function will
> +		 * be called eventually. We can also skip the subtree if the
> +		 * effective_xcpus isn't going to be changed. Otherwise, we
> +		 * will have to call remote_cpus_update().
>  		 *
>  		 * remote_cpus_update() will reuse tmp->new_cpus only after
>  		 * its value is being processed.
>  		 */
>  		if (remote && (cp != cs)) {
>  			compute_excpus(cp, tmp->new_cpus);
> -			if (cpumask_equal(cp->effective_xcpus, tmp->new_cpus)) {
> +			if (cp->remote_partition_updating ||
> +			    cpumask_equal(cp->effective_xcpus, tmp->new_cpus)) {
>  				pos_css = css_rightmost_descendant(pos_css);
>  				continue;
>  			}
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 5bc144836bdf..19c50819065c 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -347,6 +347,7 @@ TEST_MATRIX=(
>  	"   C0-3    C1-3  C2-3    C4    X2-3   X2-3  X2-3:P2 P2:C4-5 0 A3:2-3|B1:4-5 A3:P2|B1:P2 2-5"
>  	"  C4:X0-3  X1-3  X2-3     .      .      P2     .      .     0 A1:4|A2:1-3|A3:1-3 A2:P2 1-3"
>  	"  C4:X0-3  X1-3  X2-3     .      .      .      P2     .     0 A1:4|A2:4|A3:2-3 A3:P2 2-3"
> +	"   CX1-6  C1-4:P1  .    C4-5     .    C1-3     .      .     0 A1:4-6|A2:1-3|B1:4-5 A2:P1"
>  
>  	# Nested remote/local partition tests
>  	"   C0-3    C1-3  C2-3   C4-5   X2-3  X2-3:P1   P2     P1    0 A1:0-1|A2:|A3:2-3|B1:4-5 \

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
