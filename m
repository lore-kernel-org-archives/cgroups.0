From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/7] mm: memcontrol: fix cpuhotplug statistics flushing
Date: Tue, 2 Feb 2021 14:23:57 -0800
Message-ID: <CALvZod6fHOhGN2exBSsRS4+KMzXE=1O7ALF2Hq4ehjvVFW6+ig@mail.gmail.com>
References: <20210202184746.119084-1-hannes@cmpxchg.org> <20210202184746.119084-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qNAOPiZhBvntC8C14bTzDHN942diSkXcNrN3eK3rI1U=;
        b=py//dvYEibEFwVmLb4PAzjrsTA3YCydFXpiKsTfJi98dIVrg7qVsUn1zCwPK/765J/
         xrxxSxQX34Z5IqSMuCDIcyPNpFXaT6T/zkIQIiYAC7f+RArYPsUtyQj8fLsxWvPGFJQ6
         Yl40cJATocGMAb/9yXMC7R1+HkxigN0/ks8Zgc91TApzoAVqBSnBZjmIZiKauDYWUF1N
         OMrxP2/N93d7LP6Pz8DOpiBEGq4iTW3u84Q1agudNIm3TaixbI+oz0WhuOXFiGxVlbyI
         n4KOlzRwFVBigG+zifCDblUVxu256mnuXXn89LsK4p3TXqjTFNn0xo+btKP8wd57wFTK
         cZpw==
In-Reply-To: <20210202184746.119084-2-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Tue, Feb 2, 2021 at 12:18 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> The memcg hotunplug callback erroneously flushes counts on the local
> CPU, not the counts of the CPU going away; those counts will be lost.
>
> Flush the CPU that is actually going away.
>
> Also simplify the code a bit by using mod_memcg_state() and
> count_memcg_events() instead of open-coding the upward flush - this is
> comparable to how vmstat.c handles hotunplug flushing.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

I think we need Fixes: a983b5ebee572 ("mm: memcontrol: fix excessive
complexity in memory.stat reporting")

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
