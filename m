Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201613;
	b=eIZoujZd5py4RCHo9vBKjOz2NYAUXYKHDT+NOAQYzeGDW1LDh94adlDdNNbbwTROJos3
	 e2ffvodl6BdvjP2gf4opF7XX50NbkatYQUlB//3BVOfDy+Jnyi4Rtp37+rbApsXeSVJ6n
	 w70fQvmAbEP3XgsCLJFbrpOP4bl1uDot3iC+100VpDQv6IAY7ksOTplYZOZvLnYNh/vvP
	 b53cVFl0SXHv8WDkY6yZWu13bGJhEvbdPR2l8eaLgdHqsVF/S+Wy15yd/IT5/Ggo50B9f
	 WCgg2MT6PBLIZMrAcIdmrvHeEvNvO0IBLrEvWoV0xrNeIVJB8kKxYpk0I19930b6qIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201613;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=Mk3iDJt5T50uHOGaKewojk6ij6AnqevT7e8ze4YGhNg=;
	b=kdgQDJHG2UX8FOCbcSkJjibZDyFbmFuWk9pPh3U6mbhsWc1u7m96obmm7NeMyXCz+sPe
	 PAv7LmfeamBg4803RRZKQheiQzVPvqA2LmCzAjqeZw/biAd4aLX4+bLCX73oWtuMW3gYy
	 bvDDTJQu9j1MGcBfxG83HU3WaxKsyOAsO/9HXpjf9u+iQ1KpOsjgYLRakwufhzP6Xv+wE
	 qYb5WcydghJkZDDrmugu02Mv1Z1JR+7F/QX1Q3LDSskwaWxMSokGc2PsuH+MpLi1v6p3t
	 615UPOp+vUQPXtvEZ6wJwu7yBY5x8P+53Xuq4WAHLNgUNQ50IRMvC71cdUtNQNUy/xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="onWJ/2mf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803BC606A329;
	Wed, 28 Oct 2026 15:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=onWJ/2mf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E5C1F031E3;
	Wed, 28 Oct 2026 15:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201613;
	bh=Mk3iDJt5T50uHOGaKewojk6ij6AnqevT7e8ze4YGhNg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=onWJ/2mfsPmFOOalwByl3eXDdbjjgJ2gN/7iWzacAbLDdGhGigpYF8+cSJqokvBbW
	 aSUJCOId+FNB98f848eq+C5Ym/hmPnZ6ovYb6zuKOG5mtycnRe2zYZXcVSQBDhbt3/
	 8rW09EUBpaQ3LqWT9mBnxpjAlr3IGxwnamy3gLoIn3atvQm6DQPU4LNaXgNQ+KM4KB
	 zoYIzro3bcyWt7uTd+ahPoOLsECrA1y0esopsT6B5JFoLQaR/J7YwVrWaQsKqNBUCv
	 M64AlWYAvA5+DuJirYEyPPjRyvmsOjjtsGHZDrQ2LL+3r+t5ClkpliCmAR6V2E18RG
	 fv1HDgVqPIhDg==
Content-Type: multipart/mixed; boundary="===============5957388155132648867=="
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <db337130fec9f342fe80debfe2b9e4fb4310456bf9a639785e34c931a81e4bbc@mail.kernel.org>
In-Reply-To: <20261028143534.135968-3-cui.tao@linux.dev>
References: <20261028143534.135968-3-cui.tao@linux.dev>
Subject: Re: [PATCH 2/5] blk-iocost: add BPF struct_ops cost model support
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ameryhung@gmail.com,alexei.starovoitov@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 28 Oct 2026 15:33:33 +0000 (UTC)

--===============5957388155132648867==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> blk-iocost: add BPF struct_ops cost model support

TL;DR: Nit only, not a bug: the long iocost_model_ops interface comment in
blk-iocost.h repeats attach/teardown details documented elsewhere and names
call sites; suggests trimming it to the model-author contract.

