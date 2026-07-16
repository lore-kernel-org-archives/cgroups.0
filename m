Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D4F279DAD
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 02:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784167368; cv=none; b=E/wVL3L31hMDgisyVMPMs7wih/hkqdanC2TWwPjiYbs/eYQP8j2466RuH6qVNjgJgmq2mAMihOlLDEXKc6RrqtQpZYvDKOBuJYupxdfA7N+uG7MCQMR25uPOj0N0iJSSiO/ZnxHCdKHp64VCJoyKRMG5Rpwdv1kqfFkstvmlm7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784167368; c=relaxed/simple;
	bh=OYBNLrJVgZzD5pl4N5zWGWESWucYN3fNMl/Z+bQJNLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t5CS61v0vKSXvpnZ5zHtRXf9IcYq6AVR87T1RgE41bEM7gv52x/ZIIY+67HaR/emz+VoRkidYIYcxLTDXfI2CDrDZNZpKq64xjEgezg+tAzzrR0pLZeKrPOIsLa1Wj9Wmt+1UaSzyIeTOg3lA91G54mGrxuC4YQ53sa9ftyJJcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.51 with ESMTP; 16 Jul 2026 11:02:36 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.125 with ESMTP; 16 Jul 2026 11:02:36 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 16 Jul 2026 11:02:36 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chris Li <chrisl@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	joshua.hahnjy@gmail.com, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <alg7vOsSVI8CQC3D@yjaykim-PowerEdge-T330>
References: <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
 <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330>
 <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
 <alawYov0c7a0Q6_l@linux.dev>
 <alchYX43oV9KybWx@yjaykim-PowerEdge-T330>
 <CAO9r8zML09YzraA6rstMz6+Krui5Vma6a9D3j10_FXGbqfEQvQ@mail.gmail.com>
 <CACePvbVQxvZKa1y4b=mAgdT_uUO=nk4uvuSob3xvW9MZ6OEONg@mail.gmail.com>
 <alfuD8BVdvswr4ch@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alfuD8BVdvswr4ch@linux.dev>

On Wed, Jul 15, 2026 at 01:35:56PM -0700, Shakeel Butt wrote:
> On Wed, Jul 15, 2026 at 10:30:26AM -0700, Chris Li wrote:
> > On Wed, Jul 15, 2026 at 9:27 AM Yosry Ahmed <yosry@kernel.org> wrote:
> > >
> > > On Tue, Jul 14, 2026 at 10:58 PM Youngjun Park <youngjun.park@lge.com> wrote:
> > > >
> > > > On Tue, Jul 14, 2026 at 03:25:40PM -0700, Shakeel Butt wrote:
> > > > > On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> > > > > [...]
> > > > > > >
> > > > > > > Yosry, what is needed to enable zswap as a swap tier? What will be the minimum
> > > > > > > requirements for that?
> > > > > >
> > > > > > From zswap's perspective, we just need to skip zswap is zswap as a
> > > > > > tier is disallowed. Could just be a check in zswap_store() similar to
> > > > > > the check if zswap is enabled. I am assuming that if a swap tier is
> > > > > > disabled, nothing happens to the existing swapped out pages in this
> > > > > > tier, but new pages do not get swapped out to it. This is the same
> > > > > > behavior that happens if zswap is disabled at runtime.
> > > > > >
> > > > > > From the tiering perspective, we need to accept "zswap" as a possible
> > > > > > tier, or maybe creating it as a tier by default if zswap is configured
> > > > > > would be better to avoid handling the case where the user doesn't
> > > > > > create a tier for zswap.
> > > > >
> > > > > Default tier if zswap is configured makes sense. Should zswap be treated as
> > > > > having 32767 (or maybe 32768) as priority as it sits infront of all swap
> > > > > devices today? Also whichever swap tier has priority range containing 32767,
> > > > > will have zswap in it.
> > > >
> > > > Maybe we can handle zswap as an internally reserved tier which is always
> > > > preferred over swap devices.
> > > >
> > > > I do not think there is a strong use case for grouping zswap together with a
> > > > swap device that happens to use the highest priority. Also, using a visible
> > > > priority value for zswap may have a small side effect that one priority value
> > > > effectively becomes unavailable to users.
> > > >
> > > > That said, if zswap is represented as a tier, I agree that it should be the
> > > > top tier. The exact priority value or whether it is internally reserved should
> > > > be adjustable when we implement it.
> > >
> > > Agreed.
> > >
> > > [..]
> > > > I agree this is reasonable. I can treat the demotion/writeback interaction as
> > > > future work and follow up separately.
> > > >
> > > > > Youngjun, what do you think? Is this reasonable amount of additional work or do
> > > > > you envision some complexity here?
> > > >
> > > > I sent a note with some thoughts about making zswap a tier. Since Chris also
> > > > raised concerns around this area, I think it would be better to discuss it a
> > > > bit more and evaluate the details carefully.
> > > >
> > > > At this point, there does not seem to be an immediate use case that requires
> > > > zswap tiering in this series. So my preference is to keep this as future work
> > > > for now, and follow up with an RFC after verifying that introducing zswap as a
> > > > tier on top of this patchset does not cause problems.
> > >
> > > My main concern is locking ourselves into an implementation without
> > > zswap as a tier. One of the appeals of swap tiering to me, from the
> > > zswap side, is eventually unifying zswap writeback as part of a more
> > > general swap demotion, and unifying zswap controls with more general
> > > swap tier controls.
> > 
> > There is nothing locked. The major complexity will come when
> > zswap/vswap/Xswap/ghostswap become independent swap devices for swap
> > tiers. We are not there yet. But if you want a bool for zswap in swap
> > tiers world, we can make it happen trivially.
> 
> Yes please let's do this. Can you also please comment on Youngjun's response at
> https://lore.kernel.org/all/alcebHobUCUyO70k@yjaykim-PowerEdge-T330/ as well?

Hi Shakeel, Chris, and Yosry,

Thanks for the review and replies. It seems we have reached a consensus.

In the next patch series, I will update the swap.tiers.max interface to
allow controlling zswap with 0 or max.

Internally, I will handle it as a not perfect tier. 
Anyway since the user-visible interface is designed with future zswap tiering in mind, 
this approach naturally accommodates future zswap tier integration, while remaining easy to drop 
to make it as a tier if it proves unpromising (remaining this interface only controls zswap on/off).

As a follow-up, we can continue discussing the tiering of zswap, vswap,
Xswap, and ghostswap. If we proceed, making zswap an actual logical tier
entity and organizing its relationship with other interfaces (i.e., complete
tiering) will be deferred to a future patchset.

I will keep you updated if further discussion is needed during implementation.
Please let me know if you have any other feedback!

Thanks,
Youngjun

