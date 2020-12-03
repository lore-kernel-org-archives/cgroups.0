From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: Regression from 5.7.17 to 5.9.9 with memory.low cgroup
 constraints
Date: Thu, 3 Dec 2020 12:55:59 -0800
Message-ID: <20201203205559.GD1571588@carbon.DHCP.thefacebook.com>
References: <20201125123956.61d9e16a@hemera>
 <20201125182103.GA840171@carbon.dhcp.thefacebook.com>
 <20201203120936.4cadef43@hemera.lan.sysophe.eu>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lZhekP6mzoq30SS4PB0VYyBPLQxAcW7fNLlIOLcDDXM=;
 b=myPDnIJuty09/yxOTKYj6q3XsAPVorxvakhG2bLvi2Fbve1i0ZhL6TZIbwhvLc5JO3AZ
 Z6O657zCLOIa1p/lDfu+dAJDt4B72aDOZb6bhEgwMwqTzPbnDB5Rt7OAaAjKe1XU0C0K
 Ke2hd1FZhwMx4kSCa4rWwp0nlSa+SM6EvuU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g64YEGb67PwKMMN54hySbYYWQ254ZpUKKU3PgzcbiM8=;
 b=IBj9L44tANL9OUkQQq4U3ZcZIHkxaHjyy6ZOG41w4QKjYe/xZ+x5hU+udmyLsIaiFpAlX3PjMNWL3VtTsaWXP4R9dKWdnwx0SJ/JWPJieSFbdPfNg6gBnQ6kYHj2/yFp7linhyWNsvxjxzxz8dlTJ4seWyWt/kEGjo3rbyYmZqo=
Content-Disposition: inline
In-Reply-To: <20201203120936.4cadef43-pDZhbqX7CfkoGc32E1+a2S4z1YicLaQ4@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Cc: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, Dec 03, 2020 at 12:09:36PM +0100, Bruno Pr=E9mont wrote:
> Hello Roman,
>=20
> Sorry for having taken so much time to reply, I've only had the
> opportunity to deploy the patch on Tuesday morning for testing and
> now two days later the trashing occurred again.
>=20
> > diff --git a/mm/slab.h b/mm/slab.h
> > index 6cc323f1313a..ef02b841bcd8 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > @@ -290,7 +290,7 @@ static inline struct obj_cgroup *memcg_slab_pre_all=
oc_hook(struct kmem_cache *s,
> > =20
> >         if (obj_cgroup_charge(objcg, flags, objects * obj_full_size(s))=
) {
> >                 obj_cgroup_put(objcg);
> > -               return NULL;
> > +               return (struct obj_cgroup *)-1UL;
> >         }
> > =20
> >         return objcg;
> > @@ -501,9 +501,13 @@ static inline struct kmem_cache *slab_pre_alloc_ho=
ok(struct kmem_cache *s,
> >                 return NULL;
> > =20
> >         if (memcg_kmem_enabled() &&
> > -           ((flags & __GFP_ACCOUNT) || (s->flags & SLAB_ACCOUNT)))
> > +           ((flags & __GFP_ACCOUNT) || (s->flags & SLAB_ACCOUNT))) {
> >                 *objcgp =3D memcg_slab_pre_alloc_hook(s, size, flags);
> > =20
> > +               if (unlikely(*objcgp =3D=3D (struct obj_cgroup *)-1UL))
> > +                       return NULL;
> > +       }
> > +
> >         return s;
> >  }
>=20
> Seems your proposed patch didn't really help.

Anyway, thank you for testing! Actually your report helped me to reveal and
fix this problem, so thank you!

In the meantime Yang Shi discovered a problem related slab shrinkers,
which is to some extent similar to what you describe: under certain conditi=
ons
large amounts of slab memory can be completely excluded from the reclaim pr=
ocess.

Can you, please, check if his fix will solve your problem?
Here is the final version: https://www.spinics.net/lists/stable/msg430601.h=
tml .

>=20
>=20
>=20
> Compared to initial occurrence I do now have some more details (all but
> /proc/slabinfo since boot) and according to /proc/slabinfo a good deal
> of reclaimable slabs seem to be dentries (and probably
> xfs_inode/xfs_ifork related to them) - not sure if those are assigned
> to cgroups or not-accounted and not seen as candidate for reclaim...
>=20
> xfs_buf           444908 445068    448   36    4 : tunables    0    0    =
0 : slabdata  12363  12363      0
> xfs_bui_item           0      0    232   35    2 : tunables    0    0    =
0 : slabdata      0      0      0
> xfs_bud_item           0      0    200   40    2 : tunables    0    0    =
0 : slabdata      0      0      0
> xfs_cui_item           0      0    456   35    4 : tunables    0    0    =
0 : slabdata      0      0      0
> xfs_cud_item           0      0    200   40    2 : tunables    0    0    =
0 : slabdata      0      0      0
> xfs_rui_item           0      0    712   46    8 : tunables    0    0    =
0 : slabdata      0      0      0
> xfs_rud_item           0      0    200   40    2 : tunables    0    0    =
0 : slabdata      0      0      0
> xfs_icr                0    156    208   39    2 : tunables    0    0    =
0 : slabdata      4      4      0
> xfs_ili           1223169 1535904    224   36    2 : tunables    0    0  =
  0 : slabdata  42664  42664      0
