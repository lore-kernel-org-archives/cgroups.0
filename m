From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: do not miss MEMCG_MAX events for
 enforced allocations
Date: Thu, 7 Jul 2022 09:47:16 +0200
Message-ID: <YsaPhF1KQFe+ses0@dhcp22.suse.cz>
References: <20220702033521.64630-1-roman.gushchin@linux.dev>
 <CALvZod7TGhWtcRD6HeEx90T2+Rod-yamq9i+WbEQUKwNFTi-1A@mail.gmail.com>
 <YsBmoqEBCa7ra7w2@castle>
 <YsMCMveSdiYX/2eH@dhcp22.suse.cz>
 <YsMHkXJ0vAPG0lyM@dhcp22.suse.cz>
 <YsSkaiL00Jk45zNd@castle>
 <CALOAHbBrctf_wOiAxUvXD0JSjgEV46YdDQh9QnUK0XZ+Jsapnw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657180036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CEd2Na7ZICW0cPoFXBq3xNRf0e9K1vxcQxK9+w/pQcI=;
        b=hCVarrs4y/FY6SmlaBkGnrAWX3Sk5hubEwYhKsTJb62VdDHL+aJngsV0bEiPEOfhy/YYhV
        oBReVvZuCQeBjWbP7T6ZvocSNnsTZzkkRNq3CQvD4pqTp/MXqTc9q9Xe7CHeSDWm44VhDR
        5aGIVC7go5KC9Z14yDAq0U1DJsFK+E4=
Content-Disposition: inline
In-Reply-To: <CALOAHbBrctf_wOiAxUvXD0JSjgEV46YdDQh9QnUK0XZ+Jsapnw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed 06-07-22 10:40:48, Yafang Shao wrote:
> On Wed, Jul 6, 2022 at 4:52 AM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> >
> > On Mon, Jul 04, 2022 at 05:30:25PM +0200, Michal Hocko wrote:
> > > On Mon 04-07-22 17:07:32, Michal Hocko wrote:
> > > > On Sat 02-07-22 08:39:14, Roman Gushchin wrote:
> > > > > On Fri, Jul 01, 2022 at 10:50:40PM -0700, Shakeel Butt wrote:
> > > > > > On Fri, Jul 1, 2022 at 8:35 PM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> > > > > > >
> > > > > > > Yafang Shao reported an issue related to the accounting of bpf
> > > > > > > memory: if a bpf map is charged indirectly for memory consumed
> > > > > > > from an interrupt context and allocations are enforced, MEMCG_MAX
> > > > > > > events are not raised.
> > > > > > >
> > > > > > > It's not/less of an issue in a generic case because consequent
> > > > > > > allocations from a process context will trigger the reclaim and
> > > > > > > MEMCG_MAX events. However a bpf map can belong to a dying/abandoned
> > > > > > > memory cgroup, so it might never happen.
> > > > > >
> > > > > > The patch looks good but the above sentence is confusing. What might
> > > > > > never happen? Reclaim or MAX event on dying memcg?
> > > > >
> > > > > Direct reclaim and MAX events. I agree it might be not clear without
> > > > > looking into the code. How about something like this?
> > > > >
> > > > > "It's not/less of an issue in a generic case because consequent
> > > > > allocations from a process context will trigger the direct reclaim
> > > > > and MEMCG_MAX events will be raised. However a bpf map can belong
> > > > > to a dying/abandoned memory cgroup, so there will be no allocations
> > > > > from a process context and no MEMCG_MAX events will be triggered."
> > > >
> > > > Could you expand little bit more on the situation? Can those charges to
> > > > offline memcg happen indefinetely? How can it ever go away then? Also is
> > > > this something that we actually want to encourage?
> > >
> > > One more question. Mostly out of curiosity. How is userspace actually
> > > acting on those events? Are watchers still active on those dead memcgs?
> >
> > Idk, the whole problem was reported by Yafang, so he probably has a better
> > answer. But in general events are recursive and the cgroup doesn't have
> > to be dying, it can be simple abandoned.
> >
> 
> Regarding the pinned bpf programs, it can run without a user agent.
> That means the cgroup may not be dead, but just not populated.
> (But in our case, the cgroup will be deleted after the user agent exits.)

OK, that makes sense.
-- 
Michal Hocko
SUSE Labs
