From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 03/18] mm/memcg: Use the node id in
 mem_cgroup_update_tree()
Date: Thu, 1 Jul 2021 07:57:43 +0100
Message-ID: <YN1nZ2O86Qa9DOk2@infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-4-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BSVgnYAxe2R8PoaegIcaOoM7XZhNbeX1pTTSxEBVoac=; b=t2TBq0380ll/0c0dnlNJtyZH4Q
        pZ3uqtk2mYqILxxYvHtGcznBcCHp0665VeItnTBAzfFHNF3MBv7Fbg6qF+X0RZJGPqitmulCAESR8
        +yUfMbKqkpwCHAT+t5yQJ764GhUa5eoV2iO2rybbGnSK4BAEQOnfJOxKpoewRHjXSqbOZ7A30wLzb
        VK2FDWW602qB1Pnp7QK6g/y7oJd18Dj9OgPOUDt2VvOoCqFrbK3sYJg3wGpmotD5Em8lCMvht0Axu
        LQlBP8UbAZPT5raIsKeXxztu6i8DFuVQWh6y1F6TL4T475qRkSW0oCA5c9XTVG+JHdpVNsySgfvCw
        Uu9os80Q==;
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-4-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jun 30, 2021 at 05:00:19AM +0100, Matthew Wilcox (Oracle) wrote:
> By using the node id in mem_cgroup_update_tree(), we can delete
> soft_limit_tree_from_page() and mem_cgroup_page_nodeinfo().  Saves 42
> bytes of kernel text on my config.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
