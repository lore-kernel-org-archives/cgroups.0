Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9239A258EE9
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 16:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787242033; cv=none; b=fPCtBwFKr2rCZ4rTKpT5QpUJOahypUr4rZPaVQLhog5KvRqj4FaKuKn4m4CJjKgPPvIzE4rwJKWCvmmwwrTZbAhVvVuZFXy4mkakiVDv6Dlxkw4sY5YojXPs8HKTgo5Z7DZ72baNb8HVU4C0kF0BkYVD9+Y5bFdGEiHjG3qNtns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787242033; c=relaxed/simple;
	bh=53SX5U3+Y6dAV0m87LKeZ/fGFLwXadUJZBiDVWK3OgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FXg+81OkW+ePs/0vtzfSVR6yrvUrJ8Kw1ttSdZA2b60/Kn/BRxHzam1AK69bFc8yVY8IW7ubvwcsyBdbWx+0ker2ygQBEuzqiU6CSjHdxwB9AXrVEOrm0fjr0SKVL99B82bkcDdLIuoi83MwnwAM40kpybPdhhdonmBveMh8DLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ra+bP7as; arc=none smtp.client-ip=91.218.175.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ra+bP7as"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=53SX5U3+Y6dAV0m87LKeZ/fGFLwXadUJZBiDVWK3OgM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787242028; v=1; x=1787846828;
 b=Ra+bP7asCWP20VQgz/Hix3jyJvZhFyxqa7UZWmUcPCjMUU0tfxsYX3UKO18l/Y2VNxKKmVyx
 0qArScNVxZ+q/egYWdmmQ2S/TA8CS660R0jgum6l0sTeneyi9vSxvvYd2Ulbcg/n7No6bU+bVwD
 C79dA5O7Rk5Fq8fSoMG2kn4A=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:5::)
	by smtp.migadu.com with ESMTPS id e4605afa8f177308;
	Thu, 20 Aug 2026 16:06:30 +0000
X-Mizu-Trace-ID: e4605afa8f177308
X-Migadu-Flow: FLOW_OUT
Date: Thu, 20 Aug 2026 09:06:29 -0700
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
Message-ID: <aoclMssJAyYw2aCn@linux.dev>
References: <20260820012010.2016086-1-shakeel.butt@linux.dev>
 <aoanalsTiGmL69LN@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoanalsTiGmL69LN@tiehlicka>

On Thu, Aug 20, 2026 at 09:06:18AM +0200, Michal Hocko wrote:
> On Wed 19-08-26 18:20:10, Shakeel Butt wrote:
> > Joy reported that an application generating a request/response traffic
> > pattern spends 44.6% to 57.0% of CPU in the memcg charge/uncharge path
> > for a range of message sizes, against 0.27% to 0.71% outside that range.
> > Running from the root memcg, where socket memory accounting is skipped,
> > recovers the performance.
> > 
> > Tracing the charge path showed that the application generates a pattern
> > where the write syscall charges one page and the read syscall uncharges
> > two pages on the same CPU. This hits a corner case in the memcg percpu
> > stock code that thrashes the stock continuously.
> > 
> > In the memcg percpu stock code, MEMCG_CHARGE_BATCH (64) is both the high
> > watermark and the emptying target, i.e. on a request to charge one page
> > the kernel charges MEMCG_CHARGE_BATCH pages and caches
> > (MEMCG_CHARGE_BATCH - 1) of them in the percpu stock. The following
> > uncharge of 2 pages takes the cached count to (MEMCG_CHARGE_BATCH + 1),
> > and refill_stock() then empties the cache completely. With such a
> > pattern the percpu stock becomes completely ineffective.
> > 
> > Instead of a single boundary point for charges, use the technique the
> > page allocator uses for its own percpu caches, which keeps the watermark
> > and the emptying target apart: nr_pcp_free() frees between batch and
> > high - batch pages, leaving at least pcp->batch on the list. Add a high
> > watermark MEMCG_STOCK_HIGH and, once the cached count goes over it,
> > return only the pages above MEMCG_STOCK_LOW. The watermarks are
> > MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a full
> > batch.
> > 
> > For now, keep MEMCG_STOCK_HIGH same as MEMCG_CHARGE_BATCH and in
> > future we will reevaluate if it makes sense to increase it.
> > 
> > Reported-by: Joy Chaoyue Xiong <cxiong@meta.com>
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks.

> One minor nit
> 
> > ---
> > 
> > Changes since v1:
> > http://lore.kernel.org/20260817234651.666540-1-shakeel.butt@linux.dev
> > - Kept the upper limit of memcg stock same as before (Michal)
> > 
> >  mm/memcontrol.c | 25 +++++++++++++++++++------
> >  1 file changed, 19 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 17da1f43b7d3..58e4d23cf5e0 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> [...]
> > @@ -2254,9 +2264,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> >  			empty_slot = i;
> >  		if (memcg == READ_ONCE(stock->cached[i])) {
> >  			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
> > +			if (stock_pages > MEMCG_STOCK_HIGH) {
> > +				memcg_uncharge(memcg,
> > +					       stock_pages - MEMCG_STOCK_LOW);
> > +				stock_pages = MEMCG_STOCK_LOW;
> 
> I would find it easier to read to keep the update in sync with
> memcg_uncharge, i.e.
> 				stock_pages = WRITE_ONCE(stock_pages - MEMCG_STOCK_LOW)

Sorry I am not sure I understand your suggestion. The WRITE_ONCE() is throwing
me off.

> > +			}
> >  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> > -			if (stock_pages > MEMCG_CHARGE_BATCH)
> > -				drain_stock(stock, i);
> >  			success = true;
> >  			break;
> >  		}
> > -- 
> > 2.53.0-Meta
> 
> -- 
> Michal Hocko
> SUSE Labs
