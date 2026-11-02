Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.83
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793583024;
	b=F0LlADzq1lHckJhovLgttnkqfLwtBMeY9JftB+c/Tw2+rWGpDdsD27KCo3L6+LTLFm7j
	 PUWu+RTLFTLZYy7O8J0NeOx+cTfCeSKzN5gXTl9UFnxIN1NNpEbioWWBwcyBcYkMoxk0p
	 ciifFDH/kkWVN6Sq9Cihk/nvO7mbdZT4xM2e2/tbBFBPpK2ycYPEuev+jBtbEDDH8lTfR
	 yMOv9jqIGCQFBgdwJi1wVTA2HMBK/+uT0Q0Z/12v2rb2F7QzIG2eJFwsTf42eNXsTqAuv
	 JwzUeATF40+EuObF8yL7RN2SKBFiu2maDKMsFp/dSIjIu7EN/G/TTHIRTRLgWoiFf6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793583024;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=5SySUHGvWAaNRa+9l2Aa4RYt/iIP1exv/hf2wqHind8=;
	b=BLwdauOOTScQtp+Jt1tXW8XnNv7zA83KX3wwpzoD0HPsMTOTYkT79Wuqw16SKE/14Kot
	 2AvR8MnwQfgTE7pfx6T/i7iV2iQ7iImFn+zAzBkpk0RUP9a0uJTCvhuz2IS3YOnu55EsR
	 zN+b3bI/FaMc1g4Mul4BBBh03vr423MtY70pdhomkHL4SHbbXMEwIlfqpmV4P1h9Go348
	 s4jJnoLG+FnhpkbcObdP6FYsjUKVm29NCE3QmNkhb2/7NQgJ9QXvy9O3k/5sewn50yw1T
	 UAi7LlAfk6ipqsyVstUU7g4mHT2je2d0cK5NldROvpK03qsFNLlShlcZRfUczC7ndKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=S742eBVt;
	arc=none smtp.remote-ip=91.218.175.83
Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1120C606A329
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 01:30:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1120C606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=S742eBVt
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/4x3xaBdJewuJgQAldBK7xykAEYVDrVN8pq+tde6EgA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793583022; v=1; x=1794187822;
 b=S742eBVt4xT0ItcYmJaD5FIfSyTLlXXGmrcQolUi+0/LzkBxDCyHM3NmJ0mF30x5We8YZisb
 NpTrocsfAbOAVpsEVTdTiY8kkqSVH7/p1zJ4Wp7VcU7P5Y0cDGLqUK7IN0mVtxnSitBKF1BKqxD
 shYzvAeteW8s0ID+bJujASgo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 02c042eb4f586f3f;
	Mon, 02 Nov 2026 01:30:10 +0000
X-Mizu-Trace-ID: 02c042eb4f586f3f
X-Migadu-Flow: FLOW_OUT
Message-ID: <7f98f3d6-07f0-4117-92e7-91d9bb802972@linux.dev>
Date: Mon, 2 Nov 2026 09:30:05 +0800
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
Subject: Re: [PATCH v2 3/3] cgroup/cpuset: Do housekeeping check when isolated
 child with root parent may get more xcpus
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261030190701.78308-1-longman@redhat.com>
 <20261030190701.78308-4-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261030190701.78308-4-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/31 03:07, Waiman Long 写道:
