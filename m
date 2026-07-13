Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179F9305047
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 15:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783958260; cv=none; b=gw/8+AvMbbmWFHMkeGxjkeQPwL9ZMZ5hhaKhxl0UoMgZ8b3xFBVym7GpNPHLI7oD62qBLbxlUmMuzZ3mldi6ObBs9cwXHiMisZnhEOXyouQA3fHC33jNlrVVSptsK9ervCChuVO5Tx+5VzxJfyHRRnaRuul/idC6s/oPrOhAe7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783958260; c=relaxed/simple;
	bh=PycK+6oCxCBM/cFgkMSak0eCHZUZ8ZvtRCwstKPB2ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WCbSUrxshQHc7Cd387UzG9NTTLO/HNZEYPCGeqqcfaSKYe7GmvRNR6Nn5uKXMAos3CH0jRYHvX+FhVbBRGt9eD32abKvEZBj9XKLQvGgFqNttpOpIYiLFyx+T+aQwqK8pHbctkD4cqfS9wqxpCG326UDgz9Y26i0NThQRYdivGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
	by 156.147.23.52 with ESMTP; 14 Jul 2026 00:57:36 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.127 with ESMTP; 14 Jul 2026 00:57:36 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 14 Jul 2026 00:57:36 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com,
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com,
	baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>

On Mon, Jul 13, 2026 at 08:50:36AM -0700, Yosry Ahmed wrote:
> On Sun, Jul 12, 2026 at 7:57 PM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > This is the v10 series of the swap tier patchset.
> >
> > v10 folds in the Sashiko review fixes for the selftests added in v9 and
> > rebases onto the current mm-new. There are no functional changes to the
> > core swap or memcg code since v9; see the changelog for details.
> >
> > For context, the bulk of the series is unchanged since v8, with great thanks
> > to Shakeel Butt and Yosry for the reviews and discussions [1] that shaped it.
> > The main change in v8 was the interface change to use memory.swap.tiers.max
> > with '0' (disable) and 'max' (enable) values. This mechanism was suggested
> > by Shakeel and Yosry.
> >
> > This change allows for future extensions to control swap between tiers and
> > aligns better with existing memcg interfaces. It is confined to patch #3's
> > user-facing interface; internally, patch #3 still uses the existing mask
> > processing method, which is implementation-efficient.
> >
> > We also discussed tier extensions. Thanks to Yosry, Nhat and Shakeel for their
> > valuable feedback.
> >
> > Here is a brief summary of our tentative conclusions. Please correct me
> > if anything is misrepresented (details in references):
> >
> > * Zswap tiering [2]:
> >   Zswap can itself be a tier (typically the fastest one). But, until vswap lands,
> >   zswap cannot be the only allowed tier,
> >   since it still needs a physical device for allocation;
> >   that restriction can be lifted once vswap is supported.
> 
> Does this series support zswap being a tier? I cannot find any mention
> of zswap in the patches.

Hello Yosry!

This series does not cover zswap as a tier yet.

My plan is to land the swap tier infrastructure together with the
first use case (cgroup-based swap control) first, and then follow
up with zswap tier support in a subsequent series, continuing the
discussions we've had above. 
(I mentioned on cover letter, right above the overview section)

Does that approach sound reasonable to you?
