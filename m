Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F390B459AFF;
	Tue,  4 Aug 2026 11:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785841392; cv=none; b=MHUrfAcZbKHT1sFABe8e29Rsc0cUv4+DdVDAWSnuOKenLsxjKsdzNvrEdb1CPUrRvOeulKQyXQLB2OLGcolkOy01cwiXZlGTYgVa48RWhOncXi8kEARNcHfI9Zv4GHFgRHdBlO3rgR/tF07Dmdpfx1J3vCWnWabvkyT2SEaLq6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785841392; c=relaxed/simple;
	bh=iXDxYwSV7g9rYp8p++FwfQHg69A92970L1sFpqaFceo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYhfPWxMpWz5fl0AT6Q5KFDjwqVT6+D0EtmMoza96q9iQkESPrcHt2J5CC/+xPsGQkPtJk+fbr8OZeL6cxktlvQu1nXxG/nJCzKrFwIZwMj63Is8gQHVys62rdciSylC7lHhCtVvSu9oRtDiMCZEv5NU9belBOXktuS3csS16LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1CFIKAx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1CFIKAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8397F1F000E9;
	Tue,  4 Aug 2026 11:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785841390;
	bh=iXDxYwSV7g9rYp8p++FwfQHg69A92970L1sFpqaFceo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C1CFIKAxTrKJZVBjPFRcEhLN7GNjDCw/br30yzoAZTvVgSaOOk4tglexKWkvwX04i
	 4rm/a8Nq9zIxpxfupCXwKSTmzNs5iC/TLUg50TnsOG/27O/spRwljupOB1A3tAjjgK
	 GqDLuHJJwigJC+Md/pZUAcodmGDJfFMUo2HeuDlD9O+/rUsIMSS7AuShfNBkFExFC/
	 xAqLprQ9A+UR/BpWx7o2cMemDAkFhJ+KYHhW3q4UV7nIreJJwbTGIo6K/nnuUt+qEi
	 Xx9D76OxLKhR0eF/1XMdE4qRuNnRGleZ+Lw0esdYH50cYlpT3jAJZfOXASatQTL3bX
	 17+St3fDz7dUg==
Date: Tue, 4 Aug 2026 12:02:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: add some missing includes to mm-local headers
Message-ID: <anHDNwlcBlIfC-Hv@lucifer>
References: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
 <8179be78-a35c-4d0f-8034-27f3154db0e7@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8179be78-a35c-4d0f-8034-27f3154db0e7@kernel.org>

On Tue, Aug 04, 2026 at 12:45:22PM +0200, David Hildenbrand (Arm) wrote:
> On 8/4/26 12:08, Lorenzo Stoakes (ARM) wrote:
> > There are a number of internal headers local to mm/ which reference
> > functions and data types without including the relevant headers.
> >
> > mm/vma.h is a special case that intentionally does not include additional
> > headers, but the others are not.
> >
> > This breaks tooling like clangd (which is where I noticed this), though the
> > build is OK due to the C files including the headers happening to include
> > required dependencies.
> >
> > It's better to be explicit about dependencies anyway, so add the missing
> > includes and fix clangd as a bonus.
>
> I'm curious, how did you identify these? The mm/vmalloc.h is rather easy, but I wonder about
> e.g., mm/shuffle.h including mmzone.h.

Well I got AI to look them up ;) but I pared down what it gave me to a simpler
subset and checked everything so I don't consider myself in a state of
slopper-sin :)

[this kind of check ideas, look things up stuff I don't consider warrants an
Assisted-by tag btw].

The headers for everything but shuffle.h are obvious, so that's the tricky one -
it's for pg_data_t and struct zone specifically.

How I discovered this with clangd initially was - Do something like 'C-c l g r' or
'C-c l g g' in emacs via LSP and it reports 'no symbols' for something I _know_ is
compiled in.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo
