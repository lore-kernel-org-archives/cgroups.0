From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Sun, 30 Sep 2012 19:37:32 +0900
Message-ID: <20120930103732.GK10383@mtj.dyndns.org>
References: <50638793.7060806@parallels.com>
 <20120926230807.GC10453@mtj.dyndns.org>
 <20120927142822.GG3429@suse.de>
 <20120927144942.GB4251@mtj.dyndns.org>
 <50646977.40300@parallels.com>
 <20120927174605.GA2713@localhost>
 <50649EAD.2050306@parallels.com>
 <20120930075700.GE10383@mtj.dyndns.org>
 <20120930080249.GF10383@mtj.dyndns.org>
 <1348995388.2458.8.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NXYA1X9byjWe01wud7s7LDk1UtNZ49F3zHWKv/q312E=;
        b=aaGBbumIffKQxWjCkLK0U1PG56V4E4bqYJ6N8nrTWtVjWj8IjMYbmmEi31iHBvQqff
         05mm/V6p+bfY4y88Fi8cNBSfgajYhne+zlwDSowdIzfJWlffvvV3y9NlatFgyyBK1j8o
         YpXJz47uvLwniBRA7HPfFutwViFgBqQp0gF7zf6iyUORWALYbZMyaF6jANBG/P3fajcK
         SRy2m0eQNxDEu7/KsbzpoZRE0wTuxActupBTKgD6cI87ucA44sOoHR87iyB+o82pAmFJ
         wduP4ASCSCqGh+FdguTs2mH5jcLms6kxlFIwwOUBTWP/ne8vGSE60udcRvinBnhUOWly
         pzDQ==
Content-Disposition: inline
In-Reply-To: <1348995388.2458.8.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, James.

On Sun, Sep 30, 2012 at 09:56:28AM +0100, James Bottomley wrote:
> The beancounter approach originally used by OpenVZ does exactly this.
> There are two specific problems, though, firstly you can't count
> references in generic code, so now you have to extend the cgroup
> tentacles into every object, an invasiveness which people didn't really
> like.

Yeah, it will need some hooks.  For dentry and inode, I think it would
be pretty well isolated tho.  Wasn't it?

> Secondly split accounting causes oddities too, like your total
> kernel memory usage can appear to go down even though you do nothing
> just because someone else added a share.  Worse, if someone drops the
> reference, your usage can go up, even though you did nothing, and push
> you over your limit, at which point action gets taken against the
> container.  This leads to nasty system unpredictability (The whole point
> of cgroup isolation is supposed to be preventing resource usage in one
> cgroup from affecting that in another).

In a sense, the fluctuating amount is the actual resource burden the
cgroup is putting on the system, so maybe it just needs to be handled
better or maybe we should charge fixed amount per refcnt?  I don't
know.

> We discussed this pretty heavily at the Containers Mini Summit in Santa
> Rosa.  The emergent consensus was that no-one really likes first use
> accounting, but it does solve all the problems and it has the fewest
> unexpected side effects.

But that's like fitting the problem to the mechanism.  Maybe that is
the best which can be done, but the side effect there is way-off
accounting under pretty common workload, which sounds pretty nasty to
me.

Thanks.

-- 
tejun
