From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch] mm, memcg: provide a stat to describe reclaimable memory
Date: Mon, 20 Jul 2020 09:37:15 +0200
Message-ID: <20200720073715.GB18535@dhcp22.suse.cz>
References: <alpine.DEB.2.23.453.2007142018150.2667860@chino.kir.corp.google.com>
 <20200715131048.GA176092@chrisdown.name>
 <alpine.DEB.2.23.453.2007151046320.2788464@chino.kir.corp.google.com>
 <20200717121750.GA367633@chrisdown.name>
 <alpine.DEB.2.23.453.2007171226310.3398972@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.23.453.2007171226310.3398972-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 17-07-20 12:37:57, David Rientjes wrote:
[...]
> On a 4.3 kernel, for example, memory.current for the heap segment is now 
> (64MB / 2MB) * 4KB = 128KB because we have synchronous splitting and 
> uncharging of the underlying hugepage.  On a 4.15 kernel, for example, 
> memory.current is still 64MB because the underlying hugepages are still 
> charged to the memcg due to deferred split queues.

Deferred THP split should be a kernel internal implementation
optimization and a detail that userspace shouldn't really be worrying
about. If there are user visible effects that are standing in the way
then we should reconsider how much is the optimization worth. I do not
really remember any actual numbers that would strongly justify its
existence while I do remember several problems that this has introduced.

So I am really wondering whether exporting subtle metrics to the
userspace which can lead to confusion is the right approach to the
problem you have at hands.

Also could you be more specific about the numbers we are talking here?
E.g. what is the overal percentage of the "mis-accounted" split THPs
wrt. to the high/max limit? Is the userspace relying on very precise
numbers?
-- 
Michal Hocko
SUSE Labs
