From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v5 07/11] mm: memcontrol: make all the callers of
 {folio,page}_memcg() safe
Date: Sun, 19 Jun 2022 12:37:32 -0700
Message-ID: <Yq96/NEanbbUUUIW@castle>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530074919.46352-8-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655667458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YC8yB2PG4+G4xynDd4qhQyEPOAofxKVrbu3RRitWED4=;
        b=qD+Mvbj8IaI6qDNJWPeluOnJwp3jOJoDFAlyYvn3hpSvpPHCy2u9O7pXCmd/wKVQaa191Z
        BL+H+G8SckXSSX4/zrN40egc6e0GXplsUqbnw5+JYBugq02IQYc5TAljDysQhZNjUYe+lb
        /lPOYR+3IUzs8PTIkjMG8AUO96ECJrU=
Content-Disposition: inline
In-Reply-To: <20220530074919.46352-8-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Mon, May 30, 2022 at 03:49:15PM +0800, Muchun Song wrote:
> When we use objcg APIs to charge the LRU pages, the page will not hold
> a reference to the memcg associated with the page. So the caller of the
> {folio,page}_memcg() should hold an rcu read lock or obtain a reference
> to the memcg associated with the page to protect memcg from being
> released. So introduce get_mem_cgroup_from_{page,folio}() to obtain a
> reference to the memory cgroup associated with the page.
> 
> In this patch, make all the callers hold an rcu read lock or obtain a
> reference to the memcg to protect memcg from being released when the LRU
> pages reparented.
> 
> We do not need to adjust the callers of {folio,page}_memcg() during
> the whole process of mem_cgroup_move_task(). Because the cgroup migration
> and memory cgroup offlining are serialized by @cgroup_mutex. In this
> routine, the LRU pages cannot be reparented to its parent memory cgroup.
> So {folio,page}_memcg() is stable and cannot be released.
> 
> This is a preparation for reparenting the LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

The locking seems to be correct. I'm slightly worried about a potential
perf degradation, especially on dying cgroups, where css_get() is relatively
expensive. I hope getting it into mm-unstable will help to determine
whether it's actually a problem.

Thanks!
