Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D1A4028C3;
	Thu, 24 Sep 2026 06:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790230242; cv=none; b=O6DFGDVxQGiXP0z8xhypql7BqVHV7zWO63d6onSQj+wTKwWrKO+W+OTIOdk5RLPDaMqr1ojx8GENQgVpoBECh8RUhtAAMv1mju6PnjykgNDPGF4pJGxGbCbwsn31rzFxY4tTbsYet1+Bnmd+ywcelpDKSGvFRy0iNEdvXRArt28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790230242; c=relaxed/simple;
	bh=/vX/5qPhcKIDUfXBBPVG+MOqnthLMQk82JiS7mwi5Is=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BLf4dBzoq6vH1q2z89wBLbFDFLZhNGoAmLL+2RS6igk1MOzYEc11UgGl5+50uIyq/R/ycxUbI9IXIQHpX/nJbqgBpoWNwY69V/B1G8GirRxZ5AFyHNWR67nph4CaxPIMlBreW61EvDdpNpIrF9rYFEa7YT/33/OLhjiw1qsSQa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d3JXWPaU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d3JXWPaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491C11F0089B;
	Thu, 24 Sep 2026 06:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790230240;
	bh=jgbIhyImA5Ab7Qdceup6B8HUqw97jM4n8FbYC5/DV+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d3JXWPaUIukIwzqC2BDJRcdjxOsucjob53Cu9pXXIrWqn6CcWO340f9K3lI/mx3RD
	 mV8WQRhBy3w0tu5vgDCWoQALOH+H/wUbkAlH0jMt2kiERtusPk1BuxZ8k9waDoQPfY
	 EYnaKy3ZgLtKVM6XIrfS5sTrTvFx2z067Zkv6mcramGCEaKRyopTXCyh7hJ45cOkgb
	 IrxdZMoadNEdtacf4S5a2WE8Ky/V7CKn/EG/6EbyHqrR6sMZdpWtfCXRAQigwYB5Ad
	 Lq8qZmJ+FJiPaPyJpUHVqN3Rb67Y6i2SZFfhIGcsrZlbluNt+pumU+ZasQs6D8roSs
	 hYA1jOWzkUKBA==
Date: Wed, 23 Sep 2026 20:10:39 -1000
From: Tejun Heo <tj@kernel.org>
To: Peng Yu <yupeng0921@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>,
	Maurizio Lombardi <mlombard@arkamax.eu>, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] nvmet: add cgroup_path to charge namespace I/O to a
 cgroup
Message-ID: <arS-38fE5r638g4Z@slm.duckdns.org>
References: <20260924053121.17703-1-yupeng0921@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924053121.17703-1-yupeng0921@gmail.com>

Hello,

On Wed, Sep 23, 2026 at 10:31:21PM -0700, Peng Yu wrote:
...
> +#ifdef CONFIG_BLK_CGROUP
> +static int nvmet_blkcg_ns_enable(struct nvmet_ns *ns)
> +{
...
> +	cgrp = cgroup_get_from_id(ns->cgroup_id);
> +	if (IS_ERR(cgrp)) {
> +		pr_err("failed to resolve cgroup id %llu: %ld\n",
> +		       ns->cgroup_id, PTR_ERR(cgrp));
> +		return PTR_ERR(cgrp);
> +	}
> +
> +	css = cgroup_get_e_css(cgrp, &io_cgrp_subsys);
> +	if (!css || css->cgroup != cgrp) {
> +		pr_err("the io controller is not enabled in cgroup %llu\n",
> +		       ns->cgroup_id);
> +		if (css)
> +			css_put(css);
> +		cgroup_put(cgrp);
> +		return -EINVAL;
> +	}
> +	ns->blkcg_css = css;

This is really odd from interface POV. The user specified "associate IOs to
this cgroup" and that can fail if blkcg is not enabled on the cgroup. Even
if it succeeds, if blkcg gets disabled and re-enabled on the cgroup, the
device is still going to be issuing IOs as the old draining blkcg.

What the user can express is the target cgroup and the IOs should follow
whatever IO control that specified cgroup is under at the time of each IO
issue. Currently, cgroup_e_css() has to walk up the tree to find the
effective css for a given subsystem but updating cgroup code to add e_css[]
array on each cgroup to avoid the overhead shouldn't be too difficult.

Thanks.

-- 
tejun
