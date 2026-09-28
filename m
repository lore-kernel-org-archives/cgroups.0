Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598BB1AF4E9;
	Mon, 28 Sep 2026 18:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790619883; cv=none; b=iajjHaucUMH6HgOn1uzLVaeAwTdjMo7Qo+kcTN1M3gUeXavJamr8d5f+UK4zqLCOCx1/OHpMBV3vyfeoAcc2bxb+Sl2aesZJAoSC5u2vQeo2hsiwjqk44NiS0JCneEeqPEffel4Z2a0M/soSyBVmlPsgB6AlcNnLSnUP3PeKCM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790619883; c=relaxed/simple;
	bh=hNpw31ZRSc7M/qXGQtUCTYNFVyvFPmZHgaxdreCHxIM=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=jheIL55eeTspEbxMFqpfRTbZgXIBIBvMKzB84OfJWUOHGwGL1sO1p6mq/yaS1U1fCDuzBiUfO2auEOxE4s76zdK6Y2ikKkm+HxEr5VeuvJsDe7JeanLPfDbE0CwxLdgBgEqrTNvhfuV1DbcxTeVeFMoMn1GnQjEKzfwjW/V9L+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JXEl6xoI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JXEl6xoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D241F000FF;
	Mon, 28 Sep 2026 18:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790619882;
	bh=jFgegtxrqBLiSDoehqBbaOYTYpSiUebKsQY5pgr6G+M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JXEl6xoISVDdzEfU5MH19jz7JFJTYMQWsyJMMaCTTEg5BSRtsUV7kLJy1NKhv+oX4
	 F6Vo06jedsKB3C+Y42PEdDmvCkCdP1OScHxKcz9YOl7s85sLV1VkupV40OtI0RhRzI
	 6iJid23uoc1Vl+VpVOZ75SPAUd+Fo5vu3BMx4r6EdK2GAPcKBiRneoa43wE/H/1Kyt
	 iKDRt5SHpp0MVtqKQZTE+kVb2LKXj7XsJj31o2agOCxvZuRsWvLKlNVDZdpX12BYUh
	 W5Vj6Qn1bRrbGs7CdhAav5wXCgUGFceWf2fQiZOC83SOyddCXbu3v4pMJVCrMHuI8x
	 1nHcQigxzcVrA==
Date: Mon, 28 Sep 2026 08:24:41 -1000
Message-ID: <dfe81db2d9bc6cc6b17fc1f440af184b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Peng Yu <yupeng0921@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>,
	Maurizio Lombardi <mlombard@arkamax.eu>, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] nvmet: add cgroup_id to charge namespace I/O to a
 cgroup
In-Reply-To: <20260928061417.1574676-1-yupeng0921@gmail.com>
References: <20260928061417.1574676-1-yupeng0921@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Peng.

The following is a Claude-generated review.

On Sun, Sep 27, 2026 at 11:14:14PM -0700, Peng Yu wrote:
> Scenario:
> * Create multiple nvmet subsystems/namespaces.
> * The namespaces are backed by different LVM logical volumes.
> * Some of the logical volumes share the same physical volumes.
> * The subsystems are exported to different users.
> * We should provide each user a specific iops/bps quota, thus a noisy
>   neighbor won't impact the performance of other logical volumes.

- 1/3: Can you explain why in the description? Per-IO users such as nvmet
  need the lookup to be O(1) instead of walking up the hierarchy.

  rebind_subsystems() moves root csses between hierarchies without
  updating e_css[]. This is fine as a root cgroup's e_css[] always points
  to init_css_set.subsys[], but that isn't obvious. Maybe note it in a
  comment in init_cgroup_root()?

  Can you also add a comment on the new e_css[] field like the fields
  around it? It should say what it points to (the css of the nearest
  ancestor including self which has the subsystem enabled) and that it's
  updated under cgroup_mutex and read under RCU.

- 2/3: This isn't needed with the change suggested for 3/3 below.
  Otherwise, cgroup_e_css() now has the same shape as cgroup_css() and
  could be a static inline in include/linux/cgroup.h instead of an export.

- 3/3: nvmet_blkcg_set_bio() calls bio_associate_blkg_from_css() under
  rcu_read_lock(). If the blkg doesn't exist yet, it grabs queue_lock
  inside the RCU section. f928145cbcb5 ("mm/page_io: don't nest queue_lock
  under rcu in bio_associate_blkg_from_page()") removed the same nesting
  from mm/page_io.c to prepare for protecting blkcg with blkcg_mutex
  instead of queue_lock. How about the following instead?

	css = cgroup_get_e_css(ns->cgrp, &io_cgrp_subsys);
	bio_associate_blkg_from_css(bio, css);
	css_put(css);

  With 1/3, this is O(1) too and it skips csses which are going offline
  the same way nvmet_blkcg_begin() does. It also only uses symbols which
  are already exported.

Thanks.

--
tejun
