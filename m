Received: from mta0.migadu.com (out-219.mta0.migadu.com [91.218.175.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF04353A77
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 08:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789894683; cv=none; b=NrqkWpYDsrriI40pdz58QzyPu0xnG5i8d/RQ2I0a62qCOHuXPCRV3TaMcsd1bDrztU0wviGNM1+jmBUKIMZDcX0mlCMO2k5N43tey/mXlIj1pzU3VKZS9HWJ3sdlnUD302xmefhMPTYIz1E/D0CCKAVTlsPN+bI3tHZMVpROogE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789894683; c=relaxed/simple;
	bh=SkcOaP5BTl2GVSJvWcMEy94n61Gq82fdCYwK8Hy9T+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bSXkqSk2F4H7ejCE/s9jrU7qMVlpSGUy/RqZPz++Heb09Vla6bqBbLx8ic0EXIA23BiPuJHK2iRhY+Mkvj6028XiCbpo61dw/b4xXy8AxfDpdGkTMskKBTcGw7iky3n60PtjKjgGQkRrYFrYdc37HzPFP6AMOVPsHwySE6x3mNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TJQRtAzG; arc=none smtp.client-ip=91.218.175.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TJQRtAzG"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=SkcOaP5BTl2GVSJvWcMEy94n61Gq82fdCYwK8Hy9T+w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789894678; v=1; x=1790499478;
 b=TJQRtAzGJEu4zd1m/O08P86y6C7Hr5y3LPya4RrlhMNS+pL1nvQOa5D/hnlz1xf66myaYCat
 akydFsn6NhYLa8Ix4ab0858qhynyFqNyaIdrFWNEq+BpniXoohsbER1R84WotLMwc4tS6LF4Rfo
 EGsDxPRoZbzWGEge6PYbAEN4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a5691a9340c7a80d;
	Sun, 20 Sep 2026 08:57:48 +0000
X-Mizu-Trace-ID: a5691a9340c7a80d
X-Migadu-Flow: FLOW_OUT
Message-ID: <aa90bb73-c2af-4d13-8f2a-0435aa528058@linux.dev>
Date: Sun, 20 Sep 2026 16:57:39 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] cgroup/cpuset: prevent local partition activation
 over remote partition and sibling xcpus conflict
To: Hui Peng <benquike@gmail.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Waiman Long <longman@redhat.com>,
 Ridong Chen <ridong.chen@linux.dev>
Cc: Michal Koutny <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <139d9231-4723-4365-9af7-8142e6581ede@linux.dev>
 <20260920082335.257680-1-benquike@gmail.com>
 <20260920082335.257680-2-benquike@gmail.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20260920082335.257680-2-benquike@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/20 16:23, Hui Peng 写道:
> Commit 6da580ec656a ("cgroup/cpuset: Don't allow creation of local
> partition over a remote one") added a check in update_prstate() to reject
> creating a top-level local partition whose cs->exclusive_cpus intersects
> subpartitions_cpus.
> 
> However, two paths still allow overlapping exclusive CPU ownership between
> a top-level local partition and a remote partition or sibling:
> 
> 1. If a top-level cgroup A1 has cpuset.cpus.exclusive set, is first set to
>    "root" while cpuset.cpus is empty (becoming "root invalid"), has a
>    child A1/A2 enabled as a remote partition on those exclusive CPUs, and
>    then receives CPUs via A1/cpuset.cpus, update_cpumasks_hier() calls
>    validate_partition() without going through update_prstate(). Because
>    validate_partition() does not check trialcs->exclusive_cpus against
>    subpartitions_cpus, A1 transitions from "root invalid" to a valid local
>    partition over the existing remote partition A1/A2 and triggers:
> 
>      WARNING: kernel/cgroup/cpuset.c:1866 at update_parent_effective_cpumask+0x54a/0x8a0
> 
> 2. In cpus_excl_conflict(), when a valid local partition A1 uses implicit
>    exclusive CPUs (cpuset.cpus set without cpuset.cpus.exclusive, so
>    sibling->exclusive_cpus is empty while sibling->effective_xcpus is
>    populated), a sibling cgroup B1 can still set cpuset.cpus.exclusive on
>    the same CPUs because cpus_excl_conflict() only checks
>    sibling->exclusive_cpus.
> 
> Fix these issues by:
> - Checking trialcs->exclusive_cpus against subpartitions_cpus in
>   validate_partition() when !is_partition_valid(cs).
> - Falling back to sibling->effective_xcpus in cpus_excl_conflict() when
>   sibling->exclusive_cpus is empty.
> - Adding regression test cases for both paths to
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh.
> 
> Tested in QEMU on Linux 7.3.0-rc3 using
> tools/testing/selftests/cgroup/test_cpuset_prs.sh.
> 
> Fixes: 6da580ec656a ("cgroup/cpuset: Don't allow creation of local partition over a remote one")

I think this patch is still missing a Fixes: tag for the
cpus_excl_conflict() change.

The validate_partition() change can be covered by 6da580ec656a.

However, the sibling CPU ownership issue fixed in cpus_excl_conflict()
was introduced by the following commit:
Fixes: 2a3602030d80 ("cgroup/cpuset: Don't invalidate sibling partitions on cpuset.cpus conflict")

Thanks,
Guopeng

> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Peng <benquike@gmail.com>
> ---
> Changes in v2:
> - Split from the remote_partition_enable() fix into patch 2/2.
> - Check trialcs->exclusive_cpus (rather than effective_xcpus) in
>   validate_partition() when !is_partition_valid(cs) so sibling local
>   partitions with overlapping cpuset.cpus continue to share remaining
>   available CPUs as expected by test_cpuset_prs.sh.
> - Add regression tests to tools/testing/selftests/cgroup/test_cpuset_prs.sh.
> 
>  kernel/cgroup/cpuset.c                        | 9 ++++++++-
>  tools/testing/selftests/cgroup/test_cpuset_prs.sh | 3 +++
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 7381fa8502e7..f46a51f07938 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -713,7 +713,10 @@ static inline bool cpus_excl_conflict(struct cpuset *trial, struct cpuset *sibli
>  		return true;
>  
>  	/* Exclusive_cpus cannot intersect */
> -	return cpumask_intersects(trial->exclusive_cpus, sibling->exclusive_cpus);
> +	return cpumask_intersects(trial->exclusive_cpus,
> +				  cpumask_empty(sibling->exclusive_cpus)
> +				  ? sibling->effective_xcpus
> +				  : sibling->exclusive_cpus);
>  }
>  
>  static inline bool mems_excl_conflict(struct cpuset *cs1, struct cpuset *cs2)
> @@ -2415,6 +2418,10 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
>  	if (cpumask_empty(trialcs->effective_xcpus))
>  		return PERR_INVCPUS;
>  
> +	if ((parent == &top_cpuset) && !is_partition_valid(cs) &&
> +	    cpumask_intersects(trialcs->exclusive_cpus, subpartitions_cpus))
> +		return PERR_REMOTE;
> +
>  	if (prstate_housekeeping_conflict(trialcs->partition_root_state,
>  					  trialcs->effective_xcpus))
>  		return PERR_HKEEPING;
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index b732078bf319..f62155cf6162 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -321,6 +321,8 @@ TEST_MATRIX=(
>  	" C1-3:P2  X4:P2    .      .      .    X3:P2    .      .     0 A1:1-2|XA1:1-3|A2:3:XA2:3 A1:P2|A2:P2 1-3"
>  	" C0-3:P2    .      .    C4-6   C0-4     .      .      .     0 A1:0-4|B1:5-6 A1:P2|B1:P0"
>  	" C0-3:P2    .      .    C4-6 C0-4:C0-3  .      .      .     0 A1:0-3|B1:4-6 A1:P2|B1:P0 0-3"
> +	" X1-3:P1 CX2-3:P2  .      .    C1-3     .      .      .     0 A1:1|A2:2-3|XA2:2-3 \
> +								       A1:P-1|A2:P2 2-3"
>  
>  	# Local partition invalidation tests
>  	" C0-3:X1-3:P2 C1-3:X2-3:P2 C2-3:X3:P2 \
> @@ -443,6 +445,7 @@ TEST_MATRIX=(
>  
>  	# Changes to cpuset.cpus.exclusive that violate exclusivity rule is rejected
>  	"   C0-3     .      .    C4-5   X0-3     .      .     X3-5   1 A1:0-3|B1:4-5"
> +	"  C0-3:P1   .      .    C4-5     .      .      .     X3-5   1 A1:0-3|B1:4-5 A1:P1|B1:P0"
>  
>  	# cpuset.cpus.exclusive cannot be set to a superset of sibling's cpuset.cpus
>  	"   C0-3     .      .    C4-5   X3-5     .      .      .     1 A1:0-3|B1:4-5"

