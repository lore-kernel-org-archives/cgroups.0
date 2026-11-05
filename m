Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793904562;
	b=mr59K6MU0Nyng4xVA2y/LbQ6MQ4bsvU/7tz1GdaH+fF4dbVXwenWhjf3UBZ/yIPil+gj
	 kOS8FTsQ1xH42C6Ne44LBEJG3MpkDQudkcQCxbMaEJFRHzk3Ea4C2XuUxL1gbzEDTI9fG
	 UBjeAXc8gWzpvriJ1kVnvkCIyLZFVsJv//zlBkADOdZ+G6+Gz1A2Y3vj22sqeqogSGB1d
	 +2czOcztLu2XjL2FvxasRip09/EU4rJcurjipPbUYRHGTMM5ZtRIHvyN1NxGYKpc1W9W8
	 oY2pqN2cJdvfP8kHnXjgchRYJ+7lH+y9CbBmsIp4rlUQlbCqPrGk6nsJMmGdeIcFMNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793904562;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=FYrSOLCmu3GIzaMabGYZjJKQcXM64yf8sup8daWFGF4=;
	b=rKzQSlw7DLXF2TeInehi0aWA4/uHTQRC3razM7mSSWpS8HiYW3zKbl9M4e+orU7YjKwj
	 RXPMLWPszFeYlwwBf5vnKrk3+62cjDJ5qZflrBiB2KQ8ijLOQM08kc6vUKur7fQlnFpWG
	 xdd1TZIRDYcFmPxICiezi6efe4nql9A6siMnySQOi0S1reb7zERCBHzf/WUhuJAHH47lM
	 w4DGP6p96kpdHgMcjTXuAtTTw8WSbLdWyBySoLmrAgGRuJdIBHlVdm++jqS1txa75xfdF
	 Tv0o+wsAH1FVCVrdjVNEml95A4oXvmcmj5O6MU6nzspRzU9jfdgtt7N1ccH83kRz8Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HD43nCc8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CFC606A31B;
	Thu,  5 Nov 2026 18:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HD43nCc8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04A41F00919;
	Thu,  5 Nov 2026 18:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793904561;
	bh=FYrSOLCmu3GIzaMabGYZjJKQcXM64yf8sup8daWFGF4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HD43nCc8dh6ojhuWc9zEF6coxYSc/8f6hTrOhWv/dK76zIVkMbIvxhpHzA0fo1DfB
	 YQElOaMCWl/q8x/bJgbfNOmkQlluYzAx1He/B23fuiL3JgpZFR1hZcJzUgHycHC2uQ
	 EpDv+LX/NDZIXjhDUkGP+wA6ZTj7fiz1k/DhaKePbfc/PbOGI+P74kljKGuIvP9y7v
	 i1pbE7c8XorwMCgzaXZD29OO0+sBZC+PU6S5JubL9rO/CiLUBBEtsBBifk0TAlWIQD
	 1OXthKJ14jA/BS8P6Kz7lIJBpX4vxEYBKvelDyTyyLYxASdkzGy/BA3L2guGPw0oG3
	 TzOM6W2ifK5EQ==
Date: Thu, 05 Nov 2026 08:49:20 -1000
Message-ID: <95403f5dce741c515718b2fc7f5dcc64@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Peng Yu <yupeng0921@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, Keith Busch <kbusch@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Maurizio Lombardi <mlombard@arkamax.eu>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12] nvmet: add cgroup_id to charge namespace I/O to a cgroup
In-Reply-To: <20261104071600.470430-1-yupeng0921@gmail.com>
References: <20261104071600.470430-1-yupeng0921@gmail.com>
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

On Tue, Nov 03, 2026 at 11:16:00PM -0800, Peng Yu wrote:
> +/*
> + * A command of a namespace with a cgroup already runs from its own work
> + * item on the namespace's workqueue (see nvmet_blkcg_work()), so run the
> + * backend's work function right there; otherwise queue it on @wq.
> + */
> +static inline void nvmet_req_run_work(struct nvmet_req *req,
> +		struct workqueue_struct *wq, struct work_struct *work,
> +		work_func_t func)
> +{
> +#ifdef CONFIG_BLK_CGROUP
> +	if (req->ns->blkcg_wq) {
> +		func(work);
> +		return;
> +	}
> +#endif
> +	INIT_WORK(work, func);
> +	queue_work(wq, work);
> +}

With cgroup_id set, the file backend's Flush, DSM and Write Zeroes and
zone management now run synchronously in the command's blkcg_wq work
item and hold one of its max_active slots for the whole vfs_fsync(),
vfs_fallocate() or zone operation. This probably deserves at least a
comment. Can you add one?

From the cgroup and workqueue side,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
