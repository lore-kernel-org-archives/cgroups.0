Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793004599;
	b=QAftLASMMFqjSLAaVoPd8t7LpgLiowQGl5xuLXQEJxT6eSSRMU+/PntZcdsT29vKAbLM
	 pJQYtZdwxG/4dJqTeFS+BqnFJaUe53wywd2T9eeLkpeQ+dKc9PC8zZVAPxEAofucoCVqn
	 NcQC3EN+Q3Pt/tZOTTUtoT0rMcGzFzHhwR/QfPaccRBc+dmo0S9aBO3/tfxHPBqxm0ZCH
	 IC/uXrwm9XETcqt3Xo+akcbf45P5yiyT97YcFi3API5S3lzOuhfUky5LNaSTXcZeKWapl
	 yyoZHfb/JlrDSuNpa5G0JWXp1ZalvpybbkDTItQk3nkQS2GpEDLo8J8UfPm9PqlPUnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793004599;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=xTCncqWwkGyvWmFCnNOjI4Ctl5a4Y1hNNgZFEF7i6Sc=;
	b=wzRwAHPOUJkSZympzRnuwowYewtM2jxz0RkaWRBeeMKEmo/aNtUVSacGA3AAi8dwNvmD
	 swacvwOYS+FNPkEKUYR7deZ42B7lyj/eG19vQIJmU2X4Jhrr/WG9Gwno2Bnn1NpkVR1nL
	 zPK20EDdLOk+udHSLMk57hto1rptnd/VCnaw08Pgrgge88mmtsHHtmYK/xLRi1hGsnUfd
	 yNmlu+FIXAvDkd33g5FAl1nC5cJF5YtuVBTgVmSBFQm8FWcWdsN2zp5YWJX2t7vvbfmxw
	 mdkNMctH1xZT4EldYmgnxlTEGunr2wJRg4ApnrIv6iPx1VHd2fteiudgEK9RxRQVWvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Fcvbt7V2;
	arc=none smtp.remote-ip=95.215.58.56
Received: from mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A08606A320
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 08:49:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0A08606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Fcvbt7V2
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=aJ85KleHsdb6375xJChkcgqa/AGS2OmDzCxBgEDf+QY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793004596; v=1; x=1793609396;
 b=Fcvbt7V2CoxVpw3hYaKc20x1nauvHcffAQmhCiSBDPlGF/NmM2kd4ly/D9/cTWMM+OhREaZm
 HPvmkpT2UNoi2ZOSaCjFZuSwHqdYaaJXZMKtO7grmILazMGiLYeaze2Z44D655UtpU/YpT7FlSy
 77fKpKLUMid7BPCuJgxX9118=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7f4f4f5d460e380d;
	Mon, 26 Oct 2026 08:49:56 +0000
X-Mizu-Trace-ID: 7f4f4f5d460e380d
X-Migadu-Flow: FLOW_OUT
Message-ID: <c51ae201-ed72-48e0-a29c-d31ecc6e6391@linux.dev>
Date: Mon, 26 Oct 2026 16:49:36 +0800
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
Subject: Re: [PATCH-next v3 08/11] cgroup/cpuset: Release invalid isolated
 CPUs in compute_partition_effective_cpumask()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261025214449.310715-1-longman@redhat.com>
 <20261025214449.310715-9-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261025214449.310715-9-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/26 05:44, Waiman Long 写道:
