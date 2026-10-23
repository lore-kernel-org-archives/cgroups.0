Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.142
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792735417;
	b=skHkp3mugpMASLWOgZCKknAJ9gAjwrtMbyM2YN8cIxYaTQjRsOQN2xEVxp1avB27ZtlK
	 drsXyzlvG4YBxsyxN+ijqQBNU4/azh3YxZzLLHIAnUhBHbyrwV4dkS0x90ZjgdWLvirGB
	 g//hvpWnrEsBZV3aWbBkfflK2MdDC81VaaaIAWLutOndCRo+Y+mRkobaC4qrOh9EyoLoO
	 6x7yP4flzsh7+GfGPMSuBw7xotUcuJjRCZwbUAYJAXZiC2IFKtZgQJuqdfDOCi0f1fqzA
	 8nYh8EqezOjdPizPJjMkpaPASmw0lgZkvVoWZt2XycvrkzD/urFuDKRVsr0e9dkW11g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792735417;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=PC3ZZDQZUTFeURvR4AH26rMTLMMkDl4TcNOzKpehmZE=;
	b=5oWSce9H3zIvKBA9HxSTv+Iwj4NRwEFXRXcv1M5x6w8EeIWHiOD1mvYvOxSm8fpA7XAe
	 6KMj9rzI90J5qD0ebdV9ZWwupzKDpGfYT1uZAfaX59yVoiSGqwvoXtJ/EnbgiWhhlmupx
	 FpEnBvqs4vrppqhP/hk3A6/h56w7XEDPGr7RXQg2v+Y3ozl4ZoiJ/lBm+Xeerd32MTHVs
	 DxjzA/0Hm0SQOpsDfH32au5gyGD0cXJxY10P5I19cHJ3eoCuuXYYqzCwT7IEkI6Q/6ERx
	 GbchHdQNTSeH3syATethbXtspRUTChWcso6wlWiEKh6zkCuOWwe2jvMo3g3b0CCoDcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xJt2x0IC;
	arc=none smtp.remote-ip=91.218.175.142
Received: from mta0.migadu.com (out-142.mta0.migadu.com [91.218.175.142])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B27A606A31B
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 06:03:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B27A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xJt2x0IC
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1MKzGrMK1ohuiL+HWRltCYwIWtpp8h4CzZvoqB3nnHo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792735407; v=1; x=1793340207;
 b=xJt2x0IC93mXffHa/AHR309CPeQIvCPslk8M0a05Y5Ej5WBFNkVBiqdWqXTPx5eoqNA5kLQt
 yOpm1mtdlyZlv1dJayHD3F5vHUWEWcdsMULje/UBQQG4CkXZ8DMcbMyVudlhNyQ99USED0jqVxv
 bGdaluI9KlDWYpTqwQn7d0Qk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2690efadeba37ef1;
	Fri, 23 Oct 2026 06:03:27 +0000
X-Mizu-Trace-ID: 2690efadeba37ef1
X-Migadu-Flow: FLOW_OUT
Message-ID: <47c16837-728b-4127-9d41-ff4ec7f02712@linux.dev>
Date: Fri, 23 Oct 2026 14:03:18 +0800
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
Subject: Re: [PATCH] cgroup/cpuset: check effective mems for a movable-only
 configuration
To: "Gregory Price (Meta)" <gourry@gourry.net>, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, longman@redhat.com,
 tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 akpm@linux-foundation.org, feng.79.tang@gmail.com, mhocko@suse.com
References: <20261022043943.3125239-1-gourry@gourry.net>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261022043943.3125239-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/22/2026 12:39 PM, Gregory Price (Meta) wrote:
> check_insane_mems_config() warns and enables cpusets_insane_config_key
> when a cpuset's tasks can allocate only from movable memory.
> 
> In cgroup v2 the request may name a memoryless node, which has no zones
> and cpusets reports it as a movable-only nodemask.
> 
> For example, with node 2 a CPU-only node:
> 
>    # echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
>    # mkdir /sys/fs/cgroup/test
>    # echo 2 > /sys/fs/cgroup/test/cpuset.mems
>    # cat /sys/fs/cgroup/test/cpuset.mems.effective
>      0-1
>    # dmesg
>      Unsupported (movable nodes only) cpuset configuration detected (nmask=2)!
> 
> This is a bit confusing, especially consider mems.effective ends up with
> a valid nodemask by-design (cpuset.mems is treated as-if it were empty).
> 
> Check each new effective mask in update_nodemasks_hier() instead, as the
> hotplug path already does. The allocator's bail-out tests the task's
> mems_allowed, which comes from the effective mask.
> 
> A request naming a movable-only not present in the parent's nodemask
> no longer warns (since, again, the cpuset.mems gets overridden and
> treated as empty). However, it will warn if the parent's mems include
> the node later.
> 
> For Example, with node 3 a movable-only node:
> 
>    # echo 0 > /sys/fs/cgroup/test/cpuset.mems
>    # echo 3 > /sys/fs/cgroup/test/child/cpuset.mems
>    # cat /sys/fs/cgroup/test/child/cpuset.mems.effective
>      0
>    # dmesg
>      { empty }
>    # echo 0,3 > /sys/fs/cgroup/test/cpuset.mems
>    # cat /sys/fs/cgroup/test/child/cpuset.mems.effective
>      3
>    # dmesg
>      Unsupported (movable nodes only) cpuset configuration detected (nmask=3)!
> 
> Fixes: 8ca1b5a49885 ("mm/page_alloc: detect allocation forbidden by cpuset and bail out early")
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>   kernel/cgroup/cpuset.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 8ee239d5c6b48..70fbece1b9399 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2795,6 +2795,8 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
>   			continue;
>   		rcu_read_unlock();
>   
> +		check_insane_mems_config(new_mems);
> +
>   		spin_lock_irq(&callback_lock);
>   		cp->effective_mems = *new_mems;
>   		spin_unlock_irq(&callback_lock);
> @@ -2848,8 +2850,6 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
>   	if (retval < 0)
>   		return retval;
>   
> -	check_insane_mems_config(&trialcs->mems_allowed);
> -
>   	spin_lock_irq(&callback_lock);
>   	cs->mems_allowed = trialcs->mems_allowed;
>   	spin_unlock_irq(&callback_lock);

LGTM.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong

