Received: from mta0.migadu.com (out-137.mta0.migadu.com [91.218.175.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04784323416
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 01:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790558741; cv=none; b=O4nR2TwUyI2XBV5u+NZ9OAJo/DT62c9jowZucHOGryTg72LQSDruokyC3q4l+JIEnVem66WdaA0UZFFXj5TEk4F1BEBdAaBX0kKJfbZBxH10msk6NhqRQapzjuMNNKksxCgpcGIOW+VvC1cg083oIXZWx2Fa/jxCUWzRKYPplOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790558741; c=relaxed/simple;
	bh=+FUbARB7xIMmkXPd6oxJjMvQGLMcPsdpU/f5Ae3161U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Peznd3p+kWK+TTiQGbXQCBzzKtP5KyDGbRS88QFoeIK//vkONepfJEVPGt0ODTKOFZ1l+AX4f38LOeHPzoWjAXrqXEBTa1iTfCUedCTXKxRMMSSYOC95XbmhctZpWPIo8px645cWNVPkSUY+2RylPha8QwdAa0KQzPwjAr/SS9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EjYTsG74; arc=none smtp.client-ip=91.218.175.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EjYTsG74"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+FUbARB7xIMmkXPd6oxJjMvQGLMcPsdpU/f5Ae3161U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790558737; v=1; x=1791163537;
 b=EjYTsG74OiH5Dz2TdSuEz7Y4nPyawIUG97LchSzSWJq5D4YveITJwNbUJRezYDIiikdxgz5S
 gQoKAnbvHlpClamcBGA9983A5Cnzp0xum7grwvLe8zj4YBuHC3oSk8OhiDAmuw2kJLjPd/Zv/RG
 HZAuphDd3TsvAn70aNcvJzWI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0b65aad63003c6a8;
	Mon, 28 Sep 2026 01:25:16 +0000
X-Mizu-Trace-ID: 0b65aad63003c6a8
X-Migadu-Flow: FLOW_OUT
Message-ID: <fb32d01a-2020-426f-9af4-cdc74d60f9c6@linux.dev>
Date: Mon, 28 Sep 2026 09:25:08 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] cgroup/cpuset: return PERR_NOCPUS in
 remote_partition_enable() on subpartitions_cpus conflict
To: Hui Peng <benquike@gmail.com>, Waiman Long <longman@redhat.com>,
 Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: Shuah Khan <shuah@kernel.org>, Chen Ridong <chenridong@huawei.com>,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260924042729.1908863-1-benquike@gmail.com>
 <20260924042729.1908863-2-benquike@gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260924042729.1908863-2-benquike@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/24/2026 12:27 PM, Hui Peng wrote:
> When a remote partition is created underneath an existing local partition
> via a non-partition (PRS_MEMBER) intermediate cgroup, update_prstate() sees
> parent->partition_root_state == PRS_MEMBER and calls
> remote_partition_enable().
> 
> Commit 86888c7bd117 ("cgroup/cpuset: Add warnings to catch inconsistency
> in exclusive CPUs") replaced the cpumask_intersects(tmp->new_cpus,
> subpartitions_cpus) error check in remote_partition_enable() with
> WARN_ON_ONCE(). As a result, remote_partition_enable() emits a warning
> and proceeds to enable the remote partition on CPUs that are already
> owned by the ancestor local partition in subpartitions_cpus.
> 
> This can be reproduced on Linux 7.3.0-rc3 with:
> 
>    mkdir -p /tmp/cg1
>    mount -t cgroup2 none /tmp/cg1
>    echo "+cpuset" > /tmp/cg1/cgroup.subtree_control
> 
>    mkdir /tmp/cg1/A
>    echo 1 > /tmp/cg1/A/cpuset.cpus
>    echo 1 > /tmp/cg1/A/cpuset.cpus.exclusive
>    echo root > /tmp/cg1/A/cpuset.cpus.partition
>    echo "+cpuset" > /tmp/cg1/A/cgroup.subtree_control
> 
>    mkdir /tmp/cg1/A/B
>    echo 1 > /tmp/cg1/A/B/cpuset.cpus
>    echo 1 > /tmp/cg1/A/B/cpuset.cpus.exclusive
>    echo "+cpuset" > /tmp/cg1/A/B/cgroup.subtree_control
> 
>    mkdir /tmp/cg1/A/B/D
>    echo 1 > /tmp/cg1/A/B/D/cpuset.cpus
>    echo 1 > /tmp/cg1/A/B/D/cpuset.cpus.exclusive
>    echo root > /tmp/cg1/A/B/D/cpuset.cpus.partition
> 
> which triggers:
> 
>    WARNING: kernel/cgroup/cpuset.c:1594 at remote_partition_enable+0x1c1/0x300
> 
> and leaves both /tmp/cg1/A and /tmp/cg1/A/B/D as active root partitions
> claiming exclusive CPU 1.
> 
> Fix this by returning PERR_NOCPUS when tmp->new_cpus intersects
> subpartitions_cpus in remote_partition_enable(), matching the error code
> used by remote_cpus_update() for the same subpartitions_cpus conflict, and
> add a regression test case to
> tools/testing/selftests/cgroup/test_cpuset_prs.sh.
> 
> Tested in QEMU on Linux 7.3.0-rc3 using the reproducer above and
> tools/testing/selftests/cgroup/test_cpuset_prs.sh.
> 
> Fixes: 86888c7bd117 ("cgroup/cpuset: Add warnings to catch inconsistency in exclusive CPUs")
> Suggested-by: Guopeng Zhang <guopeng.zhang@linux.dev>
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>
> ---
>   kernel/cgroup/cpuset.c                            | 3 ++-
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 2 ++
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 2538faac9aba..7381fa8502e7 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1591,10 +1591,11 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>   	 * above it or remote partition root underneath it is not allowed.
>   	 */
>   	compute_excpus(cs, tmp->new_cpus);
> -	WARN_ON_ONCE(cpumask_intersects(tmp->new_cpus, subpartitions_cpus));
>   	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
>   	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
>   		return PERR_INVCPUS;
> +	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
> +		return PERR_NOCPUS;
>   	if (((new_prs == PRS_ISOLATED) &&
>   	     !isolated_cpus_can_update(tmp->new_cpus, NULL)) ||
>   	    prstate_housekeeping_conflict(new_prs, tmp->new_cpus))
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 3f7e81709365..b732078bf319 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -298,6 +298,8 @@ TEST_MATRIX=(
>   	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
>   				   .      .      .      X1      .    0 A1:0-1|A2:2-4|A3:2-4 \
>   								       A1:P0|A2:P2|A3:P-1 2-4"
> +	" CX1-3:P1 CX1-3  CX1-3    .      .      .      P1      .    0 A1:1-3|A2:1-3|A3:1-3 \
> +								       A1:P1|A2:P0|A3:P-1"
>   
>   	# Remote partition offline tests
>   	"   C0-3    C1-3  C2-3     .    X2-3   X2-3 X2-3:P2:O2=0 .   0 A1:0-1|A2:1|A3:3 A1:P0|A3:P2 2-3"

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.
-- 
Best regards
Ridong

