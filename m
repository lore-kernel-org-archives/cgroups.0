Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982C846DFE8
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 11:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806171; cv=none; b=mac+WwygfbanXs1nRnKCzl0H+0/SHcZ2kZ7t4BmgyEZKKfFzPE484GjSUzEhDy4+8BlkkovJPDJacsy1y1qRncSdolBxH2rAn0xhcfi9Y6aXAdJYNiiqK0LrzHpLkcSYpYPTOAU+Ivww8aF9uVeUgtEFag8MGryYogcDIHDmhew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806171; c=relaxed/simple;
	bh=JyyhQtr/gKnfrU1jyzFKqWtR44cDxtJZTgBbJ8srlvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ff77JhmLEunO7zz/pCytFxL7EJEdl/Y9R0akyi5+GXq6ASS77AWrJv9Rm9jF9rqajplkEmHaFKJ/xKXodQLi7NGGUslUhRIDububbjToNS2OZVEHdGrhrR5/6jbkMvz+Mv7ob6C1JtM4+mo0Ejz//yHlDY89QxjM2JBlrjsq/8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dmcrERvO; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dmcrERvO"
Date: Thu, 23 Jul 2026 19:29:17 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784806165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4XnK5MSZnm10txveKUazi1pt0QZOCFoh2oisogPVwAY=;
	b=dmcrERvOOrxVpIfxHgtyEWEvap5lrXEjssBSFtGgA/+fX2aNAs6CQAq9AGzIkJRB1Ch+MU
	T2RdeaIPyWYC++4/ReVAQcWvH1MCnxevqYUO+LzvCgSqfy62lWAkN1cow5j3uoX1hIwuxV
	8ruwfWHStx6xP345j8n5kw5DRBYFKc8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 03/13] mm/slab: remove objs_per_slab()
Message-ID: <amH619DxX4_rO6kM@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-3-2fa7c6f60dbe@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260720-b4-objext_split-v2-3-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 20, 2026 at 04:16:17PM +0200, Vlastimil Babka (SUSE) wrote:
> The function has an unused kmem_cache argument and almost nothing uses
> it anyway; doing slab->objects is simpler. Remove it with the last two
> users. KUNIT_EXPECT_EQ() needs a cast to avoid "error: ‘typeof’ applied
> to a bit-field" but we don't need to keep a wrapper just for that.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/kfence/kfence_test.c | 2 +-
>  mm/slab.h               | 6 ------
>  mm/slub.c               | 3 +--
>  3 files changed, 2 insertions(+), 9 deletions(-)
> 

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
