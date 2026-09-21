Received: from mta0.migadu.com (out-103.mta0.migadu.com [91.218.175.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0061137756B
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 07:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789974544; cv=none; b=aTHtxYVBc6+6qdBeooVt+f62iDroX418S26lhDKSXXosMKR+Y0BxNqmSdpqI35AbaJ8k9kH/49FT72hlAMUOKrAnCs8VNGfDsR0XIjutrCrT47wjF2y8o3OMQMoB2A05YcHgMQwuR0I8DuI0uK3qNPqrV5jVv+sBYU6G2oub6Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789974544; c=relaxed/simple;
	bh=fP06fUHtBpp2cGAnDwmJQ/nY6+PkTalsUPKOuD9WtKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q7f1dHiJ+J1R+dZzIWI2ttPNjYY81EUMGCedscUn4f4KY4y5P7yYxThDjADjZznpda5gyvIDg+OonwSzIjFF7qDzlVptnqI7WTpawcYvcjZmMIrICgdB9O0Qr5PeICrM83dufimlnoqvOkVYLxQilniJ32R+XQV8AFcztG+3qE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xhrRP/zv; arc=none smtp.client-ip=91.218.175.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xhrRP/zv"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fP06fUHtBpp2cGAnDwmJQ/nY6+PkTalsUPKOuD9WtKM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789974539; v=1; x=1790579339;
 b=xhrRP/zvxJyI/kzGlCRME/x2ufvzsIa6m5R16CX43gNscJV+T5eTFhoi2WljrN4AbN3QjqWv
 O01wsimJUSY9+mbf6AsEQgsi3FsXWAzlUfIwUQi9nSHvYWIGZd+ZomSbqxkJSYwqGN6LSA9bt8n
 oxKeCXE22h7tEe5lz8OZsI8s=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a688a47092d9ca8d;
	Mon, 21 Sep 2026 07:08:59 +0000
X-Mizu-Trace-ID: a688a47092d9ca8d
X-Migadu-Flow: FLOW_OUT
Message-ID: <a00dbaaa-99f1-4172-b337-911ff45ae71e@linux.dev>
Date: Mon, 21 Sep 2026 15:08:55 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] cgroup/cpuset: return PERR_NOCPUS in
 remote_partition_enable()
To: Hui Peng <benquike@gmail.com>, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Waiman Long <longman@redhat.com>
Cc: Michal Koutny <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <aa90bb73-c2af-4d13-8f2a-0435aa528058@linux.dev>
 <20260920181449.3122336-1-benquike@gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260920181449.3122336-1-benquike@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/21/2026 2:14 AM, Hui Peng wrote:
> Commit 6da580ec656a ("cgroup/cpuset: Don't allow creation of local
> partition over a remote one") updated update_prstate() to prevent creating
> a top-level local partition whose exclusive CPUs conflict with an existing
> remote partition.
> 
> However, if a top-level local partition A1 is created on CPUs 1-3, has a
> non-partition member child A1/A2 with cpuset.cpus.exclusive = 1-3, and a
> grandchild A1/A2/A3 is then enabled as a partition root on 1-3,
> update_prstate() sees !is_partition_valid(parent) (since A1/A2 is a member)
> and calls remote_partition_enable(). Because remote_partition_enable() does
> not check whether tmp->new_cpus intersects subpartitions_cpus, A1/A2/A3 is
> enabled as a remote partition on CPUs already owned by A1, triggering:
> 
>    WARNING: kernel/cgroup/cpuset.c:1594 at update_prstate+0xbef/0xd70
> 
> Return PERR_NOCPUS in remote_partition_enable() when tmp->new_cpus
> intersects subpartitions_cpus, matching the error code used by
> remote_cpus_update() for subpartitions_cpus conflicts, and add a
> corresponding regression test case to
> tools/testing/selftests/cgroup/test_cpuset_prs.sh.
> 
> Tested in QEMU on Linux 7.3.0-rc3 using
> tools/testing/selftests/cgroup/test_cpuset_prs.sh.
> 
> Fixes: 6da580ec656a ("cgroup/cpuset: Don't allow creation of local partition over a remote one")
> Suggested-by: Guopeng Zhang <guopeng.zhang@linux.dev>
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>
> ---
> Changes in v3:
> - Split the series into 3 patches (one per logical change and Fixes: tag).
> 

What is going on here?

Please do not reply with a new series. And I think the changes should be listed 
in the cover letter. Otherwise, it will get very confusing.


>   kernel/cgroup/cpuset.c                        | 4 +++-
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 2 ++
>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index c8ab89cfbe3d..7381fa8502e7 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1678,8 +1678,10 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>   	 * Callers must have validated that effective_xcpus is not empty.
>   	 */
>   	spin_lock_irq(&callback_lock);
> -	if (cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus)) {
> +	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus) ||
> +	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus)) {
>   		spin_unlock_irq(&callback_lock);
> +		if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
> +			return PERR_NOCPUS;
>   		return PERR_HKEEPING;
>   	}
>   

I cannot apply this patch. It seems quite different from v2.

> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index a1f42ef64bc1..b732078bf319 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -298,6 +298,8 @@ TEST_MATRIX=(
>   	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
>   				   .      .      .      X1      .    0 A1:0-1|A2:2-4|A3:2-4 \
>   								       A1:P0|A2:P2|A3:P-1 2-4"
> +	" CX1-3:P1 CX1-3  CX1-3    .      .      .      P1     .     0 A1:1-3|A2:1-3|A3:1-3 \
> +								       A1:P1|A2:P0|A3:P-1"
>   
>   	# Remote partition offline tests
>   	"   C0-3    C1-3  C2-3     .    X2-3   X2-3 X2-3:P2:O2=0 .   0 A1:0-1|A2:1|A3:3 A1:P0|A3:P2 2-3"

-- 
Best regards
Ridong

