Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.208
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793266981;
	b=Ozp1e6YNY4fqsyAMv7CKGkZ/7C0PZJsLyybHfoZGtrLdTo9i0B1S2GXOUF3hIHuaSJLW
	 S9HHHC2fDHnsSjG6e9k+MkN9qOWp8psUzsDlVrz5+HpQ/lJ2GkasA8z/D9opjKp/g7lzZ
	 S/a4DajliEI/K2wmv0CiVj+X2f5B2JzUH401V3f89OULMY4AZXJPucgUp/qLnSNP0OEiv
	 ZXhrp/N39NejS9neCptULg/G9HrdYbpGO2o9zIdUfm9ogP1tMFrwpZM7DmrbjgIKbdIhq
	 iRBDhox0TZOcStqaAJX6+Nd2+AnMu8C9Mrzk8rzQd6/oKlRdZTr5xf/CoZft2qBtnug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793266981;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=UP6gHQkhKRJUMAuDqFnPe45vLrw8ei1MhRg8EtXJDb8=;
	b=BtTnOCqdH0xAm1Fi/CIGMxnFnqjEMRanzR+ylZqucTLTJpTdoZMiBQ0n9qFUmkKfr5jH
	 O8Qx5axK+VC57BUpzBLSlXZHevX9mNMnFlBDXLCseWZmlxtVcCL25XWrYcEP+T0cnfYg5
	 3kHbeyUnEQ9GBgh6wpFSn26qvPW0dqZJP6ZMKtF92VfUgHVajsA5YCotZPD7/KGBX0Ltk
	 J+hCiJbjitiECWKPyZVTMru4kjXnIMKtiBRxilnN/mk6bVjZWrT+cdYuvTC5FX/d62nTC
	 jdPgxND2hcpUZXakikJAMEaoNyCm4xcWkYTSqewQpqz9Ow47x7ygxRZ8X1WqH71Rsxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=enYnEgW9;
	arc=none smtp.remote-ip=95.215.58.208
Received: from mta1.migadu.com (out-208.mta1.migadu.com [95.215.58.208])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4CF606A31D
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 09:42:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D4CF606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=enYnEgW9
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=iS3D+aJiyxzfc6b48kGp2uoaVhzDYrJGX0S/tMkSCok=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793266977; v=1; x=1793871777;
 b=enYnEgW92EmhxTm+hGdhj/hwFz7ZdeQWB3O8UUhPgAq/EuwAR4LDMQTd2yfNENk8iGM+L7O2
 q+DD8yx42bk0Lc8zamCJeYqQiJ0fe8ADVQ6FyYgmuLW+0/tSlS61Sgn/yeZ1xiLzQZPTHVEILSA
 MTWAH/CFZtdesbifkBnWP2U0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cbe5db6c4e60f0d6;
	Thu, 29 Oct 2026 09:42:57 +0000
