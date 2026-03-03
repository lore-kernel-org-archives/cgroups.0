Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DC6298CD7
	for <cgroups@vger.kernel.org>; Tue,  3 Mar 2026 08:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772524905; cv=none; b=i2lREJwtcYjbNps/R9jSs9Efb012V0CRwcCqazLw8O5uqlLqji/yHxKvBJ3LBwu1/qzXQgE3cPqm++Ds7RMD3tiZNymtudSijxkMXmxTqbV0L+p7aoqkS1J18UkcLwlpyWvW61O8yLhDFrt6pR5pPqPdbZVsdLE5LOONeBC1h70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772524905; c=relaxed/simple;
	bh=7Fk6GSalx0F8jPPR7nHq/i4P4yRmrf/sSPbnIXv5hmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PtLFbGZ1K9AQw769Y++qr7mZjgZXATyL6dGA387NxGH0o/USRV3UUxhvPGXsGO7L68j5K1CbW0mIBMv4864X+ZcUbNYfEaNjm5sk+WdB+krJM9SDqbNRdANo9o1Cc+wUlgyeOHuvZg3cBIKwLzJughihzlQWUCgrBgJTVyA93RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BXqhCwYE; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BXqhCwYE"
Date: Tue, 3 Mar 2026 16:01:09 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772524887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lGygmojsLtPwlOT4v2cotNZ1hHvskz3elg0StMnNUFs=;
	b=BXqhCwYE2S38CiFbKca5uY00d0nIpLm2ad9nlVUytP1FEw0bJJIuQII3Bzg+L06fmX44lc
	NT+5yFIP1YqUkeKcL8yplHcogpgiv0zEbzj1Oc5hz2lJJ+xhHvPIpNIUGNIOv4p05df69m
	i6azEqah0au/LLCArNfgVXIRqMiV/20=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Johannes Weiner <jweiner@meta.com>
Subject: Re: [PATCH 2/5] mm: memcg: simplify objcg charge size and stock
 remainder math
Message-ID: <xhv6zv5atecuzfsf75cyh4mynbloc56e7ukgwhgdgf2qvrrpwy@x7o7qldvxku7>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-3-hannes@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-3-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 02, 2026 at 02:50:15PM -0500, Johannes Weiner wrote:
> From: Johannes Weiner <jweiner@meta.com>
> 
> Use PAGE_ALIGN() and a more natural cache remainder calculation.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 

Nice rewrite!
Reviewed-by: Hao Li <hao.li@linux.dev>
