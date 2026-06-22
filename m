Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5501078F4A
	for <cgroups@vger.kernel.org>; Mon, 22 Jun 2026 01:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782092552; cv=none; b=ade9Qx7ehI893o8zmEdP0DxSSYSnL+AKvGRZky2IOpVBzU9EYLnv6KZxV+PihPG3pslUticenI6DTXACPzvvAhYTYwLRlU05EaG2IU+plTy6gmuhl0x+U7+53su1zi5QIP2caEvWta+7s+klxbaGm81RPM8Vw0tnisrwePg0nBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782092552; c=relaxed/simple;
	bh=Cz9Ld5YcxQmdCb3wmnb9RHjpjGqk0/1visOeYkHsGw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ehC6vCw67iW9BvRJ9k8Q8ARX78VgMWc+RJHSA6KYJOpnMdkL6tOyPOjf12zn+yOuVmSINCIlIG21X98DzhXRnmb/AmUnhNoHkyzB+WKkOelQdAqiM5pCKM2S7S3J/T6e683ix1gPvtJ7cFotjA4P5f7J1D34Az5cwCpDXeTLwUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wkgpIn8o; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wkgpIn8o"
Message-ID: <e7f3385a-953d-4e82-9e84-30029da7747b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782092539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ed3uADOh58bQx7YJ5G5Wy/xNlbT1GNIfgqT8EJ3Y7qI=;
	b=wkgpIn8ovHyf81iFJXdi+qeQV71iHuM/ENCcPR8lAkanzvkNzaj4agu+xqnWVn5sA/4R50
	anrOG9hy3OpZSEu7C3xGhAD+unhZ9cnyvkeTi8b2svHXytYrfq0dPaBxXjl1dpJHvRmhkA
	JTAdvXYfpCgxmJTF4KzgR2JiLUb74rQ=
Date: Mon, 22 Jun 2026 09:42:10 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v7 1/9] cgroup/cpuset: rebind mm mempolicy to
 effective_mems, not mems_allowed
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Li Zefan <lizefan@huawei.com>,
 Farhad Alemi <farhad.alemi@berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Aaron Tomlin <atomlin@atomlin.com>, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Gregory Price <gourry@gourry.net>, David Hildenbrand <david@kernel.org>,
 stable@vger.kernel.org
References: <20260621032816.1806773-1-longman@redhat.com>
 <20260621032816.1806773-2-longman@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260621032816.1806773-2-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 6/21/2026 11:28 AM, Waiman Long wrote:
> From: Farhad Alemi <farhad.alemi@berkeley.edu>
> 
> Creating a child cpuset where cpuset.mems is never set leads to a div/0
> when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
> CPU hotplug event.
> 
> Reproduction steps:
>   1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
>   2) Move the task into the child cpuset
>   3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
>   4) unplug and hotplug a cpu
>        echo 0 > /sys/devices/system/cpu/cpu1/online
>        echo 1 > /sys/devices/system/cpu/cpu1/online
>   5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
>      call to __nodes_fold()
> 
> The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
> nodes to the rebind routine.  Use cs->effective_mems instead, which is
> guaranteed to have a non-empty nodemask.
> 
> Closes: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
> Link: https://lore.kernel.org/all/CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com/
> Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
> Suggested-by: Gregory Price <gourry@gourry.net>
> Suggested-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Acked-by: Waiman Long <longman@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>   kernel/cgroup/cpuset.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 591e3aa487fc..b21c31650583 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2653,7 +2653,7 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
>   
>   		migrate = is_memory_migrate(cs);
>   
> -		mpol_rebind_mm(mm, &cs->mems_allowed);
> +		mpol_rebind_mm(mm, &cs->effective_mems);
>   		if (migrate)
>   			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
>   		else

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>

-- 
Best regards
Ridong