> xfs_inode         12851565 22081140   1088   30    8 : tunables    0    0=
    0 : slabdata 736038 736038      0
> xfs_efi_item           0    280    456   35    4 : tunables    0    0    =
0 : slabdata      8      8      0
> xfs_efd_item           0    280    464   35    4 : tunables    0    0    =
0 : slabdata      8      8      0
> xfs_buf_item           7    216    296   27    2 : tunables    0    0    =
0 : slabdata      8      8      0
> xf_trans               0    224    288   28    2 : tunables    0    0    =
0 : slabdata      8      8      0
> xfs_ifork         12834992 46309928     72   56    1 : tunables    0    0=
    0 : slabdata 826963 826963      0
> xfs_da_state           0    224    512   32    4 : tunables    0    0    =
0 : slabdata      7      7      0
> xfs_btree_cur          0    224    256   32    2 : tunables    0    0    =
0 : slabdata      7      7      0
> xfs_bmap_free_item      0    230     88   46    1 : tunables    0    0   =
 0 : slabdata      5      5      0
> xfs_log_ticket         4    296    216   37    2 : tunables    0    0    =
0 : slabdata      8      8      0
> fat_inode_cache        0      0    744   44    8 : tunables    0    0    =
0 : slabdata      0      0      0
> fat_cache              0      0     64   64    1 : tunables    0    0    =
0 : slabdata      0      0      0
> mnt_cache            114    180    448   36    4 : tunables    0    0    =
0 : slabdata      5      5      0
> filp                6228  15582    384   42    4 : tunables    0    0    =
0 : slabdata    371    371      0
> inode_cache         6669  16016    608   26    4 : tunables    0    0    =
0 : slabdata    616    616      0
> dentry            8092159 15642504    224   36    2 : tunables    0    0 =
   0 : slabdata 434514 434514      0
>=20
>=20
>=20
> The full collected details are available at
>   https://faramir-fj.hosting-restena.lu/cgmon-20201203.txt=20
> (please take a copy as that file will not stay there forever)
>=20
> A visual graph of memory evolution is available at
>   https://faramir-fj.hosting-restena.lu/system-memory-20201203.png=20
> with reboot on Tuesday morning and steady increase of slabs starting
> Webnesday evening correlating with start of backup until trashing
> started at about 3:30 and the large drop in memory being me doing
>   echo 2 > /proc/sys/vm/drop_caches
> which stopped the trashing as well.
>=20
>=20
> Against what does memcg attempt reclaim when it tries to satisfy a CG's
> low limit? Only against siblings or also against root or not-accounted?
> How does it take into account slabs where evictable entries will cause
> unevictable entries to be freed as well?

Low limits are working by excluding some portions of memory from the reclai=
m,
not by adding a memory pressure to something else.

>=20
> > > My setup, server has 64G of RAM:
> > >   root
> > >    + system        { min=3D0, low=3D128M, high=3D8G, max=3D8G }
> > >      + base        { no specific constraints }
> > >      + backup      { min=3D0, low=3D32M, high=3D2G, max=3D2G }
> > >      + shell       { no specific constraints }
> > >   + websrv         { min=3D0, low=3D4G, high=3D32G, max=3D32G }
> > >   + website        { min=3D0, low=3D16G, high=3D40T, max=3D40T }
> > >     + website1     { min=3D0, low=3D64M, high=3D2G, max=3D2G }
> > >     + website2     { min=3D0, low=3D64M, high=3D2G, max=3D2G }
> > >       ...
> > >   + remote         { min=3D0, low=3D1G, high=3D14G, max=3D14G }
> > >     + webuser1     { min=3D0, low=3D64M, high=3D2G, max=3D2G }
> > >     + webuser2     { min=3D0, low=3D64M, high=3D2G, max=3D2G }
> > >       ...
>=20
> Also interesting is that backup which is forced into 2G
> (system/backup CG) causes amount of slabs assigned to websrv CG to
> increase until that CG has almost only slab entries assigned to it to
> fill 16G, like file cache being reclaimed but not slab entries even if
> there is almost no file cache left and tons of slabs.
> What I'm also surprised is the so much memory remains completely unused
> (instead of being used for file caches).
>=20
> According to the documentation if I didn't get it wrong any limits of
> child CGs (e.g. webuser1...) are applied up to what their parent's
> limits allow. Thus, if looking at e.g. remote -> webuser1... even if I
> have 1000 webuserN they wont "reserve" 65G for themselves via
> memory.low limit when their parent sets memory.low to 1G?
> Or does this depend on on CG mount options (memory_recursiveprot)?

It does. What you're describing is the old (!memory_recursiveprot) behavior.

Thanks!
