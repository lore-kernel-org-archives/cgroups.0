Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AE71A0712;
	Thu, 28 May 2026 19:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779997063; cv=none; b=o5lB3/KH6h05lfBGMczOSrFOHL2Kh/u5dvB7iKKLECqJgUkhMc8JlW5TPoWNIlDyKeW+6qW/kTv6eadev3YLicrwvKjRqnP3q9ea3AFazr1dpD2NJ5Fe37Zp87ip+Mfckv/cTszPw1tqlFYWyIq8rg32V3aQEVkrwKniDr7eBYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779997063; c=relaxed/simple;
	bh=1Dkmvj0eqxwuhHb0ZPzTLNC14IC1a4p/8OKe4X8u+kQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S01e/nVEe8wpi5blXMYcI983P7anA2M9bRCfYC0VXfX7V0Mwt8b3YbzLf3lHZRlz4WvlJb4z1KWCUgeausfTyR4/uSzgHzwfd5J05BTI7NiUnNvPkAfxoFAHsTUZ+ejpGlcf1crnJbwNcUz8lK701cvnPDA5B1OwU8cIFA8Galw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vbdVjCk4; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vbdVjCk4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=365/QyEIbQHX23D/D0iz12r6u0cbZ1h1Iww4gETb2gg=; b=vbdVjCk4Sp468Yol27/B0dNUVF
	R9slRW3qAWTf1TbHIty+EV6z5VOAjSRuB2MDx0igwR5WGUFk16saTVcGndZpu8+CDPqIu8T4070sU
	mT7iR8QdOSmbmP3YBcSTw4nNbcmSzH8/mKZ6eRgCQyIrl3MMIV8TZTh4mkudQKsUkvVZRTDBNP+co
	yVAZXCQwOrCMhEUdoAARSMZa1I4hRL05wKQzfgL0plmMIHftV317A+uZosvBGV3ZpX18uWPZz2OZw
	X2xclxJp+2wFC75c6jCXnMajvNteogK/D4LuiJSNNVcTwzu4RU73PUsknOgGTmFeuggOGVPN+RKAD
	E84eEQYw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSgXr-00000004mKt-0H6p;
	Thu, 28 May 2026 19:37:31 +0000
Date: Thu, 28 May 2026 20:37:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Waiman Long <longman@redhat.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
Message-ID: <ahiZeqgwUxqAOPiG@casper.infradead.org>
References: <20260528190337.878027-1-ynorov@nvidia.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528190337.878027-1-ynorov@nvidia.com>

On Thu, May 28, 2026 at 03:03:37PM -0400, Yury Norov wrote:
>  static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
          ^^^^

>  				   const nodemask_t *rel)
>  {
> +	unsigned int w = nodes_weight(*rel);
>  	nodemask_t tmp;
> -	nodes_fold(tmp, *orig, nodes_weight(*rel));
> +
> +	if (w == 0)
> +		return -EINVAL;

... this doesn't even compile.
