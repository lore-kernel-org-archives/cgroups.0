From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 01/18] mm: Add folio_nid()
Date: Thu, 1 Jul 2021 07:56:22 +0100
Message-ID: <YN1nFlmsBe0d10nX@infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-2-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=AgYv3eVv0xvsLDo0HnmAr3kYRe
        l0WMswRmdCB1AuL9DPWQ42bnc0vdylSbP0rYvlA6GhuF64OTAacVA9qh0Kav/P9Y8yCw8m5UjvQPW
        L1oFEYscb7roSY8GdSTm29ktTnFIPeRtB83l6WgIIHraMOX9MfhB6u+PeQRLshnfqTFctjLtTUJPw
        ROh/SQFtX/pg6kLYJMG0ESvdEMdvwL/3+t3ivtG6A5cMRKxsjbzJ7v6bmvIjM8JYMrODh430qK3Ck
        6AlphtOVKCF6evmOovPOc4A/1ZLlBWfRlplYw8Qyr5xMVwLHRtlF4OHDVgwoKAaXgAXiPyfbHYpys
        46BAXDMw==;
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-2-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
