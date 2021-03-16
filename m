From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Date: Tue, 16 Mar 2021 14:02:03 -0700
Message-ID: <20210316140203.0d5ddf33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
        <CAOFY-A1L8c626HZYSWm6ZKFO9mqBdBszv6obX4-1_LmDBQ6Z4A@mail.gmail.com>
        <CALvZod7hgtdrN_KXD_5JdB2vzJzTc8tVz_5YFN53-xZjpHLLRw@mail.gmail.com>
        <CAOFY-A0v2BEwRinhPXspjL_3dvyw2kDSyzQgUiJxc+P-3OLP8g@mail.gmail.com>
        <CAOFY-A2q4otqu=pD60tUiD0GTDZnpcm+zajFp6SRDh4VixbV2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615928524;
        bh=JabW6V+JpL9pQaNpNRb0IG759fPR+7+Gv+pQSojDt34=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jOk9a5TPgHzTAN5ehOWPg8HuwPQrH0q3mHqJ37unDnf1PG40sZpnvwxU0T71BAchP
         hFOCtYBamTnnDN8DKucrMp3+1m+zX0yKiENOlLQ5rhTpz0ZAs5WQUmnNnDoWeV8dYO
         vaz0OjRFROztRXqg5zRMktFltLTYjih7InXGuqaloONOH1JqpaZHzO3J+Y0fEXWxVb
         dHDbX9DC8B96C+NvnXBkeKm9VMCExKXNHI3G4dFi1HIPBAGNwoncDrLuF/RkBzZtfS
         uPoSY6JW+5yhuSk3iT7ZaWnHEBiVPWKbzOgDyBPYKu5pKU/bIrVHdz++B0lMxRqB0G
         /BhHwJErBjG5A==
In-Reply-To: <CAOFY-A2q4otqu=pD60tUiD0GTDZnpcm+zajFp6SRDh4VixbV2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Arjun Roy <arjunroy.kdev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Mon, 15 Mar 2021 23:28:08 -0700 Arjun Roy wrote:
> On Mon, Mar 15, 2021 at 11:22 PM Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Mon, Mar 15, 2021 at 9:29 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:  
> > >
> > > On Mon, Mar 15, 2021 at 9:20 PM Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:  
>  [...]  
> > > [...]  
>  [...]  
>  [...]  
> > >
> > > It is due to "mm: page-writeback: simplify memcg handling in
> > > test_clear_page_writeback()" patch in the mm tree. You would need to
> > > reintroduce the lock_page_memcg() which returns the memcg and make
> > > __unlock_page_memcg() non-static.  
> >
> > To clarify, Shakeel - the tag "tag: v5.12-rc2-mmots-2021-03-11-21-49"
> > fails to build on a clean checkout, without this patch, due to a
> > compilation failure in mm/shmem.c, for reference:
> > https://pastebin.com/raw/12eSGdGD
> > (and that's why I'm basing this patch off of net-next in this email).
> >
> > -Arjun  
> 
> Another seeming anomaly - the patch sent out passes
> scripts/checkpatch.pl but netdev/checkpatch finds plenty of actionable
> fixes here: https://patchwork.kernel.org/project/netdevbpf/patch/20210316041645.144249-1-arjunroy.kdev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/
> 
> Is netdev using some other automated checker instead of scripts/checkpatch.pl?

--strict --max-line-length=80
