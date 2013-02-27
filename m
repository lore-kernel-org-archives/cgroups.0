From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: implement low limits
Date: Wed, 27 Feb 2013 17:13:52 +0100
Message-ID: <20130227161352.GF16719@dhcp22.suse.cz>
References: <8121361952156@webcorp1g.yandex-team.ru>
 <20130227094054.GC16719@dhcp22.suse.cz>
 <17521361961576@webcorp1g.yandex-team.ru>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <17521361961576-UZ+4eo27dRL0t1ZyImeKKJZIWCK8hONu@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Johannes Weiner-Arquette <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org" <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed 27-02-13 14:39:36, Roman Gushchin wrote:
> 27.02.2013, 13:41, "Michal Hocko" <mhocko-AlSwsSmVLrQ@public.gmane.org>:
> > Let me restate what I have already mentioned in the private
> > communication.
> >
> > We already have soft limit which can be implemented to achieve the
> > same/similar functionality and in fact this is a long term objective (at
> > least for me). I hope I will be able to post my code soon. The last post
> > by Ying Hand (cc-ing her) was here:
> > http://comments.gmane.org/gmane.linux.kernel.mm/83499
> >
> > To be honest I do not like introduction of a new limit because we have
> > two already and the situation would get over complicated.
> 
> I think, there are three different tasks:
> 1) keeping cgroups below theirs hard limit to avoid direct reclaim
> (for performance reasons),

Could you clarify what you mean by this, please? There is no background
reclaim for memcgs currently and I am a bit skeptical whether it is
useful. If it would be useful then it should be in par with the global
reclaim (so something like min_free_kbytes would be more appropriate).

> 2) cgroup's prioritization during global reclaim,

Yes, group priorities sound like a useful feature not just for the
reclaim I would like it for oom selection as well.
I think that we shouldn't use any kind of limit for this task, though.

> 3) granting some amount of memory to a selected cgroup (and protecting
> it from reclaim without significant reasons)

and soft limit sounds like a good fit with this description.

> IMHO, combining them all in one limit will simplify a kernel code,
> but will also make a user's (or administrator's) life much more
> complicated.

I do not think all 3 tasks you have described can be covered by a single
limit of course. We have hard limit to cap the usage, we have a soft
limit to allow over-committing the machine. Task 2 would require a new
knob but it shouldn't be covered by any limit or depend on the group
usage. And task 1 sounds like a background reclaim and then it should be
consistent with the global knob.

> Introducing low limits can make the situation simpler.

How exactly? I can see how it would address task 3 but yet again, soft
limit can be turned into this behavior as well without changing its
semantic (that limit would be still considered if we are able to handle
memory pressure from the above - either global pressure or parent
hitting the limit).
-- 
Michal Hocko
SUSE Labs
