Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.78
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793007873;
	b=iSeTV++p3K5OFdxEmbT4WuxcKiHKcH9KjBTEe1Hs4WrL22OdHnmOowQHkuo10JEu6fhi
	 LurlFBkZPTvbB9yaynZXUdJ9KXRZV42cAEhYsnHB8HK/5fVWyXlRqd4qb1zFkbulZSvjR
	 n5RAg0YttPqJqXM+3GLTPGodQ7/I0RnktbdrLXzzYJ6C9nKtC5n8HTxA7wTOno0qHFb/w
	 itBvVJAqBo86T3R30RISb5SdN23zbMC+FIov3BlvMHudQK22J4Pvyv7Platp4YC+N+8s2
	 tZGTkGdaEKQ1Oy3BjHFLCf7iohBYB6XFERVPyG03vxoMvfcWIU8korIhzdFabX/6tXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793007873;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=D0vHwRSblGt0gwstuQ1Buqrn2lVuEmdLN4fWQhtatD4=;
	b=PSTD2FVdjxRZWL7Tbne5trhOW4sICQ8AesstLkfGHXhM++qXyRARf1PMYiglryC6Yeac
	 44kYhjgOcqywX3o7U4RuHcGOIZ5H8saNkPHhGo1IAZs3pt50p5HZNO3yL+7SOZlayTL3s
	 jMyaaP0endIv4lqTndFP9iVFYQGdPsaW6r76b/FVbVUtajFek2TVMTjTTY2K5BFuaGRU1
	 P/OfF8aIo5reF645WFw1P5niNWqTerpek5pI+0x9PHpCWlkEVBdDQGZcds2V8TH9W/0Nr
	 iV+ACR/Llg1dZqdD5daduJ1wcG9r7Qz60pI0IcrVCi47AW83XwUxIDaAQonsTQjmjnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bSjOMoUN;
	arc=none smtp.remote-ip=91.218.175.78
Received: from mta0.migadu.com (out-78.mta0.migadu.com [91.218.175.78])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A69606A33F
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 09:44:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5A69606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bSjOMoUN
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=d8PN0Ac6T7SMrev3Gfq3IX7vzOzJ8svErGB9LxGMOXM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793007870; v=1; x=1793612670;
 b=bSjOMoUNEgjxgQcV62RXZf3YTyPEmXoHexHrXMNdzGiMAt3iLoqg15ueXMw2EibtgBgXmJK/
 aeDp93kTVohHInkYYH+KBhQGEoHf7F5ABirernhh5+Jp68lghJoQMFpGzFOks9JkQvMyKvrnDb/
 0MQHANAbFYw6NojfQuuiCuHY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a986f198c5218d38;
	Mon, 26 Oct 2026 09:44:30 +0000
X-Mizu-Trace-ID: a986f198c5218d38
X-Migadu-Flow: FLOW_OUT
Message-ID: <dac64e77-60b8-47ec-935e-6aea1b38acf0@linux.dev>
Date: Mon, 26 Oct 2026 17:44:22 +0800
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
Subject: Re: [PATCH-next v3 11/11] cgroup/cpuset: Integrate
 compute_partition_effective_cpumask() into compute_effective_cpumask()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261025214449.310715-1-longman@redhat.com>
 <20261025214449.310715-12-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261025214449.310715-12-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/26 05:44, Waiman Long 写道:
> Update compute_effective_cpumask() to call
> compute_partition_effective_cpumask() directly if the given cpuset is
> a valid remote or local partition root. This simplifies the call sites
> where they are being involved. No functional change is expected.
> 
> Suggested-by: Ridong Chen <ridong.chen@linux.dev>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 37 ++++++++++---------------------------
>  1 file changed, 10 insertions(+), 27 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index f37d929616a6..2598a0e2d667 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1606,8 +1606,6 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>  	struct cpuset *child;
>  	bool populated = partition_is_populated(cs, NULL);
>  
> -	WARN_ON_ONCE(!is_partition_valid(cs));
> -
>  	/*
>  	 * Check child partition roots to see if they should be invalidated
>  	 * when all the effective_cpus will be used up and cs is populated.
> @@ -1668,6 +1666,10 @@ static void compute_effective_cpumask(struct cpumask *new_cpus,
>  {
>  	bool has_cpus;
>  
> +	if (is_remote_partition(cs) ||
> +	    (is_partition_valid(cs) && is_partition_valid(parent)))
> +		return compute_partition_effective_cpumask(cs, new_cpus);
> +
>  	has_cpus = cpumask_and(new_cpus, cs->cpus_allowed, parent->effective_cpus);
>  	if (!has_cpus && is_in_v2_mode())
>  		cpumask_copy(new_cpus, parent->effective_cpus);
> @@ -2268,10 +2270,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>  			remote = (new_prs == old_prs);
>  		}
>  
> -		if (remote || (is_partition_valid(parent) && is_partition_valid(cp)))
> -			compute_partition_effective_cpumask(cp, tmp->new_cpus);
> -		else
> -			compute_effective_cpumask(tmp->new_cpus, cp, parent);
> +		compute_effective_cpumask(tmp->new_cpus, cp, parent);
>  
>  		if (remote)
>  			goto get_css;	/* Ready to update cpuset data */
> @@ -2352,10 +2351,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>  			 */
>  			new_prs = cp->partition_root_state;
>  			if (new_prs != old_prs) {
> -				if (new_prs > 0)
> -					compute_partition_effective_cpumask(cp, tmp->new_cpus);
> -				else
> -					compute_effective_cpumask(tmp->new_cpus, cp, parent);
> +				compute_effective_cpumask(tmp->new_cpus, cp, parent);
>  			}
>  		}
>  
> @@ -3987,7 +3983,6 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>  	static nodemask_t new_mems;
>  	bool cpus_updated;
>  	bool mems_updated;
> -	bool remote;
>  	int partcmd = -1;
>  	struct cpuset *parent;
>  
> @@ -3999,21 +3994,12 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>  	if (!tmp || !cs->partition_root_state)
>  		goto update_tasks;
>  
> -	/*
> -	 * Compute effective_cpus for valid partition root, may invalidate
> -	 * child partition roots if necessary.
> -	 */
> -	remote = is_remote_partition(cs);
> -	if (remote || (is_partition_valid(cs) && is_partition_valid(parent)))
> -		compute_partition_effective_cpumask(cs, &new_cpus);
> -
> -	if (remote && (cpumask_empty(subpartitions_cpus) ||
> -			(cpumask_empty(&new_cpus) &&
> -			 partition_is_populated(cs, NULL)))) {
> +	if (is_remote_partition(cs) && (cpumask_empty(subpartitions_cpus) ||
> +				       (cpumask_empty(&new_cpus) &&
> +					partition_is_populated(cs, NULL)))) {
>  		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
>  		remote_partition_disable(cs, tmp);
>  		compute_effective_cpumask(&new_cpus, cs, parent);
> -		remote = false;
>  	}
>  
>  	/*
> @@ -4039,10 +4025,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>  
>  	if (partcmd >= 0) {
>  		update_parent_effective_cpumask(cs, partcmd, NULL, tmp);
> -		if (is_partition_valid(cs)) {
> -			compute_partition_effective_cpumask(cs, &new_cpus);
> -			cpuset_force_rebuild();
> -		} else if (partcmd == partcmd_invalidate) {
> +		if (is_partition_valid(cs) || (partcmd == partcmd_invalidate)) {
>  			compute_effective_cpumask(&new_cpus, cs, parent);
>  			cpuset_force_rebuild();
>  		}

Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
