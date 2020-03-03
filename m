From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] memcg: css_tryget_online cleanups
Date: Tue, 3 Mar 2020 15:49:41 -0800
Message-ID: <CALvZod7C9nrS4S36AfTY74cx0=58LXNNh_b+mXzXNG1j9_6RZg@mail.gmail.com>
References: <20200302203109.179417-1-shakeelb@google.com> <20200303093251.GD4380@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tpXe9qW1IE+W6FbdZ2WrOfJnBA8frqrFQCxhnKyXLE4=;
        b=bB6r52TIAf9ibs8y+NORyBaaxS8dDSOoFewL5V+z/CPv0VD4b2OXTG6GjdIJmrw58z
         cwXa6SOKYzcoE6dWgm+bCSol1ivF2L9qVLVRz3mKzFvrJAPRf4PWTkXNXW/is292Zn74
         J55/rf2DmiKqvpVC6Odc7IREGf3IQi86Z6kTQ7sARuwR+Lvq65kG2x/EoNvUplkvFTO8
         bSq3pb01X7RoInfsU5ZI55las/N8rTcK8Glm07jN+KgrytBr1AfviEAZU3goLEalPW+n
         doZIGwWim8QgvhWhdUTNejU9cr0K+fD99+36FFBaMy74hYx5hyy0UMccTYHE1fqqH6cy
         gT/g==
In-Reply-To: <20200303093251.GD4380-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Mar 3, 2020 at 1:32 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Mon 02-03-20 12:31:09, Shakeel Butt wrote:
> > Currently multiple locations in memcg code, css_tryget_online() is being
> > used. However it doesn't matter whether the cgroup is online for the
> > callers. Online used to matter when we had reparenting on offlining and
> > we needed a way to prevent new ones from showing up.
> >
> > The failure case for couple of these css_tryget_online usage is to
> > fallback to root_mem_cgroup which kind of make bypassing the memcg
> > limits possible for some workloads. For example creating an inotify
> > group in a subcontainer and then deleting that container after moving the
> > process to a different container will make all the event objects
> > allocated for that group to the root_mem_cgroup. So, using
> > css_tryget_online() is dangerous for such cases.
> >
> > Two locations still use the online version. The swapin of offlined
> > memcg's pages and the memcg kmem cache creation. The kmem cache indeed
> > needs the online version as the kernel does the reparenting of memcg
> > kmem caches. For the swapin case, it has been left for later as the
> > fallback is not really that concerning.
>
> Could you be more specific about the swap in case please?
>

With swap accounting enabled, if the memcg of the swapped out page is
not online then the memcg extracted from the given 'mm' will be
charged and if 'mm' is NULL then root memcg will be charged. However I
could not find a code path where the given 'mm' will be NULL for
swap-in case.

>
> > Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Other than that nothing really jumped at me although I have to confess
> that I am far from deeply familiar with the sk_buff charging path.
>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks.
