Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC0F380FFB;
	Tue, 29 Sep 2026 00:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790642544; cv=none; b=pSDHXvlY5i3oxySy9sG8AfMMvZlDEexqaOLdnxcLa85+YpqLZmTpmpX9RQ1YPVQS8ME5yYPmBHGSrW+drEAaD24YQqazxUqKhZ7Hgl24/HXwdyAW2DYiQ8AEhxiCOIGG3rtwfZg8WOAJTIDGVKuKLYhWhddvJpRhdnILZcLLuIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790642544; c=relaxed/simple;
	bh=uVIuYkzuaJw7Zz/Tbel3b5SvmDQDvfBFYtSORJpaNYk=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MsRgl412fiL2oGQUX5c6V6I9tQMhWWQ7UyTzq4Z+Y6i+2bGXvnjZv+IXzi/jA/fm3aCb90vReVKSgtB7IsUKp5KlosafgPefenSwKSoliXA9Z6Yio3zia96WdyQsSNNs5M+HcMNvDVzUqrhQmk2qzkWQxgOTFokfl6gChrWRZpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=atSryl01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="atSryl01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9281F00893;
	Tue, 29 Sep 2026 00:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790642543;
	bh=qabIyLDYNcn0aC6+7dBkZKy9dGM8JJT1KIakYgnj0aE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=atSryl01XT9URytke0ehPLuwP7MAb3sqC8jMzgCjlidKHHTexyN5sk1Tg4dX2KeW3
	 CNfPTWu+coesdEa6qGQ/nSK5UfRImCcqA5bhv4nUmqIfjB+4XSHNu+2iaLjc7YPxUF
	 YMUDfOmLXpGCot50FoXnGhrfgDtRATd3nORUxOcliHLiW17x6zWPl73cde5rrCR4f4
	 lIYV+Xf7PjBZejPE0zRQ427uu4Ny7qn5zK9lHQf7UuCGBYDR6WW3puXh8g04Dzam9K
	 aKBvxHjhv6ISMkhLORbZ5a9HzObbyibVLEI/pizpeIFf1GB2quKc2I/VBZfbO4GPGq
	 qOH0w/jn077Nw==
Date: Mon, 28 Sep 2026 14:42:22 -1000
Message-ID: <4412563645504aa9a87d3cafd544c97c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, ameryhung@gmail.com,
 alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v7 1/4] blk-iocost: add BPF struct_ops cost model
 support
In-Reply-To: <20260924054549.2271705-2-cui.tao@linux.dev>
References: <20260924054549.2271705-1-cui.tao@linux.dev>
 <20260924054549.2271705-2-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Tao.

On Thu, 24 Sep 2026 13:45:46 +0800, Tao Cui wrote:

> -	/* if user is overriding anything, maintain what was there */
> -	if (ioc->user_qos_params || ioc->user_cost_model)
> +	/* if user is overriding anything, maintain what was there; the
> +	 * same while a BPF model is attached: the builtin coefficients
> +	 * are inert then, so stepping the profile is pointless
> +	 */
> +	if (ioc->user_qos_params || ioc->user_cost_model
> +#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
> +	    || rcu_dereference_protected(ioc->model,
> +					 lockdep_is_held(&ioc->lock))
> +#endif
> +	   )

Can you add a helper which returns the model in use with a stub returning
NULL for !CONFIG_BLK_CGROUP_IOCOST_BPF? That'd remove most of the #ifdefs
including the one in this condition and the duplicated seq_printf() in
ioc_cost_model_prfill().

> +		/* sub-page IO: nothing to transfer-price */
> +		if (!pages)
> +			return 0;
> +		/* zero transfer cost is a legal model; guard the division */
> +		if (!coeff)
> +			return 0;
> +		/* pages * coeff can wrap and dodge the clamp below */
> +		if (coeff > VTIME_PER_SEC || pages > VTIME_PER_SEC / coeff)
> +			return VTIME_PER_SEC;
> +		return min(pages * coeff, VTIME_PER_SEC);

This can just be pages * coeff like the builtin. An overflow only skews
the met/missed accounting, same as a user-set linear coefficient, and it
also gets rid of the 64-bit division.

> +	bdevf = bdev_file_open_by_dev(new_decode_dev(ops->dev),
> +				      BLK_OPEN_READ, NULL, NULL);

When the disk goes away, the model should be ejected completely.
ioc_rqos_exit() unbinds it but the open bdev file keeps the dead disk and
the driver module pinned until the link is destroyed. Can you drop all
device references on removal like hid_bpf_destroy_device() does and look
up the device like blkg_conf_open_bdev() does, with blkdev_get_no_open()
and disk_live() checked under rq_qos_mutex? The two attach issues bpf-ci
reported, the missing re-attach check in .reg and the missing disk_live()
check, are real.

Thanks.

--
tejun
