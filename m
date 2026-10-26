Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.223
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792997218;
	b=GC2GjHqiXjBVSj3xgEuRQp+q321uzna5egJRyelp1u8EHkO9uLmb8YF61RXhN8z8O6FT
	 kM7i+NUEDTN20kqW5row47QCXMBUWS7/cmQHBXONnkoeztfQ3K1oxUhP3NTMeDmMfSPIl
	 su1asBUmhvKtSlo7lXB9VfaxsRuptE+vN8ajLKjaFmL/vWxGhb6EKeMJKcAMNdgXxaytb
	 Zrj58HtReVBIeDJZRXku/AOmekBL/zO50zbCS2Z7lmh9H73If9Svt4fqtKla8Cqp5kfw0
	 4DKhWmZj79oYsZJB0LrrCz8B0AEBwKgjN61VAqUm/YyWNNdu/2cqpiNemiEB7XDB5CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792997218;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=lqqASOx9ifYZB66aP1V0hiXpK1AV/oYgH5ZBw9yXVsc=;
	b=P3czI1pcOsTbcm8087eF8n3Uhk0ijp9B3Tgb7GMMzGS+3kHj3QeoxHdh9t6928R7Xs7V
	 tA2NS+BByfyarFsJ6YsCe4aoNtGyKamZtAmu84S/1xc7YQRVsZnK7y/q6EcxxMdF1Os2/
	 ojO7CrSeVdxYFepxGT/rGhimpUuuxkePKAFTkqGEaFTs+bsKfoQnoru/rRrM4WJYGAZbg
	 nKh79DyQpS4848/zLX9We/fq13FIbG7C2LpA0y0Uow2NcWBOLyvgIe6DdgxrQaVlFjdYJ
	 3VCnWJg4mFKyX2EbHX/CNJ9+RGD+QXXx8xMH2L96JZsj8kDLt+AGZsfjpf49lSb08hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pOG4jBEj;
	arc=none smtp.remote-ip=91.218.175.223
Received: from mta0.migadu.com (out-223.mta0.migadu.com [91.218.175.223])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9474606A31D
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 06:46:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9474606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pOG4jBEj
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=QQilnpc1/DiIxNOEQgnIkrmo1rXlpeywIQLIMe3oivU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792997214; v=1; x=1793602014;
 b=pOG4jBEjq530CxRe+BoMsmTnH2gxtDe5ni3KTzi7BQTOXXyYrPCKtZQhWhGYc/xCh+EoX1Si
 HD0bzjtUcrhP/yMIehVPkTahNYKMBiArpBua80XI0Ey+7P3Dwx4NFtqwdVSnpEJJehnV2q+rBj+
 DqZNMfU/mKJgk30PJx0yiqs0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 46f43af3f22f1e09;
	Mon, 26 Oct 2026 06:46:54 +0000
X-Mizu-Trace-ID: 46f43af3f22f1e09
X-Migadu-Flow: FLOW_OUT
Message-ID: <a72f4a2d-4028-4bf9-906e-e270ab21623b@linux.dev>
Date: Mon, 26 Oct 2026 14:46:47 +0800
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
Subject: Re: [PATCH-next v3 03/11] cgroup/cpuset: Fix incorrect effective_cpus
 bug in update_cpumasks_hier()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261025214449.310715-1-longman@redhat.com>
 <20261025214449.310715-4-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261025214449.310715-4-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/26 05:44, Waiman Long 写道:
> With the introduction of cpuset.cpus.exclusive, the computation of
> effective_cpus differs depending on if a cpuset is a valid partition
> root or not.
> 
> In update_cpumasks_hier(), effective_cpus is computed early
> to check if the current subtree can be skipped. Later on
> update_parent_effective_cpumask() may be called which can change the
> partition state from valid to invalid or vice versa. If the partition
> state changes, the previously computed effective_cpus may no longer be
> valid. Fix that by recomputing effective_cpus again when that happens.
> 
> Also add a new test case into test_cpuset_prs.sh to verify this change.
> 
> Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c                            | 10 ++++++++--
>  tools/testing/selftests/cgroup/test_cpuset_prs.sh |  3 +++
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index b850aba4d907..37bc79d0c647 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2327,10 +2327,16 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>  		if (update_parent) {
>  			update_parent_effective_cpumask(cp, partcmd_update, NULL, tmp);
>  			/*
> -			 * The cpuset partition_root_state may become
> -			 * invalid. Capture it.
> +			 * Capture current partition_root_state as it may have
> +			 * changed. Recompute effective cpumask if changed.
>  			 */
>  			new_prs = cp->partition_root_state;
> +			if (new_prs != old_prs) {
> +				if (new_prs > 0)
> +					compute_partition_effective_cpumask(cp, tmp->new_cpus);
> +				else
> +					compute_effective_cpumask(tmp->new_cpus, cp, parent);
> +			}
>  		}
>  
>  		spin_lock_irq(&callback_lock);
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 8bdda955b4a7..f4eb984752a0 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -364,6 +364,9 @@ TEST_MATRIX=(
>  	" C1-4:X2-4 C2-4:X3-4:P1 C3-4:X4:P2 \
>  				   .      .      X5      .      .    0 A1:1-4|A2:2-4|A3:3-4 \
>  								       A1:P0|A2:P-1|A3:P-2 ."
> +	" C1-5:X3-5:P2 C3-5:X4-5:P2 C4-5:X5:P2 \
> +				   .    X1-4     .       .      .    0 A1:1-3|A2:4|A3:4 \
> +								       A1:P2|A2:P2|A3:P-2 1-4"
>  	" C1-4:X2-4 C1-4:X3-4:P1 C3-4:X4:P2 \
>  				   .      .      .      X1      .    0 A1:1-2|A2:3-4|A3:3-4 \
>  								       A1:P0|A2:P1|A3:P-2 ."

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
