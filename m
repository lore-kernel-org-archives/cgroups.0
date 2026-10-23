Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792739294;
	b=IuUpmt3See0Vy7o0nw+2j6o106QLZNikH73UPIK/ny93PaWJmftNp98jbUWAxFrqUY/J
	 Sn2LcA/gI3LlQaqZfzK5Oq/cbDZ+rk2O8Z7n4fNCILCG9ZV1Gw2suLfFfaP7YGBS1QICz
	 PxYWBsHMvggUHWjP6Y07UxafZo8C+3CjKw9iBMuH3byOLdPSu8dDY0b6Pehi9DZi8dlhD
	 X3pTtvHEMIiUzd89hBJRaTAgpwM12PKjHEkXE8olApehuJVjnMnELnFWoNbzrGYHtVd9E
	 Ws7G0/rqytzJyGxfzKyrQElS+bHflLzQWdLOhsGvxwnAp4HO06Wkrvp9ipAUEMKVwuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792739294;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=7Bi9zppZM2yD7mKvBKUrbEl0+w7X4vbpIcDv6FIEg8c=;
	b=si4y+fJ0ntkQTQ3Vp4WaQ5Z+KF5j/SZ7I7iVThTt22BzL27eZqkVIda4ed+qSz9wLeCh
	 XGVMI7Jiu8mn1h0ZazFhC2lNhEuSxiCqWiqDGcGzITj5wq5ZlbTM0V0nPz2x2mUNfuerp
	 IiuYpAI5ZTLDHiZFbQibkci5quLYJNfviTnkpXBLT3cwq16Ud+DOcxVSuqTbOATQlf6yF
	 /WyATKXchd9LEIEe7EmpJMdL/HCHb6Wpg+nO+iL+eHa04+8x6SfvG+D91SUVq13GJJIPz
	 q60moZjojclZ2KkBRHkkWbFOZN77lqLjaHKRAZY53YHR9csks1RNZKiMmeX3JFEoD1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BfVmx2X2;
	arc=none smtp.remote-ip=91.218.175.39
Received: from mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E7C606A320
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 07:08:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52E7C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BfVmx2X2
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pAq3+l4oQM0fA1DixnIYuWfCLcca2gf22KdWyl5gugU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792739290; v=1; x=1793344090;
 b=BfVmx2X2no0q+x03VvQeQWxeu/iN3eilcKjpyVvq5L7XlcnMpxGwGQIJGBfq+Ig7qU0GbB47
 8nfym7Pvpz79jCjRzm51rP395RH38wgMeyQmwTivmfgPwJk1KTq88LjG4x6xoCzkcLs2wvHkjH5
 49dfSBzBwmLCHr72bFyHTg2c=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f7e879e1153112cc;
	Fri, 23 Oct 2026 07:08:10 +0000
X-Mizu-Trace-ID: f7e879e1153112cc
X-Migadu-Flow: FLOW_OUT
Message-ID: <fda68203-1626-4118-9664-79064aad4548@linux.dev>
Date: Fri, 23 Oct 2026 15:07:59 +0800
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
Subject: Re: [PATCH-next 3/6] cgroup/cpuset: Fix incorrect effective_cpus bug
 in update_cpumasks_hier()
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>
References: <20261022031643.1351877-1-longman@redhat.com>
 <20261022031643.1351877-4-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261022031643.1351877-4-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/22/2026 11:16 AM, Waiman Long wrote:
> With the introduction of cpuset.cpus.exclusive, the computation of
> effective_cpus differs depending on if a cpuset is a valid partition
> root or not.
> 
> In update_cpumasks_hier(), effective_cpus is computed early
> to check if the current subtree can be skipped. Later on
> update_parent_effective_cpumask() may be called which can change the
> partition state from valid to invalid or vice versa. If the partition
> state changes, the previously computed effective_cpus may no longer be
> valid. Fix that by recomputing effective_cpus again when that happens.
> 
> Also add a new test case into test_cpuset_prs.sh to verify this change.
> 
> Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   kernel/cgroup/cpuset.c                            | 10 ++++++++--
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh |  3 +++
>   2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index db6e4663f4be..7b9062326f35 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2316,10 +2316,16 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>   		if (update_parent) {
>   			update_parent_effective_cpumask(cp, partcmd_update, NULL, tmp);
>   			/*
> -			 * The cpuset partition_root_state may become
> -			 * invalid. Capture it.
> +			 * Capture current partition_root_state as it may have
> +			 * changed. Recompute effective cpumask if changed.
>   			 */
>   			new_prs = cp->partition_root_state;
> +			if (new_prs != old_prs) {
> +				if (new_prs > 0)
> +					compute_partition_effective_cpumask(cp, tmp->new_cpus);
> +				else
> +					compute_effective_cpumask(tmp->new_cpus, cp, parent);
> +			}
>   		}
>   

If cs is a partition (remote or local), we call 
compute_partition_effective_cpumask to compute the effective cpumask; otherwise 
we should call compute_effective_cpumask. Wouldn't it be better to call 
compute_partition_effective_cpumask whenever cs is a valid partition, so we can 
eliminate the branch outside?

```
static void compute_effective_cpumask(struct cpumask *new_cpus,
				      struct cpuset *cs, struct cpuset *parent)
{
	bool has_cpus;

	if (is_remote_partition (cs) ||
	    (is_partition_valid(cs) && is_partition_valid(parent)))
		return compute_partition_effective_cpumask(cs, &new_cpus);

	has_cpus = cpumask_and(new_cpus, cs->cpus_allowed, parent->effective_cpus);
	if (!has_cpus && is_in_v2_mode())
		cpumask_copy(new_cpus, parent->effective_cpus);
}
```

>   		spin_lock_irq(&callback_lock);
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 47791591002f..8595b6b4b7bf 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -364,6 +364,9 @@ TEST_MATRIX=(
>   	" C1-4:X2-4 C2-4:X3-4:P1 C3-4:X4:P2 \
>   				   .      .      X5      .      .    0 A1:1-4|A2:2-4|A3:3-4 \
>   								       A1:P0|A2:P-1|A3:P-2 ."
> +	" C1-5:X3-5:P2 C3-5:X4-5:P2 C4-5:X5:P2 \
> +				   .    X1-4     .       .      .    0 A1:1-3|A2:4|A3:4 \
> +								       A1:P2|A2:P2|A3:P-2 1-4"
>   	" C1-4:X2-4 C1-4:X3-4:P1 C3-4:X4:P2 \
>   				   .      .      .      X1      .    0 A1:1-2|A2:3-4|A3:3-4 \
>   								       A1:P0|A2:P1|A3:P-2 ."

-- 
Best regards
Ridong

