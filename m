Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574C02E2840
	for <cgroups@vger.kernel.org>; Sun, 11 Oct 2026 06:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791698709; cv=none; b=cD8XDFBzg6PxKyflvR1vnDQPeCnUDCPeUuKDP8ER2UedENhDt5bPvdljWdvXERSW9gGZCSde2J3NFgTxvnk6A2/1naUCncp1Exj7kNns828Ac+lWIFrLCsSA5Oi5UN1Ti8ogQ0mUlAd0rHtPcvd0YaINKVjFe4ztwmpet60jz+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791698709; c=relaxed/simple;
	bh=WTJnMz1L+nTj4XciCQtdQWPFA/4kTHabv1cDP1vlEuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b3RKw06ofqtLkCncsKzY0e8pBiLdvLJ1GN63xlErXnJqsv/t26VW13gr8p60ETH+gEO7fvf2/E2fYX+l0A0NCYUJHUCj+sAT9ezVCsDZsoHot8J5qMK6LqMm38neCeKJIy+l0kAkGtrhMwPYONVMCmsw224krJPS6JJ9cJCfPiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k7ebHTbA; arc=none smtp.client-ip=91.218.175.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k7ebHTbA"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=WTJnMz1L+nTj4XciCQtdQWPFA/4kTHabv1cDP1vlEuU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791698703; v=1; x=1792303503;
 b=k7ebHTbA38A9BLCn6VHe/vd5X2Q+cgP06+YmF+pjznRACNSYtouF5/Y/DCcRArjcWzBerIPw
 8sFvgko6hwpF1Yvmy2C4aaBrX1vCUIl2902qQIlMng+Et0qswj66df42+RI9MAeTb5bkumCdDbJ
 w4VPOqjePtYngE+mYhqWAYBA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e098440cc4f179bd;
	Sun, 11 Oct 2026 06:05:02 +0000
X-Mizu-Trace-ID: e098440cc4f179bd
X-Migadu-Flow: FLOW_OUT
Message-ID: <c0e3c4fb-82d4-4ec9-940a-f8ab94d34aa2@linux.dev>
Date: Sun, 11 Oct 2026 14:04:54 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 3/6] cgroup/cpuset: Do housekeeping check before
 converting invalid partition to valid
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Hui Peng <benquike@gmail.com>
References: <20261010221938.243859-1-longman@redhat.com>
 <20261010221938.243859-4-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261010221938.243859-4-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/11 06:19, Waiman Long 写道:
> When a hotplug event happens or when update_cpumasks_hier() is called, an
> invalid partition may be converted back to valid. However check against
> housekeeping conflict isn't being done which can lead to a partition
> state that violates the housekeeping rules. Update the code to allow
> reviving an invalid partition only if it can pass the housekeeping check.
> 
> Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 1c0441fa3bea..fb41cd76add6 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1374,6 +1374,13 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
>  	cpumask_var_t full_hk_cpus;
>  	int res;
>  
> +	/*
> +	 * For a currently invalid partition state, do the check assuming that
> +	 * it may be converted back to valid.
> +	 */
> +	if (new_prs < 0)
> +		new_prs = -new_prs;
> +
>  	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT) && (new_prs == PRS_ROOT) &&
>  	    !cpumask_subset(add_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
>  		return true;
> @@ -1956,9 +1963,16 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  			bool exclusive = true;
>  
>  			/*
> -			 * Convert invalid partition to valid has to
> -			 * pass the cpu exclusivity test.
> +			 * Convert invalid partition to valid has to pass the
> +			 * cpu exclusivity test as well as the housekeeping
> +			 * check.
>  			 */
> +			if (prstate_housekeeping_conflict(cs->partition_root_state,
> +							  parent->partition_root_state,
> +							  xcpus, NULL)) {
> +				part_error = PERR_HKEEPING;
> +				goto write_error;
> +			}
>  			rcu_read_lock();
>  			cpuset_for_each_child(child, css, parent) {
>  				if (child == cs)

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
