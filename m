Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793798723;
	b=cqmY1YQ5gCjAbW8+1vCVvFvEECS0ev4xzNrt3e9HKBLX5CIqqINEJPQ/xjoUt4vwXQud
	 KXA+oVnXyz4qyAoia5pyXEQcCOW9VeC6FlROZ9ggmPmsFR+zHUMbRTHlrC5fy873Gy4BJ
	 pGZe9qVJTjV6/ws6ZppDf0XJeUXiJAQtq2V+tkwQouzrwm98ZCa9fpbIdmxRVL0MDCarg
	 wuazBf1tPn3GVCWq8+t+Baz2TyQtu0tHMX34DWL4PLTYWhh+UJdpX+TKpT7aGb5HdJDFJ
	 MtfsdKL3a/k/JoohxzwwM7nts4AOkqJekSIkplGAtrVyJmlGnl46C8Hpq0EvEL8zmyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793798723;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=WewCNuo8YovPY2dmGEGeXhtwDfjeK4b5OhGvtgGhTF0=;
	b=p1dwaYeakD9y9zIaQjs3toUe/ohaCh7KTeCTY0V9Hcvy0Y2zNW75DU0J/JoFNVLBfUVR
	 BTuGWESuZ0L58tefJ8pIe6Y41N1DB9NGHX1r3THH0i1tYpEd2RV0jLq6bXiuxbY+bwf6J
	 9gEcqgNqR3Bz6H3dgcNABsqp+CO/GMcPtoRjdZMnhrSsmz/BGycmggHp1uP01vvo35y2T
	 WkNb5rV3fLTaprchumhgPEZytbXguIQ0p1cQZGLhDX+dldudr7sphpxw949uKkus9Q8wF
	 tTTrvanuw38vxUDtoT3vS0fsxfwLRTurtr+SgXNKWacDXnuLPAZfPKlGEZkaWNxqelw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="YhT7a/p1";
	arc=none smtp.remote-ip=95.215.58.113
Received: from mta1.migadu.com (out-113.mta1.migadu.com [95.215.58.113])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21E0606A31B
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 13:25:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E21E0606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YhT7a/p1
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BNLoTZcqlZkdyN8nI/N/fiKEzBgCvrjgOnls62w/d7g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793798720; v=1; x=1794403520;
 b=YhT7a/p1dfsL/eIlLPBtQDmuzjGr03JYM2Gxa5WMRSSPpTLxzmO3W1fKHTFQjo8AgVngvNSc
 JzwxYKxyMMo1od4tWhMEmYiw96VQeFm440m2HOBGqSOificvFPUSbqBUSjWMAYGFKzVYngYH6Ni
 liDZR52RlRNsexBbDOBBvHsw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id eca819494a8d83eb;
	Wed, 04 Nov 2026 13:25:19 +0000
X-Mizu-Trace-ID: eca819494a8d83eb
X-Migadu-Flow: FLOW_OUT
Message-ID: <57f4dd69-a326-4802-b9b3-f715568b8ea4@linux.dev>
Date: Wed, 4 Nov 2026 21:25:10 +0800
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
Cc: cui.tao@linux.dev, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu,
 stable@vger.kernel.org
Subject: Re: [PATCH] cgroup/freezer: walk exiting tasks in the v1 freezer
To: mt4022@columbia.edu, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
References: <20261103-cgroup-freezer-exiting-v1-1-00d43b443747@columbia.edu>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20261103-cgroup-freezer-exiting-v1-1-00d43b443747@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Mani,

