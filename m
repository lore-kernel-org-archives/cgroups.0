From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch v2] mm, memcg: do not retry precharge charges
Date: Sat, 14 Jan 2017 11:22:38 -0500
Message-ID: <20170114162238.GD26139@cmpxchg.org>
References: <alpine.DEB.2.10.1701112031250.94269@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1701121446130.12738@chino.kir.corp.google.com>
 <20170113084014.GB25212@dhcp22.suse.cz>
 <alpine.DEB.2.10.1701130208510.69402@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+c357wSM+RqbpiWBUUqLu2TSWXEJY+TZijQ/bTC/R9E=; b=PU5DZsx5SLint7NPUNrlXhwg/+
        jzmh2k3Ki1twNtQuH0B6ZQMD50t96gKo1dxjUI9LtCFSeTzeUGjb9HitJJDgu7Qiq7DQM24KpCHLN
        CcfbgrGW+cNl+BAbw1m/4kTl2mw26IvCpS7sKpNcdckUzlQNu0sO/vAxVYrmcHWCXCbQ=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1701130208510.69402-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Jan 13, 2017 at 02:09:53AM -0800, David Rientjes wrote:
> When memory.move_charge_at_immigrate is enabled and precharges are
> depleted during move, mem_cgroup_move_charge_pte_range() will attempt to
> increase the size of the precharge.
> 
> Prevent precharges from ever looping by setting __GFP_NORETRY.  This was
> probably the intention of the GFP_KERNEL & ~__GFP_NORETRY, which is
> pointless as written.

The OOM killer livelock was the motivation for this patch. With that
ruled out, what's the point of this patch? Try a bit less hard to move
charges during task migration?
