Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794850226;
	b=lYXIIh3fWnK6E9PSwcqb9qINEyBw7wVhEQqEEezmnVHGov0FmwAfMN7dDTCY61tqWrTd
	 QVerN6zkWIo27kBCMKZZLtz70Jut2JoEesdi82EbXBi/YmHKj/8sLUHv+ZJEcwbqebNC0
	 Mq5gt+KnXZrITDUPbD7fJjJ21tCX3m1pkKCJhXS8Hk8XkfYpe92k4o6OAK64Isd8THZ1k
	 xQY9Ngo1YkvamGNmaKJRkLEWrZ3sxsxNpU+Pc/nWSNTn7+vBLjb48crBMgRVWNAOOm16k
	 v7zI/wA57ivUyKrMbd9IQwNj5sqyOHdzquqoZqbojjywN40MVNqpN2K7VSgLA5t9F+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794850226;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=nBxXHNjk5FG5xL+xxn2QO4lUIRqJ9IaQmLyQVNlu0GM=;
	b=J0tNV/eiARymto/wmh69MMnajMG7eLjg9oCoX00ziLlVdZkDyLTc093TP0u75YfynEMh
	 C83Rp9h/Lo7yBOr2R8sX9ZOXgWWbNT6VaYZjtPi8cb+YFNDROc0UCo7BnsOsnPjmYscB3
	 ixT2QCrn91rNxHYqVfoGmuxaxreJozu2qd1lX8ciRjTNbUT9UE3yHb6OqZBNNlLa48ve7
	 f/DuvwNAEErBfnCtA00c9xLacBCUNIsTsx7lzlbKyb4jju+NjpVZwV9UDYc1E34mm1UBr
	 W+/swmx9Pavy3JkUMIfE4rtjHBlpily4LvHLQ/FVALGr/MUX2Iymxo9IaXzk0DmKxXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ht7sTMxy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF80606A322;
	Mon, 16 Nov 2026 17:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ht7sTMxy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D4F1F000C4;
	Mon, 16 Nov 2026 17:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794850226;
	bh=nBxXHNjk5FG5xL+xxn2QO4lUIRqJ9IaQmLyQVNlu0GM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Ht7sTMxy0U4Ej58lOaSwOzkVSUDI0ugJeW1p1kXztSP2p5UVykLnahEg9Xf+JyM1q
	 KfXTKzDUYNobu+oo/mC5ewpF+az80YCOM0CBYoyJfikMzQ620+ON3pPOGjVpOcbbzv
	 TCQO5jkmhv1GDfcUr6y/uwLyhlfqB270+9mRPpUy5jrImlSRdr8gpk7ML6nOMQTlN9
	 UBjQklNQoUOqOnFnwk9kMRalq0Zev4EVNUgpiJFiGBGP9xya32XSI6zBAG/z3akKqc
	 cLDNSOmNXLKTTRk1hc0N0PJ4cqoanFKxAxVNFaA8yN7kKHtxXuaqcm0dPDc07ycgit
	 76TWQPCVXJeyw==
Date: Mon, 16 Nov 2026 07:30:25 -1000
Message-ID: <d77a5e897461e10ccc1328db603f8880@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, alexei.starovoitov@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org, cuitao@kylinos.cn, ameryhung@gmail.com
Subject: Re: [RFC PATCH v13 2/4] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
In-Reply-To: <20261106122356.3224638-3-cui.tao@linux.dev>
References: <20261106122356.3224638-1-cui.tao@linux.dev> <20261106122356.3224638-3-cui.tao@linux.dev>
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
Content-Transfer-Encoding: 7bit

On Fri, Nov 06, 2026 at 08:23:54PM +0800, Tao Cui wrote:
> Add iocost_ioc_tick, emitted once per period from ioc_timer_fn() with
> the overall controller state: period_us, vrate, busy_level, active iocg
> count and usage percentage.  busy_level, cur_period, nr_active and
> usage_us_sum are complete at the emission point.  usage is wall time
> over wall time, summed over iocgs, and is not capped at 100.  vrate and
> period_us reflect the current controller state, which an io.cost.qos
> write may have changed mid-period.
>
> The event fires every period the controller is running, including
> steady states, plus one final tick before the controller goes idle, so
> the transition to dormancy is directly visible.  The active iocg count
> is only gathered when the tracepoint is enabled.
>
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
