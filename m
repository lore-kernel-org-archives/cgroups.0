Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794300726;
	b=mTJie9RhLxXu23fhGuP2AmwWB+2ws+4nnLQvWhXRGjQn257g4UtBWkEBC1DWmTWXvNfH
	 iynUe6xa2N1DYspckTfGGX2hXgQhS9XkJ2A/nwdsGTgoXtgFBD1QjVMO9c/+Qkf8qViPs
	 AGVZI4UeREuV8GyzoW4lsy+kDDcvXoxBaVhGr1yJW7pPT+pO9i9IBW3QE+EB0mvjwRPj0
	 cA+AIZs+TvSqYIVOCR/ikQr/QO7WAKUJPIClnY9f78HR0Tdh3Vc7fp/Q9zB0ugh0BA7Zo
	 +d4FkxA181V54rKQjGG98hd4FFVgfhp54xsXuhssk4TEsNXylR0ZUNz3zLMWmUru/zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794300726;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=TxIY8XsQFFLO+ZbM5id8ZpOpV7xTdib7OGBAUjMzQw4=;
	b=u7H5NF8YKbLciuNwwweLFLRBTBcTMwJIdYwWCknGa1RJJFgkb/C2tdYjzG1I387HKnTC
	 XB+b+aqpGj1lMQsgTHY2i63UVtmUvzaxzLsWqQnZJfyK89uqKqH8vxDx43cXX/KEJkJb6
	 LdzH1shtlrBRSOV3ONpsq4ulgMDavk0mA9xQLvFuxICNJRro2oGs3fdWpDHzC6QV1DSot
	 qr4m3YAX8q7+TTbdMn5IdLfHGQimVB2+ffLArWsbt0zvonTZnp+Xx+6UmzIAHceEI9Nia
	 gYqW18jdpVYh5i2cEDHThtXH6BjeNMwoMfMZct4aKdDbv/OmuZDBO5+83lQ+SEKFqNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TQOxZ7w9;
	arc=none smtp.remote-ip=91.218.175.149
Received: from mta0.migadu.com (out-149.mta0.migadu.com [91.218.175.149])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2E2606A326
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 08:52:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A2E2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TQOxZ7w9
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vaYmXHQxTza2NkZwViy4+IUrs3azcnT2fsW4UGTBL+M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794300722; v=1; x=1794905522;
 b=TQOxZ7w9OkP72GCU6Q/Jvs/ZT2HfmQIspArGzwfXkKwz6IY1ASGFnhtSw7tLfuGubYhNLaSa
 GDdEcmoMzL8TQNlY70B+e1496ko9DCBqJImw9vtklmxFXuSyDvnfCTO/GqJKoW1Q302LVNJIxRg
 49YcZXMTFycQv2m3nTLT96EY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6a8d2a76e21fa56e;
	Tue, 10 Nov 2026 08:52:02 +0000
X-Mizu-Trace-ID: 6a8d2a76e21fa56e
X-Migadu-Flow: FLOW_OUT
Message-ID: <44ae3718-5ed2-48a2-94ce-5068d71d6cee@linux.dev>
Date: Tue, 10 Nov 2026 16:51:55 +0800
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
Subject: Re: [PATCH-next v2 3/5] cgroup/cpuset: Fix incorrect partition
 invalidation logic in cpuset_hotplug_update_tasks()
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Sashiko <sashiko-bot@kernel.org>
References: <20261109190955.1398611-1-longman@redhat.com>
 <20261109190955.1398611-4-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261109190955.1398611-4-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/10/2026 3:09 AM, Waiman Long wrote:
> When most of the active CPUs of a system are allocated to
> sub-partitions below the top_cpuset partition, it is possible that a
> CPU offline operation may remove the last active CPU in the top_cpuset
> partition. When that really happens, cpuset_handle_hotplug() will clear
> the subpartitions_cpus to make sure active CPUs are present in the top
> partition and let the other sub-partitions get invalidated and then
> competes for their exclusive CPUs again.
> 
> In cpuset_hotplug_update_tasks(), the current code use
> "cpumask_empty(subpartitions_cpus)" to determine if that partition
> should be invalidated. That is fine if there is only one sub-partition.
> As reported by sashiko that when there are more than one sub-partitions
> and the first sub-partition will get invalidated and then it will
> try to acquire the exclusive CPUs and become valid again. When this
> happens, the subpartitions_cpus will no longer be empty. The remaining
> sub-partitions will assume their exclusive CPUs are safe and proceed
> as normal. As a result, active CPUs owned by those sub-partitions
> remain in both top_cpuset.effective_cpus and the sub-partitions'
> effective_cpus while missing from subpartitions_cpus, breaking partition
> CPU exclusivity and triggering WARN_ON_ONCE() in generate_sched_domains()
> and remote_partition_disable().
> 
> Fix that by checking if the sub-partitions' effective_xcpus are subset
> of subpartitions_cpus to determine if they should be invalidated. Also
> remove the obsolete WARN_ON_ONCE() call in remote_partition_disable().
> 
> Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/bug/linux-bf69cd3c-833a-4599-a1f9-8dd9e044cd7c
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   kernel/cgroup/cpuset.c | 19 +++++--------------
>   1 file changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3955d2d574cf..e9b84671af21 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1766,15 +1766,6 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>   static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
>   {
>   	WARN_ON_ONCE(!is_remote_partition(cs));
> -	/*
> -	 * When a CPU is offlined, top_cpuset may end up with no available CPUs,
> -	 * which should clear subpartitions_cpus. We should not emit a warning for this
> -	 * scenario: the hierarchy is updated from top to bottom, so subpartitions_cpus
> -	 * may already be cleared when disabling the partition.
> -	 */
> -	WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus) &&
> -		     !cpumask_empty(subpartitions_cpus));
> -
>   	spin_lock_irq(&callback_lock);
>   	cs->remote_partition = false;
>   	partition_xcpus_del(cs->partition_root_state, NULL, cs->effective_xcpus);
> @@ -4020,9 +4011,9 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   	 * or update_parent_effective_cpumask() is called as cs->effective_cpus
>   	 * may have been updated.
>   	 */
> -	if (is_remote_partition(cs) && (cpumask_empty(subpartitions_cpus) ||
> -				       (cpumask_empty(&new_cpus) &&
> -					partition_is_populated(cs, NULL)))) {
> +	if (is_remote_partition(cs) &&
> +	    (!cpumask_subset(cs->effective_xcpus, subpartitions_cpus) ||
> +	     (cpumask_empty(&new_cpus) && partition_is_populated(cs, NULL)))) {
>   		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
>   		remote_partition_disable(cs, tmp);
>   		compute_effective_cpumask(&new_cpus, cs, parent);
> @@ -4035,12 +4026,12 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   	 * 1) empty effective cpus but not valid empty partition.
>   	 * 2) parent is invalid or doesn't grant any cpus to child
>   	 *    partitions.
> -	 * 3) subpartitions_cpus is empty.
> +	 * 3) effective_xcpus isn't a subset of subpartitions_cpus.
>   	 */
>   	if (is_local_partition(cs) &&
>   	    (!is_partition_valid(parent) ||
>   	     tasks_nocpu_error(parent, cs, &new_cpus) ||
> -	     cpumask_empty(subpartitions_cpus)))
> +	     !cpumask_subset(cs->effective_xcpus, subpartitions_cpus)))
>   		partcmd = partcmd_invalidate;
>   	/*
>   	 * On the other hand, an invalid partition root may be transitioned

LGTM.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong

