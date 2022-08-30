From: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] mm: memcontrol: remove mem_cgroup_kmem_disabled
Date: Tue, 30 Aug 2022 15:06:57 +0800
Message-ID: <CAMgjq7A+Ju247rC7+fo9jcZpK8rkd0Ou6e=7qzgL4rV3JWBX5w@mail.gmail.com>
References: <20220830055949.12640-1-ryncsn@gmail.com> <20220830055949.12640-2-ryncsn@gmail.com>
 <Yw2x6T3xchjpzX7j@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=I6h+p+HXVP3mSqfdvkmPovmRewn0b+siAgR4AO+P2BE=;
        b=Y3eReunSE2Y54gGd+4yIdZ0icTwQ5EJ/3dWQgm/g6JFNU/y72JrhdvOTk32zvNxcFd
         YqToO/fmRoRruDY85/WP3/6GEu6ZpU2qXYmfCRhJ6P0l/AXwXBzZMibHdBySun+aifOz
         aGGehvk94R59ZeGRUPSTvaIo/lDczky3Ea3QpAGWmTR4/MZ8OUVBlt8DkqecYft03QyL
         /HmLgCE5weDZbiSxff706yg9YZD5GnG4RKMF/aJ7Cs29cmE1xOPJqF9zPtOPNi4mS2e2
         9cN7/wjPKiXLFdIclE3ZEFWNp8kYcQjof69Pir0esfprnaTn5AATb0v5m5OKafI8+XhS
         8f9A==
In-Reply-To: <Yw2x6T3xchjpzX7j-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> =E4=BA=8E2022=E5=B9=B48=E6=9C=8830=E6=97=A5=
=E5=91=A8=E4=BA=8C 14:45=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue 30-08-22 13:59:48, Kairui Song wrote:
> > From: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> >
> > There are currently two helpers for checking if cgroup kmem
> > accounting is enabled:
> >
> > - mem_cgroup_kmem_disabled
> > - memcg_kmem_enabled
>
> Yes, this is a bit confusing indeed!
>
> > mem_cgroup_kmem_disabled is a simple helper that returns true if
> > cgroup.memory=3Dnokmem is specified, otherwise returns false.
> >
> > memcg_kmem_enabled is a bit different, it returns true if
> > cgroup.memory=3Dnokmem is not specified and there is at least one
> > non-root cgroup ever created. And once there is any non-root memcg
> > created, it won't go back to return false again.
> >
> > This may help improve performance for some corner use cases where
> > the user enables memory cgroup and kmem accounting globally but never
> > create any cgroup.
> >
> > Considering that corner case is rare, especially nowadays cgroup is
> > widely used as a standard way to organize services.
>
> Is it really that rare? Most configurations would use a default setup, so
> both MEMCG enabled and without nokmem on cmd line yet the memory
> controller is not enabled in their setups.

Actually I don't have too much confidence saying that as well... but
AFAIK, almost all distros will create a few sub cgroup on boot by the
init (eg. openrc, finit, systemd).
Maybe it's not that rare indeed.

>
> > And the "once
> > enabled never disable" behavior is kind of strange. This commit simplif=
ies
> > the behavior of memcg_kmem_enabled, making it simply the opposite of
> > mem_cgroup_kmem_disabled, always true if cgroup.memory=3Dnokmem is
> > not specified. So mem_cgroup_kmem_disabled can be dropped.
> >
> > This simplifies the code, and besides, memcg_kmem_enabled makes use
> > of static key so it has a lower overhead.
>
> I agree that this is slightly confusing and undocumented. The first step
> would be finding out why we need both outside of the memcg proper.
>
> E.g. it doesn't make much sense to me that count_objcg_event uses the
> command line variant when it should be using the dynamic (and more
> optimized no branch) variant.
>
> On the other hand pcpu_alloc_chunk seems to be different because it can
> be called before the controller is enabled but maybe we do not need to
> waste memory before that? Similarly new_kmalloc_cache. I suspect these
> are mostly to simplify the code and reduce special casing.

Yes, that's very insightful, let me tidy up the code and logic behind
and send a V2 later.
