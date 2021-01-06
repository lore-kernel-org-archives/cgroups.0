From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: add swapcache stat for memcg v2
Date: Wed, 6 Jan 2021 08:42:39 -0800
Message-ID: <CALvZod6Lv3gWmWRPP7jAaw4YCQPyPXcxqXTO3Vp6YVZ6AcEH4w@mail.gmail.com>
References: <20210101023955.250965-1-shakeelb@google.com> <20210106145349.GN13207@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=utozISaxL63drmUZAC6aSc+ai12dhlJYUKebxiFAYAo=;
        b=NJgC/VUIvpf5fbTrQst8wZDFHYVt/5v9vItzWgOp62erRY5JkQGsNMvKLDONIPp/BD
         zfZi6fl4PjIAf6Zmb7/vqYHlqhAebazjLTxpe49ORp+LFKCsUl04l9F1aU1l3EZZwSL7
         3C2r0OzvfFvuvUAJEVE08+OI3ztkKPl0RHcNxLSH43zDth8rS2q9Ka97JE1HGgk34A9Y
         urfd7r+YFlHUazX1lwYuWsVOio3w20BEArpVhHgsEz5f91diI5p1QamKhRnX9eKPmEId
         K04++Bd9AxG5mDliD9J8T6GMEBG1NZe2MXWAd43BvvvkRi9lRGkmf108ZUt8111O7wJJ
         DPXg==
In-Reply-To: <20210106145349.GN13207-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jan 6, 2021 at 6:53 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Thu 31-12-20 18:39:55, Shakeel Butt wrote:
> > This patch adds swapcache stat for the cgroup v2. The swapcache
> > represents the memory that is accounted against both the memory and the
> > swap limit of the cgroup. The main motivation behind exposing the
> > swapcache stat is for enabling users to gracefully migrate from cgroup
> > v1's memsw counter to cgroup v2's memory and swap counters.
> >
> > Cgroup v1's memsw limit allows users to limit the memory+swap usage of a
> > workload but without control on the exact proportion of memory and swap.
> > Cgroup v2 provides separate limits for memory and swap which enables
> > more control on the exact usage of memory and swap individually for the
> > workload.
> >
> > With some little subtleties, the v1's memsw limit can be switched with
> > the sum of the v2's memory and swap limits. However the alternative for
> > memsw usage is not yet available in cgroup v2. Exposing per-cgroup
> > swapcache stat enables that alternative. Adding the memory usage and
> > swap usage and subtracting the swapcache will approximate the memsw
> > usage. This will help in the transparent migration of the workloads
> > depending on memsw usage and limit to v2' memory and swap counters.
>
> Could you expand a bit more on why memsw usage is important even in
> cgroup v2 land? How are you going to use the approximated value?
>

Two main benefits. First, it hides the underlying system's swap setup
from the applications. Applications with multiple instances running in
a datacenter with heterogeneous systems (some have swap and some
don't) will keep seeing a consistent view of their usage.

Second, most of the applications (at least in our prod) are not really
interested in two separate memory and swap usage metrics. A single
usage metric is more simple to use and reason about for these
applications.
