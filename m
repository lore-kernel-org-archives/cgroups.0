Received: from mta1.migadu.com (out-138.mta1.migadu.com [95.215.58.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFB643F8A5
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 09:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788513744; cv=none; b=nburGxRwQLnz/BBLdIt68gD3wZtzMcJHs6hK8qzJK3CaKIaSdjr5HXMjGpj3npID5nEa3PgFT6rNmB0Vn5odPWAvGHq28JMG2/76rvV8rrckOIeV9aEuuzOznu3JpnrBkBpV0O5ZEQb3hUm2gbHBI0R87bNukkm3RjElxTdklk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788513744; c=relaxed/simple;
	bh=XNzKjHkngtqCqjAb20SyRUTjszAkf7AltK/o8l/wh4c=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZoWjEPtfDnsE8qqxFyHaWqH1gVTcqRzkUTfg6SQVLcLmVE8wzZNfdx61D+g4WIKMOjgbmdSwxpuMgaxvXGi1eZqznw/ft5ulpoQjbT3n8oa8v7iyjJEY4/rDAtc9l4a9FXK/ZZyK1dyQdVbI1yCRzoyGjF+cqNuAJiSeiBljoao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jliOTdxF; arc=none smtp.client-ip=95.215.58.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jliOTdxF"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XNzKjHkngtqCqjAb20SyRUTjszAkf7AltK/o8l/wh4c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788513720; v=1; x=1789118520;
 b=jliOTdxFdYOZ523Ol/7jwNqyhcK0HU6euwaS4w3sdOU+PTG1z1P4JzL+WfoNJeh5KCXt5Exw
 v0RkuFBpw6+D2R5ZOkXs91Gw0QEYBZWkO5kagk9sjHjUYxlToHVSfSF62tDlFjUflyXpkqMWtce
 kVvdtQ88SbF5hOhDmWaRcEaE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4d2c5bf555aa2c40;
	Fri, 04 Sep 2026 09:21:50 +0000
X-Mizu-Trace-ID: 4d2c5bf555aa2c40
X-Migadu-Flow: FLOW_OUT
Message-ID: <ce007c25-8d49-4df4-9508-3af911f90eb7@linux.dev>
Date: Fri, 4 Sep 2026 17:21:42 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, bsegall@google.com, cgroups@vger.kernel.org,
 corbet@lwn.net, dietmar.eggemann@arm.com, hannes@cmpxchg.org,
 juri.lelli@redhat.com, kprateek.nayak@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 mgorman@suse.de, mingo@redhat.com, peterz@infradead.org,
 rostedt@goodmis.org, skhan@linuxfoundation.org, tj@kernel.org,
 vincent.guittot@linaro.org, vschneid@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] sched/fair: Remove the write-order dependency
 between cpu.max and cpu.max.burst
To: Zhe Liu <liuzhe1@kylinos.cn>, mkoutny@suse.com
References: <aobnZEh1hfIBhswD@localhost.localdomain>
 <20260904062013.504236-1-liuzhe1@kylinos.cn>
 <20260904062013.504236-2-liuzhe1@kylinos.cn>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260904062013.504236-2-liuzhe1@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi, Zhe,

在 2026/9/4 14:20, Zhe Liu 写道:
> Keep the configured burst independent of the current quota and cap it
> when CFS refills runtime. This allows quota and burst updates in either
> order.
> 

Ran the selftests on next-20260903 in a VM: all 10 test_cpu cases pass
with the series applied, and test_cpucg_max_burst fails on the unpatched
kernel, so the test does catch the old behavior.

One problem (spotted by sashiko, an automated overflow checker; I
re-did the arithmetic): dropping the burst_us + quota_us <=
max_bw_runtime_us check is not safe. With quota and burst both near
MAX_BW, the period-scaling path in sched_cfs_period_timer() can double
both up to 512x, and the new clamp quota + min(burst, quota) in
__refill_cfs_bandwidth_runtime() then wraps u64 to 0, leaving the group
with zero runtime on every refill.

I believe you can just drop the burst_us > quota_us comparison and keep
the sum check. Both write-order cases still pass that way: burst=80ms
with quota=50ms gives 130ms, well under the limit.

Tested-by: Tao Cui <cuitao@kylinos.cn>

> Fixes: f4183717b370 ("sched/fair: Introduce the burstable CFS controller")
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
> ---
>  kernel/sched/core.c | 3 +--
>  kernel/sched/fair.c | 3 ++-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index f78275192036..5269b8cfcf7f 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -10159,8 +10159,7 @@ static int tg_set_bandwidth(struct task_group *tg,
>  	if (quota_us != RUNTIME_INF && quota_us > max_bw_runtime_us)
>  		return -EINVAL;
>  
> -	if (quota_us != RUNTIME_INF && (burst_us > quota_us ||
> -					burst_us + quota_us > max_bw_runtime_us))
> +	if (burst_us > max_bw_runtime_us)
>  		return -EINVAL;
>  
>  #ifdef CONFIG_CFS_BANDWIDTH
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 6d881e530f89..488de18d477e 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6627,7 +6627,8 @@ void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
>  		cfs_b->nr_burst++;
>  	}
>  
> -	cfs_b->runtime = min(cfs_b->runtime, cfs_b->quota + cfs_b->burst);
> +	cfs_b->runtime = min(cfs_b->runtime,
> +			     cfs_b->quota + min(cfs_b->burst, cfs_b->quota));
>  	cfs_b->runtime_snap = cfs_b->runtime;
>  }
>  

