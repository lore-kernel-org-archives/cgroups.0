From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: update parent subparts cpumask while
 holding css refcnt
Date: Tue, 11 Jul 2023 13:52:50 +0200
Message-ID: <tebnrmbl6ouz567vlalojcynk25siwwom7et7yn2vvi6zyv6nv@jj3r5o3kl52j>
References: <20230701065049.1758266-1-linmiaohe@huawei.com>
 <fbabnjfly5w6fxrhe3eu6ebspngz2hd3tqs6rrbropcdvylnhs@ayjdpq73kwui>
 <74f1906e-fe58-c745-a851-b160374f7acf@redhat.com>
 <30b1f809-a11b-efe8-289c-04a801f20207@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rpxvczwrelgzbfqd"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1689076371; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4te5JwumvF8/GIgkO+TJ0V5B1TkpxMPkr04XN6p1A28=;
        b=VZJbzOP9afXhZN7G+sPdUEroSa0FtkyX6R848TJmsI6bwBCCzelW/44TukY+ylg/n2eRgQ
        +aKbEHzo+IgUHChuHawdB5oSk1EA0paU+2ES+ZtylsWY50PVEZLah94VKtl3TuGfOKWumd
        65r259bjXC3jaokWPET6XBTaeGYyy9E=
Content-Disposition: inline
In-Reply-To: <30b1f809-a11b-efe8-289c-04a801f20207-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--rpxvczwrelgzbfqd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 11, 2023 at 10:52:02AM +0800, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>=
 wrote:
> commit 2bdfd2825c9662463371e6691b1a794e97fa36b4
> Author: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Wed Feb 2 22:31:03 2022 -0500
>=20
>     cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning

Aha, thanks for the pointer.

I've also found a paragraph in [1]:
> In addition, the -rt patchset turns spinlocks into a sleeping locks so
> that the corresponding critical sections can be preempted, which also
> means that these sleeplockified spinlocks (but not other sleeping
> locks!) may be acquire within -rt-Linux-kernel RCU read-side critical
> sections.

That suggests (together with practical use) that dicussed spinlocks
should be fine in RCU read section. And the possible reason is deeper in
generate_sched_domains() that do kmalloc(..., GFP_KERNEL).

Alas update_cpumask_hier() still calls generate_sched_domains(), OTOH,
update_parent_subparts_cpumask() doesn't seem so.

The idea to not relieve rcu_read_lock() in update_cpumask() iteration
(instead of the technically unneeded refcnt bump) would have to be
verified with CONFIG_PROVE_RCU && CONFIG_LOCKDEP. WDYT?

Michal

[1] https://www.kernel.org/doc/html/latest/RCU/Design/Requirements/Requirem=
ents.html?highlight=3Drcu+read+section#specialization

--rpxvczwrelgzbfqd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZK1CkAAKCRAGvrMr/1gc
jslQAP9hbBzspCiXduaN1xbeQyV+ZnUhEAOznzhyLOo8+dDxRgEA3FXd5SDDuVMJ
87l6UFwCe1ThIrCymWRsgFxk2a+AJws=
=Xt4s
-----END PGP SIGNATURE-----

--rpxvczwrelgzbfqd--
