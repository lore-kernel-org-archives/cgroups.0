Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.213
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701623;
	b=nqN/ozINfDWkm5XYwAtImp/Xy6xENqwlhWnBRz3B+UKD0yvMjkapDs2km3Eew7615Ocg
	 SMkl5BskFWLWfFGz8/JXqCXXp/kWaGR2MXryejt9sonqnu2ErchxJlJdvcMDRRd6Pkxvi
	 M5+dVF1u/hg+VURH/5NRmCHjO8SDsU+yrzu23H5oX3szelwS7TG2Nw86Ic+f+cgH9y0a3
	 at52fRmOLD6NE71YiyhuKO8APxe7ekBMLPMgtuRhkDp5CHnXBJFQybsbs08T9MHRX84E1
	 BbT7/DNVG/bamH1qWVZzHNVa60fUuEURUal0ULSgQ4nDmWujAa8YrhFb9I6beRf3xmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701623;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=BLOHIiVh9KScUX9/k8FRamlay1WjAQp1p19oFBHTvH0=;
	b=vvYynu5VK56WjwQ+4QBciAy6lN6Y1ZTosPYZkO3/9u4gbUz/khJfexUpasYIPzXvRIOs
	 BWq1p90CvNvPjEkaNtP6YOK/rMqCH5eb0yrKU2JuLu7KxLlsaqEs534yX63B4LhuoU7sn
	 GOCSJAof1F3vHN0qwF0M+OL5Gji9qvqflmRS2bcUzlFd/z5oz/uEGrqsYyZ+RfXPsgg3f
	 lvJ363hRNC1cRcDRtfwNB0oav74anh8zn9/3QK0UOmyz4R0glkJZJTjsxOOANBijkmcNn
	 /UYQuzefwKYt/tlkv3VkgdUX3s5krTXKi15fERR22FzVvdIHUZOK1BIBJbJ6nto126Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fPiRBSRl;
	arc=none smtp.remote-ip=95.215.58.213
Received: from mta1.migadu.com (out-213.mta1.migadu.com [95.215.58.213])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9160C60850A5
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 10:27:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9160C60850A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fPiRBSRl
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uVhKCRPYYUCTxuKfKCPJrKjYgbdLJ824hxS2eudo/Zs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793701620; v=1; x=1794306420;
 b=fPiRBSRlYy3Vwo05AqVUHNNpp7hOU01Q5k8fWY4sK1OLGosAScUMJk8UgUdgMvZxGiXfyPaL
 nhAsKxscf0JylJA3H5Pojz4zQjNCw294rJmrnznqQpDFVnkzfs9QCQAluKQcsiiB4kfNiZOuIKp
 ZAZ9DS6S43B9+zcNVcRzJMH4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 46b14ca827d6b28a;
	Tue, 03 Nov 2026 10:27:00 +0000
X-Mizu-Trace-ID: 46b14ca827d6b28a
X-Migadu-Flow: FLOW_OUT
Message-ID: <b2caa92c-9e10-4e36-bd73-b71621d60108@linux.dev>
Date: Tue, 3 Nov 2026 18:26:51 +0800
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
Subject: Re: [RFC PATCH -v4 04/22] cpuset: introduce partition_enable()
To: Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutn? <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chen Ridong <chenridong@huawei.com>, Ridong Chen <chenridong@xiaomi.com>
References: <20261101114206.2434398-1-ridong.chen@linux.dev>
 <20261101114206.2434398-5-ridong.chen@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261101114206.2434398-5-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/1 19:41, Ridong Chen 写道:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Add partition_enable() to consolidate updates to key cpuset structures
> during partition enablement, including:
> 1. remote_partition
> 2. effective_xcpus
> 3. partition_root_state
> 4. prs_err
> 
> Key operations performed:
> 1. Invokes partition_xcpus_add() to assign exclusive CPUs
> 2. Maintains remote partition flag
> 3. Syncs the effective_xcpus mask
> 4. Updates partition_root_state and prs_err
> 5. Triggers scheduler domain rebuilds
> 6. Sends partition change notifications
> 
> This helper also handles the transition between root and isolated
> states of a valid partition. In that case the cpumasks are unchanged
> and only isolated_cpus is updated.
> 
> A partition_state_update() helper is added to set partition_root_state
> and prs_err, and to reset the partition data when the new state is not
> a valid partition.
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  kernel/cgroup/cpuset.c | 51 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index df52f6e5e99f..052a131731dd 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1716,6 +1716,57 @@ static void compute_effective_nodemask(nodemask_t *new_mems,
>  		nodes_copy(*new_mems, parent->effective_mems);
>  }
>  
> +static void partition_state_update(struct cpuset *cs, int new_prs,
> +				   enum prs_errcode prs_err)
> +{
> +	lockdep_assert_held(&callback_lock);
> +
> +	cs->partition_root_state = new_prs;
> +	WRITE_ONCE(cs->prs_err, prs_err);
> +	if (!is_partition_valid(cs))
> +		reset_partition_data(cs);
> +}
> +
> +/**
> + * partition_enable - Transitions a cpuset to a partition root
> + * @cs: The cpuset to enable partition for
> + * @parent: Parent cpuset of @cs, NULL for remote parent
> + * @new_prs: New partition state to set
> + * @new_excpus: New effective exclusive CPUs mask for the partition
> + *
> + * Transitions a cpuset to a partition root, only for v2.
> + * It also supports the transition between root and isolated partition.
> + */
> +static void partition_enable(struct cpuset *cs, struct cpuset *parent,
> +			     int new_prs, struct cpumask *new_excpus)

Should we consider the bisection case here? With CONFIG_WERROR=y this
patch fails to build on its own — partition_enable() is defined but not
used.

Thanks,
Guopeng

> +{
> +	int old_prs = cs->partition_root_state;
> +
> +	lockdep_assert_cpuset_lock_held();
> +	WARN_ON_ONCE(new_prs <= 0);
> +	WARN_ON_ONCE(!cpuset_v2());
> +
> +	if (old_prs == new_prs)
> +		return;
> +
> +	spin_lock_irq(&callback_lock);
> +	if (old_prs > 0) {
> +		/* Switch between root and isolated, cpumasks are unchanged */
> +		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
> +	} else {
> +		/* enable partition should only add exclusive cpus */
> +		partition_xcpus_add(new_prs, parent, new_excpus);
> +		/* enable remote partition */
> +		if (!parent)
> +			cs->remote_partition = true;
> +		cpumask_copy(cs->effective_xcpus, new_excpus);
> +	}
> +	partition_state_update(cs, new_prs, PERR_NONE);
> +	spin_unlock_irq(&callback_lock);
> +	cpuset_force_rebuild();
> +	notify_partition_change(cs, old_prs);
> +}
> +
>  /*
>   * remote_partition_enable - Enable current cpuset as a remote partition root
>   * @cs: the cpuset to update

