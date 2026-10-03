Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB811F91F6;
	Sat,  3 Oct 2026 02:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790994107; cv=none; b=E7W5ULIXx0P8COjivH3PllGz91+SW7R0FVrgMXZhQ/SjkL2SDCmbapdhjiZDVTuztMgq/1nNx+2CT9AMUPCi11SvnyY0fGVI1A1MImn6zaHHzNeruIF+3rDL+LmgSkqcYRyLNWe+I4m3XJHm/4t5GbMaopAdSaRft6slmGlp3jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790994107; c=relaxed/simple;
	bh=ef65CnKJiB+hmKDpqOyglkdOK0el0sfrfIecsE+5eGM=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=GF2PjSjzIdeSl2XolXuhq3e6hFBp048SG5BUsr0oRYOrJrtZK8xuVXJANq16z02hFONwfkCVrmSM9cs2y1Lbk/QmMdrOsiVZmj5hyqdde+j0rGp4t7MJZOR7ta0XjDIuTQcGLEwy5s99W9qXXhT4tG5eKsHSGbHDehfhNgxZ4GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OAkDfCdx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OAkDfCdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65401F000FF;
	Sat,  3 Oct 2026 02:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790994105;
	bh=4mPXn+7XmycjHk3RSVrwRLQjhSTsvmqDOVG9LF9wysI=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=OAkDfCdxVfxLqtOH+zNCwe0CLEAbXl/Pk6/q3dHgBaALzz40sZGKCtADSCMXHzop4
	 CtNHWX9+hF7ILGrAE6TTjY21F/8XIPhht4EStX3ikfc1YtXu4F321nKzevKobAXpNT
	 2TkLMNrz1MTgfv18tRiv12hfYfFPPKJi20faF6F6eKCJp9sVo1ezf7NrMv9ijgQjH6
	 jcVoG9w59+WnBGSNTSvqYlKh8Zhlsgc0I/b84xRdIcpIzwhbdJ9+9MGCcwHDgps5Wv
	 klGljEObuK9gvphqNGwO0YPu3Vb76FpXj5qcyEpz0e72HjvLRaQjh52c4nqsAJ2yQG
	 wPbmvXZm/7+AQ==
Content-Type: multipart/mixed; boundary="===============6522024683136353624=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <c2a0a6fa869032fdc6a1bfb487939c58e9a9a295ea17b2bc8a63d2df0b9e079c@mail.kernel.org>
In-Reply-To: <20261003013033.149288-2-cui.tao@linux.dev>
References: <20261003013033.149288-2-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v9 1/4] blk-iocost: add BPF struct_ops cost model support
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ameryhung@gmail.com,alexei.starovoitov@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat,  3 Oct 2026 02:21:44 +0000 (UTC)

--===============6522024683136353624==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> blk-iocost: add BPF struct_ops cost model support

TL;DR: Possible behaviour issue in blk-iocost BPF model: a blkg whose
radix_tree_insert() fails may get iocg_init() without iocg_free(), or the
reverse, if attach/detach races, contradicting the documented pairing. No
kernel harm.

> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 2745bffcd5ee..581b48543441 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c

[ ... ]

> @@ -3048,6 +3163,18 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
>  	spin_lock_irqsave(&ioc->lock, flags);
>  	weight_updated(iocg, &now);
>  	spin_unlock_irqrestore(&ioc->lock, flags);
> +
> +	/*
> +	 * the attached model is RCU-protected: a concurrent detach
> +	 * publishes NULL and the struct_ops image survives it by a
> +	 * grace period, so the callback is safe inside the read-side
> +	 * critical section
> +	 */
> +	rcu_read_lock();
> +	model = ioc_attached_or_null(ioc);
> +	if (model && model->iocg_init)
> +		model->iocg_init(blkg->blkcg, ioc->rqos.disk->queue);
> +	rcu_read_unlock();
>  }
>
>  static void iocg_release(struct rcu_head *rcu)
> @@ -3066,8 +3193,15 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
>  	struct blkcg_gq *blkg = pd_to_blkg(pd);
>  	struct ioc *ioc = iocg->ioc;
>  	unsigned long flags;
> +	const struct iocost_model_ops *model;
>
>  	if (ioc) {
> +		rcu_read_lock();
> +		model = ioc_attached_or_null(ioc);
> +		if (model && model->iocg_free)
> +			model->iocg_free(blkg->blkcg, ioc->rqos.disk->queue);
> +		rcu_read_unlock();
> +

The commit message says:

  "... iocg_init() is delivered on attach to every cgroup which already
  has a blkg on the device and to each one appearing afterwards,
  iocg_free() on detach to every cgroup still existing then, and at
  policy deactivation time for the rest, so init and free always pair
  up."

Does that pairing hold for a blkg that never reaches q->blkg_list?

blkg_create() calls the policy's pd_init_fn (ioc_pd_init(), which delivers
iocg_init() when a model is attached) before the radix_tree_insert(), and
only adds the blkg to q->blkg_list if that insert succeeds:

blkg_create() {
    ...
    pol->pd_init_fn(blkg->pd[i]);
    ...
    ret = radix_tree_insert(&blkcg->blkg_tree, disk->queue->id, blkg);
    if (likely(!ret)) {
        ...
        list_add(&blkg->q_node, &disk->queue->blkg_list);
    ...
    /* @blkg failed fully initialized, use the usual release path */
    percpu_ref_kill(&blkg->refcnt);
    return ERR_PTR(ret);
}

The insert is into a GFP_NOWAIT radix tree, and on the bio association path
(blkg_tryget_closest() -> blkg_lookup_create() -> blkg_create()) there is no
preload, so it can fail with -ENOMEM. That blkg is then released through
blkg_release() -> call_rcu() -> blkg_free_workfn() -> ioc_pd_free().

If ioc_bpf_detach() runs after that ioc_pd_init() but before that
ioc_pd_free(), ioc_bpf_walk_iocgs() does not find the blkg on q->blkg_list,
and ioc_pd_free() then sees ioc->attached as NULL. iocg_init() has been
delivered and iocg_free() never is.

The reverse looks possible too.  If ioc_bpf_attach() runs in that window,
ioc_pd_init() ran with no model, the attach walk misses the blkg, and
ioc_pd_free() then delivers an iocg_free() with no matching iocg_init().

Can a BPF model that keeps per-cgroup state in iocg_init()/iocg_free() see
these unpaired callbacks?  Nothing in the kernel itself is harmed, but the
commit message and the comment above struct iocost_model_ops say the
callbacks always pair up.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/37087498848
--===============6522024683136353624==--
