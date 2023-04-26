From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: dump memory.stat during cgroup OOM for v1
Date: Wed, 26 Apr 2023 17:27:19 +0200
Message-ID: <ZElC127xlU2NtlqF@dhcp22.suse.cz>
References: <20230426133919.1342942-1-yosryahmed@google.com>
 <20230426133919.1342942-3-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1682522839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PxTXn2BTS1MgLfa6uUxx1IJIGot7tRzMX6mJKeRAOU0=;
        b=QDiaNXkKB3uTdY6B9oH8hNNCSYV+uqkT4a1892oDrK572lszPhfddPLLMre1CgTN3Dsf5G
        ScrUsE1jjfCCS9RdneK3ReDxQPcYS0UeDH/7UrhHe7/jwYuQBWILAIQmwaaDfjMZvTqx/I
        Ekl+fSwPwceAjY3EN+9UF9Yv5eHU6lw=
Content-Disposition: inline
In-Reply-To: <20230426133919.1342942-3-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 26-04-23 13:39:19, Yosry Ahmed wrote:
> Commit c8713d0b2312 ("mm: memcontrol: dump memory.stat during cgroup
> OOM") made sure we dump all the stats in memory.stat during a cgroup
> OOM, but it also introduced a slight behavioral change. The code used to
> print the non-hierarchical v1 cgroup stats for the entire cgroup
> subtree, not it only prints the v2 cgroup stats for the cgroup under
> OOM.
> 
> Although v2 stats are a superset of v1 stats, some of them have
> different naming. We also lost the non-hierarchical stats for the cgroup
> under OOM in v1.

Why is that a problem worth solving? It would be also nice to add an
example of the oom report before and after the patch.
-- 
Michal Hocko
SUSE Labs
