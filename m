Received: from mta0.migadu.com (out-90.mta0.migadu.com [91.218.175.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACD337FF70
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 15:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787065787; cv=none; b=PjWMdf9gDzTJ681mZ/DAJgxNzOWqgb26Zn7bDWsgDFSeGtQLXxfJ4QXL/HBO1VpHELDJ85SLOYeE734DHOSP+uHHTz0fi+QdM+SbWJLue+6XZU09Ma2VmDzR2a0fkmaa3AWD4UzifLL88zk/kuBgMgGHUKJ7daifGg525FDV2Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787065787; c=relaxed/simple;
	bh=sEjhvPD2ekveHVjazAifLyhpA56JI5CFArPLYf0xVLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CpN0xrYb8BLTCq/OlbpQpAQB5BDyAdJ56ryWYT1CglO7jHxa0vWerKuLsSQhNwOjRwwyrQUVa9AKp7/S4YUCJeSIjO5Lo2JktMpNz1g0uBDaUk6IRU4kzcuzhuBgHT/7XKCjgssObjhGrtUqH+Gu4FCtwsdTw3FIep7wtstMU7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QTbaK+bE; arc=none smtp.client-ip=91.218.175.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QTbaK+bE"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=sEjhvPD2ekveHVjazAifLyhpA56JI5CFArPLYf0xVLY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787065783; v=1; x=1787670583;
 b=QTbaK+bEJOztQQi95vCcdTlkK1aS21S1B3dg4EZNpJrR2sHFM/LPNtWwnzGA+bHUR19RP0hj
 vRZjJeaYCZ8eOe6leyGjH5yd+rDdTXqesevO/pNuY9dmVfr624WHccB8gjECFnTGTlJVdI+mggY
 kRB5dbVsa+bONvOz7aNjQkx8=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:59::)
	by smtp.migadu.com with ESMTPS id ddfa09f4e93c0093;
	Tue, 18 Aug 2026 15:09:43 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 08:09:42 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, mhocko@suse.com, mhocko@kernel.org, 
	joshua.hahnjy@gmail.com, willy@infradead.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, zhuhui@kylinos.cn, audra@redhat.com, bingfangguo@tencent.com
Subject: Re: [PATCH v2] mm: memcg: release the css reference when a stock
 slot empties
Message-ID: <aoR1lxZCxkD2jEVr@linux.dev>
References: <20260818130135.154315-1-husong@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818130135.154315-1-husong@kylinos.cn>

On Tue, Aug 18, 2026 at 09:01:35PM +0800, Song Hu wrote:
> consume_stock() can drive a stock slot's nr_pages to zero while its
> cached[] pointer stays set, so the slot keeps pinning the css
> reference that refill_stock() took.  The offlining drain only
> flushes slots with cached pages, so the reference is never released
> unless the slot happens to be displaced by an unrelated charge or
> by CPU hotplug, and the memcg lingers in the dying state - up to
> NR_MEMCG_STOCK (7) of them per CPU under container churn.
> 
> Keeping the slot populated past the last page only saves a
> css_get()/css_put() pair on the next charge of the same memcg, and
> costs more than that: the offlining drain has to know about empty
> slots, and refill_stock() cannot reuse them either, so a charge
> under a different memcg evicts a live batch through the drain_idx
> rotation instead.
> 
> Drop the reference in consume_stock() when the slot empties.
> Empty slots stop existing, so is_memcg_drain_needed() and the drain
> path stay as they are, and refill_stock() reuses emptied slots
> directly.  The cost is one refcount pair per emptied slot, at most
> once per MEMCG_CHARGE_BATCH pages.
> 
> Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
> Signed-off-by: Song Hu <husong@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

