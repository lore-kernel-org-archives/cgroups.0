Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD785212542;
	Thu, 28 May 2026 19:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779997295; cv=none; b=rWCSTywMrzfwjPMxn4w56KPMZHdajtzb9qSpqUCSM1KQfSA38fr2+aPFVt8YTF/YOn814LydXhA2b+/moLYbInOQifb+PV/RM3MNmRMOGz3gkBuPn/XkWEZyTPXiyw6CqDP8g3v5rlFCHhjOtY/uohnpe7zSJOTidTtGMKoIyso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779997295; c=relaxed/simple;
	bh=UH3fyQXalATwV44o3/NG9l5MX26OjW9siAGg7unX/ic=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Z/tzt4cRFtRx0CZldoXVtd4Z95ufAA1UfFIuWig1R0gQgtP2ZyQB8YrPmib136sA4sw93q2DNMuRQUo3jufEwIVMZZ+3DKuBYatFJXME1b0LK3Uy5+HnM/nSI8JPexfuPkZNGatMNhaa2Yq35oEDpDjgmMP92riDFdhgmTM/0wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DaRSN3et; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DaRSN3et"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E535C1F000E9;
	Thu, 28 May 2026 19:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779997294;
	bh=mCdBYtvZPP11aQlPQeSM2ybwZJhqmrs4vdzqMl79lJI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DaRSN3etf1UD0hQ8XimNb/OzlvKUJp6QzbYxVb3eBDYbD1ycGL8pJSAeZzSf6w7qZ
	 j1pDGOcNdoQR6Jc9TaSaaVHxDN2g+ucKrAzeA8Yfo2ExXxN7uLdPLTD0TxrC8hn9Nz
	 sdiNS4IuWTfK6VsesMHt8hbAF2J2xIITFY/cspF8=
Date: Thu, 28 May 2026 12:41:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew
 Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory
 Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Farhad Alemi <farhad.alemi@berkeley.edu>,
 Waiman Long <longman@redhat.com>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
Message-Id: <20260528124133.c88c27b11a8ea0ef05e494f7@linux-foundation.org>
In-Reply-To: <20260528190337.878027-1-ynorov@nvidia.com>
References: <20260528190337.878027-1-ynorov@nvidia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 28 May 2026 15:03:37 -0400 Yury Norov <ynorov@nvidia.com> wrote:

> Reassigning nodes relative an empty user-provided nodemask is useless,
> and triggers divide-by-zero in the function.
> 
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Link: https://lore.kernel.org/all/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/

Thanks both.

It looks like this is very old code, so we'll be wanting a cc:stable in
this.

> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -370,8 +370,13 @@ static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
>  static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
>  				   const nodemask_t *rel)
>  {
> +	unsigned int w = nodes_weight(*rel);
>  	nodemask_t tmp;
> -	nodes_fold(tmp, *orig, nodes_weight(*rel));
> +
> +	if (w == 0)
> +		return -EINVAL;
> +
> +	nodes_fold(tmp, *orig, w);
>  	nodes_onto(*ret, tmp, *rel);
>  }

I suspect we should address this at the mpol level - it should never
have got that far.  Hopefully the mempolicy maintainers can have a
think.


