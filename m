Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB90130DD11;
	Tue,  3 Mar 2026 07:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772524605; cv=none; b=f4hAHJ/RdhHhy6f9zCs9jhmEytQLlsg+Qgn1Y5TNNHZxKcjVK9nqrrB/nX7BvM+1T/+YaoVNOvWabJOmy9MhV67WrHAVWpF23sj5lBmluZBsZZjwjd3x61Q16l6mIlDRhHbIdi4y0H1ckV10E/lhaIuUdTRkgHjzWJve702pzKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772524605; c=relaxed/simple;
	bh=yiWYUAtSue4lGkvaeYz6DrC/x7oMjh4vd3+hw4iCiPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qvBqXD2icBgqNff1RDjjBP05q00+cY26JFf5NkTs5oJGg76YX2PaSmVIDjOn+k85rcga3nM1mm+qd9esW5xMk6W3r1qPtFGicfPKtyN51c9grPEWYBOoqhPviZTRx/kDvOE5JhCHMmdBJDVT5O3oj+m4CPLUR6kt1B67Ml4MEl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cQ9dMGdS; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cQ9dMGdS"
Date: Tue, 3 Mar 2026 15:56:24 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772524602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZDWRum35XOoYEguLtAtn2u4EvUrjQgF5qvmDIstdPgU=;
	b=cQ9dMGdSLe5PXlA5a3yAXk/3kZiIH+0TQwmQUmjKk2gcJ/GQSY+HeaTgPu2iIyWPGCHV4o
	DG0NiNz7/H5gzL34C9bg0ywNcn9y0B4qnODvhglEmfQCvlf/nekFq8V8PK2RqZYOxOq3vt
	peuFdiDjhqiaFrvvAYq1Amc2U3sbfts=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Johannes Weiner <jweiner@meta.com>
Subject: Re: [PATCH 1/5] mm: memcg: factor out trylock_stock() and
 unlock_stock()
Message-ID: <xfnrnmnhgblqfj7xthzxztclo46unhbhfhoeykbbphs5bpuin5@qmfk4mwmgib3>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-2-hannes@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-2-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 02, 2026 at 02:50:14PM -0500, Johannes Weiner wrote:
> From: Johannes Weiner <jweiner@meta.com>
> 
> Consolidate the local lock acquisition and the local stock
> lookup. This allows subsequent patches to use !!stock as an easy way
> to disambiguate the locked vs. contended cases through the callstack.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>
