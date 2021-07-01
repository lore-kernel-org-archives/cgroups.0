From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 04/18] mm/memcg: Remove soft_limit_tree_node()
Date: Thu, 1 Jul 2021 08:09:09 +0100
Message-ID: <YN1qFcKFNYWvHnM6@infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-5-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=50uiSuVXb7YRWg4xmPpIJvUycemcgynDMzy6r4j5vw0=; b=TgBSC4NNc2oE0SQcaRdVKhuZIj
        p3ITr1LECpUxNWf21zenVH8kh1LlcOTqWL4W8D/Eb/HsjNWaju2z3AaWyt3FS8MlQbavBIkSVlxWR
        AhQCOxMAYWts8he5zs9Q6ulfHRdwj7Y5A9EkJ9BBd9zDsqWNS6dn1ZftYusR9Q91vg6Z9vqUoQGMM
        J47oVTYtOUpuHmr8fAYmcuGKeOOYoQb7U0cRVf2FwawAN4LQvLjuH2sMS8skiihK8+0CumkJkkOSU
        ArplK9Vxo1mhDF8rjS9ojXPLuihLJguFGXsumsk1VK4ccvK3NxMOtA6MvbXKe7aKw0PVO9ogIrLbh
        1kI01A3Q==;
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-5-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jun 30, 2021 at 05:00:20AM +0100, Matthew Wilcox (Oracle) wrote:
> Opencode this one-line function in its three callers.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
