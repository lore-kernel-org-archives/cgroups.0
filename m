Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06DD43A808
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 11:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806774; cv=none; b=P2E5cMFBvd9XEIB0qIZCypOWWqpTMMVB92ywGvb+LyFH9WZ+wmQ3swWAAvJRAXYTiiNPn4fuwyEu8uFr9203s6yCIGFn3wojmZ2cEP2kykGV5g8vQrCAQT0Vf2i4VwIe1Vk5UkYoZf5oSEPJsaHEvFwJQS3orI6uYLI72DirZfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806774; c=relaxed/simple;
	bh=beah4yPiJA7BeEtfLv4r45Ojuj4UkjS5TshRQRqSqmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uEcNghlhNVu0+sqrINpMUqorai1DD32sg06K5EFJ1cJCNB0zg30Zr/FG5pjeCQAHVTlmQVGtvoGwjRtF/YQSRYayZYWNZ5Od/Cz0bfHvpNg49rFK9JQJ31HE3+0xagIiHEJn6w8Ne4J3DVGTtNpICoEOk7IzlZn1D7OI0gyWVyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
	by 156.147.23.51 with ESMTP; 23 Jul 2026 20:39:22 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.127 with ESMTP; 23 Jul 2026 20:39:22 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 23 Jul 2026 20:39:22 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Johannes Weiner <hannes@cmpxchg.org>, h@yjaykim-poweredge-t330
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	yosry@kernel.org, joshua.hahnjy@gmail.com, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, baver.bae@lge.com,
	her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <amH9alaO97YqT8pY@yjaykim-PowerEdge-T330>
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <amDCIl51NoNPL7Op@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amDCIl51NoNPL7Op@cmpxchg.org>

On Wed, Jul 22, 2026 at 09:14:10AM -0400, Johannes Weiner wrote:

Hello Johannes!

> Zswap is a first-order swap destination with writeback semantics. The
> way the discussion around zswap has been going in this thread is
> disappointing, and I don't feel comfortable adding permanent user
> interfaces on this basis.

I have given this a lot of thought. First, could you clarify exactly which
part of the discussion or consensus makes you hesitate? Understanding this
will help me re-evaluate my proposal.

To make sure we are on the same page, I would like to share my thoughts and
vision for the present and future of the tier interface semantics for your
further consideration.

The interface should provide the swap amount allocated to a tier and allow
the use of the swap device defined by that tier via swap.tiers.max.
Currently, it would only support 0 and 'max' (essentially on/off for
explicit usage). Auto-demotion is planned for the future, and specifying
exact capacity limits is still to be determined. (I have also reviewed
potential interface collisions and duplications based on Yosry's guidance.)

From this perspective, zswap currently cannot exist as a standalone tier. It
resides in RAM when allocated and borrows slots from other swap devices.
(If all tiers except zswap are turned off, it is effectively the same as
zswap being off, meaning there is no zswap-only tier.) The zswap writeback
interface essentially leaves only the zswap first tier enabled by using
other swap slots. Virtualized swap should solve this in the near future.

On the other hand, in systems without zswap (like ours), this situation does
not occur. Allocation and deallocation depend strictly on swap priority,
avoiding this contradiction. (While it might be possible to implement the
tier interface only for !CONFIG_ZSWAP first, I abandoned this idea as it
seemed unpromising.)

In my initial review, I considered creating the swap tier interface while
excluding zswap configurations, even if zswap is present. From zswap's
perspective, it acts as a first-order swap, and other tiers operate well
according to their original tier semantics. Once virtualized swap arrives, we can
open up the interface without any contradictions.

However, virtualized swap might be toggled on or off (at runtime or
compile time), we must still account for zswap without virtualized swap anyway.
There is also a possibility that the initial overall picture might seem
misaligned until zswap tiering is officially introduced. It looks like we must
care this case on the first stage.

Therefore, I decided to follow Yosry's suggestion. Since a zswap-only setup
has contradictions, we initially considered removing user visibility
as possible as we can (returning an error for unsupported interfaces).

Because the implementation is a bit tricky, we agreed on an on/off toggle
for this first baby step, accompanied by detailed documentation so users are
fully aware of what a zswap-only tier means.

As a result, I reviewed this direction and found it does not conflict with a
future zswap tier. When virtualized swap arrives, the design will align
perfectly, and we can consider making zswap a proper tier.

One thing that remains undecided, however, is zswap tiering, which is not
yet fully agreed upon by everyone and should be discussed at the next stage.

> We will not be merging a memcg swap tier interface until the swap side
> has a story for indirection and backend migration.

Regarding this point, is your position that an indirect layer (I see
this is virtualized swap) must be implemented first?
Or do you mean we need community consensus on the overall design before proceeding?
I believe our direction is set toward virtualized swap, but there are still some discussions regarding
implementation details.

I would love to hear your thoughts. In the meantime, my preference is to
proceed as discussed if we can agree on the future direction. If more
discussion and design verification are needed, I am happy to follow up and
address any concerns you might have.

However, if you feel the tier concept is premature, I would like to hear
your thoughts and others' as well on a fallback option. We could add
per-cgroup swap control in debugfs for now. If we need to scale back, we
could either keep the swap tier design internally or drop it entirely,
implementing per-swap control strictly for our specific use case. We could
then revisit this as a primary use case when swap tier discussions resume.

What do you think? I would appreciate hearing everyone's thoughts on this.

Youngjun
