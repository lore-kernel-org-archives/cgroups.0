From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: vmpressure: don't count userspace-induced reclaim as
 memory pressure
Date: Mon, 27 Jun 2022 10:03:53 -0700
Message-ID: <CAJD7tkYemNQqu_O2nYG3cqxPWGELvc6Lh5i+KKNCtv6cgSPmdA@mail.gmail.com>
References: <YrQ1o3CeaZWhm+h4@dhcp22.suse.cz> <CAJD7tkadsLOV7GMFAm+naX4Y1WpZ-4=NkAhAMxNw60iaRPWx=w@mail.gmail.com>
 <YrSWruhPlJV1X9kp@dhcp22.suse.cz> <CALvZod6eLa1X1FJ2Qi6FXhFA-qBCP4mN2SB31MSgjj+g8hKo6Q@mail.gmail.com>
 <YrSdFy3qYdG+rGR6@dhcp22.suse.cz> <CAJD7tkZNEtzJMDsLMHuNHkxFfurS37UuK=zFcPCkOkWfN-dbJQ@mail.gmail.com>
 <YrlpcdgF1HzA7bHS@dhcp22.suse.cz> <CAJD7tkYVy2uNwaPiiJdPKT5P_O-9WgxD68iFJ6vw=TLJcQV3Ag@mail.gmail.com>
 <Yrl2T632Vfv8QGPn@dhcp22.suse.cz> <CAJD7tkZzwzHq7Q7KKUdVSdO4LWTPkrGprp0Q-ze_SWhUd_mTMw@mail.gmail.com>
 <YrmjH2FZF7iNn8da@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ZvfkO3IFf3n/ZVC71sBF9P6CPQM5ABge97UmMt98ps=;
        b=MjiW4IZIKNvnRLaZM4hrpDs4I/vEqDj5/3xOzyG/gv8hlURBfdXynnwR5LA4UVW70b
         o6v1EJHUzimguE8TQT2qD+Ab522RK1leX7GKKUj72qeBt/3gTwNZo3T7zB5s5GAWR77C
         kmZiLNM8c8QVC160v7Ww9LlRpm1EKOj9ecAo/uAQCARN/f/mgZjude7rkreOk0yXGga4
         Yc2oi4K5OYLJIn0wx5Z3wx0IbtNw5aTVQ4dxcBthCiW5NNtCuEvfM0Mj9ZlgHR8TiiCA
         U8V6ZkaLIF2+CvNbXCBVwy7P4laWgV05N1TKs+pMvPm7BtkXpcmeznV712/+QiAYbgHU
         HMwQ==
In-Reply-To: <YrmjH2FZF7iNn8da-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon, Jun 27, 2022 at 5:31 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 27-06-22 02:39:49, Yosry Ahmed wrote:
> [...]
> > (a) Do not count vmpressure for mem_cgroup_resize_max() and
> > mem_cgroup_force_empty() in v1.
>
> yes, unless you have a very good reason to change that. E.g. this has
> been buggy and we have finally understood that. But I do not see any
> indications so far.

I don't have any bug reports. It makes sense that users do not expect
vmpressure notifications when they resize the limits below the current
usage, because it should be expected that reclaim will happen so
receiving notifications here is redundant, and may be incorrectly
perceived by a different user space thread as being under memory
pressure. But I get your point that what the user sees as memory
pressure or not could be different, and is probably already defined by
the current behavior anyway, whether it makes sense or not.

I can also see some userspace applications depending on this behavior
in some way, either by handling that limit resize notification in a
certain way or deliberately dropping it. Either way, making this
change could throw them off. I don't expect any userspace applications
to crash of course (because there are cases where they won't receive
notifications, e.g. scanned < vmpressure_win), but perhaps it's not
worth even risk misguiding them.

So I agree that just because it doesn't make sense or is inconsistent
with other definitions of behavior then we can make a visible change
for userspace. I will drop the v1 changes in the next version anyway.

Thanks!

>
> > (b) Do not count vmpressure (consequently,
> > mem_cgroup_under_socket_pressure()) in v2 where psi is not counted
> > (writing to memory.max, memory.high, and memory.reclaim).
>
> I can see clear arguments for memory.reclaim opt out for vmpressure
> because we have established that this is not a measure to express a
> memory pressure on the cgroup.
>
> Max/High are less clear to me, TBH. I do understand reasoning for PSI
> exclusion because considering the calling process to be stalled and
> non-productive is misleading. It just does its work so in a way it is
> a productive time in the end. For the vmpressure, which measures how
> hard/easy it is to reclaim memory why this should special for this
> particular reclaim?
>
> Again, an explanation of the effect on the socket pressure could give a
> better picture. Say that I somebody reduces the limit (hard/high) and it
> takes quite some effort to shrink the consumption down. Should the
> networking layer react to that in any way or should it wait for the
> active allocation during that process to find that out?

I am out of my depth here. Any answer on my side would be purely
speculation at this point. Shakeel, can you help us here or tag some
networking people?
Thanks!

> --
> Michal Hocko
> SUSE Labs
