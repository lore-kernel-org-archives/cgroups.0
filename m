From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: use root_mem_cgroup as css when current is
 not enabled
Date: Mon, 15 Aug 2022 10:12:44 -1000
Message-ID: <YvqovLtVv8C3Zifj@slm.duckdns.org>
References: <1660298966-11493-1-git-send-email-zhaoyang.huang@unisoc.com>
 <YvakpukeF9d35Bc8@slm.duckdns.org>
 <CAGWkznG6n=+v7hUKR8Rmg8VEF=BTDegk8bh6aHfvOU5TbmeXDw@mail.gmail.com>
 <CAGWkznHa9WTV2oK=HB1OVEdKeMZ1V2omDDiNrRdyBdyYd=q5Fg@mail.gmail.com>
 <CAGWkznEQ_njmNt8usr-DyaiYDAHJE-niC2QxoXPQkDqY7v_Mqg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=4ge96+G7p+gdjTYmHEuqmuSxfOOy8/jVGuHx76Z8uTY=;
        b=pLp2CiRi+Q0codn/rk0EUtKXWKYbBTq4iQ1i0IS8oj2p881Cp5/783eDfJBXDkuqIU
         jjJs9qY3y/DHGcUDIdRbaCh9dkPrWj84/Rf0ZzDNoWCj5sxoRKDDNuhsaFm17B4b9Hx1
         k5KRl39FLK4MkAbHYeLrBvTexfeNTeu5cWnaKgf+BzKHrGhDfTH8hbj0MNMbBvTs/kJR
         JU+Lrnbjt1EkY2ulXYMkOIvCmOR82l6Y0YYJxkjR4IWoHNW0+9Xc5kyrR50WROX/+ti+
         HBGuR+L4Qx0G3vttyZ4FBcnOUp87yMYKnWnvuNZOe2ozDCx+kp3Qra4iWOZHUpnVyQE5
         frUg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGWkznEQ_njmNt8usr-DyaiYDAHJE-niC2QxoXPQkDqY7v_Mqg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

On Mon, Aug 15, 2022 at 05:17:03PM +0800, Zhaoyang Huang wrote:
> > > IMHO, I would like to say if it makes more sense as "A given cgroup
> > > always encompasses all the resources consumed in its ENABLED
> > > self-including subtree." Otherwise, how should I couple with the
> > > scenarios I raised in the commit message which I prefer parts of the
> > > subtrees compete for "memory" while others are free for it. The free
> > > here is not only without "min/low/high watermarks" but also not
> > > charged to their own LRU.
> > I would like to state more why these make sense. Memory cgroup is a
> > little bit different to other cgroups, that is, memcg will have real
> > physical resources attached, say pages. From perspective of memory
> > reclaiming, it is odd to find that pages under free memcgs are charged
> > to separate LRUs but without any management(no watermark control) and
> > perhaps affect workingset mechanism by LRU reason. Furthermore, v2
> > should grant the groups with the right to reject the subsys which
> > introduced by sibling enable, which could be deemed as v2's
> > inconvenient. The memcg could also apply subtree_control to enroll all
> > memory back whenever it want.
> As suggested by zefan, raise the practical scenario here to make more
> sense. The issue is observed in android system where per-app cgroup is
> demanded by freezer subsys and part of them require memory control.
> Under this scenario, less efficient memory reclaim is observed when
> comparing with no memory control. It is believed that multi LRU
> scanning introduces some of the overhead. Furthermore, page thrashing
> is also heavier than global LRU which could be the consequences of
> partial failure of WORKINGSET mechanism as LRU is too short to protect
> the active pages.

The basic architecture isn't gonna change and there are fundamental reasons
why things are the way they are. The resources, especially the main ones,
are entangled with each other - e.g. memory, io and cpu are entangled with
each other through reclaim. While we aren't capturing the cpu part yet but
we now do a largely acceptable job of controlling memory and io together.

This is reduction of flexibility compared to cgroup1 and can cause some
inconvenience when transitioning from cgroup1 but the experience has been
that the pros clearly outweigh the cons. Even here, none of the problems
you're listing are architectural. If there are memcg behavior problems, we
should fix them in memcg, not work around by twisting the basic
architecture. Are the problematic memcg behaviors reproducible in upstream?
If so, can you please make a detailed report on those?

Thanks.

-- 
tejun
