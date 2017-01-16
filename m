From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch v2] mm, memcg: do not retry precharge charges
Date: Mon, 16 Jan 2017 08:35:41 +0100
Message-ID: <20170116073540.GB7981@dhcp22.suse.cz>
References: <alpine.DEB.2.10.1701112031250.94269@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1701121446130.12738@chino.kir.corp.google.com>
 <20170113084014.GB25212@dhcp22.suse.cz>
 <alpine.DEB.2.10.1701130208510.69402@chino.kir.corp.google.com>
 <20170114162238.GD26139@cmpxchg.org>
 <alpine.DEB.2.10.1701142137020.8668@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1701142137020.8668-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sat 14-01-17 21:42:48, David Rientjes wrote:
> On Sat, 14 Jan 2017, Johannes Weiner wrote:
> 
> > The OOM killer livelock was the motivation for this patch. With that
> > ruled out, what's the point of this patch? Try a bit less hard to move
> > charges during task migration?
> > 
> 
> Most important part is to fail ->can_attach() instead of oom killing 
> processes when attaching a process to a memcg hierarchy.

But we are not invoking the oom killer from this path even without
__GFP_NORETRY. Or am I missing your point?

-- 
Michal Hocko
SUSE Labs
