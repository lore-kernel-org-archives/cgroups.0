From: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] mm: memcontrol: remove mem_cgroup_kmem_disabled
Date: Tue, 30 Aug 2022 15:45:01 +0800
Message-ID: <CAMgjq7DTSXavytZUraNy0uGu9D+WngBKXMTjoA4Xha1NEUminA@mail.gmail.com>
References: <20220830055949.12640-1-ryncsn@gmail.com> <20220830055949.12640-2-ryncsn@gmail.com>
 <Yw2x6T3xchjpzX7j@dhcp22.suse.cz> <CAMgjq7A+Ju247rC7+fo9jcZpK8rkd0Ou6e=7qzgL4rV3JWBX5w@mail.gmail.com>
 <Yw24cFGTtOZF7Cgw@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=96IRGBfcr5J9/GRtulzalfsCYmkGXye7ZPp+1XPMemc=;
        b=ZaLX9vwlsNnUkPUmS7uMrUQJ7sNnSHEUaPBpt/On8HRnJbnSVy/lt90ZvWaMRgor2i
         Ph/rqPOrHM7aPfcaIlY/XJfjku5scFdKAyvPfDJa9ks7ySKCKEO0BxxGEFjnF39umarH
         AMMDGE9E6m0WhJbo6qgTLl1DORwnZX2YcomKG8ffyLrZT/NEXUpoVxGH5gUhiyEZGnqO
         PgRJvnA6bxgbbt2Rwl8MTOpxXAjj8XWtjK+XDpKSlB2qMxtkiIgo/MCR82RisAtQBsxF
         s+vPiZvoPHE8IFRDP2KxneJsozXta4d922Ya/hudxh32NBklMno0ZG7SB1NjCvkqQjAk
         2w/g==
In-Reply-To: <Yw24cFGTtOZF7Cgw-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> =E4=BA=8E2022=E5=B9=B48=E6=9C=8830=E6=97=A5=
=E5=91=A8=E4=BA=8C 15:12=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue 30-08-22 15:06:57, Kairui Song wrote:
> > Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> =E4=BA=8E2022=E5=B9=B48=E6=9C=8830=E6=97=
=A5=E5=91=A8=E4=BA=8C 14:45=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Tue 30-08-22 13:59:48, Kairui Song wrote:
> > > > From: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> > > >
> > > > There are currently two helpers for checking if cgroup kmem
> > > > accounting is enabled:
> > > >
> > > > - mem_cgroup_kmem_disabled
> > > > - memcg_kmem_enabled
> > >
> > > Yes, this is a bit confusing indeed!
> > >
> > > > mem_cgroup_kmem_disabled is a simple helper that returns true if
> > > > cgroup.memory=3Dnokmem is specified, otherwise returns false.
> > > >
> > > > memcg_kmem_enabled is a bit different, it returns true if
> > > > cgroup.memory=3Dnokmem is not specified and there is at least one
> > > > non-root cgroup ever created. And once there is any non-root memcg
> > > > created, it won't go back to return false again.
> > > >
> > > > This may help improve performance for some corner use cases where
> > > > the user enables memory cgroup and kmem accounting globally but nev=
er
> > > > create any cgroup.
> > > >
> > > > Considering that corner case is rare, especially nowadays cgroup is
> > > > widely used as a standard way to organize services.
> > >
> > > Is it really that rare? Most configurations would use a default setup=
, so
> > > both MEMCG enabled and without nokmem on cmd line yet the memory
> > > controller is not enabled in their setups.
> >
> > Actually I don't have too much confidence saying that as well... but
> > AFAIK, almost all distros will create a few sub cgroup on boot by the
> > init (eg. openrc, finit, systemd).
>
> Yeah, but do they enable the memory controller as well? Unless I am
> missing something this will require at least one memcg enabled cgroup to
> be created.

Systemd enable memory controller by default since ver 238 from 2018,
but I'm not sure about the others.
Now I think I was wrong about the assumption, will be sure to do more
homework next time.

And thanks for the review!
