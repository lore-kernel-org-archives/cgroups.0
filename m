From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] mm: memcontrol: use memcg_kmem_enabled in
 count_objcg_event
Date: Mon, 19 Sep 2022 19:27:38 -0700
Message-ID: <YyklGi1KVaOL6d7C@P9FQF9L96D>
References: <20220919180634.45958-1-ryncsn@gmail.com>
 <20220919180634.45958-2-ryncsn@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663640863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eeERVvMe/yZ4WRpFkDFlzsr8+m+omuR9+WcKqeq+40g=;
        b=bk877dvOilqXPR/W2GG9QgSFDJ9hkO2gNM3LKayAg5uyueSbyMhG/o5ByJqgdQJ5D9Rzrn
        DWn1zzfwIgbieK6vuTTp9CrshXf8Ve3oCCt49LtQdIuprua3AncXc3rlU2hSF02RZMQF6N
        aDy7OIouYOiGvqP5COG4nKlU71QdrIs=
Content-Disposition: inline
In-Reply-To: <20220919180634.45958-2-ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Thanks, Kairui!
