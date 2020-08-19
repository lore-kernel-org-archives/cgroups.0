From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/5] mm: Identify compound pages sooner in
 isolate_migratepages_block
Date: Wed, 19 Aug 2020 12:43:09 +0100
Message-ID: <20200819114309.GB17456@casper.infradead.org>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
 <20200819042705.23414.84098.stgit@localhost.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ak4zJfL3jaSZH9A144fE0Ks6867bEAtu2NTkcDH4RvU=; b=RXOzKbrxZsfW3t1Wc6xtkyc7lT
        I+02t0IG7W47hbjx6qsg4QiL6EcBfdWn2aBpC7gmY52ux5erb1OYdpDwQu58mJ9ZG4hmTgVFgDIMb
        CKVgKq/EMapYfJeCEq7+sPv9fSjNFOr1z7bYFj6ovfyc3jt7+Gpy0dV/1c6OSRwXnmYUu9ayo7G9H
        acNNDxZjmcEBy/nqgab4XdpN5SnxJPNEca2H4ALpDZ/QhF6XGF/hKvoViSs2EYF4g1sUHQMErIgKf
        EqDgis9otkTiDaVkk0eQYqWc/Bxf9X8D3dXkNa/TV+XSz6A0hxRiY7AUM3ESI0ctl2xdYmsUfjk+Y
        R2hAdK3Q==;
Content-Disposition: inline
In-Reply-To: <20200819042705.23414.84098.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org

On Tue, Aug 18, 2020 at 09:27:05PM -0700, Alexander Duyck wrote:
> +		/*
> +		 * Page is compound. We know the order before we know if it is
> +		 * on the LRU so we cannot assume it is THP. However since the
> +		 * page will have the LRU validated shortly we can use the value
> +		 * to skip over this page for now or validate the LRU is set and
> +		 * then isolate the entire compound page if we are isolating to
> +		 * generate a CMA page.
> +		 */
> +		if (PageCompound(page)) {
> +			const unsigned int order = compound_order(page);
> +
> +			if (likely(order < MAX_ORDER))
> +				low_pfn += (1UL << order) - 1;

Hmm.  You're checking for PageCompound but then skipping 1UL << order.
That only works if PageHead.  If instead this is PageCompound because
it's PageTail, you need to do something like:

				low_pfn |= (1UL << order) - 1;

which will move you to the end of the page you're in the middle of.

If PageTail can't actually happen here, then it's better to check for
PageHead explicitly and WARN_ON if you get a PageTail (eg a page was
combined into a compound page after you processed the earlier head page).

Is it possible the page you've found is hugetlbfs?  Those can have orders
larger than MAX_ORDER.
