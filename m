From: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCH] nfs: include xattr.h from fs/nfs/nfs3proc.c
Date: Mon, 3 Feb 2014 14:48:13 -0500
Message-ID: <F2DD11A7-8D32-4E1E-BB4D-7384F0932B2D@primarydata.com>
References: <20140203193107.GH30250@htj.dyndns.org>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140203193107.GH30250-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dr Fields James Bruce <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linuxnfs <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Feb 3, 2014, at 14:31, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> fs/nfs/nfs3proc.c is making use of xattr but was getting linux/xattr.=
h
> indirectly through linux/cgroup.h, which will soon drop the inclusion
> of xattr.h.  Explicitly include linux/xattr.h from nfs3proc.c so that
> compilation doesn't fail when linux/cgroup.h drops linux/xattr.h.
>=20
> As the following cgroup changes will depend on these changes, it
> probably would be easier to route this through cgroup branch.  Would
> that be okay?
>=20
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>

EWRONGMAINTAINER=85 :-)

Acked-by: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>

> Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> fs/nfs/nfs3proc.c |    1 +
> 1 file changed, 1 insertion(+)
>=20
> --- a/fs/nfs/nfs3proc.c
> +++ b/fs/nfs/nfs3proc.c
> @@ -18,6 +18,7 @@
> #include <linux/lockd/bind.h>
> #include <linux/nfs_mount.h>
> #include <linux/freezer.h>
> +#include <linux/xattr.h>
>=20
> #include "iostat.h"
> #include "internal.h"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Trond Myklebust
Linux NFS client maintainer
