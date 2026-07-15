Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10A13B3BE6
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 20:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784147782; cv=none; b=fOVR0BeJuMTAvO7oVW4K57CHxCmTcWBwXUWZx7ja8yBBKcneglyJ8bbQZMXrNDFpj5mbdvlSOdIQvywxKbdSQdMR7T6WM2r9s2EUqittOnVdEOcda84g9vlwDBvDrIxuD4txDSt6dpQP/FPnzGQwKjG7DAiDkZbbhKuYaZbUZhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784147782; c=relaxed/simple;
	bh=gz2oIMW5lhEvL64wKqVVcCDuxMIDofX+1OIVeeJkOw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WWi2scomM0Zl15hdbH1n6qjuIIDPda0ljbJl1mf301oXkHmj5l95+4Gai4N73ESOLkebL2MizXFa6JVHBV7ueEcsV2mT5vmiZ8qCtVRu7jEhFewghLLEOTeniePeASg1VCA1huhd3wmGsQxg965F8tuuOKYx8kyxztMV74F1StQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NDaqQ0cu; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NDaqQ0cu"
Date: Wed, 15 Jul 2026 13:35:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784147777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mo3OtT6Wk9vIr43G06ljgu1nSIzxYDl9BQZisg9bu58=;
	b=NDaqQ0cuaRwXU76Il3raLdJi4qiC6OqzUb2UO3fPbucggNWoFdggpf+GH3YtwgJcGTPRTI
	BpKLlswF8rIWD8MGIPIcUNKdvglsG1hUA12eeO6JfKinOcbtnnj4FkEYx3A/SWTPjnGtkS
	LEjaZ19YzZDSwi5TlJJCdPW3N76X13U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: Yosry Ahmed <yosry@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <alfuD8BVdvswr4ch@linux.dev>
References: <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
 <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330>
 <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
 <alawYov0c7a0Q6_l@linux.dev>
 <alchYX43oV9KybWx@yjaykim-PowerEdge-T330>
 <CAO9r8zML09YzraA6rstMz6+Krui5Vma6a9D3j10_FXGbqfEQvQ@mail.gmail.com>
 <CACePvbVQxvZKa1y4b=mAgdT_uUO=nk4uvuSob3xvW9MZ6OEONg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbVQxvZKa1y4b=mAgdT_uUO=nk4uvuSob3xvW9MZ6OEONg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 15, 2026 at 10:30:26AM -0700, Chris Li wrote:
> On Wed, Jul 15, 2026 at 9:27 AM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Tue, Jul 14, 2026 at 10:58 PM Youngjun Park <youngjun.park@lge.com> wrote:
> > >
> > > On Tue, Jul 14, 2026 at 03:25:40PM -0700, Shakeel Butt wrote:
> > > > On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> > > > [...]
> > > > > >
> > > > > > Yosry, what is needed to enable zswap as a swap tier? What will be the minimum
> > > > > > requirements for that?
> > > > >
> > > > > From zswap's perspective, we just need to skip zswap is zswap as a
> > > > > tier is disallowed. Could just be a check in zswap_store() similar to
> > > > > the check if zswap is enabled. I am assuming that if a swap tier is
> > > > > disabled, nothing happens to the existing swapped out pages in this
> > > > > tier, but new pages do not get swapped out to it. This is the same
> > > > > behavior that happens if zswap is disabled at runtime.
> > > > >
> > > > > From the tiering perspective, we need to accept "zswap" as a possible
> > > > > tier, or maybe creating it as a tier by default if zswap is configured
> > > > > would be better to avoid handling the case where the user doesn't
> > > > > create a tier for zswap.
> > > >
> > > > Default tier if zswap is configured makes sense. Should zswap be treated as
> > > > having 32767 (or maybe 32768) as priority as it sits infront of all swap
> > > > devices today? Also whichever swap tier has priority range containing 32767,
> > > > will have zswap in it.
> > >
> > > Maybe we can handle zswap as an internally reserved tier which is always
> > > preferred over swap devices.
> > >
> > > I do not think there is a strong use case for grouping zswap together with a
> > > swap device that happens to use the highest priority. Also, using a visible
> > > priority value for zswap may have a small side effect that one priority value
> > > effectively becomes unavailable to users.
> > >
> > > That said, if zswap is represented as a tier, I agree that it should be the
> > > top tier. The exact priority value or whether it is internally reserved should
> > > be adjustable when we implement it.
> >
> > Agreed.
> >
> > [..]
> > > I agree this is reasonable. I can treat the demotion/writeback interaction as
> > > future work and follow up separately.
> > >
> > > > Youngjun, what do you think? Is this reasonable amount of additional work or do
> > > > you envision some complexity here?
> > >
> > > I sent a note with some thoughts about making zswap a tier. Since Chris also
> > > raised concerns around this area, I think it would be better to discuss it a
> > > bit more and evaluate the details carefully.
> > >
> > > At this point, there does not seem to be an immediate use case that requires
> > > zswap tiering in this series. So my preference is to keep this as future work
> > > for now, and follow up with an RFC after verifying that introducing zswap as a
> > > tier on top of this patchset does not cause problems.
> >
> > My main concern is locking ourselves into an implementation without
> > zswap as a tier. One of the appeals of swap tiering to me, from the
> > zswap side, is eventually unifying zswap writeback as part of a more
> > general swap demotion, and unifying zswap controls with more general
> > swap tier controls.
> 
> There is nothing locked. The major complexity will come when
> zswap/vswap/Xswap/ghostswap become independent swap devices for swap
> tiers. We are not there yet. But if you want a bool for zswap in swap
> tiers world, we can make it happen trivially.

Yes please let's do this. Can you also please comment on Youngjun's response at
https://lore.kernel.org/all/alcebHobUCUyO70k@yjaykim-PowerEdge-T330/ as well?
