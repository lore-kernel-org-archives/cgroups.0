From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce dynamic protection for memcg
Date: Thu, 7 Apr 2022 16:14:57 +0200
Message-ID: <Yk7x4U5gTvS4/ijR@dhcp22.suse.cz>
References: <Ykq7KUleuAg5QnNU@dhcp22.suse.cz>
 <CAGWkznGbd5TOTHZE8uUhak3SnHqEWx_9QCJVtUFUSg9rk3xYEQ@mail.gmail.com>
 <Ykrkx4JML4c81gBV@dhcp22.suse.cz>
 <CAGWkznEaEavCz9GeiYuTqsox2qZK43iQKevt8njkzaHv6KiW-A@mail.gmail.com>
 <YkwxNaJIg6ptJOYT@dhcp22.suse.cz>
 <CAGWkznG=QH3HRSzgum0sQBkyQAahqgiWf8nXCv1qXstxrn7e8w@mail.gmail.com>
 <Yk6VZlGnB48RqnYW@dhcp22.suse.cz>
 <CAGWkznG+V88f_DjtJAe4_Nr=32Q7Z4b1CaBCB0FVqhAAsuNsWA@mail.gmail.com>
 <Yk6ya5Ks0H6rHPx4@dhcp22.suse.cz>
 <CAGWkznH1NhfDXy94cOs0YWnw_uOOVbcbrygT5X6CAZ44CTf78Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649340899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dKwrr1idTmWArX2lqn5YORjBOhR4BKEAOp87gdFGmAs=;
        b=JJOWpMh04HvpMRV9OHslNnYorECxh2BD2x5KOqtVFuXhlvMJYVYdpOespQ8gzdXuS+vIbr
        xcez1y5fivmjExddn6mXf7iZ7mev5ZvAdim89+c+9N8W2INFFncr1rhx9538zF0O2NhH+2
        neOak+Z7R28zFIrQW/wC8IqrTMRVydg=
Content-Disposition: inline
In-Reply-To: <CAGWkznH1NhfDXy94cOs0YWnw_uOOVbcbrygT5X6CAZ44CTf78Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

On Thu 07-04-22 20:36:51, Zhaoyang Huang wrote:
> On Thu, Apr 7, 2022 at 5:44 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > [...]
> > On Thu 07-04-22 16:59:50, Zhaoyang Huang wrote:
> > > > This means that limits are altered even if there is memory to be
> > > > reclaimed from other memcgs. Why? How does this line up with the
> > > > basic property of the low limit to act as a protection from the reclaim?
> > > ok, partially understand. I would like to say that low's original
> > > definition under this patch has changed, says the calculated low just
> > > provide protection when the psi value is lower than the setting and
> > > will introduce reclaiming if it exceed.
> >
> > OK, I guess I finally get to understand what you are trying to say. So
> > effectivelly your new semantic defines the low limit as an initial
> > protection that is very soft and only preserved under a light global
> > memory pressure[1]. If the reclaim pressure is higher the user provided
> > protection is decreased. The new semantic is planned to be a global
> > opt-in.
> >
> > Correct?
> right. But I don't think the original protection is soft which could
> be proved by the test result that the memcg is protected in a certain
> range of pressure and could also help to release the system by
> breaking low limit.

Low limit protection is considered soft because it doesn't provide any
guarantee. I will be ignored (and that will be reported to the userspace
via LOW event) if there is nothing reclaimable in the scope of the
reclaimed hierarchy. An alternative would be OOM actually.

> > Now, that I (believe) to have a slightly better understanding I have to
> > say I really dislike the idea.
> > First of all the new semantic would have to be memcg reclaim aware. That
> > means that the scaling logic would need to be aware where the memory
> > pressure comes from.
> I don't follow. Does it mean that the protected should distinguish the
> pressure from global and other memcgs? I don't know why.

No, it should behave consistently for any external memory pressure.
A reclaimed memcg can apply different constraint depending on the root
of the reclaim. Your solution is considering root to be root_memcg.

[...]
-- 
Michal Hocko
SUSE Labs
