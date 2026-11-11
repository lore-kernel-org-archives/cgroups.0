Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.129
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794402065;
	b=RwP9Ozr4GuO5QJH60ii9/i5jq6W+qoYvX29Fans59dn5bfO6Y3PaLIdOi05/961UfnF4
	 eXD9geT8Uvno4Tmgg0PiOI4uPzI4W9NxwUPyeeMccN8EUAL2/51szSwCPoFksf1yxFNvn
	 T0tl2hd+awFLCej3A2MwN2gwd+SRxQRthC+x74hWXdScpUQNy+aS4VxP8f6ypltyr0ZAZ
	 2ku+fAmH1FLG67063vuMD+sdbFNfIFS+8JYD+NHArmYk9b2MHBusBKSrjsCsw4yEJLZr6
	 qZkUflkhqyLzt/WKNUK+8lNy2bIG///u8YwC9Fn1mlRH4eilyCguD9QzZ3d7aMGe/5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794402065;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=MGhwOVfEFbGlg5V7wXp/+toXSAI9DHTPbFgkVl/KqBU=;
	b=P6XCyEkpbTZYIZ1qLIU9QT7oQhe2f9Pm4gnJ2P9ea+ES7uLGRHoDQ9kW0ClBfoayt42w
	 dKfvLPlYpaajYnIm4u5qig4BOi5t3c6gtTKG/Im0y7PnhsK9fxfa7LPkxkOL/oJtVbeAo
	 0REw15+e1dj2ShjHaLXms0R2kICtsNN5IZEGh1MPsLnAF6COdNEbt2e5NRWWvNaAeIryD
	 Ve4nGRIlpz6C+4qyigXeDrx/8EzuvJzay9iH9t8Pba6WSlSn1ne8HaCrNPkbW2MukWm75
	 V2NJBpYjpFYWRM1fcG/CkE6Ao59e7cbFUIEs7iK6suGNAdGNChrxyqBMyngZJf53MFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=H2F1q3Jm;
	arc=none smtp.remote-ip=95.215.58.129
Received: from mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80B7606A330
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 13:01:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D80B7606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=H2F1q3Jm
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+SPNyAr5wEcYGYC1BWBrIIIA9wxF2i7BPl3rmhxghqU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794402062; v=1; x=1795006862;
 b=H2F1q3Jm22CV78LqVlByH06lJyEyWANp4deQaUiPcM8E9EGWxejLZdxgpo6EeRJC2jserDq1
 gGYwEppOQGy3O+EkX+OoBBeP5uvnVruJeJhnUL46B/XM36diYedurtBG0iKRkexx91SRA4c325W
 sQFR/zMBUzI//7kuzKnkNSx8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e80b374ed1e391c1;
	Wed, 11 Nov 2026 13:00:58 +0000
X-Mizu-Trace-ID: e80b374ed1e391c1
X-Migadu-Flow: FLOW_OUT
Message-ID: <0e1edfd7-e1a6-4864-81c8-afa2fa9c2d9e@linux.dev>
Date: Wed, 11 Nov 2026 21:00:48 +0800
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
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Sashiko <sashiko-bot@kernel.org>
References: <20261111020204.1660055-1-longman@redhat.com>
 <20261111020204.1660055-2-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261111020204.1660055-2-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/11/2026 10:02 AM, Waiman Long wrote:
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
>   kernel/cgroup/cpuset.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 8a8a424a389f..862864b44960 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4031,7 +4031,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   {
>   	static cpumask_t new_cpus;
>   	static nodemask_t new_mems;
> -	bool cpus_updated;
> +	bool cpus_updated = false;
>   	bool mems_updated;
>   	int partcmd = -1;
>   	struct cpuset *parent;
> @@ -4044,12 +4044,17 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   	if (!tmp || !cs->partition_root_state)
>   		goto update_tasks;
>   
> +	/*
> +	 * cpus_updated should be set to true when remote_partition_disable()
> +	 * is called as cs->effective_cpus will be modified.
> +	 */
>   	if (is_remote_partition(cs) && (cpumask_empty(subpartitions_cpus) ||
>   				       (cpumask_empty(&new_cpus) &&
>   					partition_is_populated(cs, NULL)))) {
>   		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
>   		remote_partition_disable(cs, tmp);
>   		compute_effective_cpumask(&new_cpus, cs, parent);
> +		cpus_updated = true;
>   	}
>   
>   	/*
> @@ -4082,7 +4087,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   	}
>   
>   update_tasks:
> -	cpus_updated = !cpumask_equal(&new_cpus, cs->effective_cpus);
> +	cpus_updated |= !cpumask_equal(&new_cpus, cs->effective_cpus);
>   	mems_updated = !nodes_equal(new_mems, cs->effective_mems);
>   	if (!cpus_updated && !mems_updated)
>   		goto unlock;	/* Hotplug doesn't affect this cpuset */

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong

