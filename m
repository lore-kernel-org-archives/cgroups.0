From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 11/18] mm/memcg: Convert mem_cgroup_migrate() to take
 folios
Date: Thu, 1 Jul 2021 08:20:05 +0100
Message-ID: <YN1spXpTskTdLE6y@infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-12-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2/0xo8Pb2WVfKAJOsLbHqk9I4cw9p84KsjkT2rmHhdw=; b=R5AkJKPBcNT43NaRbYf0jqvU9m
        1pT10ur4pPswKyKqwkn4ubcJ6ym1IujcGo++cl9hANZrzu/0kfr1cJC3qlxj4vcGvunviq5sh9RfU
        7F2v5vSWuNYNhuZ5CzgA79cl02CXH3yWJgdqbEiuv4QEeBg/G4JBz2KUB2AcGLn80qFQdV8/q9cfK
        UWt0qxe4Zo/EcNo1nBVbW2yipSoNKfv4NSuTidnNnfrFNVMAQgCsr6TaXtxAYtyDVrBOKGOTioIZP
        DcnElL1R7AuMpLIAiZx7jKVtoVPqn1E0H9/cJdIlEGjLcwuA95HYTgnczT9m2f9sXUY1NEtnTL8Ro
        15HVzzAA==;
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-12-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jun 30, 2021 at 05:00:27AM +0100, Matthew Wilcox (Oracle) wrote:
> Convert all callers of mem_cgroup_migrate() to call page_folio() first.

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
