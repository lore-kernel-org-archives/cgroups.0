Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.183
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792737946;
	b=VuR5a5+UnWMnOL+8CVW8UXJTY1vl+JG7xYO+r10PLzUjollfkpxWdAHVU+9fvJx1xZwB
	 qBaFOvnoBOw4Cu0HtNvgLPdEzWjZTAkiIJxU6i2W42j0SoATlrbZbNQIsBbviG3NYKC0c
	 Q5PPg8F8f+yDOoREA5CtTODtZkcidFMUB2Uc1Wq87lTpDD0HkuLn/Zso+AIBcF8kzygEg
	 5Yj7+rKx700wZoM6eVnVXE0dA048WLsIxZFz2hItIeW6tSCaluHFQa0lWln/6kre31HqZ
	 UYVKyoAHU0em57YMTLHwqcr1qmhLUeL7rAtkxtSaG3O9124wo3x4yTnKJuoVdUe/d5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792737946;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=uap1d0YQBPlGa3j+uz35jkZOz7so7dVvvr1+5IPZ/Gg=;
	b=UnSYjseLbX3nqdcg+TvHQd+386Q0otc9o2ebWQXnMUs/tAIBTROsclDhN0lCHKL+N3Jc
	 naFbE/tht/rwoF9t8i5i5M4wU5G7EsufzA4UQHTP8M/HHF9aJP7Qv+4zdcOG55SEYgYcR
	 lnPfD8NfPCLI46p6gU0k4qkrH1eH+l89EtUz+z54/0lsrVWOvfJC39aCaFKrR7PthdoEh
	 j5FFCktESReIxk6ITxQQqcgRTR+wRBH7atBMnizkeMwzDgHRxfeh4LypsmvJxf46RQlPZ
	 KViat+BODVfq014E+05+xYGFJ1uMkBXpeHZbDWMaRWycQfCEV8laKBZg+eVIFnj6Wxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=R8kCpHQS;
	arc=none smtp.remote-ip=91.218.175.183
Received: from mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECCC606A31D
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 06:45:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9ECCC606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=R8kCpHQS
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ooKo4YxWexedKOabnOdquTmvn6cl6rHb/OzDbkPDsNA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792737943; v=1; x=1793342743;
 b=R8kCpHQSs4+K7KnzjYvpDKW95NlF93MjOir+XBlEgIImoC6FtEcXbQgRgaDe5kfg7kJWbjCS
 VOHgGKf8Vmw5DCbvA8iLwcKAinwlRTXX3kr4SGLdc3JOTcTBMIz5Lizfwdx6FDWogO3GnV/J+lp
 FQztD3NpQQG5hF6B1IHHCccs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 13bbd67df336cd5d;
	Fri, 23 Oct 2026 06:45:38 +0000
X-Mizu-Trace-ID: 13bbd67df336cd5d
X-Migadu-Flow: FLOW_OUT
Message-ID: <d4ce3eba-b48a-4e63-af0f-87cd27d04e4c@linux.dev>
Date: Fri, 23 Oct 2026 14:45:31 +0800
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
Subject: Re: [PATCH-next 2/6] cgroup/cpuset: Properly compute effective xcpus
 in update_parent_effective_cpumask()
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>
References: <20261022031643.1351877-1-longman@redhat.com>
 <20261022031643.1351877-3-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261022031643.1351877-3-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/22/2026 11:16 AM, Waiman Long wrote:
> Since the introduction of cpuset.cpus.exclusive in commit
> e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2"), a
> compute_effective_exclusive_cpumask() helper which is later renamed to
> compute_excpus() is added to compute the effective xcpus of a partition
> root. However update_parent_effective_cpumask() is not updated in all
> proper places to use the new helper to check if a given cpuset should
> remain a valid partition root. This can cause a cpuset to incorrectly
> remain a valid partition root even if no effective xcpus is left.
> 
> Fix that problem by using compute_excpus() to compute the effective xcpus
> into delmask in all cases except partcmd_disable and partcmd_invalidate
> and use it for tasks_nocpu_error() check as well as checking its
> emptiness. This enables us to catch invalid partition root more
> accurately in update_parent_effective_cpumask().
> 
> Some test case are added to test_cpuset_prs.sh for invalidating a
> partition root due to its effective xcpus becoming empty as well as
> making sure that an invalid partition can only be revived when exclusive
> CPUs are available agin.
> 
> Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   kernel/cgroup/cpuset.c                        | 36 +++++++++----------
>   .../selftests/cgroup/test_cpuset_prs.sh       |  6 ++++
>   2 files changed, 22 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 7ead8c3b7974..db6e4663f4be 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1798,7 +1798,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   	int deleting;	/* Deleting cpus from parent's effective_cpus	*/
>   	int old_prs, new_prs;
>   	int part_error = PERR_NONE;	/* Partition error? */
> -	struct cpumask *xcpus = user_xcpus(cs);
>   	int parent_prs = parent->partition_root_state;
>   	bool nocpu;
>   
> @@ -1841,30 +1840,29 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   	if (!newmask && xcpus_empty(cs))
>   		return PERR_CPUSEMPTY;
>   
> -	nocpu = tasks_nocpu_error(parent, cs, xcpus);
> +	/*
> +	 * Except for partcmd_disable, use delmask to compute the current
> +	 * effective xcpus value and use it for tasks_nocpu_error check.
> +	 */
> +	if (cmd != partcmd_disable) {
> +		compute_excpus(cs, tmp->delmask);
> +		nocpu = tasks_nocpu_error(parent, cs, tmp->delmask);
> +	}
>   
>   	if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
> -		/*
> -		 * Need to call compute_excpus() in case
> -		 * exclusive_cpus not set. Sibling conflict should only happen
> -		 * if exclusive_cpus isn't set.
> -		 */
> -		xcpus = tmp->delmask;
> -		if (compute_excpus(cs, xcpus))
> -			WARN_ON_ONCE(!cpumask_empty(cs->exclusive_cpus));
>   		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
>   
>   		/*
>   		 * Enabling partition root is not allowed if its
>   		 * effective_xcpus is empty.
>   		 */
> -		if (cpumask_empty(xcpus))
> +		if (cpumask_empty(tmp->delmask))
>   			return PERR_INVCPUS;
>   
> -		if (prstate_housekeeping_conflict(new_prs, parent_prs, xcpus, NULL))
> +		if (prstate_housekeeping_conflict(new_prs, parent_prs, tmp->delmask, NULL))
>   			return PERR_HKEEPING;
>   
> -		if (tasks_nocpu_error(parent, cs, xcpus))
> +		if (nocpu)
>   			return PERR_NOCPUS;
>   

