Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794407954;
	b=JjgcKQvyShvhkduO7MIPLafGnzeM4Mrw1oGDgKKj7axYcGH3i8M3nj9To0PGrfYn0Den
	 oyBrxNRRm7GM08xnGb10mCO6i1TDRxBxuvry5O06dIxZEoLqOrSYfXFYj/kwixEgbMJCY
	 ao/8YI8mCqAUM+QfbQxHX8+FOBMg9Y7rV0ECSm814BD/21OlAu26YH1HS40otNAuzxfOn
	 Hr5UN91D/HCCXx8om9UokTsWnySOM+0RGLsk2CU6sijcClmuPFWbY9JwZD8d67omB1eC6
	 KsPKuKzYauxu13XS5ygYoTBjdbLakh69SsPUFAnWwr6We/AKDz2i69Hl359RsyoqMqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794407954;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=C3oPuDPO0VYHqtguIXd8xVh7hOh8gbzHRPbwL03ijNk=;
	b=2ylZdYUCXuLVsh7YF7wNI9M2N3HYLFyUF3HPoejYd0ZY2FAWPGGIwSDn9dbCz1fgryhr
	 t1n4z147LegF1eRTACylnMwCQ2QjQYW/PbAOp0jOECQjrmxHkox4gs6oUYEBJkGQNCNsi
	 kaB8T51jF2NAQQJlkBNkVnxhkTLQ5apGFWGPsdXpLF9GgNr2EvsleRSpEpZfvWUMAESG4
	 Pqr8K4yYHik8dMxT9Vglkg0KPx99Euba8LtzavSfy+DrI1auD3XDrzpzFO8qf26vY/yPN
	 Hco0Bh75WrMqLNar8ZpZxvr6q7m7IpIj/ahABL1vkUZH591zpEiCLRR/khlZYffCCCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IBMO2sTM;
	arc=none smtp.remote-ip=95.215.58.22
Received: from mta1.migadu.com (out-22.mta1.migadu.com [95.215.58.22])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26334606A32D
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 14:39:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26334606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IBMO2sTM
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Gwi1hqZgtwb2ABl6IdwfrO0Yqa6B/15LvCky+iBgjsw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794407951; v=1; x=1795012751;
 b=IBMO2sTMfo5qMYr8CtYl7y+IZ0uEpWVmEjM2FxMnerRpGv0aTshSn2IzYbSXzqyvHaeQo9vH
 /y+tZAjVH3qup1ekj4T6ivDAH588oMPasTihtN1Gqs9tLkN0/P7lVS8IUMj3nMHqFwzeqACrkQW
 1BM84f0DWpSoQAEOF+iXfhLk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ee14b68a753824d2;
	Wed, 11 Nov 2026 14:39:10 +0000
X-Mizu-Trace-ID: ee14b68a753824d2
X-Migadu-Flow: FLOW_OUT
Message-ID: <271d016b-4597-4b6f-9331-5d53d9a9f3a2@linux.dev>
Date: Wed, 11 Nov 2026 22:39:01 +0800
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
Subject: Re: [PATCH-next v3 1/3] cgroup/cpuset: Correctly set cpus_updated in
 cpuset_hotplug_update_tasks()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
References: <20261111020204.1660055-1-longman@redhat.com>
 <20261111020204.1660055-2-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261111020204.1660055-2-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/11 10:02, Waiman Long 写道:
> When cpuset_hotplug_update_tasks() is called with the conditions that
> remote_partition_disable() has to be called, the cs->effective_cpus will
> be updated such that it matches what is computed in new_cpus. In such
> case, cpus_updated can be incorrectly set to false leading to stale CPU
> afinity remained in the tasks not matching the new cpuset value. Fix that
> by forcing cpus_updated to true after calling remote_partition_disable().
> 
> Fixes: 181c8e091aae ("cgroup/cpuset: Introduce remote partition")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/bug/linux-ab90f7e8-0d60-40ca-83e9-e405075b24d2
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 8a8a424a389f..862864b44960 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4031,7 +4031,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>  {
>  	static cpumask_t new_cpus;
>  	static nodemask_t new_mems;
> -	bool cpus_updated;
> +	bool cpus_updated = false;
>  	bool mems_updated;
>  	int partcmd = -1;
>  	struct cpuset *parent;
> @@ -4044,12 +4044,17 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>  	if (!tmp || !cs->partition_root_state)
>  		goto update_tasks;
>  
> +	/*
> +	 * cpus_updated should be set to true when remote_partition_disable()
> +	 * is called as cs->effective_cpus will be modified.
> +	 */
>  	if (is_remote_partition(cs) && (cpumask_empty(subpartitions_cpus) ||
>  				       (cpumask_empty(&new_cpus) &&
>  					partition_is_populated(cs, NULL)))) {
>  		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
>  		remote_partition_disable(cs, tmp);
>  		compute_effective_cpumask(&new_cpus, cs, parent);
> +		cpus_updated = true;
>  	}
>  
>  	/*
> @@ -4082,7 +4087,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>  	}
>  
>  update_tasks:
> -	cpus_updated = !cpumask_equal(&new_cpus, cs->effective_cpus);
> +	cpus_updated |= !cpumask_equal(&new_cpus, cs->effective_cpus);
>  	mems_updated = !nodes_equal(new_mems, cs->effective_mems);
>  	if (!cpus_updated && !mems_updated)
>  		goto unlock;	/* Hotplug doesn't affect this cpuset */

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
