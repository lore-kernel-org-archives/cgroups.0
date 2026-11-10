Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.185
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794300034;
	b=uB+c4Faz/DBCKsSglz8uBFp4OpRTFgHbzssKk5Mb+tj8O0huS+xoSOkHARqVk88ZXG+s
	 T1aDoA+BSkvkIjxTc+8zIkDL1G+1l7ItvBEfUlpHrT7YrWh2HryO1OPOz7AQ7vCtvGxI8
	 z/Fwd9BvQHHv+eW1apmtl6No1vuRikamy5MrkUOJabonf7B3n3RW5n1Sitw8CeKusoEj+
	 flzakDGZyZp1Ep5u9M13q/IXKLVe+mH+oZ9S2pdHNZU+tzojH98HExt/4ln+k7BHvfFzl
	 NzRmFq21WIPD+9Dt95PQpKyD1DBpho5r2XKAvCQWHfi60qGr8bRA6GK5yPmLaOchrSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794300034;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Kuuk/hrD7Y5kBgo1UUEL20dkTIOAGPjE8cjvVVCmqM8=;
	b=2qKZeZLEyWOkVxkGXQN+8MDDqTd3x9uJhlx4ohX+n/abVoM6o3r+tOpmJtpJ0k/LyO5w
	 IzH4uisM+cmO1GcAauBSvzxzv7XsWtvj8n3HPqrcgsN7vkZXp5tXZeJrS0T2HeH0dZKbe
	 ciT9W0jnoNbp1EgUL7EveIi4/attFBERwHynT26oBFcmvchifuJ97xNHqzTNcL5RxW4q/
	 t4xJHPz+8viNkLj2Zn0bVXPitPS4weOFc32EGqqAHOHnQDzcUJ6kXoKOU9MJpXDkSmp8c
	 lMBDbYD0QbxgP6hvTuSFaFdJDbbHhYA0/VYBUngL0qHDP32HCOOGyBdfLNsF/ivYYzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="MeEgI13/";
	arc=none smtp.remote-ip=91.218.175.185
Received: from mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD89A606A32A
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 08:40:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD89A606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MeEgI13/
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+BDtNKQAcgvK1t7SdHiV+auWUziT0f+nSZmIK+DU/cc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794300030; v=1; x=1794904830;
 b=MeEgI13/jXZpugEa8xwaYdHQdHhqOWcuWPvcdt8wICUwqvVEYSG3Fe7mjdYS0N0N7S2KUQWM
 oOy6qL++UY/ePaIJGNStTDQDFwHguZ0GUoBahMuRqy+pEroXhOAIbsLgsnGWyGOM9pzM9bH38MK
 0pVB6Rr9gt2CQxrzm+B1gtKo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 41afd226588cedd8;
	Tue, 10 Nov 2026 08:40:25 +0000
X-Mizu-Trace-ID: 41afd226588cedd8
X-Migadu-Flow: FLOW_OUT
Message-ID: <d66ec8aa-fb96-42de-a9a0-5b5aa29f1083@linux.dev>
Date: Tue, 10 Nov 2026 16:40:18 +0800
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
Subject: Re: [PATCH-next v2 2/5] cgroup/cpuset: Correctly set cpus_updated in
 cpuset_hotplug_update_tasks()
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Sashiko <sashiko-bot@kernel.org>
References: <20261109190955.1398611-1-longman@redhat.com>
 <20261109190955.1398611-3-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261109190955.1398611-3-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/10/2026 3:09 AM, Waiman Long wrote:
> When cpuset_hotplug_update_tasks() is called with the conditions that
> either remote_partition_disable() or update_parent_effective_cpumask()
> has to be called, the cs->effective_cpus can be updated such that it
> matches what is computed in new_cpus. In such case, cpus_updated can
> be incorrectly set to false leading to stale CPU afinity remained in the
> tasks not matching the new cpuset value. Fix that by forcing cpus_updated
> to true whenever one of these partition helpers is being called.
> 
> Fixes: 4b842da276a8a ("cpuset: Make CPU hotplug work with partition")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/bug/linux-ab90f7e8-0d60-40ca-83e9-e405075b24d2
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   kernel/cgroup/cpuset.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 6074327c3477..3955d2d574cf 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4002,7 +4002,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   {
>   	static cpumask_t new_cpus;
>   	static nodemask_t new_mems;
> -	bool cpus_updated;
> +	bool cpus_updated = false;
>   	bool mems_updated;
>   	int partcmd = -1;
>   	struct cpuset *parent;
> @@ -4015,12 +4015,18 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   	if (!tmp || !cs->partition_root_state)
>   		goto update_tasks;
>   
> +	/*
> +	 * cpus_updated should be set to true when remote_partition_disable()
> +	 * or update_parent_effective_cpumask() is called as cs->effective_cpus
> +	 * may have been updated.
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
> @@ -4045,6 +4051,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   		partcmd = partcmd_update;
>   
>   	if (partcmd >= 0) {
> +		cpus_updated = true;
>   		update_parent_effective_cpumask(cs, partcmd, NULL, tmp);
>   		if (is_partition_valid(cs) || (partcmd == partcmd_invalidate)) {
>   			compute_effective_cpumask(&new_cpus, cs, parent);
> @@ -4053,7 +4060,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   	}
>   
>   update_tasks:
> -	cpus_updated = !cpumask_equal(&new_cpus, cs->effective_cpus);
> +	cpus_updated |= !cpumask_equal(&new_cpus, cs->effective_cpus);
>   	mems_updated = !nodes_equal(new_mems, cs->effective_mems);
>   	if (!cpus_updated && !mems_updated)
>   		goto unlock;	/* Hotplug doesn't affect this cpuset */

I think the issue only happens in the remote partition case.
remote_partition_disable() calls reset_partition_data(), which sets
cs->effective_cpus to what compute_effective_cpumask() will return
afterwards, so the cpumask_equal() check misses the change while the
tasks still have the old affinity.

update_parent_effective_cpumask() only updates the effective_cpus of
the parent (through partition_xcpus_add/del()), and cs is skipped in
update_sibling_cpumasks(). So cs->effective_cpus isn't changed there and
the original check still works. If new_cpus is the same as
cs->effective_cpus in that case, forcing cpus_updated just walks all the
tasks in cs and calls set_cpus_allowed_ptr() with their current mask.
Should cpus_updated only be set in the remote partition case?

Also, as the problem comes from remote_partition_disable() in the
hotplug path, should the Fixes tag be the following instead?

Fixes: 181c8e091aae ("cgroup/cpuset: Introduce remote partition")

-- 
Best regards
Ridong

