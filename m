From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Subject: Re: [patch 12/13] mm: memcontrol: rewrite charge API
Date: Mon, 23 Jun 2014 11:42:03 +0200
Message-ID: <20140623094203.GG14781@pengutronix.de>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-13-git-send-email-hannes@cmpxchg.org>
 <20140623061526.GH13440@pengutronix.de>
 <20140623093052.GG9743@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140623093052.GG9743-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org

On Mon, Jun 23, 2014 at 11:30:52AM +0200, Michal Hocko wrote:
> On Mon 23-06-14 08:15:26, Uwe Kleine-K=F6nig wrote:
> > Hello,
> >=20
> > On Wed, Jun 18, 2014 at 04:40:44PM -0400, Johannes Weiner wrote:
> > > The memcg charge API charges pages before they are rmapped - i.e.=
 have
> > > an actual "type" - and so every callsite needs its own set of cha=
rge
> > > and uncharge functions to know what type is being operated on.  W=
orse,
> > > uncharge has to happen from a context that is still type-specific=
,
> > > rather than at the end of the page's lifetime with exclusive acce=
ss,
> > > and so requires a lot of synchronization.
> > > ...
> >=20
> > this patch made it into next-20140623 as 5e49555277df (mm: memcontr=
ol: rewrite
> > charge API) and it makes efm32_defconfig (ARCH=3Darm) fail with:
> >=20
> >   CC      mm/swap.o
> > mm/swap.c: In function 'lru_cache_add_active_or_unevictable':
> > mm/swap.c:719:2: error: implicit declaration of function 'TestSetPa=
geMlocked' [-Werror=3Dimplicit-function-declaration]
> >   if (!TestSetPageMlocked(page)) {
> >   ^
> > cc1: some warnings being treated as errors
> > scripts/Makefile.build:257: recipe for target 'mm/swap.o' failed
> > make[3]: *** [mm/swap.o] Error 1
> > Makefile:1471: recipe for target 'mm/swap.o' failed
> >=20
> > imx_v4_v5_defconfig works, so probably the thing that makes
> > efm32_defconfig fail is CONFIG_MMU=3Dn.
>=20
> Fix is here:
> http://marc.info/?l=3Dlinux-mm&m=3D140330132521104
Thanks for the link.

I have another problem that makes my machine fail to boot but at least
this patch makes next compilable again for me.

Thanks
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig        =
    |
Industrial Linux Solutions                 | http://www.pengutronix.de/=
  |
