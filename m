Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377213C10BB
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 06:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785133388; cv=none; b=V0T7Ox+86/f5CcjoIcx/4bdYIIInX2dBQDkiAJnbquRzoRV0T/0YV8XkfLXl/dZAxjNuK8R10kaJawcv0Zx+ko5P2I1m6XUN8QsVYGkHcsHn6Eh68sWE9EOm5wEZnAwyG6nnMF0vyorh89w+z8xX7e9VHrJx7wleKOzsFp8NUM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785133388; c=relaxed/simple;
	bh=oKn0mWWTv1QZb/mmTUUqVa2q9YgHkp34zWxGkNt2S1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jwgrYuYjoKL1sMpoHdUxbk/9ITqgP3xfEXuOyiFl9Vc3D3Xsl6DEEtt8f56HwX/4JGfjK8LuqmXpx8xOYS45kLzz8Fn1MR2lJ2TW/RXINM1cOCFOWfMytQ7ii+yEVGNISHAU5XIedMcGjkcFvMw7La0cGWTJiV2m166Re66M0GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nw9UfUv0; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nw9UfUv0"
Date: Mon, 27 Jul 2026 14:22:39 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785133371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JZmxPmsLA/v62j29nrs+JTmYYoheM7akRz2Dh6biEKQ=;
	b=nw9UfUv0xp3woEzgCFw5HyhW0GCyu3aS2xj0bjmL6xnk6YeODTbcjaI8uImAnTnURwcLB/
	P/NnV8x8yKRmIRgc39KKTg/QlVKjw/W1rL/H2Cu6b50vm9FyUj//PtMhyEciQS9rHUXvC3
	WyJnUGe4MEPLJs0AL6KAAJOQjxsa0Vs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
Message-ID: <amb49FJ_az_3QOPx@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
 <amGEY5w-cBm4_uhx@fedora>
 <9b2dadb7-8e3d-4b9b-a870-969be9a7a432@kernel.org>
 <amHkbJsvOjcfUR3D@fedora>
 <e3f283e3-27a4-4e3e-bc4c-39fafbcfe1ee@kernel.org>
 <89662cae-b3d9-4aa4-a7fa-cf5931781dbc@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89662cae-b3d9-4aa4-a7fa-cf5931781dbc@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 27, 2026 at 02:41:20PM +0900, Harry Yoo wrote:
> 
> 
> On 7/25/26 12:42 AM, Vlastimil Babka (SUSE) wrote:
> > On 7/23/26 11:56, Hao Li wrote:
> >> On Thu, Jul 23, 2026 at 03:27:51PM +0900, Harry Yoo wrote:
> >>>
> >>> and drop OBJEXT_FLAG_UNUSED.
> >>
> >> Yes, this idea is insightful and I think it may need a standalone patch without
> >> blocking current patchset.
> >>
> >>>
> >>> ...not sure how much we care about this on 32bit though.
> >>
> >> Yeah, 32bit is a rare arch today :)
> > 
> > Agreed with you both. Let's deal with it later.
> 
> Sounds reasonable.

Yes, agree.

> 
> > Also AFAICS the memory was already wasted on 32bit prior this series when
> > e.g. CONFIG_MEM_ALLOC_PROFILING was disabled, so there was just 4-byte objcg
> > pointer in 8-byte aligned slabobj_ext, right?
> 
> Right.

Exactly.

-- 
Thanks,
Hao
