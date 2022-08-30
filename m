From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2] mm: memcontrol: remove mem_cgroup_kmem_disabled
Date: Tue, 30 Aug 2022 09:12:48 +0200
Message-ID: <Yw24cFGTtOZF7Cgw@dhcp22.suse.cz>
References: <20220830055949.12640-1-ryncsn@gmail.com>
 <20220830055949.12640-2-ryncsn@gmail.com>
 <Yw2x6T3xchjpzX7j@dhcp22.suse.cz>
 <CAMgjq7A+Ju247rC7+fo9jcZpK8rkd0Ou6e=7qzgL4rV3JWBX5w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661843569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eNLXbzHMzQQl1S+F8MG5tq68Rc2DBXxOVacQ+xIc0Yc=;
        b=Y/SIOnqS5qw04flbBT0UNoziQh4DL76iydFlVllZY+A0CuuiymDctwvPAVb0iymIopbpe6
        KWyit2vQ1FPjzGG9nhgthU0208gtfTPsZ9XcW/V8t71kobfUGPIF+eiPIJinYYrhCvFyX5
        qDDPWjg5H/fGrgXOVU/fO5Q+N/WngCo=
Content-Disposition: inline
In-Reply-To: <CAMgjq7A+Ju247rC7+fo9jcZpK8rkd0Ou6e=7qzgL4rV3JWBX5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 30-08-22 15:06:57, Kairui Song wrote:
> Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> 于2022年8月30日周二 14:45写道：
> >
> > On Tue 30-08-22 13:59:48, Kairui Song wrote:
> > > From: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> > >
> > > There are currently two helpers for checking if cgroup kmem
> > > accounting is enabled:
> > >
> > > - mem_cgroup_kmem_disabled
> > > - memcg_kmem_enabled
> >
> > Yes, this is a bit confusing indeed!
> >
> > > mem_cgroup_kmem_disabled is a simple helper that returns true if
> > > cgroup.memory=nokmem is specified, otherwise returns false.
> > >
> > > memcg_kmem_enabled is a bit different, it returns true if
> > > cgroup.memory=nokmem is not specified and there is at least one
> > > non-root cgroup ever created. And once there is any non-root memcg
> > > created, it won't go back to return false again.
> > >
> > > This may help improve performance for some corner use cases where
> > > the user enables memory cgroup and kmem accounting globally but never
> > > create any cgroup.
> > >
> > > Considering that corner case is rare, especially nowadays cgroup is
> > > widely used as a standard way to organize services.
> >
> > Is it really that rare? Most configurations would use a default setup, so
> > both MEMCG enabled and without nokmem on cmd line yet the memory
> > controller is not enabled in their setups.
> 
> Actually I don't have too much confidence saying that as well... but
> AFAIK, almost all distros will create a few sub cgroup on boot by the
> init (eg. openrc, finit, systemd).

Yeah, but do they enable the memory controller as well? Unless I am
missing something this will require at least one memcg enabled cgroup to
be created.

-- 
Michal Hocko
SUSE Labs
