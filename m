Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF35224B15
	for <cgroups@vger.kernel.org>; Thu, 26 Feb 2026 00:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772064008; cv=none; b=LOQLTxpzTI+5En0Ihvuiqs7kr9ojR3Hj11uoRtIoDhywPdgDUBAPDkBxLpc19qqVu6tNrNUMLox7318xnEK3RJvZ96UE0doYsC1A/c/LSdVCgIJddstdud2oO/8v2IGk/XIfbzIYDvJVFckkfN4SSNqKBnhUVaNs7HFpEEO4cgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772064008; c=relaxed/simple;
	bh=ZwXkuLbNtBiV0ALMwk6j+6/MlReleR0M0iHtCFbRX9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xwjofnk14B4fI8J+MC+cpSZ95xDe4360ji6sSuhI6tp+KHPkVZd5LULVPz0B4ghZzECx8fUySpY9sfsDRRSD61nZBwVkMUfLUOYlQi4LclM4W8kKOQK7cfGXhixaalAnqO2PtUafJaTieyLi0PTkk++MaqYMqvCVESCphMKkwfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AGlwvQuQ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AGlwvQuQ"
Date: Wed, 25 Feb 2026 16:00:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772064004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wawHLyOTJp2IXUoV4PemjW87N7htBQucAPkl0+HuDtA=;
	b=AGlwvQuQN+0uaJ8qH6Ehe4SZQoqfoPvzfxZUrv6EIeE/o3WNCyvlzFuer5C/vTA6AgaKZ0
	PuynYss88Gi3ryI5Pyf/F0CDNjP1kRYJXCa498rcUE3Akd9vRJF7u3uSJLc2hAyQkRsCeY
	IVNZnkFwZxooMU9CqbvAUuui1X6shK0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH 3/3] ptdesc: Account page tables to memcgs again
Message-ID: <aZ-Innu9a3ND6Pdq@linux.dev>
References: <20260225162319.315281-1-willy@infradead.org>
 <20260225162319.315281-4-willy@infradead.org>
 <aZ8oT-n4a8VDY2AH@linux.dev>
 <aZ9jHvd-kpnQzMgC@casper.infradead.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ9jHvd-kpnQzMgC@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 25, 2026 at 09:01:18PM +0000, Matthew Wilcox wrote:
> On Wed, Feb 25, 2026 at 08:55:54AM -0800, Shakeel Butt wrote:
> > >  #ifdef CONFIG_MEMCG
> > > -	unsigned long pt_memcg_data;
> > > +	struct mem_cgroup *pt_memcg;
> > 
> > This is kernel memory, so this would be struct obj_cgroup * instead of struct
> > mem_cgroup pointer. We will need something similar to __folio_objcg(), maybe
> > __ptdesc_objcg() and then call obj_cgroup_memcg() on it. Basically how
> > folio_memcg() handles the kernel memory.
> 
> Why would we want to do that instead of just stashing a pointer to the
> memcg in the ptdesc?

Not the memcg pointer but the objcg pointer, a bit background first though.

Underlying we are using alloc_pages_noprof(__GFP_ACCOUNT) and __free_pages() for
ptdesc, so allocation path looks like the following:

	alloc_pages_noprof(__GFP_ACCOUNT)
	...
		-> __alloc_frozen_pages_noprof(__GFP_ACCOUNT)
			-> __memcg_kmem_charge_page()
				-> page_set_objcg(page, objcg)

and page_set_objcg() is defined as 

static void page_set_objcg(struct page *page, const struct obj_cgroup *objcg)
{
	page->memcg_data = (unsigned long)objcg | MEMCG_DATA_KMEM;
}

page->memcg_data overlaps with ptdesc->pt_memcg_data, so we need remove
MEMCG_DATA_KMEM to get the objcg pointer.

If we want to store a pointer in struct ptdesc then we can't use the raw page
allocator/free functions. We have to allocate without __GFP_ACCOUNT and then do
the charging in __pagetable_ctor and uncharging in pagetable_dtor explicitly.

BTW we are trying to migrate from memcg pointers to objcg pointers in most of
the places due to zombie issue.

> I feel very stupid about the differences between
> all of these things and would dearly love to read some documentation to
> learn.

Unfortunetely we don't have a good documentation, just code.
