Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEA43939AE
	for <cgroups@vger.kernel.org>; Fri, 12 Jun 2026 05:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781242515; cv=none; b=SIvEJGbOnY/VL1hAJ3K2Y1nna1ZMmHf7fBeanBhjcX6yeVuQAhvT1dQvisMSgJqw4bnTFARH/KSM1X03E7NKMXWf0piEDueym/TPPsAzsDp5PwJsj4bSel9rrjq8UEhoexWr2+VVpPbS+NHmLijVgQMbna1pd0p5CZagW2+8Qn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781242515; c=relaxed/simple;
	bh=cvUzhn2Wxz3ZXNBEPRmqpB2Gw3yJx1mhKTvt7AOVg/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N6ZiXxpwvfhtI2urClINZE2RUOn9s3ze4jXucI4zx9DLQPFa1pltBtzK2l17JiO9Xj6EVJzY8dN+QvyYW4R73MilnU/iH2sq/dfEZv54hDWydDSketW008yEmS0J9eDJkMK4QUtOWpqZ8pWYkdNmPO8XVHaURR67vG93b/OadDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=adnOBQhT; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="adnOBQhT"
Date: Fri, 12 Jun 2026 13:34:33 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781242512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mAWalnkfq5iOPhyVkcUx6hxjbGEftgu1Arv6KFIZNLs=;
	b=adnOBQhT/kdwf1srUsq085IWW8dNvpJ4V3UBaXoDyMPUARhmbNs8c48lmte4qntFlvv1pz
	3O1IsLoJ4rZdgFiekGEOxmy14D6EE2eS71blAMyuGqiYDKPH5t1oq6pja/K0W/9tfErVgs
	1QVhuUx8ZCk9Ngu9+uxlB5Fx3h7xAFw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 12/16] mm/slab: pass slab_alloc_context to
 __do_kmalloc_node()
Message-ID: <aiuZZKDwYCshXPGK@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-12-7190909db118@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-12-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 10, 2026 at 05:40:14PM +0200, Vlastimil Babka (SUSE) wrote:
> With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an
> alloc flag that prevents kmalloc recursion. For that we need a version
> of kmalloc() that takes alloc_flags and use it in places that perform
> these potentially recursive kmalloc allocations (of sheaves or obj_ext
> arrays).
> 
> As a preparatory step, make __do_kmalloc_node() take a pointer to
> slab_alloc_context. This replaces the 'caller' parameter and includes
> alloc_flags which we'll make use of.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
