Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619587;
	b=00ngjWalxNGieaXvSd1PAl6xFxJiL/phEDSZYlQ6EXFuWiqjXwrw0PqJ7wXqv1jj6uzN
	 +WfRobhWuOnfG1iQeMnZBLCyXsXROsHJP000v9hvtc3F3btmVZjSc05onAG/OjSBBbm70
	 K7kBvg20xr+5jT8HhI9Ipqfos9nAl6sNmC62m1t+/FF8XeWa2XzDHXJLUGpa1yM5zVKI7
	 tyd32JKbTLNBi/LifqXb4VArGuiPn0IgVHXcSZVO4BrOb9mNpFPdD2hynXGnR+mvhfPav
	 XtcHoVaf5QdzhfFX7GylqW8gmzRXQk0hOeWE/MSP7AgPHXsZxz/KbE6uylEw1wM2V+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619587;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=grCglpvS1lmgRAOWz2fgR+PrAXF3N9/tLLxd6ICUxy4=;
	b=dqqXZ1TOvKJfp7PCQDxUEOdwFQPOtWuYwgGjEhxDDih1/yZtKHMxJczhRRsKeoaSPqYT
	 OLN7DB9Zz3jxDfkvMxQotlhb9bBw6dHXha0EIlL/RyC/JGKGEHdTu7IJI7m+j2ylO+YM8
	 yCecI27BvXminuTELQH2cOT+L/YJBzwZ+1VrKsmzDDn52PtCI7sEQoZPMpNTM/HfRZly2
	 rc0mZW4On1h/mwUt6chbTmajSZITO7rz/C8uIGZtDaOBkpoyFPGr0WqZmzQ6/Gt4I1mIv
	 YVW4jauwYFPUikWq0TDNPakl5n+uWQLmUWHWI/esUD7c58vjBSvJ2B0BxqEFaPfD/Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iB0RPjE+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF88606A31E;
	Wed, 25 Nov 2026 15:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iB0RPjE+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61781F000CA;
	Wed, 25 Nov 2026 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795619587;
	bh=grCglpvS1lmgRAOWz2fgR+PrAXF3N9/tLLxd6ICUxy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iB0RPjE++rgwjZ78MftirKMEilvmJDSVplUkjMjsFliZsNlVhz6LHbMtmfxYfW/Nj
	 F2kcGN3/AuXODAtuxNeGHGbdpk+63bx44lMEcnrQNBIKjqpf6iSzOl1YqdnVUEGetn
	 OKiqemMdcV7N4q8ABQ0nDKD79HzpSNSW9fOsBTNectISbm/KEHpcSl1czMhDqGCoJS
	 X+CupyitUx2Bnea12XiUCZbF2o0D650hluaLFO2B/OPwUsgi85tLRbLy6/px3fo4Id
	 HuRQ9/IqTVAaYq1e6Y9lQCnayy6qWKMjYSDk2p5GA2nqdjVMfOp4ExBIn4kJfauyN5
	 a9HmxBEOgmsmQ==
Date: Wed, 25 Nov 2026 15:13:05 +0000
From: Harry Yoo <harry@kernel.org>
To: Takuo Koguchi <takuo.koguchi@gmail.com>
Cc: cip-dev@lists.cip-project.org, Steven Rostedt <rostedt@goodmis.org>, 
	Takuo Koguchi <takuo.koguchi.sw@hitachi.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] memcontrol: protect drain_local_stock() with
 get_cpu_var()
Message-ID: <awb6bJ1-_8zeyTYQ@thinkstation>
References: <20261125043900.3618611-1-takuo.koguchi.sw@hitachi.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125043900.3618611-1-takuo.koguchi.sw@hitachi.com>

[+Cc PREEMPT_RT and MEMCG folks properly ]

This doesn't look like a patch for the latest mainline.
Which kernel version is it based onto?

On Wed, Nov 25, 2026 at 01:39:00PM +0900, Takuo Koguchi wrote:
> On PREEMPT_RT, drain_local_stock() accesses the per-cpu memcg_stock
> via this_cpu_ptr() without disabling preemption.
>
> Accesses to memcg_stock from consume_stock() and refill_stock() are
> already serialized using get_cpu_var()/put_cpu_var(). However,
> drain_local_stock() still accesses the same per-cpu state without
> equivalent protection.
> 
> As a result, drain_local_stock() may be preempted while operating on
> memcg_stock, allowing another task running on the same CPU to observe
> or modify the same per-cpu stock concurrently. This may result in
> inconsistent updates of cached charges and stock counts.
> 
> Failures were observed as divergence between memcg accounting and
> actual memory consumption. The divergence occurred in both positive
> and negative directions, indicating corruption of accounting state
> rather than a simple charge leak.
> 
> Under stress testing, the accounting divergence was reproducible and
> was frequently accompanied by oops storms. Protecting
> drain_local_stock() with get_cpu_var()/put_cpu_var() eliminated the
> accounting divergence and the associated stability issues.
> 
> Use get_cpu_var()/put_cpu_var() in drain_local_stock() to serialize
> accesses to the per-cpu memcg stock and make its protection consistent
> with the other memcg stock users.
> 
> Signed-off-by: Takuo Koguchi <takuo.koguchi.sw@hitachi.com>
> ---
>  mm/memcontrol.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f9d80952723c..9b298ce10a7a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1933,14 +1933,21 @@ static void drain_stock(struct memcg_stock_pcp *stock)
>  }
>  
>  /*
> - * This must be called under preempt disabled or must be called by
> - * a thread which is pinned to local cpu.
> + * Drain this cpu's stock.  Called directly by drain_all_stock() for the
> + * local cpu and as a work item for the other cpus.  Preemption is
> + * disabled here because neither caller guarantees it on PREEMPT_RT:
> + * drain_all_stock() only holds get_cpu_light(), which is a plain
> + * barrier() without CONFIG_SMP, and the work item runs in a preemptible
> + * kworker.  consume_stock() and refill_stock() run with preemption
> + * disabled, so this keeps every user of the per-cpu stock serialized.
>   */
>  static void drain_local_stock(struct work_struct *dummy)
>  {
> -	struct memcg_stock_pcp *stock = this_cpu_ptr(&memcg_stock);
> +	struct memcg_stock_pcp *stock = &get_cpu_var(memcg_stock);
> +
>  	drain_stock(stock);
>  	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
> +	put_cpu_var(memcg_stock);
>  }
>  
>  /*
> -- 
> 2.34.1

-- 
Cheers,
Harry / Hyeonggon
