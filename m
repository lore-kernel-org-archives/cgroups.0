Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5689F433029
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 19:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784058725; cv=none; b=SoRTaq8gEsbjO5Uf6YRPeJPgKp3bNokWpPT8DKl8e/m4NqufJDOoZZpY+2yLFGkrF1c9i1Tuh7Ncz14d3JbRut1/1HKVY/f3jrXUrmf8zBPpx2HrJwOh5udN+xDtsd/bic2Pc8SFTmo1+WsnCrGqw0IHI8oGLrDRj3Jj2zZlwC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784058725; c=relaxed/simple;
	bh=lFyokh7MUwA6B1sjQ4JNosFhqk0VvrtBmAVznOUX+WU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDgmlrbmX2z2fZeVAPO8MjL97v91rNxfAmGjDMZ8vzOX8HpG1LG6d4NtOBtDtzQNqvTxvXPVfDBASTdARiT3N6kw2bEt+Yq7bcjRg0LJ+C1V5GbInCGbjLiMz4zwO+su6EiuPoU4zvZ9KS3ylgltekuWzSo0+5F+3Aud3i7tJ2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xbEaUCOX; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xbEaUCOX"
Date: Tue, 14 Jul 2026 12:51:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784058710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cuoijzz0rTY63A4da4n+CjQ+9RFOuE3zmPGDmmxWI6M=;
	b=xbEaUCOXuxx8FfZYpiWNatKkOn8twLD8coYe4FO6wtqEyxg+Xc5o0DpNmmhZq091tIF8d+
	DgEzCKaSTpgZl3w6bv1b4wdJ4vO/M/B95cjJk4wLhxu5e80JY+rubyvjdOYeWuf0s9uOAr
	k3jZZEiWpz4kF5sfNDvVwF0yHk0V/hU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Guopeng Zhang <guopeng.zhang@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: update state_local when flushing NMI
 stats
Message-ID: <alaTQeiiTTmKLngu@linux.dev>
References: <20260713085053.2916813-1-guopeng.zhang@linux.dev>
 <20260713113901.GG276793@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713113901.GG276793@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 13, 2026 at 07:39:01AM -0400, Johannes Weiner wrote:
> On Mon, Jul 13, 2026 at 04:50:53PM +0800, Guopeng Zhang wrote:
> > From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> > 
> > flush_nmi_stats() updates state[] for kmem and slab counters but leaves
> > the corresponding state_local[] counters unchanged. Local kmem and
> > slab statistics therefore miss updates collected through the NMI-safe
> > atomic path.
> > 
> > Update state_local[] together with state[].
> > 
> > Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
> > Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> This issue affects memcg1 but also the workingset shrinker.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> And we should probably CC: stable # 6.15. Shakeel?

Yes it makes sense.
