Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.167
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794312690;
	b=HV8/+e28eBEDdWdCAh262FYu8PNJHNgq/uS5DE1wrpsZQUonCP3X5XeyCsUr5yWDWDZl
	 uYmloM9EW8hmTGQt8Ev4sNviUTIlfHec3T9rECiMp9+TB4mlWd3sH9brNVsMj95Z8HHe0
	 Pz26/65kbDy8w4Ub6Mjcyz0U7rGWltTgbezBamIgs89dQ5djXqegNMVk62oHYf3zD1itv
	 n4XZAEqmmmpmRBvhDPEPL7gLkwly6MtpttvcuN86h9BzLo/FkpTCFjkoaLLaPu7XQa9w9
	 VVDh/EoYYr21zGYCCaH6ulYW4aBlyfK9bREgGB4Wg80pGJG7R1tKsqFUFzOy4Xup3/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794312690;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=V6y3oj1wdghgriG30314q44VQVQpH2RHL0HCcz8YFiY=;
	b=IzTZ9rNL29WPrkmF7bKkoMevB3a0oNRYi5l+qq1gjTu4L+sKWQThIu3kkFMt3SKUOSYx
	 PzfpT4lMDx0xJEwHlMsZA9Lgc5MC+Wk2Y6sq+rmzUr0WVC5LKANKaUU4Mc7Z23mNy8pDF
	 uLagBGbHmqOjhBcWtmtNxaebwEGLmc7T4ZrleaEX5jFZz2L17PNF0VE2N4CrM2WPx2PCN
	 wxzxwLgrrfWUA5B4aF7BOgrg8W5uEsM02bmoSb8ytKKkKyw1//XW5xCh/bKttmS2oi8qd
	 dkgU3jAa2APMTLk+Deldm7volJ1Kcn4yOmHRMY0KxfLhSS9Dlj5K7aFLvlZWRSBeCBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=anirYGOP;
	arc=none smtp.remote-ip=95.215.58.167
Received: from mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47410606A326
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 12:11:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47410606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=anirYGOP
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=EMm/A2BN1q75zo8IDzHb8rOAGXmZADLMHipKeX0V8hQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794312687; v=1; x=1794917487;
 b=anirYGOPNjpzWZekw3oE7YQCf1/CI3cOZ3UScO+Ewr3Bdf6WOgspTJpVw/fw9fapKtcqGlc/
 Ulhc+VU74O1ZouEDCQLoY0X5YMW0gcH5RnTmerr/+gPSpy5ja8lbxpHRJ+PCbKxzuir5omPSEqF
 rrEZwdycF+2arc74U3+aPMvA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cbcdfaa187e3d225;
	Tue, 10 Nov 2026 12:11:27 +0000
X-Mizu-Trace-ID: cbcdfaa187e3d225
X-Migadu-Flow: FLOW_OUT
Message-ID: <d615a099-5369-4e34-8f48-17152ce000d6@linux.dev>
Date: Tue, 10 Nov 2026 20:11:18 +0800
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
Subject: Re: [PATCH v3 2/3] cgroup/cpuset: Allow top-level partition CPU
 replacement
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long
 <longman@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261110050324.173461-1-guopeng.zhang@linux.dev>
 <20261110050324.173461-3-guopeng.zhang@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261110050324.173461-3-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/10/2026 1:03 PM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> When replacing a partition's CPUs, tasks_nocpu_error() checks whether
> the parent's current effective_cpus is a subset of the new exclusive
> CPU mask. The parent mask does not yet include CPUs being returned by
> the update, so this can invalidate an otherwise valid partition.
> 
> For example, on an 8-CPU system without boot isolation:
> 
>    echo 2-7 > A/cpuset.cpus
>    echo isolated > A/cpuset.cpus.partition
>    echo 0-4 > A/cpuset.cpus
>    cat A/cpuset.cpus.partition
>    isolated invalid (Parent unable to distribute cpu downstream)
> 
> The update should return CPUs 5-7 to the parent and leave A as a
> valid isolated partition.
> 
> Skip this subset check for top_cpuset. top_cpuset_sd_nocpu() already
> accounts for returned CPUs and ensures that an active boot domain
> housekeeping CPU remains.
> 
> Add a regression test for this case.
> 
> Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Hi Guopeng,

Patch 2 depends on patch 1. Skipping the cpumask_subset() check for
top_cpuset is only safe because top_cpuset_sd_nocpu() added by patch 1
now covers it. Without patch 1, patch 2 alone would let a partition
take away all the CPUs of top_cpuset. So patch 2 can't be backported
on its own, and the two have different Fixes tags. I think it would be
better to fold patch 2 into patch 1.

Also, the fix in patch 2 seems incomplete. The same false PERR_NOCPUS
happens when the parent is a local partition, as cpumask_subset()
there doesn't take the CPUs given back by the update into account
either. On an 8-CPU system:

	cd /sys/fs/cgroup
	echo +cpuset > cgroup.subtree_control
	mkdir A1
	echo 1-7 > A1/cpuset.cpus
	echo root > A1/cpuset.cpus.partition
	echo +cpuset > A1/cgroup.subtree_control
	mkdir A1/A2
	echo 3-7 > A1/A2/cpuset.cpus
	echo isolated > A1/A2/cpuset.cpus.partition
	sleep 1000 &
	echo $! > A1/cgroup.procs
	echo 1-4 > A1/A2/cpuset.cpus
	cat A1/A2/cpuset.cpus.partition
	isolated invalid (Parent unable to distribute cpu downstream)

A2 takes CPUs 1-2 from A1 and gives CPUs 5-7 back, so A1 still has
CPUs for its task. Instead of skipping the check for top_cpuset only,
how about making the check in tasks_nocpu_error() account for the CPUs
given back by cs for all parents? The hotplug caller would then need
to not count cs->effective_xcpus as given back, similar to what patch 3
does for top-level partitions.

> ---
>   kernel/cgroup/cpuset.c                            | 4 +++-
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 3 +++
>   2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index c405719ccd12..8b6831983803 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1232,8 +1232,10 @@ static bool tasks_nocpu_error(struct cpuset *parent, struct cpuset *cs,
>   
>   	/*
>   	 * A populated partition (cs or parent) can't have empty effective_cpus
> +	 * The top_cpuset check above also accounts for CPUs being returned.
>   	 */
> -	return (cpumask_subset(parent->effective_cpus, xcpus) &&
> +	return (parent != &top_cpuset &&
> +		cpumask_subset(parent->effective_cpus, xcpus) &&
>   		partition_is_populated(parent, cs)) ||
>   	       (!cpumask_intersects(xcpus, cpu_active_mask) &&
>   		partition_is_populated(cs, NULL));
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 0288af1c2eb3..ee4d57b7e35b 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -554,6 +554,9 @@ TEST_MATRIX=(
>   	" C2-6:X2-5:P1 CX3-6:P2 \
>   	                    .      .   T:X4-6    .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
>   
> +	# A CPU replacement must account for CPUs returned to the top cpuset.
> +	" C2-${CPULIST#0-}:P2 . . . C0-4 . . . 0 A1:0-4 A1:P2 0-4"
> +
>   	#
>   	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
>   	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------

-- 
Best regards
Ridong

