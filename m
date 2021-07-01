From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 05/18] mm/memcg: Convert memcg_check_events to take a
 node ID
Date: Thu, 1 Jul 2021 08:09:55 +0100
Message-ID: <YN1qQwZR22WySwNw@infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-6-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=vDKJb0soHg96ca/OPz+A7fZLgE
        6i2oBe6Kh+/yew0wOCBwMZ9YoCHqI0T2cNL9qgiAB7kQdNj3mVsqeqLJ3uNSN3eDEsrncbl7DD3lN
        wZgL2xZMkJGH2Aljwdxm6RqhYZspZyPjk0LYEA9KsJFM5hbxZD/OK+22KVzU6Qfbshhs7i17l6sHc
        Fb/HAT6OWkn2/2dQ0hS0kL77MpmzpCpK6ztmOicc4JTZ8iM7Z5xRFph56ajpclXsmEWbEisk7lYeh
        6Im8xxW2gGh3PttTUBPIFqNYafCBpT75khb0nLX5KfWFCc3fn3aD9Dt0WFNMGJH8Ub7IaRzy+fvuj
        kmNLcvgA==;
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-6-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
