Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04871799F
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 03:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789874965; cv=none; b=Y1fX5JonpkUO7maCnFJT03X6LIH/t0ZejBVCpmYjRXcHumip74uqsjBLHoEilW/vYCmgHJrOz6gEhr19MWadMYGwGZmCU6KA5fw44dtZGT9OEG3ve0pr7A2OUkYrLS9/3182r6qWKBXrMcSYVNM496ObrI8sYMxuSJkf+nbkZ3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789874965; c=relaxed/simple;
	bh=7t9pgJ258Rrl5dDQjj8X+z+ssND9xQQoxEd4N7iBmDA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=az+EBp+jrokN/UmxiKRLd0DtHlmqEad+flD6jzkgmhs1KahwgkW9gfICmECR0r/FjKcV3ZjgLZBH0t5NZp7yKexijaAh4/PV3A9VOMk33YRDe9DqRmP8Kjt/V/zjh45e1wPSYc1jc/FSN69b4C4JHCbFnTNUY1KO180k3l37Ing=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a/dbhuOv; arc=none smtp.client-ip=95.215.58.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a/dbhuOv"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=7t9pgJ258Rrl5dDQjj8X+z+ssND9xQQoxEd4N7iBmDA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789874961; v=1; x=1790479761;
 b=a/dbhuOvBedqB60bdEBAj4jNrIQA4Kq75IjusovlAOLhiMw/eRAkcCgvcM/T3HbMQMqgxLjK
 ZRDP3RdEr9KtrZACnGHRuLnVxyIjuRJEWP+i7C8UACUPJam1GJnXxkFBlc6ljpwZ46R3kIqtXcc
 RJWi3/M+xPvJjrOLTJkXHPYc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 43907a8009874808;
	Sun, 20 Sep 2026 03:29:21 +0000
X-Mizu-Trace-ID: 43907a8009874808
X-Migadu-Flow: FLOW_OUT
Message-ID: <a932b397-de99-42ba-91e7-cea923fa6f9f@linux.dev>
Date: Sun, 20 Sep 2026 11:29:16 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: Remove redundant sched domain rebuild
 from update_prstate()
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260920025256.24991-1-guopeng.zhang@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260920025256.24991-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2026 10:52 AM, Guopeng Zhang wrote:
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
> Changes in v2:
> - Rename the patch to avoid the misleading "defer" wording.
> 
>   kernel/cgroup/cpuset.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 8f24171b6055..d58ecf56f384 100644
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

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong

