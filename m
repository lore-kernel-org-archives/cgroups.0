Received: from mta0.migadu.com (out-162.mta0.migadu.com [91.218.175.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6739249480F
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 10:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789728085; cv=none; b=UkZeqIkQKX0ZI7uVXyOo+8/nLjfj5MSTRBLuwrntsnyfxkWJD0XO8LDdx+j9mzfNkVKqXPqN6Je4begwqVevDis7cyR8ok2TLb1fZkZbDTfAtHhrO8cL7rk29a/ezcmY1eOXPjx/sd7bGRBCs6oudoyxHksSt7Afyki1/OnOuEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789728085; c=relaxed/simple;
	bh=Aaiy1rMz4EhHkblLUPeMVq/wxQPTonR1DPrr7Wel0Qo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b+ZcGfginliPcWB6GlZCuG7Z/oiBux/KP+CHtgOV+XF/otPVsPLRO4Tm2Hpa8bCPSto4lOCZfvbxfH/HfEV1IT2tsBmjqRCY020TlxxAGbJekP3T5oab+XXxZIEzQwJcPw4TEFvsX0osc8ufrjQFXKqiMtZcyJdGmx/DnkD/lbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XqYq6+zM; arc=none smtp.client-ip=91.218.175.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XqYq6+zM"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Aaiy1rMz4EhHkblLUPeMVq/wxQPTonR1DPrr7Wel0Qo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789728079; v=1; x=1790332879;
 b=XqYq6+zMDbOGoGCE1ST4Y8ls0FUIz9tRrxD7wq7p5tmM9EFpzTm0stg3PA7kIaNedkaoafqU
 wSGfW3phmMSuuqIIcqVQBEC2mNaBOk5KBy8CBh84+SR/NSQxSWcmXHMnQC/BznK0qcxPNLBlvFv
 5aaCEa/uNpe5/rkXNRhvJGOg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 876c893c0474fdfa;
	Fri, 18 Sep 2026 10:41:18 +0000
X-Mizu-Trace-ID: 876c893c0474fdfa
X-Migadu-Flow: FLOW_OUT
Message-ID: <c74015aa-0e51-4161-9fe8-c779a34c64ce@linux.dev>
Date: Fri, 18 Sep 2026 18:41:13 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Defer sched domain rebuild to common
 unlock path
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260918102730.72263-1-guopeng.zhang@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260918102730.72263-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/18/2026 6:27 PM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Both callers of update_prstate(), cpuset_partition_write() and
> cpuset_css_killed(), call cpuset_update_sd_hk_unlock() immediately
> afterwards. That helper rebuilds sched domains when force_sd_rebuild is
> set before releasing the cpuset locks, so the check in update_prstate()
> is redundant.
> 
> Commit 3bfe47967191 ("cgroup/cpuset: Move
> housekeeping_update()/rebuild_sched_domains() together") removed the
> same check from cpuset_write_resmask(). Remove the remaining one from
> update_prstate().
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 8f24171..d58ecf5 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3039,8 +3039,6 @@ out:
>   	update_partition_sd_lb(cs, old_prs);
>   
>   	notify_partition_change(cs, old_prs);
> -	if (force_sd_rebuild)
> -		rebuild_sched_domains_locked();
>   	free_tmpmasks(&tmpmask);
>   	return 0;
>   }

This title is confusing. I thought you were doing some async work, what does 
"defer" mean here? In fact, it just removes a piece of redundant code.

-- 
Best regards
Ridong

