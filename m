Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187C547143E
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 14:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784817075; cv=none; b=T+OYqp3QOYMEve/AbaT+5AFd9n7yGNo5aL4Jt4AEVvgsb3GIXArPr2ymY00KxjdkRDBNHeRsE0VWMhxJ7CHAUtXHN/Y1MSzx4pTB2L1KJySv8pCRZSHw5bIGVJP2eqt/KS1h1A6OcVwvDL6VqR7rOuiFzxNhf6veIOLyuftYRo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784817075; c=relaxed/simple;
	bh=GKtdiZX3y0NX17bJQGexbS+5JDeyRbkGDRGXZr48qhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7xJajk3+wUniVzBQAKjtIBaJa9nNndMRwDibyUyDxy6J4YzhCBWS5UdzbqlIlLhDP5Q4gVw1Aq9JNBnUK+DYAxT2rVDyjIkRe6/yDhLe+DzvB53wJ5jqrEgJHuQsP0AiIOpvrVyQz4VGlouZ6VOVZS0oCKe2Wrf4I9tCMa/q9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=MFTbYGaX; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="MFTbYGaX"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c0ecfaee7so5888261cf.0
        for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 07:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784817072; x=1785421872; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1zAg+xMWc/xZ3o/AF2/ksssRntRxa3XS2KXW4/UcoJg=;
        b=MFTbYGaXqAiwmFu5CD7m/aXDYP8ot5f+MAvFwWo1x8RiyXoIvt1bn8TdJOS71357tm
         TGF5lD36hTjgCZbV4loCP2o6zsPRGYG3ZqOb6+smuERIanB2S5wXl/1Ge+UDNmqux2U5
         16sGsUk4KvU7W1BnKC4r4q62otqi3rW/QFNDWVQcNm1BwjyS08wavt409dcQSl5yQQQ3
         LkcGQUxvOGmDPDNfxSkVxFwrQxgNmmGc8YAFTEvLSw3hLg1b8SjP/dX8T24emlIh1cN6
         MPNDOFW7XcYt2xjcO2m8H0Uv+Ut5rDqxgKf1/Sur1z/B2mHa6E3g88oDZpXlRx7jyUFj
         KT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784817072; x=1785421872;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1zAg+xMWc/xZ3o/AF2/ksssRntRxa3XS2KXW4/UcoJg=;
        b=Zm2jR8bNgviNdSJ6r/Y/1lD+AuQKNhpG/S83DCsYfMuQ56g1bT+tttQJJs4b+BoOtt
         yMmU+ZubUdMC48M3QGjfwPta01zVtqIHe29AdJnRRgWYC266XsSYvMz3eol0FMEHjCdK
         bFUvfYPdjlau1PIy6gRUtP0qo1WaWtg7InD2YCaTCd74X0lQzUoXPhvdnPixRd/wUbuB
         T/Z0Ab59Nn5BGryxtzXS11ySzLia0X+vEQchQJ7yS33zlID0XmgPDWE4kXYQtH2YRfmZ
         a1Rd43kMc4N31smRyPjfhpWNfcsh+8j54UWzseHUxel/MO4WeA+NrjtQS1XVSzDEh2bQ
         b3PQ==
X-Forwarded-Encrypted: i=1; AHgh+RqSj3yIixETCWQRiT/Mz8ACxaI6Gr9W8HWeWzD4zBeCu/YS+dahfR2qeBTESqhiJS5iFWebz+sI@vger.kernel.org
X-Gm-Message-State: AOJu0YwOEB+xBqDo/ugvlocuVo/ww2FXXqJvM2qv+1NTx4CL0yjaezK4
	aE5d/osonBF4AvJ8pQ6sDcgIuw95I8V+8bLoe9lU6Rcx+T58xa2M6mEYvBRrvbcEXb4=