> It is found by sashiko that when a child isolated partition with parent
> root partition is invalidated in compute_partition_effective_cpumask(),
> the switching of the isolated exclusive CPUs from child to parent will
> not be reflected in isolated_cpus leading to CPU leakage. Fix that by
> calling isolated_cpus_update() when that happens.
> 
> Also simplify compute_partition_effective_cpumask() by doing
> child partition invalidation only for the special case of no more
> effective_cpus left in a populated parent. The other case doesn't
> actually warrant invalidation at this stage and subsequent iteration
> in update_cpumasks_hier() and update_parent_effective_cpumask() for
> that child should handle that.
> 
> Also drop the make_partition_invalid() helper by inlining it into
> compute_partition_effective_cpumask() as it is the only caller.
> 
> A new test case is add to test_cpuset_prs.sh to verify this.
> 
> Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c                        | 46 +++++++------------
>  .../selftests/cgroup/test_cpuset_prs.sh       |  4 ++
>  2 files changed, 21 insertions(+), 29 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 53fa3970946e..6d224e614e74 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -254,15 +254,6 @@ static inline bool cs_is_member(const struct cpuset *cs)
>  	return cs->partition_root_state == PRS_MEMBER;
>  }
>  
> -/*
> - * Callers should hold callback_lock to modify partition_root_state.
> - */
> -static inline void make_partition_invalid(struct cpuset *cs)
> -{
> -	if (cs->partition_root_state > 0)
> -		cs->partition_root_state = -cs->partition_root_state;
> -}
> -
>  /*
>   * Send notification event of whenever partition_root_state changes.
>   */
> @@ -2153,8 +2144,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   * or update_cpumasks_hier() where parent and children are modified
>   * successively, we don't need to call update_parent_effective_cpumask()
>   * and the child's effective_cpus will be updated in later iterations.
> - *
> - * Note that rcu_read_lock() is assumed to be held.
>   */
>  static void compute_partition_effective_cpumask(struct cpuset *cs,
>  						struct cpumask *new_ecpus)
> @@ -2166,15 +2155,16 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>  	WARN_ON_ONCE(!is_partition_valid(cs));
>  
>  	/*
> -	 * Check child partition roots to see if they should be
> -	 * invalidated when
> -	 *  1) child effective_xcpus not a subset of new
> -	 *     excluisve_cpus
> -	 *  2) All the effective_cpus will be used up and cp
> -	 *     has tasks
> +	 * Check child partition roots to see if they should be invalidated
> +	 * when all the effective_cpus will be used up and cs is populated.
> +	 * It is better to sacrifice a child partition root than invalidating
> +	 * the whole subtree.
> +	 *
> +	 * Return early if the effective_cpus is already empty.
>  	 */
>  	compute_excpus(cs, new_ecpus);
> -	cpumask_and(new_ecpus, new_ecpus, cpu_active_mask);
> +	if (!cpumask_and(new_ecpus, new_ecpus, cpu_active_mask))
> +		return;
>  
>  	rcu_read_lock();
>  	cpuset_for_each_child(child, css, cs) {
> @@ -2186,22 +2176,20 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>  		 * partition root.
>  		 */
>  		WARN_ON_ONCE(is_remote_partition(child));
> -		WRITE_ONCE(child->prs_err, 0);
> -		if (!cpumask_subset(child->effective_xcpus,
> -				    cs->effective_xcpus))
> -			WRITE_ONCE(child->prs_err, PERR_INVCPUS);
> -		else if (populated &&
> -			 cpumask_subset(new_ecpus, child->effective_xcpus))
> -			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
> -
> -		if (child->prs_err) {
> +		if (populated && cpumask_subset(new_ecpus, child->effective_xcpus)) {
>  			int old_prs = child->partition_root_state;
> +			int parent_prs = cs->partition_root_state;
>  
>  			/*
> -			 * Invalidate child partition
> +			 * Invalidate child partition and update isolated_cpus
> +			 * if necessary.
>  			 */
>  			spin_lock_irq(&callback_lock);
> -			make_partition_invalid(child);
> +			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
> +			if ((old_prs == PRS_ISOLATED) && (parent_prs == PRS_ROOT))
> +				isolated_cpus_update(PRS_ISOLATED, PRS_ROOT,
> +						     child->effective_xcpus);
> +			child->partition_root_state = -old_prs;
>  			spin_unlock_irq(&callback_lock);
>  			notify_partition_change(child, old_prs);
>  			continue;
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index f0d98da3cfd8..d7d0bef0a17a 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -518,6 +518,10 @@ TEST_MATRIX=(
>  	" CX0-4:P2 CX2-4:P2 CX3-4:P2 .     .     X2     .      .     0 A1:0-1,3-4|A2:2|A3:2 \
>  								       A1:P2|A2:P2|A3:P-2 0-4"
>  
> +	# When an isolated partition child with root partition parent is invalidated,
> +	# its effective xcpus will be removed from isolated_cpus.
> +	" C1-4:P1 C3-4:P2   .      .    T:C3-4   .      .      .     0 A1:3-4|A2:3-4 A1:P1|A2:P-2 ."
> +
>  	#
>  	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
>  	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
