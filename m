Received: from mta0.migadu.com (out-150.mta0.migadu.com [91.218.175.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3101E4AF177
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 13:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788441813; cv=none; b=brXJ67Ig17Hp9LB1A1zlEemF1PNrtbsd2DPz+hEfGk2wTdr9WWMEYKY3XpyVUGhxRPePiQdW/+P1DU36qd7gog3Xy3aDjE9eDQx3VBENDpq4uvEn/imuuY3qnuY05Prif6mLBvoNFs60j8ixGl/QUwv2zy1qYv+aOiwDGt6Hdas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788441813; c=relaxed/simple;
	bh=D9au2msUHhUO2wo307uzVLESszAMWmcvxM7FV+tmCEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AspkmFX1vrAEl+Dg58hAFslTofc1pp3IioDBjBLkVvbCaC/rN6wNdpJYZ+UXgcFfIu01uTxX4DmgQZdvAzJ31XmOrCsvMTpC4aeDAzqox+J4zVxPnHzsp0t+ge2YPPl0HXgz44mFmQyqUmmXhLnDe0yPW9DF2jVCoIZfY0NVbko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nqRCtZue; arc=none smtp.client-ip=91.218.175.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nqRCtZue"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=D9au2msUHhUO2wo307uzVLESszAMWmcvxM7FV+tmCEE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788441796; v=1; x=1789046596;
 b=nqRCtZueyCyfZ7Sd5AIGSwjt6Qt9HB29f6kcVe28o8QKJMkWd3qUhl/7F5bZAG7xOp+7xx6Z
 HhUh8vqspFgqwl7shSIgaSn3CvK01bjd609W1G77bbr4Fiw6bPsqXxZkWNCGzqGY4eOACeKljTp
 ODgV/rt7eE+4SD+oe5wN1vdQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 28a49aae88f5ebc0;
	Thu, 03 Sep 2026 13:23:16 +0000
X-Mizu-Trace-ID: 28a49aae88f5ebc0
X-Migadu-Flow: FLOW_OUT
Message-ID: <bc489900-c67f-4b93-940a-86e16ba1cfdf@linux.dev>
Date: Thu, 3 Sep 2026 21:23:10 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6.y] cgroup/cpuset: Fix misplaced DL migration reset
To: Karl Mehltretter <kmehltretter@gmail.com>, stable@vger.kernel.org
Cc: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Chen Ridong <chenridong@huaweicloud.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260901122642.11571-1-kmehltretter@gmail.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20260901122642.11571-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/1 20:26, Karl Mehltretter 写道:
> Mainline commit 4a39eda5fdd8 ("cgroup/cpuset: Reset DL migration state
> on can_attach() failure") puts the common error cleanup in
> cpuset_can_attach().  The 6.6.y backport instead placed that hunk at
> cpuset_can_fork()'s similarly named out_unlock label, while removing
> cpuset_can_attach()'s two existing targeted resets.
> 
> If cpuset_can_attach() fails after accounting a SCHED_DEADLINE task,
> cgroup_migrate_execute() does not call cpuset_cancel_attach() for the
> failing subsystem.  The temporary migration fields remain set, and a
> later successful migration can consume the stale state and corrupt
> deadline-task and pending-bandwidth accounting.
> 
> Move the reset to cpuset_can_attach()'s common error exit.  It is not
> needed in cpuset_can_fork(), which never accumulates migration DL state.
> 
> Fixes: 14897ef9341c ("cgroup/cpuset: Reset DL migration state on can_attach() failure")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
> Applies to Linux 6.6.155 and 6.6.156-rc1.
> 
> A controlled QEMU A/B on 6.6.155 forced an attach error after accounting a
> real SCHED_DEADLINE task.  The affected kernel returned with
> nr_migrate_dl_tasks=1 and sum_migrate_dl_bw=104857; both fields were zero
> with this patch.
> 
> The equivalent 6.1.y correction is submitted separately.
> 
>  kernel/cgroup/cpuset.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index f9c7178f51ada..bb413045d1744 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2630,6 +2630,8 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>  	 */
>  	cs->attach_in_progress++;
>  out_unlock:
> +	if (ret)
> +		reset_migrate_dl_data(cs);
>  	mutex_unlock(&cpuset_mutex);
>  	return ret;
>  }
> @@ -3462,8 +3464,6 @@ static int cpuset_can_fork(struct task_struct *task, struct css_set *cset)
>  	cs->attach_in_progress++;
>  
>  out_unlock:
> -	if (ret)
> -		reset_migrate_dl_data(cs);
>  	mutex_unlock(&cpuset_mutex);
>  	return ret;
>  }

Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