> diff --git a/block/blk-iocost.h b/block/blk-iocost.h
> index e4e517ef6a0f..6d62b4fd0c54 100644
> --- a/block/blk-iocost.h
> +++ b/block/blk-iocost.h
> @@ -22,6 +22,79 @@
>  #include <asm/local64.h>
>  #include "blk-rq-qos.h"
>
> +struct bpf_link;
> +
> +/*
> + * Pluggable cost model interface for blk-iocost.
> + *
> + * A BPF struct_ops implementation can take over the cost model of one device.
> + * The device is identified by the dev member, which is set from userspace
> + * before the program is loaded; the struct_ops core owns the program lifetime.
> + * Attaching creates the ioc if needed, like an io.cost.model write, and
> + * switches the device to the BPF model with the queue frozen before
> + * rq_qos_mutex, like an io.cost.qos write, and delivers iocg_init() to the
> + * cgroups which already exist on the device. Enabling and disabling the
> + * controller stays with io.cost.qos.
> + *
> + * While a model is attached, io.cost.model selects between it and the builtin
> + * model: "model=bpf" switches to the attached model and "model=linear" back to
> + * the builtin. Neither detaches the struct_ops; only detaching does. The
> + * builtin linear coefficients are kept while the BPF model is in use and take
> + * effect again when switched back.
> + *
> + * While in use, the BPF model prices every charged IO on the device, including
> + * flushes, from the bio charging path. calc_cost() is called from the IO
> + * submission path with RCU read lock held and must not sleep. It receives the
> + * bio itself so that the model can use what it needs (operation flags, size,
> + * sector, the issuing cgroup through bio->bi_blkg, which is guaranteed
> + * non-NULL) and returns the cost of the IO in vtime units, where 1 second
> + * of device time equals VTIME_PER_SEC (2^37,
> + * available to BPF programs through vmlinux.h). The return value is clamped to
> + * 1 second of device time per IO.
> + *
> + * The struct_ops also carries the transfer cost coefficients, vtime per page
> + * for reads and writes. While the BPF model is in use, they replace the
> + * builtin coefficients in the completion-time request sizing of READ and
> + * WRITE requests, with ZONE_APPEND counted as a write. Taking over the QoS
> + * side (latency tracking, vrate control) is left for later extensions.
> + *
> + * The cgroup callbacks are bound to the iocg policy lifetime, one (cgroup,
> + * device) pair per invocation. iocg_init() is delivered from ioc_pd_online()
> + * and on attach to the cgroups already online on the device; iocg_free() on
> + * detach to the cgroups which still exist then and at pd_free() time for the
> + * rest, so that init and free pair up exactly. iocg_free() is gated on a
> + * per-iocg delivered flag, as bios can still be priced between the blkg going
> + * offline and its free. Both callbacks are called with ioc->lock held and must
> + * not sleep; the delivery points nest inside queue_lock except for iocg_free()
> + * from ioc_pd_free() in blkg_free_workfn().
> + */

[ ... ]

this isn't a bug, but could this interface comment be cut down to the
contract a model author needs (calling context, units, clamping, locking)?

The attach description repeats what is already at the top of
block/blk-iocost-bpf.c:

 * attaches the model to that device, creating the ioc if needed and switching
 * to the model with the queue frozen before rq_qos_mutex, like io.cost.qos
 * writes, and .unreg detaches it; enabling and disabling the controller stays
 * with io.cost.qos.

The init/free pairing rules and the "bios can still be priced between
the blkg going offline and its free" reasoning are repeated in the comments
above ioc_pd_online(), ioc_pd_free() and ioc_bpf_deliver_iocg_callbacks().

The comment also names implementation call sites:

 * not sleep; the delivery points nest inside queue_lock except for iocg_free()
 * from ioc_pd_free() in blkg_free_workfn().

Would it be better to leave the attach and teardown mechanics to the
comments next to that code, so this one does not go stale when those paths
change?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/40710751825
--===============5957388155132648867==--
