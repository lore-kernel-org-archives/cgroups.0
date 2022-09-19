From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] mm: memcontrol: use memcg_kmem_enabled in count_objcg_event
Date: Mon, 19 Sep 2022 21:36:22 +0000
Message-ID: <20220919213622.s3w2v2q7ktvbrpha@google.com>
References: <20220919180634.45958-1-ryncsn@gmail.com> <20220919180634.45958-2-ryncsn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=gBPDRnXdyvF4xAXr245jZgfFcKRBxlvo8nsBRpPChFM=;
        b=pBQdFlYTW5SMJZLEMS2PIeY/jXnxQHmBdVPB0G13hsQ/jjd473V1RsISyxaNwQYjyP
         yH1LP0v5pq5LDRQLhpdkRO31sgmsuTaBoWRWpfl3oJObc2DyxrjOIJQRM78202UbhSDs
         I3YXeiX+4M9mVmC/jNaFEUhrogAJuDu88LJDMqkZifaAjpi+hYvR1xpnjM+HACqJ94bB
         LajxRGIq9aCsw8DTPeTOjXxhSvXNlH3t+YvGLSTEWAQ4/W3reGAiQWXWsg7YBT9/1i1f
         x7kIHKYQ/xdvouPjm2aKVRXkjRJtsiVBtIUblxJ9idoqr+i9hG1fedynPAQfkv10QNB9
         TPhQ==
In-Reply-To: <20220919180634.45958-2-ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 20, 2022 at 02:06:33AM +0800, Kairui Song wrote:
> From: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> 
> There are currently two helpers for checking if cgroup kmem
> accounting is enabled:
> 
> - mem_cgroup_kmem_disabled
> - memcg_kmem_enabled
> 
> mem_cgroup_kmem_disabled is a simple helper that returns true
> if cgroup.memory=nokmem is specified, otherwise returns false.
> 
> memcg_kmem_enabled is a bit different, it returns true if
> cgroup.memory=nokmem is not specified and there was at least one
> non-root memory control enabled cgroup ever created. This help improve
> performance when kmem accounting was not actually activated. And it's
> optimized with static branch.
> 
> The usage of mem_cgroup_kmem_disabled is for sub-systems that need to
> preallocate data for kmem accounting since they could be initialized
> before kmem accounting is activated. But count_objcg_event doesn't
> need that, so using memcg_kmem_enabled is better here.
> 
> Signed-off-by: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
