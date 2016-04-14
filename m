From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Thu, 14 Apr 2016 11:32:27 -0400
Message-ID: <20160414153227.GA12583@htj.duckdns.org>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160413193734.GC20142@htj.duckdns.org>
 <20160413194820.GC30260@dhcp22.suse.cz>
 <20160414070623.GC2850@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LOKV4Gyoc2T2/1LXMUGcW1VzldvIV5IaO7XwXPBjh1Q=;
        b=WY/eKZ3vhq5NgSrR1lNImvOc/vwnJAc17ESKMJIYefyewrBRrq0Oz+5id2/PZ1jNyb
         QXiswNrgP0mg6ZvVnPT0wV6YE4YpL8rMB3izcryesXQ+MmNlFYLINiCXKNLL+DFpYfns
         AL9ImO3qe0qRCiRQbvDv7B/4dzlNQRzacBxP/cpk86Ip84OHUlc2qQnniRpF0tqFPio/
         htoGSDpA9ACudg2Z/tvdvrKd9bxLGWobHep/PGUHnQdlBI9UEpX9VEKJ2mxj5if4Ximi
         JBf+rUt6JeXE8iV5/Hc87y++SVFOWq9I/8CbNaSZeYzLvjLf3J/BnfhrcDmXur/P4Qsw
         Vyag==
Content-Disposition: inline
In-Reply-To: <20160414070623.GC2850-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello,

On Thu, Apr 14, 2016 at 09:06:23AM +0200, Michal Hocko wrote:
> On Wed 13-04-16 21:48:20, Michal Hocko wrote:
> [...]
> > I was thinking about something like flush_per_cpu_work() which would
> > assert on group_threadgroup_rwsem held for write.
> 
> I have thought about this some more and I guess this is not limitted to
> per cpu workers. Basically any flush_work with group_threadgroup_rwsem
> held for write is dangerous, right?

Whether per-cpu or not doesn't matter.  What matters is whether the
workqueue has WQ_MEM_RECLAIM or not.  That said, I think what we want
to do is avoiding performing heavy operations in migration path.  It's
where the core and all controllers have to synchronize, so performing
operations with many external dependencies is bound to get messy.  I
wonder whether memory charge moving can be restructured in a similar
fashion to how cpuset node migration is made async.  However, given
that charge moving has always been a best effort thing, for now, I
think it'd be best to drop lru_add_drain.

Thanks.

-- 
tejun
