Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.62
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792741363;
	b=aFEIH53c41ljBgQ3Cd5A9OtpPJhGOGdDQsg5yOYuhvWZ9KhbNgR1m5uuyvt2Ql/6VL9f
	 VZjQMzO3JoYGGmw4uVunQtbrtJJMX+FUVnqgxUbpfnAjzx5ZfhfaUHsXrdERbgbCnKy/0
	 arfaqN5x1xtUzAwx9I6GACMnv76ICUskfbcWvsZSMRBQu/YB1dr0W8efAq7C+emKqc482
	 LlDYtYUNjSR6bWAxDV7V/zYzRflgezu/hIiRCVFThhmbS0WhS1F3xSOdgaoZKcKFWYIuP
	 jjrIHAP1lG3MkuM389NLGxPHp5nSUVW0+d7MZ0+MCfXHH/G4RzJ4F0dlfRr9otwhZkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792741363;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=EX2NYxg1qCpK7kBynX4o8sp1YSY3XpDU409ZyBkbTLc=;
	b=CNIJbEF0c4+sAARskuNPTaVt7p7/nYbHSUUZKr9BShqzCdzrwBdLuUUlu2BO/h+Gt/a8
	 MtCA79XG19XTnRJWP2ZrNDkLirmc5WcEugJbdpaRKtQ3QqGmGBLddWcmYHYYgWpNOgHBB
	 Kkqx6GUhjt/vRLJSQGlRWHVYIApj5zk6k45gxXISS7qPo6bJcqn2vaf5CVTuXM6fvkQMc
	 rb/HlCaMKv+HkYFa6liMfq2SmE22TZ8uEYOFr4cACq2zBKzhM3YymuapXpwCR+eRZa6mu
	 g/2QksRKgaXxlpNiyNN0PdZFqRpe3Vpdz0Ida+aIijsPdZy5+HVpt62n7/r1SqSjjkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FtOOwCLH;
	arc=none smtp.remote-ip=95.215.58.62
Received: from mta1.migadu.com (out-62.mta1.migadu.com [95.215.58.62])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28AE606A31D
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 07:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B28AE606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FtOOwCLH
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=nDTfAFtUX+DrIrStzCs3LFmwsV7yvA6x2yoxwbUozcM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792741359; v=1; x=1793346159;
 b=FtOOwCLHjntYCnjkON2wmZBYEnAXNP0nzt9xGoCPRxd9gqPu//G/+58zj5jVbkskC4Qr+Jo7
 +EFQXta6MOuPZHNcFrjKqbcBK2iixgvIm9KAHXkiwQtdidO6ZY5PjpFvJgaGMloFO/gdVwVxI7E
 m9yywTujle763oIlz+0fEwJ8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9f858a2b1d4eeb7c;
	Fri, 23 Oct 2026 07:42:39 +0000
X-Mizu-Trace-ID: 9f858a2b1d4eeb7c
X-Migadu-Flow: FLOW_OUT
Message-ID: <4abaeb6b-3c6c-4712-9935-0492cc130014@linux.dev>
Date: Fri, 23 Oct 2026 15:42:34 +0800
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
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261022031643.1351877-1-longman@redhat.com>
 <20261022031643.1351877-3-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261022031643.1351877-3-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Longman,

While re-reading and studying this patch, I noticed a few comments
in update_parent_effective_cpumask() that still describe the pre-patch
behavior.

在 2026/10/22 11:16, Waiman Long 写道:
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
>  kernel/cgroup/cpuset.c                        | 36 +++++++++----------
>  .../selftests/cgroup/test_cpuset_prs.sh       |  6 ++++
>  2 files changed, 22 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 7ead8c3b7974..db6e4663f4be 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1798,7 +1798,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,

The function doc header above says:

    Otherwise, effective_xcpus is assumed to remain the same.

With this patch applied, the no-newmask path recomputes the effective
xcpus via compute_excpus() and invalidates the partition when the
result is empty, so that sentence no longer matches the actual
behavior. Maybe:

    Otherwise, the requested cpu list is unchanged, but the effective
    xcpus is recomputed and an empty result invalidates the partition.

or some better wording.

>  	int deleting;	/* Deleting cpus from parent's effective_cpus	*/
>  	int old_prs, new_prs;
>  	int part_error = PERR_NONE;	/* Partition error? */
> -	struct cpumask *xcpus = user_xcpus(cs);
>  	int parent_prs = parent->partition_root_state;
>  	bool nocpu;
>  
> @@ -1841,30 +1840,29 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  	if (!newmask && xcpus_empty(cs))
>  		return PERR_CPUSEMPTY;
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
>  	if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
> -		/*
> -		 * Need to call compute_excpus() in case
> -		 * exclusive_cpus not set. Sibling conflict should only happen
> -		 * if exclusive_cpus isn't set.
> -		 */
> -		xcpus = tmp->delmask;
> -		if (compute_excpus(cs, xcpus))
> -			WARN_ON_ONCE(!cpumask_empty(cs->exclusive_cpus));
>  		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
>  
>  		/*
>  		 * Enabling partition root is not allowed if its
>  		 * effective_xcpus is empty.
>  		 */
> -		if (cpumask_empty(xcpus))
> +		if (cpumask_empty(tmp->delmask))
>  			return PERR_INVCPUS;
>  
> -		if (prstate_housekeeping_conflict(new_prs, parent_prs, xcpus, NULL))
> +		if (prstate_housekeeping_conflict(new_prs, parent_prs, tmp->delmask, NULL))
>  			return PERR_HKEEPING;
>  
> -		if (tasks_nocpu_error(parent, cs, xcpus))
> +		if (nocpu)
>  			return PERR_NOCPUS;
>  
>  		/*
> @@ -1876,9 +1874,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  		 *
>  		 * Warn if it is not the case.
>  		 */
> -		cpumask_and(tmp->new_cpus, xcpus, cpu_active_mask);
> +		cpumask_and(tmp->new_cpus, tmp->delmask, cpu_active_mask);
>  		WARN_ON_ONCE(!cpumask_subset(tmp->new_cpus, parent->effective_cpus));
> -
>  		deleting = true;
>  	} else if (cmd == partcmd_disable) {

The comment in this partcmd_disable branch still refers to "xcpus",

    /* ... xcpus may contain CPUs that shouldn't be removed ... */

but the xcpus variable is removed by this patch.

>  		/*
> @@ -1973,7 +1970,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  		 * A partition error happens when parent has tasks and all
>  		 * its effective CPUs will have to be distributed out.
>  		 */
> -		if (nocpu) {
> +		if (nocpu || cpumask_empty(tmp->delmask)) {
The header comment of this "partcmd_update w/o newmask" branch above
still says

  /*  delmask = effective_xcpus & parent->effective_cpus ... */

That matched the old code where the branch computed delmask from
user_xcpus() itself. Now delmask comes from the compute_excpus() call
at the top of the function, and the branch only intersects it with
parent->effective_cpus when reviving an invalid partition.

All minor comment updates, of course.

Thanks,
Guopeng
