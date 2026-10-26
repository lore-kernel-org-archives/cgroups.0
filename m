Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.142
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793004709;
	b=0acjOiOK6W4e/1+CztUOSb0UnuRSl0ViN4AWBIkYWtN0hr+Rs8B4DfGhZDK+Ev61IMjD
	 GbcGyVmLhLKqNHVlhzg2YAz0ggdjHOGuUmm9dEeUoXHMsNOwcj64ABXH2w3dklcCypnDC
	 xquBPJjT/3CQ+KDBhOwkN/qaug0bP0tqeMQhaTVjJQW0ErkaBYDLgshxxjMx3toHg1ZmM
	 GoDJgLzgV32iDmL9n7D+z6Vot9wupy7c17LOhECLVGroSfwciAWABo/jE56MiMLAHvzXZ
	 o7hBdWZ9I5Mii2MI1mvOBXWdHwrjznbWvCQokVtd1YdL/dyz2ucRyv/lrw/x+gvtGMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793004709;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=ZinQ6VNv4xBXZl4N4C9ER6UekGAVyBfk45WZEBqx6kM=;
	b=O4pIpbqzDSMWU7o4gQm7/h92q4QlQJ8jt32P3n51kIUzaC5EoyEGOSk4xxCrcLsGBs8P
	 pWHneahmBE0HNO9xs1p1Ylz795/a+rTmHHzWZITPAaxTq1gVFqkf5NDRaUvvpTRwVPZzy
	 RSop2hJWFzlFaFNp4Tdl7Vkd+/coMVvw/tNGbTtcmLHZblwjA23yLJabA+XemmHHSMCTs
	 1VYLagmnaGDl/icwX1F5fzhfNRuz8A4O6g9GtZj42oub6+GqiEL9l6EzDF5guDAKOqtLi
	 80cXqcG4wYZJm7kAq4s+dQsaEPJ0r0uMgBwSuieLo8NatDlb3cfE1ZKAWlItialIM5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=u3v+FL4y;
	arc=none smtp.remote-ip=95.215.58.142
Received: from mta1.migadu.com (out-142.mta1.migadu.com [95.215.58.142])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8EE606A31E
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 08:51:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD8EE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=u3v+FL4y
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OApuNekQXX8U7HnevQle7FcTjvOpTGZzG9MKgoTNv5w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793004706; v=1; x=1793609506;
 b=u3v+FL4yfxuhQ9RYtNgsEWRw0oUkbZVa8JgcWbUJ0obK6A6FKr+NIQ9F+JbkRyrOBx9fI+PT
 5V6kt3xH7oy4R7Z59JkIv8cyXhWiV/6gfFob5pW1erSrccMwtzAoVE3g/xfuHJwAWnom9F4wg1i
 xAZM8xuWakz+s6pXxnB6ogrU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 76da52be332fa9e2;
	Mon, 26 Oct 2026 08:51:45 +0000
X-Mizu-Trace-ID: 76da52be332fa9e2
X-Migadu-Flow: FLOW_OUT
Message-ID: <29f2442d-60c5-44ce-814e-7ad2d7391a5e@linux.dev>
Date: Mon, 26 Oct 2026 16:51:37 +0800
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
Subject: Re: [PATCH-next v3.1 09/11] cgroup/cpuset: Release invalid isolated
 CPUs with a shrunk root partition parent
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261025214449.310715-10-longman@redhat.com>
 <20261025235359.320155-1-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261025235359.320155-1-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/26 07:53, Waiman Long 写道:
> It is also reported by sashiko that there may be leakages of isolated
> CPUs when a root partition parent shrinks its effective_xcpus with
> isolated partition children. Leakage here means that isolated_cpus may
> contain extra CPUs that are not in any isolated partitions and not boot
> time isolated. Those CPUs cannot be used in any isolated partitions
> anymore.
> 
> There are 2 different cases here. The effective_xcpus becomes empty and
> the isolated partition should be invalidated in this case. Alternatively
> some of its effective_xcpus are not in parent's effective xcpus but
> still have some valid effective_xcpus left. The isolated partition can
> remain valid. In both cases, the invalid isolated CPUs will have to be
> released from isolated_cpus if appropriate.
> 
> Fix that by calling isolated_cpus_release() to release those isolated
> CPUs from isolated_cpus.
> 
> New test cases are added to test_cpuset_prs.sh to test this.
> 
> Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c                           | 16 +++++++++++++++-
>  .../testing/selftests/cgroup/test_cpuset_prs.sh  |  6 ++++++
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
>  [v3.1] Fix the typo "cs->effective_cpus" => "cs->effective_xcpus".
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 6d224e614e74..9a2a6f727929 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2012,8 +2012,22 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  		 *
>  		 * A partition error happens when parent has tasks and all
>  		 * its effective CPUs will have to be distributed out.
> +		 *
> +		 * For an isolated partition with a shrunk root partition parent
> +		 * we may need to return some or all of its isolated CPUs.
>  		 */
> -		if (nocpu || cpumask_empty(tmp->delmask)) {
> +		nocpu |= cpumask_empty(tmp->delmask);
> +		if ((parent_prs == PRS_ROOT) && (old_prs == PRS_ISOLATED)) {
> +			cpumask_clear(tmp->addmask);
> +			if (nocpu)
> +				cpumask_copy(tmp->addmask, cs->effective_xcpus);
> +			else if (!cpumask_subset(cs->effective_xcpus, parent->effective_xcpus))
> +				cpumask_andnot(tmp->addmask, cs->effective_xcpus,
> +							     parent->effective_xcpus);
> +			if (!cpumask_empty(tmp->addmask))
> +				isolated_cpus_release(cs, tmp->addmask);
> +		}
> +		if (nocpu) {
>  			part_error = PERR_NOCPUS;
>  			if (is_partition_valid(cs))
>  				adding = cpumask_and(tmp->addmask,
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index d7d0bef0a17a..ceb1a3b4f94e 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -522,6 +522,12 @@ TEST_MATRIX=(
>  	# its effective xcpus will be removed from isolated_cpus.
>  	" C1-4:P1 C3-4:P2   .      .    T:C3-4   .      .      .     0 A1:3-4|A2:3-4 A1:P1|A2:P-2 ."
>  
> +	# When a root partition parent with an isolated partition child is shrunk
> +	# so that its effective xcpus is no longer a superset of its child effective
> +	# xcpus, the invalid isolated CPUs should be removed from cpuset.cpus.isolated.
> +	" C1-4:P1 C3-4:P2   .      .    T:C4-6   .      .      .     0 A1:5-6|A2:4 A1:P1|A2:P2 4"
> +	" C1-4:P1 C1-2:P2   .      .    T:C4-6   .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
> +
>  	#
>  	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
>  	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