> It is reported by sashiko and Guopeng that when an isolated child with
> root parent gets more isolated CPUs from the expansion of the parent's
> effective_xcpus, it is possible that all the active housekeeping CPUs
> may be gone. So a prstate_housekeeping_conflict() should be performed
> when that happens. Add the check to make sure that we can't exhaust
> all the active housekeeping CPUs.
> 
> Test cases are added to the NOHZ_FULL_TEST_MATRIX of test_cpuset_prs.sh
> to test that.
> 
> Reported-by: Guopeng Zhang <guopeng.zhang@linux.dev>
> Link: https://lore.kernel.org/lkml/ed6fecb4-38e9-4a73-8c1a-7bdd80175a69@linux.dev
> Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c                         | 18 +++++++++++++++---
>  .../selftests/cgroup/test_cpuset_prs.sh        | 10 ++++++++--
>  2 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index ed014ecb770c..6e136888fc8e 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2119,10 +2119,22 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  			 * If there is an expansion of parent's effective_xcpus,
>  			 * we may take more xcpus from parent. The parent's
>  			 * effective_cpus should still have active CPUs or nocpu
> -			 * should have been set.
> +			 * should have been set. We also need to do a
> +			 * housekeeping check for an isolated child with root
> +			 * parent to make sure that it won't exhaust all the
> +			 * active housekeeping CPUs.
>  			 */
> -			deleting = cpumask_andnot(tmp->delmask, tmp->delmask,
> -						  cs->effective_xcpus);
> +			cpumask_andnot(tmp->addmask, cs->effective_xcpus, tmp->delmask);
> +			if ((parent_prs == PRS_ROOT) && (old_prs == PRS_ISOLATED) &&
> +			    prstate_housekeeping_conflict(old_prs, parent_prs,
> +							  tmp->delmask, tmp->addmask)) {
> +				adding = cpumask_and(tmp->addmask, cs->effective_xcpus,
> +						     tmp->delmask);
> +				part_error = PERR_HKEEPING;
> +			} else {
> +				deleting = cpumask_andnot(tmp->delmask, tmp->delmask,
> +							  cs->effective_xcpus);
> +			}
>  		} else if (is_partition_invalid(cs)) {
>  			struct cgroup_subsys_state *css;
>  			struct cpuset *child;
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 844efdf029cd..bdca6c471f87 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -137,7 +137,8 @@ LAST_PRESENT_CPU=$(cat /sys/devices/system/cpu/present | sed -e "s/.*[,-]//")
>  # If isolated CPUs have been reserved at boot time (as shown in
>  # /sys/devices/system/cpu/isolated), these isolated CPUs should be outside of
>  # CPUs 0-8 that will be used by this script for testing purpose. If not, some
> -# of the tests may fail incorrectly.
> +# of the tests may fail incorrectly. The first boot isolated CPU should be
> +# 10 or above.
>  #
>  # The current set of isolated CPUs (as shown in cpuset.cpus.isolated) should
>  # be the same as the boot value. If not, wait a bit and retry again just in
> @@ -156,7 +157,7 @@ TEST_ISOLCPUS=
>  [[ -n "$BOOT_ISOLCPUS" ]] && {
>  	FIRST_ISOLCPUS=$(echo $BOOT_ISOLCPUS | sed -e "s/[,-].*//")
>  	echo "Boot isolated CPUs: $BOOT_ISOLCPUS"
> -	[[ $FIRST_ISOLCPUS -le 8 ]] &&
> +	[[ $FIRST_ISOLCPUS -le 9 ]] &&
>  		skip_test "Boot isolated CPUs overlap CPUs to be tested"
>  }
>  
> @@ -602,6 +603,7 @@ ISOLCPUS_TEST_MATRIX=(
>  )
>  
>  # Test matrix to be run when boot time nohz_full CPUs cover all CPUs except CPUs 0-7
> +# This also means that CPU 8 is available and is a nohz_full CPU.
>  NOHZ_FULL_TEST_MATRIX=(
>  	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
>  	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
> @@ -610,6 +612,10 @@ NOHZ_FULL_TEST_MATRIX=(
>  	" C2-7:P2    .      .      .     C0-4    .      .      .     0 A1:0-4 A1:P2 0-4"
>  	" C1-7:P2 C5-7:P2   .      .       .     .      .    C0:P2   0 A1:1-4|A2:5-7|B1:0
>  								       A1:P2|A2:P2|B1:P-2 1-7"
> +	# An isolated child partition cannot grow to take over the last
> +	# housekeeping CPU when its parent expands the exclusive CPUs.
> +	" C0-8:X1-8:P1 CX0-8:P2 .  .     X0-7    .      .      .     0 A1:0-7|A2:0-7 A1:P1|A2:P-2 ."
> +	" C0-8:X0-6:P1 CX0-8:P2 .  .     X2-8    .      .      .     0 A1:|A2:2-8 A1:P1|A2:P2 2-8"
>  )
>  
>  #

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
