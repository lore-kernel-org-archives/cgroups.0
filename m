From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 7/7] mm: memcontrol: consolidate lruvec stat flushing
Date: Fri, 5 Feb 2021 12:10:28 -0500
Message-ID: <YB18BF8b41RPra5b@cmpxchg.org>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-8-hannes@cmpxchg.org>
 <YB1hhwVybr0x5M2j@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JSYiUbx9lBanOq4tbekqTAf5PAtDklDUpjXB1f72Qrc=;
        b=tM/dZEUeDe1AgSL5LylGwYfRT5+levhjDv8vOBR8fUAbDaWMIznPnPLamaZYjY3wzT
         g+cjA6pD7ZjdrM2mng9Mhako+BFslrJzcTyReIW3h3o2QgGnwwDoKQzvWVUktPepuyYF
         AQpeiGmjpMs3K7CIzmD/iIjPrJfmglw9FOMLa8DMpRqKtFq4n+aJwjjtM6lqRBeHo15z
         kMc5x+Y/a9DnW6WdEzSjR2PJZoQSYrOzjK7pChRoltFN0rOJYBKH6WVkXPnWme2gn3k3
         YwP8eOjnLw8SSf+taDiSenMwKUeZDxhJoWi9lzmTgxWYD8kMQD8Zdwho7ZOxqfsluBcS
         VKTQ==
Content-Disposition: inline
In-Reply-To: <YB1hhwVybr0x5M2j-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Feb 05, 2021 at 04:17:27PM +0100, Michal Hocko wrote:
> On Tue 02-02-21 13:47:46, Johannes Weiner wrote:
> > There are two functions to flush the per-cpu data of an lruvec into
> > the rest of the cgroup tree: when the cgroup is being freed, and when
> > a CPU disappears during hotplug. The difference is whether all CPUs or
> > just one is being collected, but the rest of the flushing code is the
> > same. Merge them into one function and share the common code.
> 
> IIUC the only reason for the cpu == -1 special case is to avoid
> zeroying, right? Is this optimization worth the special case? The code
> would be slightly easier to follow without this.

Hm, it was less about the optimization and more about which CPU(s)
need(s) to be handled. But it's pretty silly the way it's written,
indeed. I'll move the for_each_online_cpu() to the caller and drop the
cpu==-1 special casing, it makes things much simpler and more obvious.

> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Anyway the above is not really a fundamental objection. It is more important
> to unify the flushing.
> 
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks. v2 is different, so I'll wait with taking the ack.
