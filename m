Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090C428A72F
	for <cgroups@vger.kernel.org>; Tue,  2 Jun 2026 09:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780392475; cv=none; b=hXwubI9VxudgfnOFArDPZO+r/EIOaJ60sJAl461t0vkawJ6JqiDVmSLaaZSk42ePtKw465kIM7WG0vyCUvTssK6BAVLVNIe8/hiJy4tNPajxBWkISgpIChcGEavOGIpAw2pI6po/6Rs1ugqQTCDT2CZ7GalnNO/njaUSCXUyFac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780392475; c=relaxed/simple;
	bh=o0dInHLxDrOP/PQSoOYN9Tnyap42b+JbKTG1Rj7NRAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qc5Mkcvd6NSIaYQy6dnSnxUGgq9Ergf0PxHjSPWW0JowF8UK9Cb2AmLXUBdHlEO0yyCp4BwARK1Ri/sD3trKVGaU3FV3DYNUPGKYiEXoiECSfs80BeUcNaWBFjdbHlAImIZFOHUFVWei58R84nZCoUdeJ/vBArVahr0h2MbmEq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GfOarAxj; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GfOarAxj"
Message-ID: <7775e634-7667-4184-9d5a-cd17162ef402@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780392471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yNzDqkRptSQL7P61FVRdJ+sZX3qCFMf52BBPiR1VjPs=;
	b=GfOarAxj8b8ArNpP13ZDurfiNRdc21fweiidAYk1JY6CRu1LEy2+F7zF+yn0dMyz5shMGW
	fYWJ6aBU4p670Jjdu+Y/hY8LDpNCOHjXI/Y3iL7py8WYUDQi9AjefNRIp7Lr7Hguq/wUc8
	oXEoXEFCryTR9FrUUu4/2zIH8tkVMPw=
Date: Tue, 2 Jun 2026 17:27:10 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] cgroup/cpuset: Free sched domains on rebuild guard
 failure
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long
 <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: Chen Ridong <chenridong@huaweicloud.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260528093742.1792456-1-guopeng.zhang@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260528093742.1792456-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2026/5/28 17:37, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> generate_sched_domains() returns sched-domain masks and optional
> attributes that are normally handed to partition_sched_domains(), which
> takes ownership of them.
> 
> rebuild_sched_domains_locked() has a WARN guard after
> generate_sched_domains() and before partition_sched_domains() to avoid
> passing offline CPUs into the scheduler domain rebuild path. If that
> guard fires, the function currently returns directly without freeing
> the generated doms and attr.
> 
> Free the generated sched-domain masks and attributes before returning
> from the guard failure path.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>  kernel/cgroup/cpuset.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 51327333980a..c5fdebc205d8 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1004,8 +1004,11 @@ void rebuild_sched_domains_locked(void)
>  	* prevent the panic.
>  	*/
>  	for (i = 0; doms && i < ndoms; i++) {
> -		if (WARN_ON_ONCE(!cpumask_subset(doms[i], cpu_active_mask)))
> +		if (WARN_ON_ONCE(!cpumask_subset(doms[i], cpu_active_mask))) {
> +			free_sched_domains(doms, ndoms);
> +			kfree(attr);
>  			return;
> +		}
>  	}
>  
>  	/* Have scheduler rebuild the domains */

Thank you. This helps prevent a memory leak in this abnormal scenario. I
should have included it when I originally added this check.

-- 
Best regards,
Ridong
