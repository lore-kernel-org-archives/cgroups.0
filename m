Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310283C585B
	for <cgroups@vger.kernel.org>; Tue, 26 May 2026 10:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779792756; cv=none; b=EUP4NfuX2b4nEzFOhXPhH3jvdBD5M67T45UkqHM5v5rkpp+ViL5lQ+uWvkx8DSnLjLeXTmX4yR7es7I2ZzM1G88oUl5sI6DLFG77PiB8QE5eOAv0weGC0xDm9yFF+s7HJEfseb2uP2Qf7E3h8+6EcUAPCqU9Byr4qskjV8vdwlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779792756; c=relaxed/simple;
	bh=SCiNMl2HDWpXK9FRr41j8oA0wOfelyYeBmx6CuOeox8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b30f1PIvLP7vIMJorta7USXL14QnlN+PG3Tv2ak7KicsDa5fwajcnzbnbdQyl67bDXMF/1JrRGs3UUhPrQWjwv2IhoQsLOsiyPA+zSYiDrsj+T4o2Qxyh28q3us5E+HD7YSI2NiZy1+FVBdrT8KAdct562C1X7fyBiomZPaKcl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U2R4Boz9; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U2R4Boz9"
Date: Tue, 26 May 2026 18:52:20 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779792752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EimiBjgOCp06jII9evM9Ox6UF1NmDidggHL41B0/KNs=;
	b=U2R4Boz9j3fv/QALraxNzQIYVODUZOIGIyH3Y+xXsZMrxKEy7Pd2QIppH7GKvOlCyPimyb
	k7Cu160hgk7TX0HCzfHRBlAAd0SWVX61AUoKlNBTnUzKR1VF/h7jzFgBj81Gks+b3RFo6q
	gync7ieKZoeiOll1XyxmVkCVS36nMJ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: YoungJun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 1/4] mm: swap: introduce swap tier infrastructure
Message-ID: <ahV7ZJfBSNUtT4jo@MiWiFi-R3L-srv>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-2-youngjun.park@lge.com>
 <ahTTv5OWpaUF6S1S@MiWiFi-R3L-srv>
 <ahU5N1Yi2Ww+vN21@yjaykim-PowerEdge-T330>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahU5N1Yi2Ww+vN21@yjaykim-PowerEdge-T330>
X-Migadu-Flow: FLOW_OUT

On 05/26/26 at 03:09pm, YoungJun Park wrote:
> On Tue, May 26, 2026 at 06:57:03AM +0800, Baoquan He wrote:
> > On 04/21/26 at 02:53pm, Youngjun Park wrote:
> > ...snip...
> > > +bool swap_tiers_validate(void)
> > > +{
> > > +	struct swap_tier *tier;
> > > +
> > > +	/*
> > > +	 * Initial setting might not cover DEF_SWAP_PRIO.
> > > +	 * Swap tier must cover the full range (DEF_SWAP_PRIO to SHRT_MAX).
> > > +	 */
> > 
> > If so, do we need check if the upmost boundary SHRT_MAX is covered?
> 
> Hello Baoquan
> 
> It naturally covers SHRT_MAX.
> Because  all swap_tier object prio represents start of priority
> and the prio value is assured on the range of DEF_SWAP_PRIO ~ SHAR_MAX
> on the privious routine.
> 
> swap_tier_validate function is for checking the first tier cover DEF_SWAP_PRIO.
> if it is not, it breaks the assumtion "cover DEF_SWAP_PRIO to SHRT_MAX"

Thanks, I got it now. We only track the beginning of prio range via tier->prio,
while deduce the end of prio range from configured tiers. That checking
is reasonable. Sorry for the noise.