X-Gm-Gg: AR+sD10yc2HO3XpiS+oP0vn6KG/R1usoT9SWWi5Q5TMQELU7boiRY4629f2rF+vU3Kj
	pJBJAX/2v10l30bp2FfbXEF8XqWZ9Kks9dOoXmU7VCI4ed0larfPfIfoERoaOIeWa1oIXITYVyw
	EIIx8Kp094oDGuI2gEeiGrskbmAwz3f/mcwf31DnTaEbyvANzVm4d2DQHoRtg6onjWq1mfyiSjD
	YsKnJMiX2l2cDY3kFguBUClZeRaPBFMXVHXwoNJVWGWmIpNb2k1wLbXJKF2GaQlvYCsciP8QMun
	+IBCrbZtAwj9JBT3+7pS4unQjLs9K27LR+njlg/8rJD60dRE0V8WYIB1rlR04QOR18+zSuXNv5a
	DaNWb4WvPldyyxTchbcmJI9xAhLQ3wt2WLdzwcttDgnkw9vpnmzAMBIgbqcPJ/UuFljLsAzmyzH
	Xb
X-Received: by 2002:a05:622a:1196:b0:51a:8c97:938d with SMTP id d75a77b69052e-5283df677edmr29089161cf.68.1784817071384;
        Thu, 23 Jul 2026 07:31:11 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f6a4f11fsm424226585a.36.2026.07.23.07.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 07:31:08 -0700 (PDT)
Date: Thu, 23 Jul 2026 10:31:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: h@yjaykim-poweredge-t330, akpm@linux-foundation.org, chrisl@kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, yosry@kernel.org,
	joshua.hahnjy@gmail.com, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <amIlqHQ40baRoz3O@cmpxchg.org>
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <amDCIl51NoNPL7Op@cmpxchg.org>
 <amH9alaO97YqT8pY@yjaykim-PowerEdge-T330>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amH9alaO97YqT8pY@yjaykim-PowerEdge-T330>

Hello Youngjun,

On Thu, Jul 23, 2026 at 08:39:22PM +0900, Youngjun Park wrote:
> On Wed, Jul 22, 2026 at 09:14:10AM -0400, Johannes Weiner wrote:
> 
> Hello Johannes!
> 
> > Zswap is a first-order swap destination with writeback semantics. The
> > way the discussion around zswap has been going in this thread is
> > disappointing, and I don't feel comfortable adding permanent user
> > interfaces on this basis.
> 
> I have given this a lot of thought. First, could you clarify exactly which
> part of the discussion or consensus makes you hesitate? Understanding this
> will help me re-evaluate my proposal.
> 
> To make sure we are on the same page, I would like to share my thoughts and
> vision for the present and future of the tier interface semantics for your
> further consideration.
> 
> The interface should provide the swap amount allocated to a tier and allow
> the use of the swap device defined by that tier via swap.tiers.max.
> Currently, it would only support 0 and 'max' (essentially on/off for
> explicit usage). Auto-demotion is planned for the future, and specifying
> exact capacity limits is still to be determined. (I have also reviewed
> potential interface collisions and duplications based on Yosry's guidance.)

This is the part that makes me uncomfortable. The interface as
proposed now is just a small subset of what should eventually be "swap
tiers" - with limits, hierarchies and demotion rules. It seems to be
an unordered blacklist/whitelist for swapfiles right now.

And how the final form looks like depends on the indirection layer.

As Chris says upthread, virtual swap will be a whole new world. But
unfortunately interfaces are permanent. So I'm sorry, but it's
premature to start tying us to an ABI direction here.

> > We will not be merging a memcg swap tier interface until the swap side
> > has a story for indirection and backend migration.
> 
> Regarding this point, is your position that an indirect layer (I see
> this is virtualized swap) must be implemented first?

It is implemented. There have been patches floating around since the
beginning of 2025. Initial proposals date back to 2023.

But we need settled consensus before we can start adding interfaces
that are supposed to control that very layer long-term.
