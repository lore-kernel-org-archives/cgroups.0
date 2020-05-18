From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v3 3/3] mm: automatically penalize tasks with high
 swap use
Date: Mon, 18 May 2020 12:42:10 -0700
Message-ID: <20200518124210.37335d0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200515202027.3217470-1-kuba@kernel.org>
        <20200515202027.3217470-4-kuba@kernel.org>
        <CALvZod5Dcee8CaNfkhQQbvC1OuOTO7qE9bJw9NAa8nd2Cru6hA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589830933;
        bh=oF7IhR6sg52j1XJLokffl+JRh2aq7CdtTjmwU6+Sth8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eghQgmRQbj64PWGWC2pjySV1CgaF5LBoo2DwG+QKNJR+6L9j06rjcK8oXnRZ6qiZU
         toNZcgfIkOgrPlK0oZWXub6dm+a/FUHrHCiHaLV1sY9ZEJO3LM5D9CeGpqqojJgyDL
         zeGq1BHOialio2xxosyUgzHzopcxsiRzvQNyxhcs=
In-Reply-To: <CALvZod5Dcee8CaNfkhQQbvC1OuOTO7qE9bJw9NAa8nd2Cru6hA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Sun, 17 May 2020 06:44:52 -0700 Shakeel Butt wrote:
> > Use one counter for number of pages allocated under pressure
> > to save struct task space and avoid two separate hierarchy
> > walks on the hot path.
> 
> The above para seems out of place. It took some time to realize you
> are talking about current->memcg_nr_pages_over_high. IMO instead of
> this para, a comment in code would be much better.

Where would you like to see the comment? In struct task or where
counter is bumped?

> > Take the new high limit into account when determining if swap
> > is "full". Borrowing the explanation from Johannes:
> >
> >   The idea behind "swap full" is that as long as the workload has plenty
> >   of swap space available and it's not changing its memory contents, it
> >   makes sense to generously hold on to copies of data in the swap
> >   device, even after the swapin. A later reclaim cycle can drop the page
> >   without any IO. Trading disk space for IO.
> >
> >   But the only two ways to reclaim a swap slot is when they're faulted
> >   in and the references go away, or by scanning the virtual address space
> >   like swapoff does - which is very expensive (one could argue it's too
> >   expensive even for swapoff, it's often more practical to just reboot).
> >
> >   So at some point in the fill level, we have to start freeing up swap
> >   slots on fault/swapin.  
> 
> swap.high allows the user to force the kernel to start freeing swap
> slots before half-full heuristic, right?

I'd say that the definition of full is extended to include swap.high.
