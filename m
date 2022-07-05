From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: do not miss MEMCG_MAX events for
 enforced allocations
Date: Tue, 5 Jul 2022 13:51:54 -0700
Message-ID: <YsSkaiL00Jk45zNd@castle>
References: <20220702033521.64630-1-roman.gushchin@linux.dev>
 <CALvZod7TGhWtcRD6HeEx90T2+Rod-yamq9i+WbEQUKwNFTi-1A@mail.gmail.com>
 <YsBmoqEBCa7ra7w2@castle>
 <YsMCMveSdiYX/2eH@dhcp22.suse.cz>
 <YsMHkXJ0vAPG0lyM@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657054328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2XQLP0LMyl8MnEcyS+UNpbGDzxmEbywyn31NiQU5Lx0=;
        b=JSr8O0thgf/8K240RoHRwhrkNoV024GJhwM/fP5acSkn/ZlhiUCb5TdczmMwSDNlrpGuXu
        G7GwKy3IX13X5RNdKmf5nh9Zu48Mq1X/TRdewiKS5uZfzwpdcZ1Oxrp+bp6rhrbcaN46Pj
        xjy2u5+H4Mk43OwREgYrJ00f2vBjN8E=
Content-Disposition: inline
In-Reply-To: <YsMHkXJ0vAPG0lyM-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jul 04, 2022 at 05:30:25PM +0200, Michal Hocko wrote:
> On Mon 04-07-22 17:07:32, Michal Hocko wrote:
> > On Sat 02-07-22 08:39:14, Roman Gushchin wrote:
> > > On Fri, Jul 01, 2022 at 10:50:40PM -0700, Shakeel Butt wrote:
> > > > On Fri, Jul 1, 2022 at 8:35 PM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> > > > >
> > > > > Yafang Shao reported an issue related to the accounting of bpf
> > > > > memory: if a bpf map is charged indirectly for memory consumed
> > > > > from an interrupt context and allocations are enforced, MEMCG_MAX
> > > > > events are not raised.
> > > > >
> > > > > It's not/less of an issue in a generic case because consequent
> > > > > allocations from a process context will trigger the reclaim and
> > > > > MEMCG_MAX events. However a bpf map can belong to a dying/abandoned
> > > > > memory cgroup, so it might never happen.
> > > > 
> > > > The patch looks good but the above sentence is confusing. What might
> > > > never happen? Reclaim or MAX event on dying memcg?
> > > 
> > > Direct reclaim and MAX events. I agree it might be not clear without
> > > looking into the code. How about something like this?
> > > 
> > > "It's not/less of an issue in a generic case because consequent
> > > allocations from a process context will trigger the direct reclaim
> > > and MEMCG_MAX events will be raised. However a bpf map can belong
> > > to a dying/abandoned memory cgroup, so there will be no allocations
> > > from a process context and no MEMCG_MAX events will be triggered."
> > 
> > Could you expand little bit more on the situation? Can those charges to
> > offline memcg happen indefinetely? How can it ever go away then? Also is
> > this something that we actually want to encourage?
> 
> One more question. Mostly out of curiosity. How is userspace actually
> acting on those events? Are watchers still active on those dead memcgs?

Idk, the whole problem was reported by Yafang, so he probably has a better
answer. But in general events are recursive and the cgroup doesn't have
to be dying, it can be simple abandoned.

Thanks!
