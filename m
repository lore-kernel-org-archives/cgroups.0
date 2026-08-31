Received: from mta0.migadu.com (out-16.mta0.migadu.com [91.218.175.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464711C6FF5
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 01:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141025; cv=none; b=CQvniAdLwB8ttS+6Awy9fMNuzpE6Cj/762nhOPw6QmmjhlMptOI5G/HRsTHb6xjCOk3h3CmOjv12jKjtb1LvJ9wJgZt2FSV4U75li4VUK9C+3rCHADxA/rdT4R36ODWTIemSpfx3WBYZ8RMGg1+Y5rF1JTPhBZX3knMbE5Vfcb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141025; c=relaxed/simple;
	bh=FcvyL1cxg9jiIFc6PqfH9upLLBuIdCn+XO9mMwBInv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CDvFNuBDlQZBFhALDlEGqD5drrjeSVFHr0K5784806Ksn3XFgFVqASpfRPs9Go98a05IN/ehOmF1IGSTzaQKonFOKmPqhvCGAPwrtbgo6KqyBrm9rwOAFCybgKF3RIBZ+jLT27WqLPCwTYkZd/rEYas7HS9rOzyR2K73QVj5OFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KqZBdlvN; arc=none smtp.client-ip=91.218.175.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KqZBdlvN"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FcvyL1cxg9jiIFc6PqfH9upLLBuIdCn+XO9mMwBInv8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788141019; v=1; x=1788745819;
 b=KqZBdlvNp/zy0Gf0IR6kC9Crh1CQ5gXXRd5Sa3fARvOc+/zaVyquMZhAVV5JF1Rub72LrFSD
 Js/QrUTPuzLUiPrVtfVJvG1cWyRNZs0hXvaha04Tu39CTHa2nXYonu2sWxsF61KFI/jiKJOkqaN
 djY4nOUSl4tUex9F7CvLzgMg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 858a2bb64318c06d;
	Mon, 31 Aug 2026 01:50:09 +0000
X-Mizu-Trace-ID: 858a2bb64318c06d
X-Migadu-Flow: FLOW_OUT
Message-ID: <ba138f23-6972-44c8-8ce5-80de1f50891c@linux.dev>
Date: Mon, 31 Aug 2026 09:50:02 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Handle cpu hotplug race in
 guarantee_active_cpus()
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Farhad Alemi <farhad.alemi@berkeley.edu>
References: <20260828180322.730419-1-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260828180322.730419-1-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/29/2026 2:03 AM, Waiman Long wrote:
> With commit 2125c0034c5d ("cgroup/cpuset: Make cpuset hotplug
> processing synchronous"), the cpuset hotplug operation becomes
> synchronous. That commit also removes the code that handles the race
> between cpuset_hotplug_work and cpu hotplug notifier with the assumption
> that race is now gone. Later commit 7a0aabd9ce69 ("cgroup/cpuset:
> Always use cpu_active_mask") updates the cpuset code to always use
> cpu_active_mask instead of cpu_ohline_mask in various places including
> guarantee_online_cpus() which is also renamed to guarantee_active_cpus()
> in that commit.
> 
> In the case of CPU offline operation, cpuset_active_mask is updated
> first in sched_cpu_deactivate() to remove the offline CPU before
> cpuset_handle_hotplug() is called to update the effective_cpus of the
> affected cpusets. The cpu_online_mask is updated after that near the end
> of the offline operation to remove the offline CPU. As a result, the race
> comes back and the top cpuset may not have any active CPU leading to NULL
> pointer dereference during the race window when guarantee_active_cpus()
> is called after cpu_active_mask is updated to remove the CPU to be torn
> down but before cpuset_handle_hotplug() is able to properly update the
> effective_cpus of the top cpuset.
> 

Hi Longman,

Thank you for the patch. I believe it should resolve the issue.
Could Farhad please verify whether it works as expected?

> Fix this by adding back the NULL cs check to avoid this problem. However,
> the output of guarantee_active_cpus() will be unreliable during that
> race window.
> 

If guarantee_active_cpus() can return unreliable results during that race 
window, should it instead return an error when it cannot guarantee that the 
active CPUs are usable? Otherwise, callers might use an incorrect 'pmask', which 
could lead to other issues downstream.

> Fixes: 7a0aabd9ce69 ("cgroup/cpuset: Always use cpu_active_mask")
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Link: https://lore.kernel.org/lkml/CA+0ovChh3VjsKN1g+ZGjwwY2fGTpP7uD+aCCByLj5Qbymw=bfQ@mail.gmail.com
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   kernel/cgroup/cpuset.c | 20 ++++++++++++++++++--
>   1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 0bad5bbec6bf..309478ab21ad 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -513,10 +513,26 @@ static void guarantee_active_cpus(struct task_struct *tsk,
>   	rcu_read_lock();
>   	cs = task_cs(tsk);
>   
> -	while (!cpumask_intersects(cs->effective_cpus, pmask))
> +	while (!cpumask_intersects(cs->effective_cpus, pmask)) {
>   		cs = parent_cs(cs);
> -
> +		if (unlikely(!cs)) {
> +			/*
> +			 * The top cpuset doesn't have any active cpu as a
> +			 * consequence of a race between its caller and the cpu
> +			 * hotplug operation where cpu_active_mask is updated
> +			 * asynchronously before cpuset_handle_hotplug() is
> +			 * being called to adjust the effective_cpus of the
> +			 * affected cpusets. But we know the top cpuset's
> +			 * effective_cpus is on its way to be identical to
> +			 * cpu_active_mask minus the exclusive CPUs dedicated
> +			 * to other valid cpuset partitions. Just pass back
> +			 * the filtered cpu_active_mask in this case.
> +			 */
> +			goto out_unlock;
> +		}
> +	}
>   	cpumask_and(pmask, pmask, cs->effective_cpus);
> +out_unlock:
>   	rcu_read_unlock();
>   }
>   

-- 
Best regards
Ridong

