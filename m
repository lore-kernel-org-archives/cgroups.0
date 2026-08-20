Received: from mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC514212F89
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 20:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787259049; cv=none; b=a9XjydgNjlLC+SDSISgygB8aMcz6hdHyyUoK8IOFcolNTrPv9v8quh6QWd8u3euuxE0I926wgcRcUf0E6skvr9HD8Img/hkgWBCMDjjILQLpO6oQBCfckxT7oQPJcng+PufTNy2bdSNjYxxbwoz06jMiRKi6SYvTaBN6P1AXiiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787259049; c=relaxed/simple;
	bh=bgao8UUlLwR3L2Hf0JMzgYCzD6M4KAHzBdfc4Ha5bi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N4aBtEO/VZxBLTwFEyJ8vFZ8n/q8VMdxlboBb2F71X/H5MCoANzMW/VnOtHwMGpvJ1BE9JBnnaa8uvx8RjQ7532aWc4vivuoNLSLPb/vrjmdV5V5fEACSmlKOy76jk8cYgIEiGKO/f3sRuwJPUnkoUuoNmJAHY6GTQDXgxrC1JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JzHmwZBI; arc=none smtp.client-ip=95.215.58.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JzHmwZBI"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=bgao8UUlLwR3L2Hf0JMzgYCzD6M4KAHzBdfc4Ha5bi4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787259043; v=1; x=1787863843;
 b=JzHmwZBIj+Um868gpWn8rpP9UNELl5zx/TekvBNIa5f6jEmz68v9yHiiH1OC9N5qFCvz3vJR
 oWIb+XHKiNs2qpXNhVa52GTt+YUzBmX1bcotfTRHkoj68CkvgD9suaCucPVGKiFX2ZfizK6svZ9
 VZ3NC2tNqkcQLuGzpJVcm9lY=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:11::)
	by smtp.migadu.com with ESMTPS id b2b6769d35497dae;
	Thu, 20 Aug 2026 20:50:33 +0000
X-Mizu-Trace-ID: b2b6769d35497dae
X-Migadu-Flow: FLOW_OUT
Date: Thu, 20 Aug 2026 13:50:32 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Joy Chaoyue Xiong <cxiong@meta.com>
Subject: Re: [PATCH v2] memcg: trim the per-cpu charge stock instead of
 draining it
Message-ID: <aodk640QxaSa0gVK@linux.dev>
References: <20260820012010.2016086-1-shakeel.butt@linux.dev>
 <aoanalsTiGmL69LN@tiehlicka>
 <aoclMssJAyYw2aCn@linux.dev>
 <aodLEmCg76oRHY2j@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aodLEmCg76oRHY2j@tiehlicka>

On Thu, Aug 20, 2026 at 08:44:34PM +0200, Michal Hocko wrote:
> On Thu 20-08-26 09:06:29, Shakeel Butt wrote:
> > On Thu, Aug 20, 2026 at 09:06:18AM +0200, Michal Hocko wrote:
> > > On Wed 19-08-26 18:20:10, Shakeel Butt wrote:
> > > > @@ -2254,9 +2264,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> > > >  			empty_slot = i;
> > > >  		if (memcg == READ_ONCE(stock->cached[i])) {
> > > >  			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
> > > > +			if (stock_pages > MEMCG_STOCK_HIGH) {
> > > > +				memcg_uncharge(memcg,
> > > > +					       stock_pages - MEMCG_STOCK_LOW);
> > > > +				stock_pages = MEMCG_STOCK_LOW;
> > > 
> > > I would find it easier to read to keep the update in sync with
> > > memcg_uncharge, i.e.
> > > 				stock_pages = WRITE_ONCE(stock_pages - MEMCG_STOCK_LOW)
> > 
> > Sorry I am not sure I understand your suggestion. The WRITE_ONCE() is throwing
> > me off.
> 
> Sorry, brainfarth on my end. I meant to say that stock_pages should be
> updated by the uncharged decrement rather than capping it at MEMCG_STOCK_LOW.
> So in fact I meant this
> 				stock_pages = stock_pages - MEMCG_STOCK_LOW;
> but then shortcuted it to a nonsense.

To fully understand your suggestion, let me walkthrough the code:

Let's suppose stock_pages = 65

	// Original code does
	memcg_uncharge(memcg, stock_pages-MEMCG_STOCK_LOW); // uncharge 33 pages
	stock_pages = MEMCG_STOCK_LOW;			    // stock 32 pages

-----
	// You want instead
	memcg_uncharge(memcg, MEMCG_STOCK_LOW); 	// uncharge 32 pages
	stock_pages = stock_pages-MEMCG_STOCK_LOW	// stock 33 pages
	

Am I understanding you correctly?
