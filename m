Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182074;
	b=rDdvz5HDa3mvnKL2jjBgM+G0j5/LQmW240fL9eJ0QA4wptcTUh6+PaqquVx/QczTh+Y4
	 e09kIhlsoh5fMdM4d9ZmP6+5T7pZU9jj3cb/AhjqQdY0bpeM7R2aUnREb78w478s4SBN9
	 Z1KgTMEV8qU7RDGB8SUI3Ap6QkQZb4O0sFoHcEDpwaFcjX7cfmvzsvb4A2oTbZV7fi63X
	 ovVPXaRBcTbRWPyLMMgowGYwcDKlWEcTfjEty0lgA6km3SdIrvwUWR9BOFMaMla4GEKVx
	 jw4fpsTL11dSOwTe4l9vtm+6rSbpfBSu9JPvex9aleLXPvaE/ZzLZSME71CpTUWu9WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182074;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=FwxNyVQvyR6u1ITlGByMJm+FIMkbiLq8smwLlAPk+KY=;
	b=E1gSkdQTzW5ihd8+Mz0pfg59eOJe1KTbUqoAQNZZo4gbSAZ8Um/ba89Vl1vVJLncBkIf
	 0yelNWQBnebOXe2iDXqj1PFBswIf3n/I7ev2Yd7XSfToxO1Wtq7uwHLDK+x7fP/Xi58fl
	 8/EOJWfDRHqv0DqyD7jjs+Mwxeq9jhlqZCB2hoRdn/WcnLxuty+gpXTgyDYsKKq9M4JhC
	 EWmMoVhQSOIKbLom7QsnPKrM+YZNymulRt0EmcEOtr5Wi61BJsyegyASRyFM0sJpLs4VI
	 /99UEPzGxtRsmAonvBUAEuDv8a0R39ampb8W77CzhK3CSSj7NtAHAkvWMBtmZpFsl3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=UOqy7u37;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E31606A320;
	Fri, 20 Nov 2026 13:41:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2E31606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=UOqy7u37
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FwxNyVQvyR6u1ITlGByMJm+FIMkbiLq8smwLlAPk+KY=; b=UOqy7u37mhnP61kkn7RZKKf6H9
	ZaRrcOD2JPqTkLdVXkZFf7j4ccv0mAxGi6d4e2WZFmka0wbHvdEKRRkB35KpnDNy4RcWF5720e+sy
	6QjfODHYDOwWiXb5CgpNQW1shlCFB71Kw8AVusaWKoUw1w1k4UVKwYuWmoVP2AL4Cb4pHMKrYpLYA
	es9IbEn1MJdQ4UkrL+xJgrF9FR/qlmTXq82cGmIkR1JOOiZyNE+Kdx4aauaHlWFzcp9eoGq9RXFOr
	mht4nuZCmfhBYCmGxJLYGNCLJZbGt1eYE0NApUE3fgoX9sHgUA67S/rDvOzaxbQYNBKZUZdVjAAe4
	mChXJ0dg==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xUOrV-00000005Gv3-3N0b;
	Fri, 20 Nov 2026 13:41:09 +0000
Date: Fri, 20 Nov 2026 13:41:09 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Xavier Xia <xavier.qyxia@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, shakeel.butt@linux.dev,
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
	jack@suse.cz, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: batch per-task lruvec stat updates on the writeback
 path
Message-ID: <awBN9VvV6yM6Cjut@casper.infradead.org>
References: <20261120095559.429515-1-xavier.qyxia@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120095559.429515-1-xavier.qyxia@gmail.com>

On Fri, Nov 20, 2026 at 05:55:58PM +0800, Xavier Xia wrote:
> The writeback path updates two lruvec stats per folio through the memcg
> rstat machinery: NR_FILE_DIRTY when a folio is dirtied and again when
> writeback clears it, and NR_WRITEBACK when writeback starts on it.
> Consecutive folios almost always share a lruvec, so the same counters
> are updated over and over.  On a 4k buffered write + fsync workload
> __mod_memcg_lruvec_state() is about 8% of the profile.

Is this a realistic benchmark?  Does it represent some real life workload,
or did you just choose it because it shows the best benefit of this patch?
This is a fairly significant chunk of extra code, and it'd be nice to
know that it benefits a real-world use-case before applying it.

If the real world usecase is more "there's some pretty high overhead
when flushing accumulated megabytes of dirtied page cache", then there
are simpler solutions that don't involve messing with task_struct.
