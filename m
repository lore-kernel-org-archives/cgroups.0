Received: from mta0.migadu.com (out-239.mta0.migadu.com [91.218.175.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F8518AE3
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 01:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790559658; cv=none; b=PWM3jSFNLdb/sFq24QJqZwpbLMySNOyVPnzaQKdno/r44S+X5riaLDjaTjsxVfnuCra+xV9sF2lWyWx7NPeHhtAEDt427QXM7W1U8FNflvzsv8ugZXpYo7fF6Ymzb1UVyTN41XFDTvfFcepC/eFfJ8RcO7GAu+SVt/VmeYofb3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790559658; c=relaxed/simple;
	bh=hzHwDE34v1HLmM8SoW5+6io0DFeC9cWq420KEx5tFCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YUYG3nhXjl9OOP1FML8zhEgP3vu78yziaJ2HNfEmNIEEnf6Yz+xseThcsL0xOJLiKs071pjg4xd/s3ykz2LOfeq6RpFSFQDvBsN6gIF6qy8lVaXRGxLu5yKj5ojgPxdOEwnyCy366Y7OHtof754I1LxJUYVU3CX757/3eQbt0dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nQxaTHE7; arc=none smtp.client-ip=91.218.175.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nQxaTHE7"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hzHwDE34v1HLmM8SoW5+6io0DFeC9cWq420KEx5tFCc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790559654; v=1; x=1791164454;
 b=nQxaTHE7BjvQVVY4VZUMZCCjobGsoNBvy8YQqfjXDEe9zMAGre/xHFi3VPukhT2ZGRcMOx5o
 tjIkHaOSJhG/AXvbtpe4/Qy8UkAxdoFgiwlP+J2WLINCWLLd2hHZ3IiC1brYrVgMX2fGJjz1ChP
 GcrMBq4Q93hOab3FAMKIFGec=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 00eae308403adc8e;
	Mon, 28 Sep 2026 01:40:54 +0000
X-Mizu-Trace-ID: 00eae308403adc8e
X-Migadu-Flow: FLOW_OUT
Message-ID: <93e48fe3-d229-4870-af8a-32431d236211@linux.dev>
Date: Mon, 28 Sep 2026 09:40:49 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] cgroup/cpuset: prevent activating local partition
 over remote one
To: Hui Peng <benquike@gmail.com>, Waiman Long <longman@redhat.com>,
 Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: Shuah Khan <shuah@kernel.org>, Chen Ridong <chenridong@huawei.com>,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260924042729.1908863-1-benquike@gmail.com>
 <20260924042729.1908863-3-benquike@gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260924042729.1908863-3-benquike@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/24/2026 12:27 PM, Hui Peng wrote:
> Commit 6da580ec656a ("cgroup/cpuset: Don't allow creation of local
> partition over a remote one") added a check in update_prstate() to reject
> creating a top-level local partition whose cs->exclusive_cpus intersects
> subpartitions_cpus.
> 
> However, if a top-level cgroup A1 has a child A1/A2 enabled as a remote
> partition on a subset of its exclusive CPUs (X2-3 on A1, CX2-3:P2 on
> A1/A2), and A1 is then set to "root" (P1, becoming "root invalid" via
> update_prstate() because its exclusive CPUs intersect subpartitions_cpus)
> followed by expanding its CPUs to include additional non-remote CPUs
> (CX1-3), update_cpumask() / update_exclusive_cpumask() calls
> validate_partition() without going through update_prstate(). Because
> validate_partition() does not check trialcs->exclusive_cpus against
> subpartitions_cpus, A1 transitions from "root invalid" to a valid local
> partition over the existing remote partition A1/A2 and triggers:
> 
>    WARNING: kernel/cgroup/cpuset.c:1943 at update_parent_effective_cpumask+0x189b/0x1fd0
> 
> Check trialcs->exclusive_cpus against subpartitions_cpus in
> validate_partition() when !is_partition_valid(cs), and add a regression
> test case to tools/testing/selftests/cgroup/test_cpuset_prs.sh.
> 

Was this message assisted by an LLM?

It would be helpful if you could provide the reproducer as I replied earlier, so 
that it can be understood more easily and tested.

> Tested in QEMU on Linux 7.3.0-rc3 using
> tools/testing/selftests/cgroup/test_cpuset_prs.sh.
> 
> Fixes: 6da580ec656a ("cgroup/cpuset: Don't allow creation of local partition over a remote one")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>
> ---
>   kernel/cgroup/cpuset.c                            | 4 ++++
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 2 ++
>   2 files changed, 6 insertions(+)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 7381fa8502e7..7c5b4a8f1f3a 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2415,6 +2415,10 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
>   	if (cpumask_empty(trialcs->effective_xcpus))
>   		return PERR_INVCPUS;
>   
> +	if ((parent == &top_cpuset) && !is_partition_valid(cs) &&
> +	    cpumask_intersects(trialcs->exclusive_cpus, subpartitions_cpus))
> +		return PERR_REMOTE;
> +
>   	if (prstate_housekeeping_conflict(trialcs->partition_root_state,
>   					  trialcs->effective_xcpus))
>   		return PERR_HKEEPING;
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index b732078bf319..4a451350ad84 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -321,6 +321,8 @@ TEST_MATRIX=(
>   	" C1-3:P2  X4:P2    .      .      .    X3:P2    .      .     0 A1:1-2|XA1:1-3|A2:3:XA2:3 A1:P2|A2:P2 1-3"
>   	" C0-3:P2    .      .    C4-6   C0-4     .      .      .     0 A1:0-4|B1:5-6 A1:P2|B1:P0"
>   	" C0-3:P2    .      .    C4-6 C0-4:C0-3  .      .      .     0 A1:0-3|B1:4-6 A1:P2|B1:P0 0-3"
> +	"   X2-3  CX2-3:P2  .      .  P1:CX1-3   .      .      .     0 A1:1|A2:2-3|XA2:2-3 \
> +								       A1:P-1|A2:P2 2-3"
>   
>   	# Local partition invalidation tests
>   	" C0-3:X1-3:P2 C1-3:X2-3:P2 C2-3:X3:P2 \

-- 
Best regards
Ridong

