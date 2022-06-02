From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v5 09/11] mm: memcontrol: use obj_cgroup APIs to charge
 the LRU pages
Date: Thu, 2 Jun 2022 12:14:06 +0800
Message-ID: <Ypg5DhrXCEAazDE9@FVFYT0MHHV2J.googleapis.com>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530074919.46352-10-songmuchun@bytedance.com>
 <20220601173438.GC2434@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=o/UKlvjBmq/GEr5NrImr3MrgSwxgE88wiN4r50yamSw=;
        b=DZpIXcD/hmaZBUagAs3C2t/0HooyyKDjMlX2Mq/6f09fzuif5gF+Pm+6Edmc4Wblaw
         s5vRGKy2d9fkaseDxbQMVER68m3eMGq9P5FvWNFIQby1IsLn2ECsFvlsgZ89+aRpPM2q
         zf6phcx67MW4xWbVzj2tLCHWBZIzJYohlxxQ05NKm/uksVQe9lc4+nZx0/kW6j/cGUBG
         Pze9qfPd4iU6Elm+1R/2ylR4DzXuC3Epg9G47dRB67gZVFOS+h00nX0vtP1eq4Zjx0a6
         kzIrgs83pD7a82U7tUoShqimRbTpknzJI1BIJP6U3oEOcmlrsCArZ7c6jng/BkO5h4rg
         5H/Q==
Content-Disposition: inline
In-Reply-To: <20220601173438.GC2434-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Wed, Jun 01, 2022 at 07:34:38PM +0200, Michal Koutn=FD wrote:
> Hello Muchun.
>=20
> On Mon, May 30, 2022 at 03:49:17PM +0800, Muchun Song <songmuchun-EC8Uxl6=
Npydl57MIdRCFDg@public.gmane.org> wrote:
> > +static inline bool obj_cgroup_is_root(struct obj_cgroup *objcg)
> > +{
> > +	return objcg =3D=3D root_obj_cgroup;
> > +}
>=20
> Admittedly, this predicate alone caught my eye, why it did not also
> check root_mem_cgroup->objcg_list.
> However, deeper look reveals it's purpose is to avoid missing uncharges
> of pages that were charged in non-root memcg and later re-associated
> upwards after reparenting.

Right.

> So it's like obj_cgroup_root_origin() (I'm not suggesting a rename, just
> illustrating the understanding).
>=20
> get_obj_cgroup_from_current() gains some complexity but it still holds
> that in root memcg neither kernel objects nor LRU pages are charged.
> At the same time, reparented kernel objects or LRU pages are properly
> uncharged.
>=20
> These parts are=20
> Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
>=20

Thanks Michal.

> (I did not look into the locking guarantees with the new API though.)
>=20
>=20
