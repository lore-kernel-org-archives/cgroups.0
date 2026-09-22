Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC1637646C;
	Tue, 22 Sep 2026 04:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790049870; cv=none; b=YVq/RBinRO6Z5XAyhZ4eT/z7AOEHfPodnrq+d//U+da5GdEDkNmI1vWmOb0tUmk1kdY7v6TOkK/gIsqLtMpi1knMAhQN7UmpgxVC6G/iJkSRD1Y3W0SKE2IT9Nexp39mTJ6DmniZMXnmETBy8e1zWDj4B50K3CITqyQ/vpm9bhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790049870; c=relaxed/simple;
	bh=fkiPDh0RXJZZAjVo6l33x7WJLvXz7n0Y2jZYuQ7lTAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDvYEQqcVaZ9IJSNRMDYMsq0nDiNTV7LZ7owBLiv3BCqnUkbz6Vp+XJmUJMoHAI+5nJ9GhOQd7dhntIKsYS363qJe9EM5kWXXhMpFirRlEA6dX2sAKQYwl6DgvvZVJeY/a86PBjAHSWvIdgP4Yv0kMpxxc6STjdE1jwzcOHYlFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OoD1eWxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OoD1eWxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC5B1F00898;
	Tue, 22 Sep 2026 04:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790049869;
	bh=XdK9NOa+Csh4+tgbck/fIPFaNIpTXpsiJF2arJyHaDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OoD1eWxAao/IPqexC/yqGBE9mUdZr2l/XResY7bPKAKx9KitlrY6x0g+fe1ZtvHwG
	 YMBsag/OpacfmYFOv103gYiuk6qQULuSnCAMTTVlnZklJxrkBMLlRYb3f9ep60MvU9
	 fJrfqiroyQymRgjDPHQalZYFDqO7sHYLTA9N5+gA/vmmz/UyFPcCzylqV1Ah8jU/Tr
	 jk5L+LDTJV831j50vA4Gpra2zXXC4Zf8LuLviP8Mi+6fYArU9p1ozN1+qArX/6etD9
	 tfwIGktNXcyelkdo2awMWs4g5XVGrPq5L6spppc+O0ft0ar+afICAztfndaedg7QTz
	 nDfUSljFG2VVQ==
Date: Tue, 22 Sep 2026 06:04:22 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>, Chris Down <chris@chrisdown.name>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/hugetlb: account migration target folio in
 per-node NR_HUGETLB vmstat
Message-ID: <arH-Rntaf5SKFTga@localhost.localdomain>
References: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
 <20260921-for-hugetlb_state-v1-1-8a6eec92661f@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921-for-hugetlb_state-v1-1-8a6eec92661f@kylinos.cn>

On Mon, Sep 21, 2026 at 05:12:34PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The NR_HUGETLB vmstat counter is maintained per folio's node: incremented
> when a huge page is handed to a user via hugetlb_alloc_folio() and
> decremented when it is returned to the pool via free_huge_folio().
> 
> A folio obtained by alloc_hugetlb_folio_nodemask() never goes through
> hugetlb_alloc_folio(), so it is never accounted, while its free always
> is. For a migration target this means the target node gets no matching
> increment for the decrement on the old node, so the global nr_hugetlb in
> /proc/vmstat drops by nr_pages for each migration. The same asymmetry
> affects the failed migration path, which frees the target again right
> away, and the temporary folio hugetlb_mfill_atomic_pte() takes from the
> same helper.
> 
> alloc_hugetlb_folio_reserve(), used to preallocate the memfd page cache
> folios, has the same asymmetry: the folio is handed to a user without
> being accounted, while its free is accounted through free_huge_folio().
> 
> Account the folio where it is obtained, in alloc_hugetlb_folio_nodemask()
> and alloc_hugetlb_folio_reserve(), so that the increment pairs with the
> decrement in free_huge_folio(): a successful migration hands the folio
> to a user, a failed one frees it again.
> 
> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs
