Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FE03D0BE9
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 12:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786363744; cv=none; b=AL4GjLdYFEEJCurSc0RxGL0YHk0H+k1zlUbzyZP2OEBlcfP1FZLV2dpiwkuCYAkhAllIh7UAjOyP4FCGMHAW3hpjkhK4koOz261krFGQ/UzdmZVniw8zZ/BJ0ORSrPxar7Dr78lQY7bB8oyGIiyFhiPtQLYKNzmcEy31sDQ8igY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786363744; c=relaxed/simple;
	bh=XV8ZxqjRpLLLQfuYlGbp2be1V8T05rOZBfoW/R//gq0=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=r+id95Z2B7NUeYfsOEQ8msvHBw4L2pQhiQ9A1/KqmkTJkgsLLIZNvHI8ZwDZV3nAWmbw294B+Ay+e9Cv0qOfyDut0jZwN21n1zPNrkMbf8I/aB6yYmkr3Tb1L2/8xNajINpz4toe0b6JBe/mKa7WTCwwPAdjcwj1XTgrropiDIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A9FgdG6g; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A9FgdG6g"
Message-ID: <d80029e9-246f-43ca-b719-8a4c834b19ff@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786363740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XfsMqSeEbgZlvWkzIrsOLohICZgYToyeJ6wB2SRONMU=;
	b=A9FgdG6gYSb3GwmO8fErIpXg6ahWYKzJ2jADd0yPWE6v3Cnez/DMb0dEMuZVSAhz6mjLoQ
	Gen5djuSYapncDwY7QHOtTqmPlT62rjvGzh7SbM2R507WHFKOHqvoCTB+m7ObxL8K0AJSi
	HUeECVZJtVRTio9SInQ5WV/7lgxwMF4=
Date: Mon, 10 Aug 2026 20:08:08 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: cgroup-v2: fix stale "io" controller introduction
To: Zhe Liu <liuzhe1@kylinos.cn>, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, corbet@lwn.net, skhan@linuxfoundation.org
References: <20260810063535.327765-1-liuzhe1@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260810063535.327765-1-liuzhe1@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/8/10 14:35, Zhe Liu 写道:
> The introductory paragraph for the IO controller still states that
> weight based distribution is "available only if cfq-iosched is in use"
> and that "neither scheme is available for blk-mq devices".  This text
> dates from when the cgroup v2 documentation was first written (2015)
> and was correct at the time, but is no longer accurate:
> 
>   * cfq-iosched was removed in v4.12;
>   * blk-mq is now the only block I/O path, and both the absolute limit
>     scheme (io.max via blk-throttle) and the weight based scheme
>     (io.weight via iocost, or io.bfq.weight under BFQ) work on it;
>   * latency based protection (iolatency) and I/O priority (ioprio)
>     controllers have since been added.
> 
cfq-iosched was removed in v5.0, not v4.12 (f382fb0bcef4, "block:
remove legacy IO schedulers"). v4.12 only added the blk-mq schedulers;
cfq-iosched.c stayed until v5.0.

Otherwise looks good.

Reviewed-by: Tao Cui <cuitao@kylinos.cn>
> The rest of the section already documents io.weight, io.max,
> io.cost.{qos,model}, io.latency and io.prio.class correctly, so the
> introduction is the only part that contradicts them.  Rewrite it to
> reflect the current state.
> 
> Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index aed195a71cbf..0fbc7c963807 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1984,9 +1984,13 @@ IO
>  
>  The "io" controller regulates the distribution of IO resources.  This
>  controller implements both weight based and absolute bandwidth or IOPS
> -limit distribution; however, weight based distribution is available
> -only if cfq-iosched is in use and neither scheme is available for
> -blk-mq devices.
> +limit distribution.  Absolute BPS and IOPS limits are enforced by
> +blk-throttle and apply to all devices, while weight based proportional
> +distribution is provided by the iocost cost model controller
> +(CONFIG_BLK_CGROUP_IOCOST) and, when the BFQ I/O scheduler is in use
> +for a device, by BFQ's own cgroup support.  Latency-based protection
> +(CONFIG_BLK_CGROUP_IOLATENCY) and I/O priority assignment
> +(CONFIG_BLK_CGROUP_IOPRIO) are also available.
>  
>  
>  IO Interface Files

