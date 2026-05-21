Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6411DF73A
	for <cgroups@vger.kernel.org>; Thu, 21 May 2026 17:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779383393; cv=none; b=k3bwt7BTWNDdNgMpmeog+vJjBw5uufTYMQoKg7wFYTwG8XIQuAoCWgEXRJNS/elnpXZkGOWpaWEefzgTONSVvEq7SVOd681xoR55lb2eGbZ33GWI85HqsrgiMmZUH2WMcAcqv7uLZOisiVpCa20nqqFMvWAH913Sa3oFonbpwMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779383393; c=relaxed/simple;
	bh=BFXNrnovlBh7moa06yy5G0Icw9eEX2z1mQ88fT0Wwp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mWNJxlwzcD5LnvadQmYqQBACbwnagG0WtXGnVhUdI+5WOzk2+3x8QCoTne4y0uZtDuCDDquH/vIP3h0TasLCtDHoVSY1aATcuGWskghduRehc9m4xCHft0RXUgyGEAsfHS8MCnD/mpCnyjlhiAJXY4DKE9O36IT6aUKuqHK9owo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=POweKYiL; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="POweKYiL"
Date: Thu, 21 May 2026 10:09:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779383378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h4ti8tMqv/39MPGM3dj4x90oM2WjJ+5dTMf5p7SntO8=;
	b=POweKYiLpn8+ZjkVrZcM7/VVK5Km63yJ38njVHPQb2CraBfI/2fiRzEwJDuH8zcFuYbEKr
	8sr9cG+tG6MWKQBFUqb0/gCpcS7EpwTemtDrL3FKwPV6p+P9rGrQ8wmCje3hTviiKdL0+6
	DKQIfle45Zzr5iJ+Nna4+wG00SL8jqk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Kairui Song <ryncsn@gmail.com>, Mikhail Zaslonko <zaslonko@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/8] mm/memory: flatten folio allocation retry loops
Message-ID: <ag88K4CRpsqOoRak@linux.dev>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
 <20260521150330.1955924-8-hannes@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521150330.1955924-8-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT

On Thu, May 21, 2026 at 11:02:13AM -0400, Johannes Weiner wrote:
> alloc_swap_folio() and alloc_anon_folio() use a top-level if (folio)
> that buries the success path four levels deep. This makes for awkward
> long lines and wrapping. The next patch will add more code here, so
> flatten this now to keep things clean and simple.
> 
> alloc_anon_folio() already has a next label, use it for !folio. Add
> the equivalent to alloc_swap_folio().
> 
> No functional change intended.
> 
> Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
