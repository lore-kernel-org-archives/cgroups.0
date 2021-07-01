From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 08/18] mm/memcg: Convert mem_cgroup_charge() to take a
 folio
Date: Thu, 1 Jul 2021 08:13:41 +0100
Message-ID: <YN1rJSfL4XTu8G9e@infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-9-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=kfGWG7hzfK/7CWSfeCOfHhOX5l
        2z2Pkj/A2GB1yLOl+LikHofKAxneM6iOkd+7kuc3BXeUA0Dk61NhnmqoVBNbVeQJbXn4gvFdQplS2
        y0iBZ/3qPA4Q8/76B0Ntm0yL8iRJrOGY1EjoHPZ39s5JwqpKDu1zZB9NUGqaizzK5DRvKSShFv5T0
        JUPsn+fV1km3Ls2/COtkP4Nir2G7VZDrlVc63qUu3D4sPHGo3MDAm5yOr6aBHHP1ZxunfmVjZSLnO
        sc1ttjnsFSkm1begW8vsnvskdTniEK8gs69rCXUaua/s4dyLEwA55wxkeGbA5QSOzo7mrBI0qg/wM
        3IufDI4g==;
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-9-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