update_parent_effective_cpumask is only used for the local partition. So I'd 
suggest adding a local_partition_validate helper, which can be used for both 
partition enable and update. For now this logic is spread out, and many corner 
cases would easily be missed.

For the remote partition, I have also made suggestions when reviewing Guopeng's 
patches.

>   		/*
> @@ -1876,9 +1874,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   		 *
>   		 * Warn if it is not the case.
>   		 */
> -		cpumask_and(tmp->new_cpus, xcpus, cpu_active_mask);
> +		cpumask_and(tmp->new_cpus, tmp->delmask, cpu_active_mask);
>   		WARN_ON_ONCE(!cpumask_subset(tmp->new_cpus, parent->effective_cpus));
> -
>   		deleting = true;
>   	} else if (cmd == partcmd_disable) {
>   		/*
> @@ -1973,7 +1970,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   		 * A partition error happens when parent has tasks and all
>   		 * its effective CPUs will have to be distributed out.
>   		 */
> -		if (nocpu) {
> +		if (nocpu || cpumask_empty(tmp->delmask)) {
>   			part_error = PERR_NOCPUS;
>   			if (is_partition_valid(cs))
>   				adding = cpumask_and(tmp->addmask,
> @@ -1986,8 +1983,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   				cpumask_copy(tmp->addmask, cs->effective_xcpus);
>   				adding = true;
>   			}
> -		} else if (is_partition_invalid(cs) && !cpumask_empty(xcpus) &&
> -			   cpumask_subset(xcpus, parent->effective_xcpus)) {
> +		} else if (is_partition_invalid(cs)) {
>   			struct cgroup_subsys_state *css;
>   			struct cpuset *child;
>   			bool exclusive = true;
> @@ -1998,7 +1994,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   			 * check.
>   			 */
>   			if (prstate_housekeeping_conflict(cs->partition_root_state,
> -							  parent_prs, xcpus, NULL)) {
> +							  parent_prs, tmp->delmask, NULL)) {
>   				part_error = PERR_HKEEPING;
>   				goto write_error;
>   			}
> @@ -2014,7 +2010,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   			rcu_read_unlock();
>   			if (exclusive)
>   				deleting = cpumask_and(tmp->delmask,
> -						xcpus, parent->effective_cpus);
> +						tmp->delmask, parent->effective_cpus);
>   			else
>   				part_error = PERR_NOTEXCL;
>   		}
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index d04aad697b96..47791591002f 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -359,6 +359,8 @@ TEST_MATRIX=(
>   								       A1:P0|A2:P1|A3:P2|B1:P1 2-4|3"
>   	"  C1-6:P1 C3-6:P1 C5-6:P1 .      .      P2      .      .    0 A1:1-2|A2:3-6|A3:5-6 \
>   								       A1:P1|A2:P2|A3:P-1 3-6"
> +	"  C1-6:P2 C3-6:P2 C3-4:P2 .      .     C5-6     .      .    0 A1:1-4|A2:5-6|A3:5-6 \
> +								       A1:P2|A2:P2|A3:P-2 1-6"
>   	" C1-4:X2-4 C2-4:X3-4:P1 C3-4:X4:P2 \
>   				   .      .      X5      .      .    0 A1:1-4|A2:2-4|A3:3-4 \
>   								       A1:P0|A2:P-1|A3:P-2 ."
> @@ -427,6 +429,10 @@ TEST_MATRIX=(
>   	# cpuset.cpus is allowed, but those extra CPUs are ignored.
>   	"  C2-3:P1   C3:P1  .      .      .     C2-4    .      .     0 A1:|A2:2-3 A1:P1|A2:P1"
>   
> +	# A child cannot recover until its exclusive CPUs are available again.
> +	" CX1-4:P1 CX3-4:P1 .     .     X1-2     .      .      .     0 A1:1-2|A2:1-2|XA2: A1:P1|A2:P-1"
> +	" CX1-4:P1 CX3-4:P1 .     .  X1-2:X1-4   .      .      .     0 A1:1-2|A2:3-4|XA2:3-4 A1:P1|A2:P1"
> +
>   	# Taking away all CPUs from parent or itself if there are tasks
>   	# will make the partition invalid.
>   	"  C2-3:P1   C3:P1  .      .      T     C2-3    .      .     0 A1:2-3|A2:2-3 A1:P1|A2:P-1"

-- 
Best regards
Ridong

