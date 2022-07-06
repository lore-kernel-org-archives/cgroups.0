From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: do not miss MEMCG_MAX events for
 enforced allocations
Date: Tue, 5 Jul 2022 20:56:30 -0700
Message-ID: <YsUH7pgBVnWSkC1q@castle>
References: <20220702033521.64630-1-roman.gushchin@linux.dev>
 <CALvZod7TGhWtcRD6HeEx90T2+Rod-yamq9i+WbEQUKwNFTi-1A@mail.gmail.com>
 <YsBmoqEBCa7ra7w2@castle>
 <YsMCMveSdiYX/2eH@dhcp22.suse.cz>
 <YsSj6rZmUkR8amT2@castle>
 <CALOAHbAb9DT6ihyxTm-4FCUiqiAzRSUHJw9erc+JTKVT9p8tow@mail.gmail.com>
 <YsUBQsTjVuXvt1Wr@castle>
 <CALOAHbDjRzySCHeMVHtVDe=Ji+qh=n0pT4CwiAM5Pahi2-QNCQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657079801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=alOH/I63Y6VwyHb7XshPqmHXepAkppPcejnq6CzdwQY=;
        b=ebSIUSgSiPKzgstWVxefS03jBb/bvPN4BJqgaLSTovUNzkhVWf8JvRjaRymmXul7jzJJHG
        023vHAqRsS+a7oRG38Lu0WKHN7Ql/FHBY31+G/ZbWqrx88PFWxFmlrrW6AZ9CmZmrFW0aR
        snucsWj7+gQuiw75PRWSy6CjAoyFCfw=
Content-Disposition: inline
In-Reply-To: <CALOAHbDjRzySCHeMVHtVDe=Ji+qh=n0pT4CwiAM5Pahi2-QNCQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 06, 2022 at 11:42:50AM +0800, Yafang Shao wrote:
> On Wed, Jul 6, 2022 at 11:28 AM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> >
> > On Wed, Jul 06, 2022 at 10:46:48AM +0800, Yafang Shao wrote:
> > > On Wed, Jul 6, 2022 at 4:49 AM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> > > >
> > > > On Mon, Jul 04, 2022 at 05:07:30PM +0200, Michal Hocko wrote:
> > > > > On Sat 02-07-22 08:39:14, Roman Gushchin wrote:
> > > > > > On Fri, Jul 01, 2022 at 10:50:40PM -0700, Shakeel Butt wrote:
> > > > > > > On Fri, Jul 1, 2022 at 8:35 PM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> > > > > > > >
> > > > > > > > Yafang Shao reported an issue related to the accounting of bpf
> > > > > > > > memory: if a bpf map is charged indirectly for memory consumed
> > > > > > > > from an interrupt context and allocations are enforced, MEMCG_MAX
> > > > > > > > events are not raised.
> > > > > > > >
> > > > > > > > It's not/less of an issue in a generic case because consequent
> > > > > > > > allocations from a process context will trigger the reclaim and
> > > > > > > > MEMCG_MAX events. However a bpf map can belong to a dying/abandoned
> > > > > > > > memory cgroup, so it might never happen.
> > > > > > >
> > > > > > > The patch looks good but the above sentence is confusing. What might
> > > > > > > never happen? Reclaim or MAX event on dying memcg?
> > > > > >
> > > > > > Direct reclaim and MAX events. I agree it might be not clear without
> > > > > > looking into the code. How about something like this?
> > > > > >
> > > > > > "It's not/less of an issue in a generic case because consequent
> > > > > > allocations from a process context will trigger the direct reclaim
> > > > > > and MEMCG_MAX events will be raised. However a bpf map can belong
> > > > > > to a dying/abandoned memory cgroup, so there will be no allocations
> > > > > > from a process context and no MEMCG_MAX events will be triggered."
> > > > >
> > > > > Could you expand little bit more on the situation? Can those charges to
> > > > > offline memcg happen indefinetely?
> > > >
> > > > Yes.
> > > >
> > > > > How can it ever go away then?
> > > >
> > > > Bpf map should be deleted by a user first.
> > > >
> > >
> > > It can't apply to pinned bpf maps, because the user expects the bpf
> > > maps to continue working after the user agent exits.
> > >
> > > > > Also is this something that we actually want to encourage?
> > > >
> > > > Not really. We can implement reparenting (probably objcg-based), I think it's
> > > > a good idea in general. I can take a look, but can't promise it will be fast.
> > > >
> > > > In thory we can't forbid deleting cgroups with associated bpf maps, but I don't
> > > > thinks it's a good idea.
> > > >
> > >
> > > Agreed. It is not a good idea.
> > >
> > > > > In other words shouldn't those remote charges be redirected when the
> > > > > target memcg is offline?
> > > >
> > > > Reparenting is the best answer I have.
> > > >
> > >
> > > At the cost of increasing the complexity of deployment, that may not
> > > be a good idea neither.
> >
> > What do you mean? Can you please elaborate on it?
> >
> 
>                    parent memcg
>                          |
>                     bpf memcg   <- limit the memory size of bpf
> programs
>                         /           \
>          bpf user agent     pinned bpf program
> 
> After bpf user agents exit, the bpf memcg will be dead, and then all
> its memory will be reparented.
> That is okay for preallocated bpf maps, but not okay for
> non-preallocated bpf maps.
> Because the bpf maps will continue to charge, but as all its memory
> and objcg are reparented, so we have to limit the bpf memory size in
> the parent as follows,

So you're relying on the memory limit of a dying cgroup?
Sorry, but I don't think we can seriously discuss such a design.
A dying cgroup is invisible for a user, a user can't change any tunables,
they have zero visibility into any stats or charges. Why would you do this?

If you want the cgroup to be an active part of the memory management
process, don't delete it. There are exactly zero guarantees about what
happens with a memory cgroup after being deleted by a user, it's all
implementation details.

Anyway, here is the patch for reparenting bpf maps:
https://github.com/rgushchin/linux/commit/f57df8bb35770507a4624fe52216b6c14f39c50c

I gonna post it to bpf@ after some testing.

Thanks!
