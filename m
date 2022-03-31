From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [Patch v2 2/3] mm/memcg: set pos explicitly for reclaim and
 !reclaim
Date: Thu, 31 Mar 2022 11:03:50 -0400
Message-ID: <YkXC1l27pUjwRDJa@cmpxchg.org>
References: <20220330234719.18340-1-richard.weiyang@gmail.com>
 <20220330234719.18340-3-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d1kYZrmObSeZbyw3RMt9FzoTsF57Tn5L7U9ZzVddVG4=;
        b=e2xD+tga/GoLwXnWljxsycUVzkUHHyFtBZKj9ohJ3DP81/4ckKV/P9xjMrfLtBjaN8
         Y0jQRfJ0wP4mfKhofDqV7PBy2k7vHUHo0TufYPjQRU543RWwSgi458e5LByUAvekjqD6
         6mlrpkeoiYpUpBurMZwQncB+hcsM4fnzgrTSoPR45s5VhDL9WiWRUs9iec9d8NzGqATk
         aigMYifkF1/doRpuLcRVcPWvkVIQZ1qExWkm5fTs3sjVJH30REhh3Q6Qjb0Oi2JXZxPq
         wU1ti7XW3WX2DApr61woyuQxTDHY+thYU3CFYK68PNE2xWO7fIdGDsFTszmbSqBKt/8T
         XEKQ==
Content-Disposition: inline
In-Reply-To: <20220330234719.18340-3-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Mar 30, 2022 at 11:47:18PM +0000, Wei Yang wrote:
> During mem_cgroup_iter, there are two ways to get iteration position:
> reclaim vs non-reclaim mode.
> 
> Let's do it explicitly for reclaim vs non-reclaim mode.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