在 2026/11/4 02:09, Mani Tofigh via B4 Relay 写道:
> From: Mani Tofigh <mt4022@columbia.edu>
> 
> An exiting task can stay frozen after its v1 freezer cgroup is thawed.
> Since commit a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
> the css task walk hides an exiting task once its process has no live
> threads left.  That count drops when another thread of the process
> exits, which can happen between the freeze and the thaw walk.  A pid
> namespace init hits this easily since it waits freezably in
> zap_pid_ns_processes() after commit 81933038f5e2 ("pid_namespace: make
> zap_pid_ns_processes() freezable"):
> 
>   Task A (pid ns init)      Task B (A's thread)      Task C
>                             do_exit()
>                               exit_signals()
>   do_exit()
>     zap_pid_ns_processes()
>                                                      write FROZEN
>                                                        /* A frozen */
>                               /* live count 0 */
>                                                      write THAWED
>                                                        /* A skipped */
> 
> A then stays frozen even after SIGKILL:
> 
>   [   10.775155] task:fz-init         state:D stack:28152 pid:65    tgid:65    ppid:1      task_flags:0xc0004c flags:0x00080000
>   [   10.775176] Call Trace:
>   [   10.775180]  <TASK>
>   [   10.775188]  __schedule+0x10f1/0x4760
>   [   10.775252]  schedule+0xd7/0x2c0
>   [   10.775265]  zap_pid_ns_processes+0x2c7/0x5f0
>   [   10.775346]  do_exit+0x1bf4/0x2560
>   [   10.775403]  __x64_sys_exit+0x3d/0x50
>   [   10.775414]  x64_sys_call+0x156c/0x1570
>   [   10.775425]  do_syscall_64+0xfb/0x590
>   [   10.775450]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   [   10.775529]  </TASK>
> 
> Use CSS_TASK_ITER_WITH_DEAD in the three v1 freezer walks so they all
> see the same tasks, as commit 60f21a264930 ("cgroup, sched_ext: Include
> exiting tasks in cgroup iter") did for sched_ext.  With the fix, A is
> thawed and exits.
> 

Thanks for the clear writeup and reproducer. Ran freezev1.c against
next-20261103 on a 2-vCPU VM. Base reproduced the hang on round 1
(5.1s), with the patch 600s / 6124 rounds ran clean.

Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Tested-by: Tao Cui <cuitao@kylinos.cn>

Thanks,
Tao
> This bug was identified and confirmed with the help of a deterministic
> hypervisor currently under development.  The C reproducer below however
> hits it within about 10s.
> 
> Fixes: a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> ---
> Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/freezev1.c
> ---
>  kernel/cgroup/legacy_freezer.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cgroup/legacy_freezer.c b/kernel/cgroup/legacy_freezer.c
> index 8545e0d1ba3d..bd11047f2311 100644
> --- a/kernel/cgroup/legacy_freezer.c
> +++ b/kernel/cgroup/legacy_freezer.c
> @@ -265,7 +265,7 @@ static void update_if_frozen(struct cgroup_subsys_state *css)
>  	rcu_read_unlock();
>  
>  	/* are all tasks frozen? */
> -	css_task_iter_start(css, 0, &it);
> +	css_task_iter_start(css, CSS_TASK_ITER_WITH_DEAD, &it);
>  
>  	while ((task = css_task_iter_next(&it))) {
>  		if (freezing(task) && !frozen(task))
> @@ -309,7 +309,7 @@ static void freeze_cgroup(struct freezer *freezer)
>  	struct css_task_iter it;
>  	struct task_struct *task;
>  
> -	css_task_iter_start(&freezer->css, 0, &it);
> +	css_task_iter_start(&freezer->css, CSS_TASK_ITER_WITH_DEAD, &it);
>  	while ((task = css_task_iter_next(&it)))
>  		freeze_task(task);
>  	css_task_iter_end(&it);
> @@ -320,7 +320,7 @@ static void unfreeze_cgroup(struct freezer *freezer)
>  	struct css_task_iter it;
>  	struct task_struct *task;
>  
> -	css_task_iter_start(&freezer->css, 0, &it);
> +	css_task_iter_start(&freezer->css, CSS_TASK_ITER_WITH_DEAD, &it);
>  	while ((task = css_task_iter_next(&it)))
>  		__thaw_task(task);
>  	css_task_iter_end(&it);
> 
> ---
> base-commit: fffbdad76a57eed26cff1be19f4cbb407f0b6e7c
> change-id: 20261102-cgroup-freezer-exiting-c7f60e4c3200
> 
> Best regards,
> --  
> Mani Tofigh <mt4022@columbia.edu>

