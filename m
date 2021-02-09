From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/8] kselftests: cgroup: update kmem test for new vmstat implementation
Date: Tue, 9 Feb 2021 05:48:44 -0800
Message-ID: <CALvZod6Sy-SAUdAFMP=Bot_gyzGQqW2LrOehRbE-qUEgveFF8Q@mail.gmail.com>
References: <20210205182806.17220-1-hannes@cmpxchg.org> <20210205182806.17220-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T6hyX38mFJ+6yDNoRa0BGXqLisY4Yt/Qs5tS4tQuLTM=;
        b=Lnr4Vpipr9eoHCBAXs0vIMZqnnLOPt5XJJY6hZEYAEXJLxFHjgBAEVv1hMRDeE70Zu
         SPfvjE9sH0FPF2chVvLMxOf68LUhxTq+qZ/JYFtOm/zKjaGbRZSyxuO/WEzk1e+/jPcf
         wa8p46aN3DkPxs0WMp+llHSAdjEt6ZVLeBHVZF0ydb4SyhCi7gM/XYPNq96BaVzTlZPO
         tnE+xKkoiZsZq8OWZR65+m4MG9uSN8HUF+c61TlJdXXZGZWuw9/X3h5jvYTJ/Ahv+vt5
         2d00sw6ydU3gfg7oAsyhyneHfaFA/Tr92JOoGVJj5XskNx8aAQJ7euKvLBShn+SZXz9j
         VhNQ==
In-Reply-To: <20210205182806.17220-9-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Fri, Feb 5, 2021 at 10:28 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> With memcg having switched to rstat, memory.stat output is precise.
> Update the cgroup selftest to reflect the expectations and error
> tolerances of the new implementation.
>
> Also add newly tracked types of memory to the memory.stat side of the
> equation, since they're included in memory.current and could throw
> false positives.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
