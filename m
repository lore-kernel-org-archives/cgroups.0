From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 09/18] mm/memcg: Convert uncharge_page() to
 uncharge_folio()
Date: Thu, 1 Jul 2021 08:15:37 +0100
Message-ID: <YN1rmQLAAJ+PD3Ls@infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-10-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=mW9SyOz/AChaORZcbuh5K65wt+
        /NPWit8FVCVcM/ZsioJsURaVA7Wa3h2tykTk9j8T8XCzL6X8zBD3r5ngp7YlEmA2UlW7wb//U52Uo
        +GQiBRSUvCQRkMMy995wbtivpuIEKm8Zs5P2ZK3+RlEbrhf6gkOGlV0bUuhEDYctdydc8YHAwszYM
        1q7ZmT1lZQhxXThirKX6rKsmDUHrqRF+F4O+FHLZ1uD5gUoE3wsakRXpRiv12ih/otMkx/I3YSBRv
        LEbbl72TWIt9QaNLVa0kR21Xlu1I3OjvH9ahBEJ4VNsC04YjO2jP4DeYpvy3XbASxLQ313hzM47ks
        ow6zKHog==;
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-10-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
