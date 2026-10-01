Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71FB389E04;
	Thu,  1 Oct 2026 18:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790878234; cv=none; b=N/M/Eu3cWn4aBRXyYLaRn4rcWI6c0Yue9prY+BtiIIQbo071DWJ+eVzWb5SrLpwJjbRTGOwqRbJIIvpzLLOl/MAv6xL2VNTLzAqixw6NiWHz4cwzSChJhlIZ57IZ5WSraCOginmmOEzI3up9wOhTCidFhBwKoVeEi76RLuTTj/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790878234; c=relaxed/simple;
	bh=9Y4pAK88qjMP8X+cySTC8/pCIkPvhO450+5FFkVjxkY=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PyGG37Ip8oSrka3mhcCQjuc9QIiK5+vouNZoiSmtlpWJWCJwHiBP+q7Z06E2ECeVIgc1tzosBek3UzrFy7bcM8NmD5eNhCKGkGO8lj4sf0pXcAd+QsKsEdEtHq8Rjb6ihlLuzTfWdf6cQQ9I4kLOCHnnyDAcF5mpEQSbEuRqt4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ac2A2e/1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ac2A2e/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623CD1F000FF;
	Thu,  1 Oct 2026 18:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790878228;
	bh=KofKL6DMyNwNkFRP22JD3bKVkyzb29TfyRjV0Y0r2Ug=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ac2A2e/1DeJpjHbdIlYtlc+6CQqqF/PXDx6JHdS/ed69jP1C9UqP2vRJsvXiPHGmz
	 ws0jxuHv4us6LHnU1dg4EB+0EssuL4AuT+JTnkMiFLq54ZkYlsIGfzVc6y/5sRR5nI
	 /YESSgJG389pcBLZH9S2PTODgL9d0gaDFwux97KyvDkCuifnTB8R04D4ijp0xjP1CL
	 x8a/ZaVyjlJON9QokgNIBAUKTxFHvbaFzSQeNu8hnNQyKzeb5h3FEy6zAq67rqHkOG
	 pUjG4deHNgVvZXKH9IFBFm57bI6tbkJ3o1OZ9+z2dms7aId7MSaxFwCexNezcmbV2o
	 5A3o/TJxPJZQA==
Date: Thu, 01 Oct 2026 08:10:27 -1000
Message-ID: <b214a375adad1579b2b17c0e9a0f4869@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Peng Yu <yupeng0921@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Maurizio Lombardi <mlombard@arkamax.eu>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/2] nvmet: add cgroup_id to charge namespace I/O to a
 cgroup
In-Reply-To: <20260929232411.101087-3-yupeng0921@gmail.com>
References: <20260929232411.101087-1-yupeng0921@gmail.com>
 <20260929232411.101087-3-yupeng0921@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Peng.

On Tue, Sep 29, 2026 at 04:24:11PM -0700, Peng Yu wrote:
> Implementation:
> * Add a `cgroup_id` attribute under the nvmet namespace folder, e.g.:
>   /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test01:bdev/namespaces/1/cgroup_id
> * We can write a cgroup id to it, then that cgroup will control
>   the IOs used by the namespace.

This doesn't follow the usual description format or content. Can you
write it as prose explaining why the change is needed and what it does,
along the lines of the scenario section in the cover letter?

> +CONFIGFS_ATTR(nvmet_ns_, cgroup_id);

Documentation/ABI/stable/configfs-nvmet has an entry for each namespace
attribute. Can you add one for cgroup_id? It should say that it takes a
cgroup2 ID, that 0 clears it, that it can only be changed while the
namespace is disabled, and that the namespace's I/Os are charged to the
cgroup's effective io css.

> +static inline void nvmet_blkcg_set_bio(struct nvmet_ns *ns, struct bio *bio)
> +{
> +	struct cgroup_subsys_state *css;
> +
> +	if (!ns->cgrp)
> +		return;
> +
> +	css = cgroup_get_e_css(ns->cgrp, &io_cgrp_subsys);
> +	bio_associate_blkg_from_css(bio, css);
> +	css_put(css);
> +}

bio_init() and bio_alloc() already associate the bio with the current
kthread's blkcg, so each of these bios gets associated twice. If the rw
and zone append paths wrapped their bio allocations in
nvmet_blkcg_begin()/end() like the discard and flush paths do, this
function wouldn't be needed and chained bios would be covered
automatically. Not a blocker either way.

Otherwise, from the cgroup side, this looks fine to me.

Thanks.

--
tejun
