From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: folding CONFIG_MEMCG_SWAP as default
Date: Fri, 17 Apr 2020 09:41:04 -0700
Message-ID: <CALvZod7Xa4Xs=7zC8OZ7GOfvfDBv+yNbGCzBxeoMgAeRGRtw0A@mail.gmail.com>
References: <1587134624-184860-1-git-send-email-alex.shi@linux.alibaba.com> <20200417155317.GS26707@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KReP0BQ7R9kDWKVN2qYXZOSpqxd/RqsatXVhR8Hp+6M=;
        b=A+CXQpwUauVcRxKfmCkhrY+lO8YU2Of5TvIiYGM8+ZPQlQxaAlRsouUQvYIVuYEfo9
         tiFjNYW4sA8i7jeVhSr4CGPhlKpq3zNblY0JIHYp7mUhuPZ+nr52IAgv8ozW5UO4aCFr
         1xyOETsWR7Hu1Jy0boQWlTBoROvOK1qxhWVumIDprKpG6rUXf7Il+1RCub37qYG7s0i6
         vTd0fKn7UlV78sU6nxXxaEMbfUVFHOuAWNgVkcvgiz+OZCP4AOGXFdg2IzaPl2wF02Y5
         pvnB1XKmzAQb+B+OhYk2vHB5o71IRkdE8KQBO1A86zGoCa6jppakQhH1Tu7QZ7MRnUrh
         ufqg==
In-Reply-To: <20200417155317.GS26707-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Apr 17, 2020 at 9:03 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Fri 17-04-20 22:43:43, Alex Shi wrote:
> > This patch fold MEMCG_SWAP feature into kernel as default function. That
> > required a short size memcg id for each of page. As Johannes mentioned
> >
> > "the overhead of tracking is tiny - 512k per G of swap (0.04%).'
> >
> > So all swapout page could be tracked for its memcg id.
>
> I am perfectly OK with dropping the CONFIG_MEMCG_SWAP. The code that is
> guarded by it is negligible and the resulting code is much easier to
> read so no objection on that front. I just do not really see any real
> reason to flip the default for cgroup v1. Why do we want/need that?
>

Yes, the changelog is lacking the motivation of this change. This is
proposed by Johannes and I was actually expecting the patch from him.
The motivation is to make the things simpler for per-memcg LRU locking
and workingset for anon memory (Johannes has described these really
well, lemme find the email). If we keep the differentiation between
cgroup v1 and v2, then there is actually no point of this cleanup as
per-memcg LRU locking and anon workingset still has to handle the
!do_swap_account case.

Shakeel
