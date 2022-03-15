From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Patch v2 3/3] mm/memcg: add next_mz back to soft limit tree if
 not reclaimed yet
Date: Tue, 15 Mar 2022 09:54:34 +0100
Message-ID: <YjBUSqh07BIfxbl5@dhcp22.suse.cz>
References: <20220312071623.19050-1-richard.weiyang@gmail.com>
 <20220312071623.19050-3-richard.weiyang@gmail.com>
 <Yi8NudEX/sZsO2nO@dhcp22.suse.cz>
 <20220314230548.wo4colcwqxhhf3mx@master>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647334475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k31i3YTYOknR6WudpStCLK3nsIiTUhJ3ISWvBqEKH3c=;
        b=MbRJiBppXoWjXQRAq5YT4P81gpSS9nnDeHUj39iWUP03PZNHRGvEtD9vEojB4gfNUXN5Tk
        q1LeMjApOhbLSoOL8PiC0wlPgYbx+84b9+vVeLizG7aHNkZNeY/f8eATrszIWFxIJgUrmx
        cpuR7rDMXVxNY37C7t4Yl3/HUvYFjDw=
Content-Disposition: inline
In-Reply-To: <20220314230548.wo4colcwqxhhf3mx@master>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon 14-03-22 23:05:48, Wei Yang wrote:
> On Mon, Mar 14, 2022 at 10:41:13AM +0100, Michal Hocko wrote:
> >On Sat 12-03-22 07:16:23, Wei Yang wrote:
> >> When memory reclaim failed for a maximum number of attempts and we bail
> >> out of the reclaim loop, we forgot to put the target mem_cgroup chosen
> >> for next reclaim back to the soft limit tree. This prevented pages in
> >> the mem_cgroup from being reclaimed in the future even though the
> >> mem_cgroup exceeded its soft limit.
> >> 
> >> Let's say there are two mem_cgroup and both of them exceed the soft
> >> limit, while the first one is more active then the second. Since we add
> >> a mem_cgroup to soft limit tree every 1024 event, the second one just
> >> get a rare chance to be put on soft limit tree even it exceeds the
> >> limit.
> >
> >yes, 1024 could be just 4MB of memory or 2GB if all the charged pages
> >are THPs. So the excess can build up considerably.
> >
> >> As time goes on, the first mem_cgroup was kept close to its soft limit
> >> due to reclaim activities, while the memory usage of the second
> >> mem_cgroup keeps growing over the soft limit for a long time due to its
> >> relatively rare occurrence.
> >> 
> >> This patch adds next_mz back to prevent this sceanrio.
> >> 
> >> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >
> >Even though your changelog is different the change itself is identical to
> >https://lore.kernel.org/linux-mm/8d35206601ccf0e1fe021d24405b2a0c2f4e052f.1613584277.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org/
> >In those cases I would preserve the the original authorship by
> >From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >and add his s-o-b before yours.
> 
> TBH I don't think this is fair.
> 
> I didn't see his original change before I sent this patch. This is a
> coincidence we found the same point for improvement.
> 
> It hurts me if you want to change authorship. Well, if you really thinks this
> is what it should be, please remove my s-o-b.

OK, fair enough.
-- 
Michal Hocko
SUSE Labs
