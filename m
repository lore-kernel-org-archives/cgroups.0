Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41ABE36F429;
	Wed, 14 Oct 2026 18:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792001339; cv=none; b=OnIPfSbM/FXVrIR4YjQaEIcwRw5XjciHzX7Oy3leyZBU977DWC6/eTEVDLj7g8pczSsmvjC+Qw2H3MUJF7u4adpfmCzAFSjhT6yhzEPi0RvEIMCfx+SzCbLQUuYH9jePHa8co+TVw9xMq9r16Jph5AsidyLBcQt0sKi7+7HIaCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792001339; c=relaxed/simple;
	bh=hJrSunb50VnyfxfkWpoPngnUFmZt41oN1AydPjmxQoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KcQYgrsitUer3znqeuhEeWHov114GmKDVd2X1U4090qO8aipW2sRl9FQ0k1WKrrL+IpxAr1hpnzCRQwkXAQHyHajBwKtdhpzq+FIeD600xr5O8AikbQ52ZHkUOZwAZ4qLTvYg+qRfGsbpj8u7BgADeFtbbspDxZ5iuhsZx5gaUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=monCtWUT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="monCtWUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC421F000C4;
	Wed, 14 Oct 2026 18:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792001337;
	bh=YJDX7p+COi8qSZ2TAns/+c4C3bCMkstG1AQhV+nfC7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=monCtWUTJM1JJiTY5ehe5iAz7kdm0NJXj6mTFYuhtNHYYqFs6snOCEPtsgac7O5JM
	 eU2EP8c4Qc4cYC/+iTk2K+vuYSNqZ48bMmFXHuSY0hE03eDFhhhvLDe3pnCVvqkHv3
	 Xb299Pvzs05SekBEymV81B+hy8fxlN0S1OjKT+iPpJWjHiPCNwbkNmDCScsGEJ+VW5
	 NRtHtCRlc56Ek4lKzCMxVq2po9Y6NuLPnCixpsVmkzePzWXcUgz4EmMnYV4EbmiaRz
	 PIMXXvg64pVoV2DLt22JcRl6/8ZbICTupKhmxWp+GmVvXhTe42yXmLySdJNo7H3MHI
	 bYTxCfrmecq2g==
Date: Wed, 14 Oct 2026 19:08:55 +0100
From: Harry Yoo <harry@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memcontrol: remove page_memcg_check()
Message-ID: <as_FLaXgZu01g8zq@thinkstation>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>

On Wed, Oct 14, 2026 at 01:08:21PM -0400, Tal Zussman wrote:
> The last caller was removed in commit 90f095b816e2 ("mm/page_owner: use
> memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()").
> Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon
