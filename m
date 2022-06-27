From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: vmpressure: don't count userspace-induced reclaim as
 memory pressure
Date: Mon, 27 Jun 2022 02:39:49 -0700
Message-ID: <CAJD7tkZzwzHq7Q7KKUdVSdO4LWTPkrGprp0Q-ze_SWhUd_mTMw@mail.gmail.com>
References: <YrQe5A+FXnbgOR1f@dhcp22.suse.cz> <CAJD7tkanavKpKrQr8-jA8pukgD7OY4eOwJRZufJ2NoThD12G+Q@mail.gmail.com>
 <YrQ1o3CeaZWhm+h4@dhcp22.suse.cz> <CAJD7tkadsLOV7GMFAm+naX4Y1WpZ-4=NkAhAMxNw60iaRPWx=w@mail.gmail.com>
 <YrSWruhPlJV1X9kp@dhcp22.suse.cz> <CALvZod6eLa1X1FJ2Qi6FXhFA-qBCP4mN2SB31MSgjj+g8hKo6Q@mail.gmail.com>
 <YrSdFy3qYdG+rGR6@dhcp22.suse.cz> <CAJD7tkZNEtzJMDsLMHuNHkxFfurS37UuK=zFcPCkOkWfN-dbJQ@mail.gmail.com>
 <YrlpcdgF1HzA7bHS@dhcp22.suse.cz> <CAJD7tkYVy2uNwaPiiJdPKT5P_O-9WgxD68iFJ6vw=TLJcQV3Ag@mail.gmail.com>
 <Yrl2T632Vfv8QGPn@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vM3Z5SIYSYq9bPwMW1jTmQTQLpbgb+0WvNR7BGEdaNc=;
        b=kaUJc1jIpkPbtC9U8MXJHBYKoOHGQEzq3q3vaAxuGqXW070C8TPuYXSRMnth+BNr9J
         0sZMpkOpsANxBsF/IiElUG/nBHUDPjWCzHWxhmaWTxD4cBfxfZDCQdfPIEYVrLG0uYIf
         500/ZXu3ZVXey1dY/qwd+K3Go+lN6v9xvNaG2gGQospEu0PStaPpy0QoB3L44E/uLe9L
         crjZgHGPdsDgELrBhZI3C7/bz6YiGreCo/gdeyUSSiG0QPcO28gIwNw2jFwfo9wKZvca
         jCmzNyBTXKMPKf71ylml61Oa83MglG17PpcG6KxCS8H9DVy7WQu9g6ooSr5adnXstZAE
         6DGw==
In-Reply-To: <Yrl2T632Vfv8QGPn-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon, Jun 27, 2022 at 2:20 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 27-06-22 01:39:46, Yosry Ahmed wrote:
> > On Mon, Jun 27, 2022 at 1:25 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Thu 23-06-22 10:26:11, Yosry Ahmed wrote:
> > > > On Thu, Jun 23, 2022 at 10:04 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > >
> > > > > On Thu 23-06-22 09:42:43, Shakeel Butt wrote:
> > > > > > On Thu, Jun 23, 2022 at 9:37 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > > > >
> > > > > > > On Thu 23-06-22 09:22:35, Yosry Ahmed wrote:
> > > > > > > > On Thu, Jun 23, 2022 at 2:43 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > > > > > >
> > > > > > > > > On Thu 23-06-22 01:35:59, Yosry Ahmed wrote:
> > > > > > > [...]
> > > > > > > > > > In our internal version of memory.reclaim that we recently upstreamed,
> > > > > > > > > > we do not account vmpressure during proactive reclaim (similar to how
> > > > > > > > > > psi is handled upstream). We want to make sure this behavior also
> > > > > > > > > > exists in the upstream version so that consolidating them does not
> > > > > > > > > > break our users who rely on vmpressure and will start seeing increased
> > > > > > > > > > pressure due to proactive reclaim.
> > > > > > > > >
> > > > > > > > > These are good reasons to have this patch in your tree. But why is this
> > > > > > > > > patch benefitial for the upstream kernel? It clearly adds some code and
> > > > > > > > > some special casing which will add a maintenance overhead.
> > > > > > > >
> > > > > > > > It is not just Google, any existing vmpressure users will start seeing
> > > > > > > > false pressure notifications with memory.reclaim. The main goal of the
> > > > > > > > patch is to make sure memory.reclaim does not break pre-existing users
> > > > > > > > of vmpressure, and doing it in a way that is consistent with psi makes
> > > > > > > > sense.
> > > > > > >
> > > > > > > memory.reclaim is v2 only feature which doesn't have vmpressure
> > > > > > > interface. So I do not see how pre-existing users of the upstream kernel
> > > > > > > can see any breakage.
> > > > > > >
> > > > > >
> > > > > > Please note that vmpressure is still being used in v2 by the
> > > > > > networking layer (see mem_cgroup_under_socket_pressure()) for
> > > > > > detecting memory pressure.
> > > > >
> > > > > I have missed this. It is hidden quite good. I thought that v2 is
> > > > > completely vmpressure free. I have to admit that the effect of
> > > > > mem_cgroup_under_socket_pressure is not really clear to me. Not to
> > > > > mention whether it should or shouldn't be triggered for the user
> > > > > triggered memory reclaim. So this would really need some explanation.
> > > >
> > > > vmpressure was tied into socket pressure by 8e8ae645249b ("mm:
> > > > memcontrol: hook up vmpressure to socket pressure"). A quick look at
> > > > the commit log and the code suggests that this is used all over the
> > > > socket and tcp code to throttles the memory consumption of the
> > > > networking layer if we are under pressure.
> > > >
> > > > However, for proactive reclaim like memory.reclaim, the target is to
> > > > probe the memcg for cold memory. Reclaiming such memory should not
> > > > have a visible effect on the workload performance. I don't think that
> > > > any network throttling side effects are correct here.
> > >
> > > Please describe the user visible effects of this change. IIUC this is
> > > changing the vmpressure semantic for pre-existing users (v1 when setting
> > > the hard limit for example) and it really should be explained why
> > > this is good for them after those years. I do not see any actual bug
> > > being described explicitly so please make sure this is all properly
> > > documented.
> >
> > In cgroup v1, user-induced reclaim that is caused by limit-setting (or
> > memory.reclaim for systems that choose to expose it in cgroup v1) will
> > no longer cause vmpressure notifications, which makes the vmpressure
> > behavior consistent with the current psi behavior.
>
> Yes it makes the behavior consistent with PSI. But is this what existing
> users really want or need? This is a user visible long term behavior
> change for a legacy interface and there should be a very good reason to
> change that.
>
> > In cgroup v2, user-induced reclaim (limit-setting, memory.reclaim, ..)
> > would currently cause the networking layer to perceive the memcg as
> > being under memory pressure, reducing memory consumption and possibly
> > causing throttling. This patch makes the networking layer only
> > perceive the memcg as being under pressure when the "pressure" is
> > caused by increased memory usage, not limit-setting or proactive
> > reclaim, which also makes the definition of memcg memory pressure
> > consistent with psi today.
>
> I do understand the argument about the pro-active reclaim.
> memory.reclaim is a new interface and it a) makes sense to exclude it
> from different memory pressure notification interfaces and b) there are
> unlikely too many user applications depending on the exact behavior so
> changes are still rather low on the risk scale.
>
> > In short, the purpose of this patch is to unify the definition of
> > memcg memory pressure across psi and vmpressure (which indirectly also
> > defines the definition of memcg memory pressure for the networking
> > layer). If this sounds good to you, I can add this explanation to the
> > commit log, and possibly anywhere you see appropriate in the
> > code/docs.
>
> The consistency on its own sounds like a very weak argument to change a
> long term behavior. I do not really see any serious arguments or
> evaluation what kind of fallout this change can have on old applications
> that are still sticking with v1.
>
> After it has been made clear that the vmpressure is still used for the
> pro-active reclaim in v2 I do agree that this is likely something we
> want to have addressed. But I wouldn't touch v1 semantics as this
> doesn't really buy much and it can potentially break existing users.
>

Understood, and fair enough. There are 3 behavioral changes in this patch.

(a) Do not count vmpressure for mem_cgroup_resize_max() and
mem_cgroup_force_empty() in v1.
(b) Do not count vmpressure (consequently,
mem_cgroup_under_socket_pressure()) in v2 where psi is not counted
(writing to memory.max, memory.high, and memory.reclaim).

Do you want us to drop (a) and keep (b) ? or do you want to further
break down (b) to only limit the change to proactive reclaim through
memory.reclaim (IOW keep socket pressure on limit-setting although it
is not considered pressure in terms of psi) ?

> --
> Michal Hocko
> SUSE Labs
