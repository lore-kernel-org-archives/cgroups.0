From: Jing-Ting Wu <jing-ting.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [Bug] race condition at rebind_subsystems()
Date: Mon, 18 Jul 2022 15:44:21 +0800
Message-ID: <d8f0bc5e2fb6ed259f9334c83279b4c011283c41.camel@mediatek.com>
References: <1978e209e71905d89651e61abd07285912d412a1.camel@mediatek.com>
         <20220715115938.GA8646@blackbody.suse.cz>
         <YtGaP+e35DZYSQf0@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YtGaP+e35DZYSQf0-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, lixiong.liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, wenju.xu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, jonathan.jmchen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org

On Fri, 2022-07-15 at 06:47 -1000, Tejun Heo wrote:
> (resending, I messed up the message header, sorry)
>=20
> Hello,
>=20
> On Fri, Jul 15, 2022 at 01:59:38PM +0200, Michal Koutn=C3=BD wrote:
> > The css->rstat_css_node should not be modified if there are
> > possible RCU
> > readers elsewhere.
> > One way to fix this would be to insert synchronize_rcu() after
> > list_del_rcu() and before list_add_rcu().
> > (A further alternative (I've heard about) would be to utilize
> > 'nulls'
> > RCU lists [1] to make the move between lists detectable.)
> >=20
> > But as I'm looking at it from distance, it may be simpler and
> > sufficient
> > to just take cgroup_rstat_lock around the list migration (the
> > nesting
> > under cgroup_mutex that's held with rebind_subsystems() is fine).
>=20
> synchronize_rcu() prolly is the better fit here given how that
> list_node's
> usage, but yeah, great find.
>=20
> Thanks.
>=20

Hi Michal and Tejun,


Thanks for your suggestion.
Accroding your description, is the following patch corrent?

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1813,6 +1813,7 @@
=20
 		if (ss->css_rstat_flush) {
 			list_del_rcu(&css->rstat_css_node);
+			synchronize_rcu();
 			list_add_rcu(&css->rstat_css_node,
 				     &dcgrp->rstat_css_list);
 		}


If the patch is correct, we will add this patch to our stability test.
And we will continue to observe whether the problem is solved.
Thank you.




Best regards,
Jing-Ting Wu

