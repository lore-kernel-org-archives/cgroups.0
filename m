Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD59515A864
	for <cgroups@vger.kernel.org>; Tue, 26 May 2026 06:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779776704; cv=none; b=e4+yyTZizjenH8nVjZHs6NXZEZokO8/xTnbDTdkPDauP9el61RgB++03TDH2fotXANJy9+jBComyiCwv6qCPbb7pJl3YMgKOK+hlnLOSJHSZ6Xg/3xF9A8tkIM0g060o5dGr8IwviDTRW/JF6D7pmEBtSm87xH2I6BfnBjpFHNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779776704; c=relaxed/simple;
	bh=owbd11WjEQYyKJ7MrAaJxkX/hbeVyioJm9f45R/IWHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=faX78pE1gQRyx+A1B5cb0etwrGVLSoAeButgflepIvrycPcUkCtHLfYutDesZLkrBWAiU5QJXGFxhJbJx56XLwY33zDyiQU9lK906yYYpf71xSGl6VHK0U9CyyLRa24yNSF2Duu+r9cVsyHF3Xc/FypXT+RfNHoH7FhQlMUhIi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 26 May 2026 15:09:59 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 26 May 2026 15:09:59 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 1/4] mm: swap: introduce swap tier infrastructure
Message-ID: <ahU5N1Yi2Ww+vN21@yjaykim-PowerEdge-T330>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-2-youngjun.park@lge.com>
 <ahTTv5OWpaUF6S1S@MiWiFi-R3L-srv>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahTTv5OWpaUF6S1S@MiWiFi-R3L-srv>

On Tue, May 26, 2026 at 06:57:03AM +0800, Baoquan He wrote:
> On 04/21/26 at 02:53pm, Youngjun Park wrote:
> ...snip...
> > +bool swap_tiers_validate(void)
> > +{
> > +	struct swap_tier *tier;
> > +
> > +	/*
> > +	 * Initial setting might not cover DEF_SWAP_PRIO.
> > +	 * Swap tier must cover the full range (DEF_SWAP_PRIO to SHRT_MAX).
> > +	 */
> 
> If so, do we need check if the upmost boundary SHRT_MAX is covered?

Hello Baoquan

It naturally covers SHRT_MAX.
Because  all swap_tier object prio represents start of priority
and the prio value is assured on the range of DEF_SWAP_PRIO ~ SHAR_MAX
on the privious routine.

swap_tier_validate function is for checking the first tier cover DEF_SWAP_PRIO.
if it is not, it breaks the assumtion "cover DEF_SWAP_PRIO to SHRT_MAX"

Thanks for the review.
Youngjun Park
