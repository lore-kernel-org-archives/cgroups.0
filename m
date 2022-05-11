From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: kernfs memcg accounting
Date: Tue, 10 May 2022 20:06:24 -0700
Message-ID: <YnsoMEuWjlpDcmt3@carbon>
References: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org>
 <20220427140153.GC9823@blackbody.suse.cz>
 <7509fa9f-9d15-2f29-cb2f-ac0e8d99a948@openvz.org>
 <YnBLge4ZQNbbxufc@blackbook>
 <52a9f35b-458b-44c4-7fc8-d05c8db0c73f@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652238390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N9oPpCxajvjGUrmg0f6gckutPEOOPZaEku255Vyx78E=;
        b=ctkko5zKqXKRqBvkI7AzNbCPvjk+mTf48++bYM8Vcq12dt+8H2aFcWCV2RRm0dO0MO8OB8
        Ba3SyHMRE06mHqGuEi54JOaGxRgkuyMtv6h+EXp/ar9SvCbnAIfMlnyYueJ9jdGUKnfPKe
        s3kYwBI2w4ZRgaXnU6KOHUMVmTVg09M=
Content-Disposition: inline
In-Reply-To: <52a9f35b-458b-44c4-7fc8-d05c8db0c73f-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Wed, May 04, 2022 at 12:00:18PM +0300, Vasily Averin wrote:
> On 5/3/22 00:22, Michal Koutn=FD wrote:
> > When struct mem_cgroup charging was introduced, there was a similar
> > discussion [1].
>=20
> Thank you, I'm missed this patch, it was very interesting and useful.
> I would note though, that OpenVZ and LXC have another usecase:
> we have separate and independent systemd instances inside OS containers.
> So container's cgroups are created not in host's root memcg but=20
> inside accountable container's root memcg. =20
>=20
> > I can see following aspects here:
> > 1) absolute size of kernfs_objects,
> > 2) practical difference between a) and b),
> > 3) consistency with memcg,
> > 4) v1 vs v2 behavior.
> ...
> > How do these reasonings align with your original intention of net
> > devices accounting? (Are the creators of net devices inside the
> > container?)
>=20
> It is possible to create netdevice in one namespace/container=20
> and then move them to another one, and this possibility is widely used.
> With my patch memory allocated by these devices will be not accounted
> to new memcg, however I do not think it is a problem.
> My patches protect the host mostly from misuse, when someone creates
> a huge number of nedevices inside a container.
>=20
> >> Do you think it is incorrect and new kernfs node should be accounted
> >> to memcg of parent cgroup, as mem_cgroup_css_alloc()-> mem_cgroup_allo=
c() does?
> >=20
> > I don't think either variant is incorrect. I'd very much prefer the
> > consistency with memcg behavior (variant a)) but as I've listed the
> > arguments above, it seems such a consistency can't be easily justified.
>=20
> From my point of view it is most important to account allocated memory
> to any cgroup inside container. Select of proper memcg is a secondary goa=
l here.
> Frankly speaking I do not see a big difference between memcg of current p=
rocess,
> memcg of newly created child and memcg of its parent.
>=20
> As far as I understand, Roman chose the parent memcg because it was a spe=
cial
> case of creating a new memory group. He temporally changed active memcg
> in mem_cgroup_css_alloc() and properly accounted all required memcg-speci=
fic
> allocations.

My primary goal was to apply the memory pressure on memory cgroups with a l=
ot
of (dying) children cgroups. On a multi-cpu machine a memory cgroup structu=
re
is way larger than a page, so a cgroup which looks small can be really large
if we calculate the amount of memory taken by all children memcg internals.

Applying this pressure to another cgroup (e.g. the one which contains syste=
md)
doesn't help to reclaim any pages which are pinning the dying cgroups.

For other controllers (maybe blkcg aside, idk) it shouldn't matter, because
there is no such problem there.

For consistency reasons I'd suggest to charge all *large* allocations
(e.g. percpu) to the parent cgroup. Small allocations can be ignored.

Thanks!
