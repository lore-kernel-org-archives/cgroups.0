Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE591B3925
	for <cgroups@vger.kernel.org>; Sun, 11 Oct 2026 02:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791684376; cv=none; b=fW5mY9TLgQbscnqW2n7LDyT7jztyOhMpeIdRzP4f2qxEE6MWrb1QkOLVoHU2Sc8CZLtyPoL5be7ptKnATvhDJY+7enzS8T/RZFtXeYVBCrXe6yHJQzWzVeTesAxfqhqwGFB4i4ENfZAqosFpMR0eCIUKyObEa6xjx+VGg3fq+5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791684376; c=relaxed/simple;
	bh=DyIzXaWXtpsPsdJQSjLyhXE678QOzRrRW3Pw3KeUonM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WOG4H4XG5WS64jWE2JRc85JeipX85g+yfuIK+7yCKVIOGzGlCExfh2GCFnJd1JxfC3F8EYTePAfsTrqI+56TQzWUulvO0sD/WZWf92Eo3QEDk0Fh6tg9VDWdkKHy+s7h9O24+vEW9esNMFSIrL5TVKRD7w4i2lyGt48ZNcel2gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zd9T2eXo; arc=none smtp.client-ip=95.215.58.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zd9T2eXo"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=DyIzXaWXtpsPsdJQSjLyhXE678QOzRrRW3Pw3KeUonM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791684372; v=1; x=1792289172;
 b=Zd9T2eXom3bZWi+mYRrE/UO8TZrpWHY7aBxy/6Vu3/AOpFgrxJjlXN5CmLDtZqFSf++b6Gt5
 z/g77ASneo87GfB3L+JHSkvahHGe0YtHT6FIpyv9uH1ugkhfbvWvhnmItJ2mQfM7vs1HJnVElQe
 nfnv8Bo4w5JC5U4M0cfIIt/g=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b7449e92942161f2;
	Sun, 11 Oct 2026 02:06:12 +0000
X-Mizu-Trace-ID: b7449e92942161f2
X-Migadu-Flow: FLOW_OUT
Message-ID: <be5ee7da-75ba-44c7-bfeb-77abff47fca9@linux.dev>
Date: Sun, 11 Oct 2026 10:06:07 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 3/6] cgroup/cpuset: Do housekeeping check before
 converting invalid partition to valid
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Hui Peng <benquike@gmail.com>,
 Guopeng Zhang <guopeng.zhang@linux.dev>
References: <20261010221938.243859-1-longman@redhat.com>
 <20261010221938.243859-4-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261010221938.243859-4-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/11/2026 6:19 AM, Waiman Long wrote:
> When a hotplug event happens or when update_cpumasks_hier() is called, an
> invalid partition may be converted back to valid. However check against
> housekeeping conflict isn't being done which can lead to a partition
> state that violates the housekeeping rules. Update the code to allow
> reviving an invalid partition only if it can pass the housekeeping check.
> 
> Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   kernel/cgroup/cpuset.c | 18 ++++++++++++++++--
>   1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 1c0441fa3bea..fb41cd76add6 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1374,6 +1374,13 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
>   	cpumask_var_t full_hk_cpus;
>   	int res;
>   
> +	/*
> +	 * For a currently invalid partition state, do the check assuming that
> +	 * it may be converted back to valid.
> +	 */
> +	if (new_prs < 0)
> +		new_prs = -new_prs;
> +

Personally, I don't like this. I think it should be certain what new_prs really 
is when prstate_housekeeping_conflict() is called; otherwise, it makes the code 
unreadable.

So I think when new_prs < 0, we should return false.

>   	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT) && (new_prs == PRS_ROOT) &&
>   	    !cpumask_subset(add_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
>   		return true;
> @@ -1956,9 +1963,16 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   			bool exclusive = true;
>   
>   			/*
> -			 * Convert invalid partition to valid has to
> -			 * pass the cpu exclusivity test.
> +			 * Convert invalid partition to valid has to pass the
> +			 * cpu exclusivity test as well as the housekeeping
> +			 * check.
>   			 */
> +			if (prstate_housekeeping_conflict(cs->partition_root_state,
> +							  parent->partition_root_state,
> +							  xcpus, NULL)) {
> +				part_error = PERR_HKEEPING;
> +				goto write_error;
> +			}
>   			rcu_read_lock();
>   			cpuset_for_each_child(child, css, parent) {
>   				if (child == cs)

-- 
Best regards
Ridong

