Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794850039;
	b=FzSdd8Co+MHUJmGLCT4y4obCxV8huYZDvBGVlVC4sEF2czxm3Q96L9H1XW+QZlXGU9FF
	 5uONZL3WR1eARnOS8pV2TdHGOILa/GpeZNq0/MBvChBb/cpIvSxjeqJDIKtE9qd0js4HG
	 6VQIt1u5PINufYagBnJANU0ijv47uxOCVwEMC0OpK5UjaWMRo0UmMO6NtZp/td7fWhLC9
	 GCzgwDQGKbVymNq2YsW49tfUg85SncxpWE8s3tHZP92cULCn/z12UAkvVSowXpxX15HL2
	 BChy3VsVOGzudgLgd4gnagChy8eQJLuevJtNKHxZeb5RwaCF4gM5INGjxjjGlLcFyaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794850039;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=2yzovXHP1AKSCJkwBWUXIlAv/gwCI3e2QnitbG71KNI=;
	b=Jc2wQOyMUXZs12VErG3uuDzSXQf7N6d1JxU/SD33tuuUK4eV5ysJXoTQ5LD/9pnqAPEQ
	 VHwM3GGRclX8ME89SrDPBDwYHQ9qQfA6lOBamLnyt2MJ/NEFRsgVQ44ZVOlCtl6ao5yQc
	 0amcuc4p5Bn/pqvxdYBwzCDTsC6WollS/Sd8gZ4N1f2PDwBn9R5eXcVJ2vTTkXTrRD9jf
	 pGzK8Wc5mDHM51xu8joC3uvS8JDG4m9xseeTHQUCKah3SmPe3vsE7OQ91hhqMKdnke0BJ
	 BBnD/2ePH0CrTFyATx2bqUz0koKKSo9v6aD1HYthFC4EVFPoAr/qY54gfWuX4pGVUEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k5hxH+zw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4613C606A31C;
	Mon, 16 Nov 2026 17:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k5hxH+zw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE66B1F000C4;
	Mon, 16 Nov 2026 17:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794850038;
	bh=2yzovXHP1AKSCJkwBWUXIlAv/gwCI3e2QnitbG71KNI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=k5hxH+zwKwGfx7QdReyl1QJaN/qK8ywteGD6Fh7gfC9K+nWXHzPHJzqPAhBgOFFny
	 aVeJIOfTh8ctP1Kb5boKwRehnhxRxMDlMIvsY784RAHvlMplgVXAB8pkylsz0jysND
	 pq+mhkdcUlNd4qUUxsTJSxxTVZubXFsS3Iy9mG4636ymDrUGIG850CzjJ2YtcvtSe+
	 TV9/K2VMzdjZODo3HhcNWeDXWlDLGNg2ir84s/0GFrmYfZq5QSQ2PCl/TfNp5Xu7Qv
	 PI3eqA+jCWNF8f451GvMRr1/tANkKypYGQ3gM0YeMn+NOA/rR2mk2FQIl6mQ1pb3IU
	 WVahsIxww5NnA==
Date: Mon, 16 Nov 2026 07:27:17 -1000
Message-ID: <e6062944917f1c9a87ab084bae9352a9@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, alexei.starovoitov@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org, cuitao@kylinos.cn, ameryhung@gmail.com
Subject: Re: [RFC PATCH v13 1/4] blk-iocost: add BPF struct_ops cost model support
In-Reply-To: <20261106122356.3224638-2-cui.tao@linux.dev>
References: <20261106122356.3224638-1-cui.tao@linux.dev> <20261106122356.3224638-2-cui.tao@linux.dev>
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

On Fri, Nov 06, 2026 at 08:23:53PM +0800, Tao Cui wrote:
> Attaching an iocost_model_ops struct_ops binds the model to one
> device: the target is set in the dev member from userspace and
> .reg creates the ioc if needed like an io.cost.model write and
> ...

From here on, the description mostly walks through what the code does.
Can it instead explain why it works this way and what it guarantees, and
leave the mechanics to the code?

> +enum {
> +	IOCOST_COST_F_MERGE	= 1 << 0,	/* called from the merge path */
> +};

Maybe name the flags after the callback they're passed to, e.g. enum
iocost_calc_flags, IOCOST_CALC_MERGE and a calc_flags parameter, the way
sched_ext pairs ops.enqueue()'s enq_flags with enum scx_enq_flags and
SCX_ENQ_*? An unnamed enum type can't be looked up by name through BTF,
so BPF programs can't test whether a flag exists.

Also, can the comment say what the flag means to the model rather than
where the call comes from? The bio is being merged into an IO which was
already charged its base cost.

> +	/* holds a reference on the struct_ops map, NULL if none is attached */
> +	const struct iocost_model_ops	*attached;
> +	struct bpf_link			*attached_link;
> +	/* either NULL (linear) or ->attached */
> +	const struct iocost_model_ops __rcu *model;

Can the comment say why iocost holds its own reference on the map? If the
link is destroyed after del_gendisk() has unhashed the bdev but before
rq_qos_exit(), .unreg can't look up the disk and returns without
detaching, and the link drops its reference. iocost's reference keeps the
map alive until ioc_rqos_exit() detaches the model.

Also, why are attached and attached_link updated under ioc->lock in
ioc_bpf_reg() and ioc_detach_model()? Everything which reads the two
holds rq_qos_mutex: .reg, .unreg, ioc_detach_model() and
ioc_cost_model_write(), which gets it from blkg_conf_open_bdev(). Only
model is read under ioc->lock alone, by ioc_autop_idx() from the timer
and the io.cost.model show path, besides the RCU readers. What is
ioc->lock protecting for the two? Can you document the locking on the
fields?

> +static const struct iocost_model_ops *ioc_model(struct ioc *ioc)
> +{
> +	if (!IS_ENABLED(CONFIG_BLK_CGROUP_IOCOST_BPF))
> +		return NULL;
> +	return rcu_dereference_check(ioc->model, lockdep_is_held(&ioc->lock));
> +}

ioc_model() returns NULL while the builtin linear model is in use, which
is a model too. Maybe rename the accessor and the field together, e.g.
ioc_bpf_model() and bpf_model, or ioc_model_bpf() and model_bpf?

> +	spin_lock_irq(&ioc->lock);
> +	rcu_assign_pointer(ioc->model, NULL);
> ...
> +	ioc->autop_too_fast_at = 0;
> +	ioc->autop_too_slow_at = 0;

Resetting to 0 is right, but maybe ioc_bpf_reg() is a better place for
it? .reg is the only path which switches pricing to the BPF model without
a forced ioc_refresh_params(), which is what zeroes the timestamps for
io.cost.qos and io.cost.model writes. If ioc_bpf_reg() zeroes them, they
stay zero while the BPF model is in use, which covers both detach and the
"model=linear" switch sashiko reported on this posting.

Thanks.

--
tejun