X-Mizu-Trace-ID: cbe5db6c4e60f0d6
X-Migadu-Flow: FLOW_OUT
Message-ID: <661486ab-4879-47cd-8035-ae0d7a7d7462@linux.dev>
Date: Thu, 29 Oct 2026 17:42:52 +0800
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
Subject: Re: [PATCH-next] cgroup/cpuset: Fix incorrect CPU accounting with
 parent's effective_xcpus expansion
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261028152608.648427-1-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261028152608.648427-1-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/28 23:26, Waiman Long 写道:
> Commit ec0254b9eb49 ("cgroup/cpuset: Release invalid isolated CPUs with
> a shrunk root partition parent") fixes incorrect isolated_cpus accounting
> when contraction of a parent's effective_xcpus can cause a child partition
> to lose isolated CPUs. Expansion of parent's effective_cpus can also allow
> a child partition to gain more effective_xcpus. However, the current code
> doesn't handle this case correctly leading to incorrect effective_cpus
> and isolated_cpus accounting. Fix that by looking for this possible
> expansion of effective_xcpus and perform the proper accounting action.
> 
> New test cases are added to test this effective_xcpus expansion scenarios.
> 
> Reported-by: Guopeng Zhang <guopeng.zhang@linux.dev>
> Link: https://lore.kernel.org/lkml/20261027123837.100909-1-guopeng.zhang@linux.dev
> Signed-off-by: Waiman Long <longman@redhat.com>

I have tested this patch. In the scenarios I tested, the double grant
and the isolated_cpus accounting after the expansion are now correct.

> ---
>  kernel/cgroup/cpuset.c                            | 12 ++++++++++++
>  tools/testing/selftests/cgroup/test_cpuset_prs.sh | 15 +++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3219f927c35e..39c81a0a8ab9 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2097,6 +2097,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  							     parent->effective_xcpus);
>  			if (!cpumask_empty(tmp->addmask))
>  				isolated_cpus_release(cs, tmp->addmask);
> +			/* Expansion of parent's effective_xcpus is handled below */
>  		}
>  		if (nocpu) {
>  			part_error = PERR_NOCPUS;
> @@ -2106,11 +2107,22 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  						     parent->effective_xcpus);
>  		} else if ((parent_prs == PRS_ISOLATED) &&
>  			   ((old_prs == PRS_ROOT) || (old_prs == -PRS_ROOT))) {
> +			/* Parent partition state changed to PRS_ISOLATED */
>  			part_error = PERR_ISOPARENT;
>  			if (old_prs == PRS_ROOT) {
>  				cpumask_copy(tmp->addmask, cs->effective_xcpus);
>  				adding = true;
>  			}
> +		} else if (is_partition_valid(cs) &&
> +			   !cpumask_equal(tmp->delmask, cs->effective_xcpus)) {

The branch is also entered when the freshly computed effective xcpus
shrink, e.g. after a parent contraction. The cpumask_andnot() then
computes an empty delta and it doesn't seem to cause any harm. Do we
need to tighten the condition?

> +			/*
> +			 * If there is an expansion of parent's effective_xcpus,
> +			 * we may take more xcpus from parent. The parent's
> +			 * effective_cpus should still have active CPUs or nocpu
> +			 * should have been set.
> +			 */
> +			deleting = cpumask_andnot(tmp->delmask, tmp->delmask,
> +						  cs->effective_xcpus);
>  		} else if (is_partition_invalid(cs)) {
>  			struct cgroup_subsys_state *css;
>  			struct cpuset *child;
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 83ef6c781af3..844efdf029cd 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -531,6 +531,21 @@ TEST_MATRIX=(
>  	" C1-4:P1 C3-4:P2   .      .    T:C4-6   .      .      .     0 A1:5-6|A2:4 A1:P1|A2:P2 4"
>  	" C1-4:P1 C1-2:P2   .      .    T:C4-6   .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
>  
> +	# The extra CPUs gained by a child partition when its parent expands the
> +	# exclusive CPUs have to be taken away from the parent.
> +	" C2-6:X2-5:P1 CX3-6:P1 \
> +	                    .      .    X2-6     .      .      .     0 A1:2|A2:3-6|XA2:3-6 A1:P1|A2:P1 ."
> +	" C2-6:X2-5:P1 CX3-6:P2 \
> +	                    .      .    X2-6     .      .      .     0 A1:2|A2:3-6|XA2:3-6 A1:P1|A2:P2 3-6"
> +
> +	# Both expansion and contraction of parent's effective_xcpus will be
> +	# correctly handled in child partition and the child can be invalidated
> +	# if a populated parent could lose all its effective_cpus.
> +	" C2-6:X2-5:P1 CX3,5-6:P2 \
> +	                    .      .    X4-6     .      .      .     0 A1:4|A2:5-6|XA2:5-6 A1:P1|A2:P2 5-6"
> +	" C2-6:X2-5:P1 CX3-6:P2 \
> +	                    .      .   T:X4-6    .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
> +
>  	#
>  	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
>  	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------

BTW, about the housekeeping check issue from my previous email.
I verified it with the session below on a nohz_full=8-31 boot where
CPUs 0-7 are the housekeeping CPUs:

  # cat /sys/devices/system/cpu/nohz_full
  8-31
  # cd /sys/fs/cgroup
  # echo +cpuset > cgroup.subtree_control
  # mkdir -p A/B
  # echo 0-7 > A/cpuset.cpus
  # echo 1-7 > A/cpuset.cpus.exclusive
  # echo root > A/cpuset.cpus.partition
  # echo +cpuset > A/cgroup.subtree_control
  # echo 0-7 > A/B/cpuset.cpus
  # echo 0-7 > A/B/cpuset.cpus.exclusive
  # echo isolated > A/B/cpuset.cpus.partition
  # cat /sys/fs/cgroup/cpuset.cpus.isolated
  1-7
  # cat A/B/cpuset.cpus.exclusive.effective
  1-7
  # echo 0-7 > A/cpuset.cpus.exclusive
  # cat A/B/cpuset.cpus.partition
  isolated
  # cat /sys/fs/cgroup/cpuset.cpus.isolated
  0-7

B stays a valid isolated partition holding all the housekeeping CPUs
and there is no warning at all.

If the housekeeping issue is going to be addressed in this series, is
a test case like the one below worth adding?

+	# An isolated child partition cannot grow to take over the last
+	# housekeeping CPU when its parent expands the exclusive CPUs.
+	" C0-7:X1-7:P1 C0-7:X0-7:P2 .      .      X0-7     .      .      .     0 A1:0-7 A1:P1|A2:P-2 ."

Thanks,
Guopeng
