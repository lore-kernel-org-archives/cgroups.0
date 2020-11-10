From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcg/slab: Fix root memcg vmstats
Date: Tue, 10 Nov 2020 10:23:05 -0500
Message-ID: <20201110152305.GB842337@cmpxchg.org>
References: <20201110031015.15715-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4K7M+yU2qQGJnBqVAjylDdUBTFCEnQjaCz6moXfYMEE=;
        b=on8OoPlw3VSXy8JNQfuM/sHMVZ8emLX5MZJzG0sTRRpgjWF3aRCwxgJSI9FEVC44qS
         4kQmG920BaTWRgy9W2+iS2syx5dG8Yg/RXtBHWoo/nKw12Ik/Ir0l7CSBjpeXHec2dph
         lNTHcg4fv8MpCEcu4c1MPc5PltE4KD+y6Lh3c2Wbsrd3pxKmW1K3nSqPVTtn/9yghgNO
         pM8A1l0COcK6/hiUfry60njJLbjv+PNmAhrx5oDAM/Um3Rwv00auj9hEJ+rr8/0YIKVG
         vTQ4g4GT+ArZWI37EDyK9bWNccjv5MrIbne6986cr4gqOKWA46X7OiN7nEmlRpHxIGJJ
         yFIQ==
Content-Disposition: inline
In-Reply-To: <20201110031015.15715-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Nov 10, 2020 at 11:10:15AM +0800, Muchun Song wrote:
> If we reparent the slab objects to the root memcg, when we free
> the slab object, we need to update the per-memcg vmstats to keep
> it correct for the root memcg. Now this at least affects the vmstat
> of NR_KERNEL_STACK_KB for !CONFIG_VMAP_STACK when the thread stack
> size is smaller than the PAGE_SIZE.
> 
> Fixes: ec9f02384f60 ("mm: workingset: fix vmstat counters for shadow nodes")
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
