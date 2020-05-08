From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/3] mm: swap: fix vmstats for huge pages
Date: Fri, 8 May 2020 17:52:28 -0400
Message-ID: <20200508215228.GC226164@cmpxchg.org>
References: <20200508212215.181307-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/Bg23MpwaLt5ES1Q90+CSXO9u0G+8VEy9TthqACk8pE=;
        b=1rm4qMVbcyKhgRbqDol38rBrkbyaZbxpfkXsQfwESaWUofm9FQVmK/wxaUfeIUZygo
         HsGYt09Ll+D1Q0/NDvGuVng7N+gAh0575gb8z6n8u+dxMoQHoC1vfOYVhf68hgZoLvhb
         LvTWV94B9ObgkjWuVKW+yxNPICHdMTrcOc92uPtwZpCy5PSiU0iklgWmIEx1+ny+Lmdp
         r8n9oZQHT856fp9eRfvxZU5UPwlEyFophlObXiv3bFFtElwVs1Cw9q3D149s40LMK8a/
         ZWmePp2TvUuF/ICL2KJQ7+1+jY2pq+wlkDiMsN/8bp0c8W/1W2ZxCweHg7a/K6x7WB9D
         NnLg==
Content-Disposition: inline
In-Reply-To: <20200508212215.181307-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 08, 2020 at 02:22:13PM -0700, Shakeel Butt wrote:
> Many of the callbacks called by pagevec_lru_move_fn() do not correctly
> update the vmstats for huge pages. Fix that. Also __pagevec_lru_add_fn()
> use the irq-unsafe alternative to update the stat as the irqs are
> already disabled.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
