Received: from mta0.migadu.com (out-245.mta0.migadu.com [91.218.175.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99103A453A
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 23:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788823312; cv=none; b=PlWXbCrQ58zOW8hf8jMS71Yd2sxUaSa0ReJAfGT4/62Fl3kpZ7kTACFNuqtlgcafrJH0q7LOC5vzwicnjBrVXp3Fqzak4xTPCsLhXUCRI36mvz3JlQSewoInufXevA1qvlckldVI3V1y82INwBpi/JybUJsPzrsY2c1a9JQOHZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788823312; c=relaxed/simple;
	bh=dXcyzj0cv0sTbjRRKi4cwX3Cv6d/R9jjW33EzUucGLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=an7xrIijpgCCoOpFVXpOWlhwndRvEKyQAmrqTdnT7yQeYPny7mXFLhSFHSI4xMG9JarZSUR4rW+UwCqeLDgfInsOebiqeqTiIsqdFHMt4cp0Hoc2Fly0WhIa8WbVsc7xy1JkOC5CPTYHOV5dXspsdchPWNBZvu/ao+Gv+6yrSpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y/rhkCAh; arc=none smtp.client-ip=91.218.175.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y/rhkCAh"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dXcyzj0cv0sTbjRRKi4cwX3Cv6d/R9jjW33EzUucGLY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788823308; v=1; x=1789428108;
 b=Y/rhkCAhBv76xCHNrIdIxvdCtXjAHHV0qQLPjk3jZO1BCcRA601TjKHJK0jSu0wIUwF1px1d
 6NdTKUM9XbUEFI6OMZ9NzKXfARw6wWPiEcKUFOnt34MEejgi7AfJ+1g8HlstzxBHbkR08sHMANP
 nyEXFAUwcfJgNwJGTJblv+mo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dc786c64e4031727;
	Mon, 07 Sep 2026 23:21:38 +0000
X-Mizu-Trace-ID: dc786c64e4031727
X-Migadu-Flow: FLOW_OUT
Date: Mon, 7 Sep 2026 16:21:33 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	dev@lankhorst.se, mripard@kernel.org, nat@pixelcluster.dev, tj@kernel.org, 
	mkoutny@suse.com, osalvador@suse.de, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, kernel-team@meta.com
Subject: Re: [PATCH v5 4/7] mm/page_counter: use stock in
 page_counter_try_charge
Message-ID: <ap86vDv143VHvrzh@linux.dev>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
 <20260831163752.2193337-5-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831163752.2193337-5-joshua.hahnjy@gmail.com>

On Mon, Aug 31, 2026 at 09:37:48AM -0700, Joshua Hahn wrote:
> Transparently make page_counter_try_charge attempt to service the charge
> from its stock. We preserve the same semantics as the existing stock
> management in try_charge_memcg:
> 
> 1. Limit-check against the stock. If there is enough, then skip the
>    hierarchy walk and charge to the stock.
> 2. Greedily attempt to fulfill the charge request and refill the stock
>    simultaneously to the hierarchy.
> 3. If this fails, retry the stock and charge without trying to refill
>    the stock, i.e. with the number of pages requested.
> 4. If the greedy attempt succeeds, return excess pages to the stock.
> 
> page_counter_refill_stock() falls back to a hierarchical uncharge when
> there is no stock, in NMI contexts, on lock contention, or for a refill
> larger than the batch.
> 
> The greedy charge is also skipped in NMI where both stock helpers bail
> out since the batch charge would be undone again.
> 
> No functional change intended, since no page_counter enables stock yet
> and counter->batch is left at 0.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  include/linux/page_counter.h |   2 +
>  mm/page_counter.c            | 135 +++++++++++++++++++++++++++++++----
>  2 files changed, 125 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> index c1fe331f34e7e..428ca8e7b2da5 100644
> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
> @@ -82,6 +82,8 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
>  
>  void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
>  void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
> +unsigned long page_counter_refill_stock(struct page_counter *counter,
> +					unsigned long overage);
>  bool page_counter_try_charge(struct page_counter *counter,
>  			     unsigned long nr_pages, struct page_counter **fail,
>  			     unsigned long *nr_charged);
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index 3f61eba695518..a76949abf04e7 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -113,25 +113,126 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
>  	}
>  }
>  
> +static bool page_counter_consume_stock(struct page_counter *counter,
> +				       unsigned long nr_pages)
> +{
> +	struct page_counter_stock __percpu *stock = READ_ONCE(counter->stock);
> +	struct page_counter_stock *pcp_stock;
> +	unsigned long flags;
> +	bool charged = false;
> +
> +	if (!stock || nr_pages > counter->batch)
> +		return false;
> +
> +	/* raw_spin_trylock isn't enough to protect against nested NMI in UP */

I don't understand what this comment is trying to say. The nested NMI is
confusing.

> +	if (in_nmi())
> +		return false;

You are completely disabling stocks for memcg charges in nmi context. Why? I
assume that is what the comment above trying to explain but it is failing.

IIUC you want to use spin_lock instead of local_trylock because you want to
support draining from remote cpus and spin_lock on UP are simply disable irq and
does not protect from NMI. Maybe you need spin_trylock similar to local_trylock.
Not saying you to implement that but please explain stuff clearly.

> +
> +	/* It's OK to migrate here, since stock is fungible within a counter. */
> +	pcp_stock = raw_cpu_ptr(stock);

migrate between cpus? Why? What are you gaining by allowing that?

> +
> +	if (!raw_spin_trylock_irqsave(&pcp_stock->lock, flags))

Why do you need to disable irqs?

Anyways, you are changing the fast path of the charge drastically. Previously
there was no atomic ops and not irq toggling but this patch is adding atomic op
and irq toggle (not sure about why irq toggle is needed) on the fast path.

I understand that remote draining is the only reason you need to use spin locks
here otherwise you will need to allocate work_struct in page_counter_stock. You
are making these design decisions very silently and implicitly.

How about we decouple the decision of remote drain / spin lock from moving stock
inside page counter? First move the stock to page counter without any spin lock
or remote drain and later in the series you convert to spin lock plus remote
draining with performance numbers.

