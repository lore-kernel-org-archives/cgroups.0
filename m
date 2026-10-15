Received: from mta0.migadu.com (out-241.mta0.migadu.com [91.218.175.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DA04CEE52
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 13:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792069384; cv=none; b=HsDGpLTYCtJJagfgD1o6OGNX4m1cg8ibzvcjm91OEdSYwKfyMZKkwWblE0sFMhEOnkzJIwf9ZCQp1a5HSJN1hMVxv3Lz6yrkzrrFy+aIrkYRaJkA3Rn9CJrPrHq1p/rbaCXFRY4y8RHf+17RqRkUI8tVbpU9o7/HoP+/dayWxME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792069384; c=relaxed/simple;
	bh=VdVodvPg3p6dDjQ9jUKaUEb04QaunJ71hLYZPi/ddKE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VhNXDSIA14211AoOJft306Eowzvw7OpJ6Qgwj41Kmqu2LeRasBVJnkNDiuCIRRLjuLWbxSicrUCtO9raomRHbbQpkYIt7tt9IlOsHQYMA82sT9fITm7Qj/lcVLkvZ/8Wiq/bu6OfkzWG1G58p8YCGKLsCwFGSEcyh6JGp8TIYxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RZmlHshl; arc=none smtp.client-ip=91.218.175.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RZmlHshl"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VdVodvPg3p6dDjQ9jUKaUEb04QaunJ71hLYZPi/ddKE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792069380; v=1; x=1792674180;
 b=RZmlHshlVdI7h8o4NDOlXIVeAXJzSXphNENBO7VVV0Kyx9uAzGB4mOQhyteuaTZO+7QdRJuK
 MAt451h2Z/8ZWRWfOTnZiMFKDqHyMwdRP3RpI729GlgbNQAxucqjE81kdRQ3u8AJXxLZFaTVgo2
 e6r1rhRXL4eKm0pTUhnAkw+4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5f4e01ac4f981c2e;
	Thu, 15 Oct 2026 13:03:00 +0000
X-Mizu-Trace-ID: 5f4e01ac4f981c2e
X-Migadu-Flow: FLOW_OUT
Message-ID: <0bd7f6ff-3675-4447-a62a-a2047241e3e6@linux.dev>
Date: Thu, 15 Oct 2026 21:02:54 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v3 1/9] cgroup/cpuset: Fix a missing isolated_cpus
 update in update_cpumasks_hier()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Hui Peng <benquike@gmail.com>
References: <20261014140548.575122-1-longman@redhat.com>
 <20261014140548.575122-2-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261014140548.575122-2-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/14 22:05, Waiman Long 写道:
> It is found that when a local isolated partition is being invalidated
> because its root partition parent is no longer valid, the isolated_cpus
> cpumask may not be properly updated. If the parent was previously
> an isolated partition, its invalidation should have properly updated
> isolated_cpus before and no action will be needed.
> 
> Fix that by calling isolated_cpus_update() in this invalidation case
> to update isolated_cpus. A test case in test_cpuset_prs.sh is modified
> to test that.
> 
> Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c                        | 19 ++++++++++++++-----
>  .../selftests/cgroup/test_cpuset_prs.sh       |  4 ++--
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 0ebba2d646c3..6b5c870e5607 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2229,7 +2229,9 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>  		 * cpuset if the parent's effective_cpus changes.
>  		 */
>  		if ((cp != cs) && old_prs) {
> -			switch (parent->partition_root_state) {
> +			int parent_prs = parent->partition_root_state;
> +
> +			switch (parent_prs) {
>  			case PRS_ROOT:
>  			case PRS_ISOLATED:
>  				update_parent = true;
> @@ -2238,11 +2240,18 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>  			default:
>  				/*
>  				 * When parent is not a partition root or is
> -				 * invalid, child partition roots become
> -				 * invalid too.
> +				 * invalid, child partition roots become invalid
> +				 * too. For an isolated partition with root
> +				 * partition parent, isolated_cpus_updated()
> +				 * is called to update isolated_cpus.
>  				 */
> -				if (is_partition_valid(cp))
> -					new_prs = -cp->partition_root_state;
> +				if (is_partition_valid(cp)) {
> +					new_prs = -old_prs;
> +					if ((old_prs == PRS_ISOLATED) &&
> +					    (parent_prs == -PRS_ROOT))
> +						isolated_cpus_update(old_prs, new_prs,
> +								     cp->effective_xcpus);
> +				}

I tested switching a parent partition from root to member and found that
CPUs can remain listed in cpuset.cpus.isolated. CPUs 0-15 are online, with
nohz_full=2-15 and no isolcpus:

    # cd /sys/fs/cgroup
    # echo +cpuset > cgroup.subtree_control
    # mkdir A
    # echo 1-2 > A/cpuset.cpus
    # echo root > A/cpuset.cpus.partition
    # echo +cpuset > A/cgroup.subtree_control
    # mkdir A/C
    # echo 2 > A/C/cpuset.cpus
    # echo isolated > A/C/cpuset.cpus.partition
    # cat cpuset.cpus.isolated
    2
    # echo member > A/cpuset.cpus.partition
    # cat A/C/cpuset.cpus.partition
    isolated invalid (Parent is not a partition root)
    # cat cpuset.cpus.isolated
    2

A is now a member and C is invalid, so cpuset.cpus.isolated should be
empty here, but CPU 2 remains.

Thanks,
Guopeng>  				WRITE_ONCE(cp->prs_err,
>  					   is_partition_invalid(parent)
>  					   ? PERR_INVPARENT : PERR_NOTPART);
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 7efd5e645767..874a8a161236 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -292,9 +292,9 @@ TEST_MATRIX=(
>  								       A1:P0|A2:P2|A3:P1 2-4|2-3"
>  	"   C0-4    C1-4  C2-4     .    X2-4  X2-4:P2 X3-4:P1   .    0 A1:0-1|A2:2|A3:3-4 \
>  								       A1:P0|A2:P2|A3:P1 2"
> -	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
> +	" C0-4:X2-4 C1-4:X2-4:P1 C2-4:X4:P2 \
>  				   .      .      X5      .      .    0 A1:0-4|A2:1-4|A3:2-4 \
> -								       A1:P0|A2:P-2|A3:P-1 ."
> +								       A1:P0|A2:P-1|A3:P-2 ."
>  	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
>  				   .      .      .      X1      .    0 A1:0-1|A2:2-4|A3:2-4 \
>  								       A1:P0|A2:P2|A3:P-1 2-4"

