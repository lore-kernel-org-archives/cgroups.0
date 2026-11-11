Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794418299;
	b=g7v1jHAHi2sy6k+VQFQiaLuftZf8D78WUhgg/F3GJi99C0/GNEtqEKlLqeqr3WsNh9y5
	 tQgFDiHz/V36pY/gfjRM+TeddJ8jJZpr4P74wXYOM8F5XTu2dWhr3UmlGypujVyA41Rk3
	 K3eUHeAzmEsI+z4dMQlZ4k/HDmIYi5disRH6LBUcGK12QBotJBue5FvQKtjKPhVYZNbn1
	 KAVuhGLT8rI56l0MfkjPffSwa+GiL+TxQY2EFkct3kMcw9dvSF+WgBPMm7i/QEBxuyUtm
	 c1O6bXLmRWGD4Ymasn2CGeJHaKGW5QB1z9sV8/QqCrbroFpIZbFizAPrKz019/sIP8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418299;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=nfRcRl/M9CMIHhFB2poU3/svabg/YK+L1d4LcrG1cCU=;
	b=AQiPgrac9lib+aLbPKYNet0ti89LTwx9QYgTjigwI9HAUoSV7COxj/VlOo8dXFi3wInV
	 pAgOuqD+y0zyLYRTDrA1ciPcAl2jsmKFWsG9PF1v3DpQlNXiLmDcwx96dDi2GzVCas1EK
	 Qj5pB+HI9Ux9/MXXEksEUzubWlxSabHB7LtAN5a22HEV87YPqOcnxeYZnYreQ2e5JcGTe
	 Y/vf6mdPNIJSm50FUEic63xrE6x8K28lsxuTSLOHl/PXAZ6mRTfXASpKIOVR98nC5glLL
	 1i5jmd6vyQc8LmFCW6ZemoZv1gN3ctpXDAEY3nmAYNyDAWjy6ean80ie7SzZ4cyoMOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P08L9r2l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BA3606A31C;
	Wed, 11 Nov 2026 17:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P08L9r2l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206991F00A05;
	Wed, 11 Nov 2026 17:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794418299;
	bh=nfRcRl/M9CMIHhFB2poU3/svabg/YK+L1d4LcrG1cCU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=P08L9r2liflwN1Dhjk5TTiGxbqMLqyrJgOuOgU1fXlo4rBCiDCHezPbd1kA+mf1OM
	 CtJYekULJ2ONrVxHPDHcsrMZXHXGbsePZU08VU+7sACXNeUpvlN9ImhZEyE/4iBl6q
	 J1rKFHk+lCBkqcTWsZDje6xx1/i1lqZ6QzanTdanNIg1pXqoCn75hHV8DB/Ek9SIxQ
	 Jl+3mgGWHNRl9aQXLRWESalm9SINGFZ0li5uDMl2sWnW75j1Letj/7ASHbJkf2YPHK
	 ArcoBxfr911U8Q4kkEG4BJu7zyOiJnilF+Es2KJFZxa3MgZlvXqEDBOnBzJ73HIy28
	 moKbNb82lu4Ew==
Date: Wed, 11 Nov 2026 07:31:38 -1000
Message-ID: <bfe5007b2758bb06504b6966abaf1f7e@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: axboe@kernel.dk, josef@toxicpanda.com, oliver.sang@intel.com, nilay@linux.ibm.com, hch@lst.de, yukuai@fygo.io, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, cuitao@kylinos.cn, sashiko-bot@kernel.org
Subject: Re: [PATCH] blk-iocost: fix the lock order in ioc_cost_model_write()
In-Reply-To: <20261111162137.295523-1-cui.tao@linux.dev>
References: <20261111162137.295523-1-cui.tao@linux.dev>
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

Hello, Tao.

On Thu, Nov 12, 2026 at 12:21:37AM +0800, Tao Cui wrote:
> The inversion cannot currently deadlock because blk_mq_freeze_queue()
> is in a noio scope since 1e1a9cecfa ("block: force noio scope in
> blk_mq_freeze_queue"), so a caller freezing a queue cannot recurse
> into the frozen queue through reclaim. Holding the mutex across
> the freeze needlessly serializes config writers behind it and
> leaves two different orderings in the same file.

There is no deadlock here to begin with, and the noio scope isn't why.
Freezing is counted and doesn't exclude other freezers, and a freeze only
waits for in-flight IOs to drain, none of which takes rq_qos_mutex. The
patch doesn't make the ordering consistent either. blk_iocost_init() still
freezes under the mutex through rq_qos_add() and blkcg_activate_policy(),
and so do blk_throtl_init() and blk_iolatency_init().

> +	mutex_unlock(&q->rq_qos_mutex);
>  	memflags = blk_mq_freeze_queue(q);
> +	mutex_lock(&q->rq_qos_mutex);

This lets the disk be deleted in the middle. @ioc was looked up before the
unlock and rq_qos_exit() can tear it down before the mutex is retaken.
With a delay added after the unlock and a null_blk device deleted during
it, the write goes on to use the ioc after ioc_rqos_exit() and KASAN
reports use-after-free in blk_mq_quiesce_queue() called from
ioc_cost_model_write().

So, this fixes nothing and adds a bug.

Separately, ioc_qos_write() already has the same window. It retakes the
mutex without rechecking disk_live(), so with the disk deleted in between,
it initializes iocost on the dead disk and hits the same use-after-free.
That's the part which needs fixing.

Thanks.

--
tejun
