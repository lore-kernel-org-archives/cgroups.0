Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE0F502D52
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 22:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633632; cv=none; b=Cru9VEvOUbbaRmPCUjmunHtpLtXahOGPjrN4Lhe1d9MT7StWR6rznjr8PiFYE+sOQtvF7XDYOL++DgRDmVoNq3iSWlqJIJMD+xgCHfx05CUPgGgpAeA1PQnV9xR3lht7jzz92u73ASyUCTLC0GbERhe1pUAve3Jv0rXroTNmaTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633632; c=relaxed/simple;
	bh=LhPr/3N5CT4HP3diIFgEUTiiw9QHBmCdPdCTJgVnTTM=;
	h=From:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 To:Cc:Content-Type; b=tfxTRbjorx1AOy49xMoAGv/4fsYfHW4WzDWPGfG5yTNvZrNbdrEwVw4c4uWYPuIQZLnN8QCR8kqXBwm3OpZfcbkj3CcX9NTTMxUOdrVZa2k6nfol3Yuqrx/KApOk0vALbi6hNS+agDKktQopooQyg9ZJaAujG0xVfu0V75uQI6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=xMqpEhE5; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="xMqpEhE5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:in-reply-to:references:mime-version:to:cc:
	content-type:content-transfer-encoding:cc:content-type:date:from:subject:to;
	s=s1; t=1790633630;
	bh=LhPr/3N5CT4HP3diIFgEUTiiw9QHBmCdPdCTJgVnTTM=;
	b=xMqpEhE5onvhmJUwCGRu0ueRhvnCyFfpSqVbzGhcC5+thgrQXTKMsshRzAxSO674H8GQ
	DlhWReUDbIZyOL34PQpjyiggwg2v7AyUl2a5zK84bPO7nrhTfgB0r/LhRqDdPjBB+RzSmP
	+G2Fl/768QVVZisel2lvZ8ypwMdx4SCKCIGuQBVIE9kRf7+UPNdGe1Yn3Hi3z7o1TD1xoW
	/XIoZrKn+/35VQ0cc65Ydgv/UXJPEWHVC4ERWIw77M3EcayT7GBZES5x/ECUrFxPmpFZxh
	gzGCHx2yocdZP5qWnKHUdh2O8WEkEWa1OF6R3l1b+i8vHbFeZ6ybaMlhcmtsiOMA==
Received: by recvd-canary-7bc664d96-rr7cp with SMTP id recvd-canary-7bc664d96-rr7cp-1-6ABAE69E-A
	2026-09-28 22:13:50.058278031 +0000 UTC m=+354514.976073350
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-13 (SG)
	with ESMTP
	id GsnC_o2GSBmkpLj7FchG8A
	Mon, 28 Sep 2026 22:13:50.000 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: Re: [PATCH] writeback: let foreign flushes reach dying cgwbs
Date: Mon, 28 Sep 2026 22:13:50 +0000 (UTC)
Message-ID: <20260928221349.1443179-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ee85445f60194cfbc78897cb6fe744c7@kernel.org>
References: <20260926-wb-dying-cgwb-flush-v1-1-a8d898085a3a@honeycomb.io> <ee85445f60194cfbc78897cb6fe744c7@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeUC5kvTHBdlB?=
 =?us-ascii?Q?Y0OEXhZWKcE3XqZx=2F9VWoKqLYD00fyqtReTCMYv?=
 =?us-ascii?Q?qGuChLBBTQO4UfKoiNfWejExKSbUBMct5f6Op2a?=
 =?us-ascii?Q?L4iflnpRD5xlounm2jOrCKwOCzt+Fok+dX6Q5dF?=
 =?us-ascii?Q?0pqfH=2FmeZZqe2xyw0XNRxenifYyFeRmHlY64+M0?= =?us-ascii?Q?cF9D?=
To: Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, stable@vger.kernel.org
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Tejun,

On Mon, Sep 28, 2026 at 09:19:37AM -1000, Tejun Heo wrote:
> Instead of walking bdi->wb_list, can't we update the lifetime rule so that
> a wb stays on bdi->cgwb_tree until it's actually released? That is, remove
> it from the tree in cgwb_release_workfn() instead of cgwb_kill() and have
> the creation paths skip dying wbs. cgroup_writeback_by_id() would then
> find the dying wb through the regular lookup.

Yes, that's cleaner, thanks for the suggestion. Implemented in v2:
https://lore.kernel.org/all/20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io/

One edge case: a live memcg whose blkcg association changes needs a new
wb in the same slot while the killed one is still there, so
cgwb_create() takes over a dying wb's slot and cgwb_release_workfn()
uses radix_tree_delete_item() to only remove a wb that still owns it.
cgwb_bdi_unregister() skips dying wbs so they aren't killed twice.

> Note that the blkcg association check in wb_get_lookup() would have to
> move to the creation side.

Done, along with a wb_tryget_live() for the creation paths, including
wb_get_create_current().

> I don't think this qualifies as a fix. Can you drop the Fixes: and stable
> tags?

Dropped in v2. I'd tagged it because foreign flushes can't reach the
owning wb in exactly the case where its memcg has gone away, which
looked like a bug in the original implementation. But we avoided it in
userspace by syncing after the old container's last write, so agreed, it
doesn't need to go to stable.

Thanks,
Liz
