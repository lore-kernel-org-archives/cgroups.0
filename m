Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793218169;
	b=jnIwFKwYKrBHGgI6tlUiH9WSr+MgmtbO0Q5T13w6xESJDgYzkBFMTuBU7rUkFmm2u7Qd
	 SQbPzmBd8Bi5qaCImtV17KFJGZs6yRfKpatZFql9Okl0v1M/3F7+vhSJvVZm62elRAUBz
	 d5qegE9KTuEE5WmihQO73DGiySWaxXAfQKZXjZ9DaG5OwhR1WD9hHMMSdE2pP4uoCINNg
	 XicEfaFvRYkjfWv2DJLLNOJ4cZWS1n5/3nh/FdGmyrtfhgxjhH0/Tlh9iYz6nGoMRLiJw
	 0x70L+4zzm2rFB2gEwtqwQcysppZH1DeMcRAniCwjvoFz7g+hn6/fnu53U3nCe3bN9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218169;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Wp+0Yj0Lz4BPqvrq9eW7Lj8ytJ+Vwq7ZAYHHcFtuB+4=;
	b=WO+4QJEWn6cHJOgeBX1wW8348gCqtjw7Tj43r/w3WhPUchpKhlBqPtGiVG3o/yAkW+6y
	 fkNvgMj6B0nvY6iGFdLQ+lGjY4Mb2EQxOvxnaedVTUaZPcyPOM6OMmJ9FarYlMVnWmQMS
	 7ftz5PCjP4KymKl4J0S8VCDyko3MWVCbCM8GRVSRZOjNqy9cfUSVoaq7spJ2PtsSLuXBv
	 EGs1HVnOz2KMz/oFb03nhfoDwpP1H/G435TW/Uqu2pzT7hgugWIn3gs3aig7r5G10WnzN
	 FnzD11t+ceRg9dQARrYXVxTiyOcKw1SrCrKFuYlqExTjHItlsYJxOm/DgmCKeGxys4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iTbtDjsx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632A460A261E;
	Wed, 28 Oct 2026 20:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iTbtDjsx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C0E1F031E6;
	Wed, 28 Oct 2026 20:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218168;
	bh=Wp+0Yj0Lz4BPqvrq9eW7Lj8ytJ+Vwq7ZAYHHcFtuB+4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iTbtDjsx8xqclN4kfgdZjY1XlF0KJH7Pf3J9Fwf4+BT+f8ztEniqCbg7VMRZixZJ+
	 ZfWEyso0onDCn77mMrpLV7e6ndxvet/04YcytET/gC9XjS0b4PfIj7KcGMbVbJrPLN
	 IMYiqB6XrykokxWhKqmqBjk3FGIndep9I6OKXljXHC4ucd2NIXBymfn2TVkI63gHM2
	 eDL4V/W2QNw/l3tUmmTSG14ncwEGlQ/xf3fMkEF3zVV55D2eIIdtw4fBcZeI9kCDZ2
	 Ebo9yBzwnVrZt+AdCYsVAqBj+/Y9Btl+CEO49oqvTIivpDAzGsp3tbyIdWdjnXAcpp
	 JWDEuKzpiuRsw==
Date: Wed, 28 Oct 2026 10:09:28 -1000
Message-ID: <0753eaa990c954aa56a0c5fa8ba302e2@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org, cuitao@kylinos.cn, ameryhung@gmail.com, alexei.starovoitov@gmail.com
Subject: Re: [PATCH 2/5] blk-iocost: add BPF struct_ops cost model support
In-Reply-To: <20261028143534.135968-3-cui.tao@linux.dev>
References: <20261028143534.135968-1-cui.tao@linux.dev> <20261028143534.135968-3-cui.tao@linux.dev>
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

On Wed, Oct 28, 2026 at 10:35:31PM +0800, Tao Cui wrote:
> +/*
> +/*
> + * Deliver iocg_init()/iocg_free() to the cgroups already online on the

The comment opens with "/*" twice. clang warns "'/*' within block comment
[-Wcomment]" and CONFIG_WERROR builds break.

> +			/*
> +			 * A blkg which never went online never reached the
> +			 * radix tree, so it must not receive an init either;
> ...
> +			if (!iocg || !iocg->pd.online)
> +				continue;

blkg_create() adds a blkg to q->blkg_list only after radix_tree_insert()
succeeds, so the blkgs skipped here are the ones blkg_destroy() already
took offline, not ones that never reached the radix tree.

> +	if (!disk_live(disk)) {
> +		mutex_unlock(&q->rq_qos_mutex);
> +		blk_mq_unfreeze_queue(q, memflags);
> +		blkdev_put_no_open(bdev);
> +		return -ENODEV;
> +	}

The guard() suggestion from v10 was only partly applied. This unlock,
unfreeze and put sequence is repeated on three error paths.

> +	/*
> +	 * Scope the mutex so the tail bdev put runs with blkcg_mutex
> +	 * already released: dropping the last device reference can
> +	 * reach disk_release() -> blkcg_exit_disk() ->
> +	 * blkg_destroy_all(), which takes q->blkcg_mutex.
> +	 */
> +	{
> +		guard(mutex)(&q->blkcg_mutex);

The bare { } block isn't necessary, and ioc_bpf_detach() has the same
block with the same comment. Can you drop them?

> +	/*
> +	 * The attachment is checked under rq_qos_mutex first, so an unmatched
> +	 * detach exits without freezing.
> +	 */
> +	mutex_lock(&q->rq_qos_mutex);
> +	spin_lock_irq(&q->queue_lock);
> +	ioc = q_to_ioc(q);
> +	if (ioc) {
> +		spin_lock(&ioc->lock);
> +		matched = ioc_attached_model_locked(ioc) == ops &&
> +			  ioc->bpf_link == link;
> ...

The same 11 lines check the attachment again after the freeze. The check
under rq_qos_mutex after the freeze is the one that matters.

> +/*
> + * Pluggable cost model interface for blk-iocost.
> + *
> + * A BPF struct_ops implementation can take over the cost model of one device.
> ...
> + * offline and its free. Both callbacks are called with ioc->lock held and must
> + * not sleep; the delivery points nest inside queue_lock except for iocg_free()
> + * from ioc_pd_free() in blkg_free_workfn().
> + */

This restates the attach mechanics and lists the call sites. The comments
and descriptions in general are still long and narrate mechanics.

Thanks.

--
tejun
