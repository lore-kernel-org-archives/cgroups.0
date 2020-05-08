From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/3] mm: swap: memcg: fix memcg stats for huge pages
Date: Fri, 8 May 2020 17:56:16 -0400
Message-ID: <20200508215616.GD226164@cmpxchg.org>
References: <20200508212215.181307-1-shakeelb@google.com>
 <20200508212215.181307-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8zne5kD9U815Qp7lQoOfSkfWPnKdq4UH7l4ACZ1laQI=;
        b=rVWxHIzDFvif9rrgKfKEzuzUqpug84jgH+pn6g2K+if7ys4WCpoBTPfsO3vQPvKAhN
         yVfFa2Lp+fBa+5PTkzDejJhE9e4mKzNB4oFie8Fb4O99NmTGN8QvA+xTxmSSZnk3ibBc
         HY2i6VFZUdjANcY0MDN1d4b9v0m8v8op+VhiOv7vwRUaW0FVadyL0QI7pMaOVKtzkkDK
         eICt41IJctDdTY3MUPL17fid7XHKjjKefy0raEReMlnpRuJoXM9b+XyKVFxobwnSPF9F
         Mh/uSrnjUReBhhaHgRTzE7vs/YNfmZ2ip7aKqPqWJrOr4nWGMCvhk2K4BK7cIVcztiM7
         Ocsw==
Content-Disposition: inline
In-Reply-To: <20200508212215.181307-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 08, 2020 at 02:22:14PM -0700, Shakeel Butt wrote:
> The commit 2262185c5b28 ("mm: per-cgroup memory reclaim stats") added
> PGLAZYFREE, PGACTIVATE & PGDEACTIVATE stats for cgroups but missed
> couple of places and PGLAZYFREE missed huge page handling. Fix that.
> Also for PGLAZYFREE use the irq-unsafe function to update as the irq is
> already disabled.
> 
> Fixes: 2262185c5b28 ("mm: per-cgroup memory reclaim stats")
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
