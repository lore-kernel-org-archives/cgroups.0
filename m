From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 15/19] kernfs: split ->kill_sb
Date: Mon, 18 Sep 2023 17:24:11 +0200
Message-ID: <vqax7efvf5h4agxge5g43pdl6tsa5on5mob74bydydd5vdxwb5@5fj2qgmuxjj3>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-16-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fb5cgu6m55xbwjgl"
Return-path: <linux-usb+bounces-328-glug-linux-usb=m.gmane-mx.org-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1695050653; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZTsaizh9uJKTEcz6c5p2g2QGw5JzmlLl2sAISOCHTb0=;
	b=uNDNyyEycKJBCT8u9QqHT2QXUZQSV7KEwqPhRKMT8g78tvewNow7/PM0Dx8tyzi3UtSwzx
	cITrOJ3w7steQa1htyVtogiSbMXtJDg/hwSQ96Jf43HJYSsCYwhj25c8Sf6DEVuyfURH1Y
	aU9810o4zzQKZkEvrA6beovh34oBypU=
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:linux-usb+subscribe-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Unsubscribe: <mailto:linux-usb+unsubscribe-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230913111013.77623-16-hch-jcswGhMUV9g@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardeni


--fb5cgu6m55xbwjgl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 13, 2023 at 08:10:09AM -0300, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wr=
ote:
> Split the kernfs_kill_sb helper into helpers for the new split
> shutdown_sb and free_sb methods.  Note that resctrl has very odd
> locking in ->kill_sb, so this commit only releases the locking
> acquired in rdt_shutdown_sb in rdt_free_sb.  This is not very good
> code and relies on ->shutdown_sb and ->free_sb to always be called
> in pairs, which it currently is.  The next commit will try to clean
> this up.
>=20
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c | 12 +++++++++---
>  fs/kernfs/mount.c                      | 18 ++++++++----------
>  fs/sysfs/mount.c                       |  7 ++++---
>  include/linux/kernfs.h                 |  5 ++---
>  kernel/cgroup/cgroup.c                 | 10 ++++++----
>  5 files changed, 29 insertions(+), 23 deletions(-)

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

(Also, I didn't find a necessity to have kernfs_free_sb(sb) under
rdtgroup_mutex, so folding the following patch of the series may be fine
too.)


--fb5cgu6m55xbwjgl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZQhrmQAKCRAGvrMr/1gc
joA0AQCDANwuvql51NVbMvBdMPjFI6Th8lDr5goiUMJIkDInfAEAgIpZtJp32qUD
1HpNpPzzwxVHRHauSQjOpc8j5wdn+Qk=
=yjqf
-----END PGP SIGNATURE-----

--fb5cgu6m55xbwjgl--

