From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] kernfs: attach uuid for every kernfs and report it in
 fsid
Date: Tue, 11 Jul 2023 16:04:03 +0200
Message-ID: <2023071159-unsigned-salvation-405d@gregkh>
References: <20230710183338.58531-1-ivan@cloudflare.com>
 <2023071039-negate-stalemate-6987@gregkh>
 <CABWYdi39+TJd1qV3nWs_eYc7XMC0RvxG22ihfq7rzuPaNvn1cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1689084246;
        bh=hkjM3kAIgQB2MsZK32Y0LnSzvU+OKdW0pajbNogIOCY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n9y6shDSvExiH8umQsf+SFCjEhlxKpJcK1FITT1X9fxWaBcy/PBj6GNyONmVduAK7
         VrN+5V1Cp/gDD5e/zaI0L7WDA3s767ezmniJorTsn3GXlqUFZeSrma97UopLdgpudB
         7GEQmf3i8/WAon5QrBgT3kivHV+TBb+xGvmBcNmI=
Content-Disposition: inline
In-Reply-To: <CABWYdi39+TJd1qV3nWs_eYc7XMC0RvxG22ihfq7rzuPaNvn1cQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon, Jul 10, 2023 at 02:21:10PM -0700, Ivan Babrou wrote:
> On Mon, Jul 10, 2023 at 12:40=E2=80=AFPM Greg Kroah-Hartman
> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> >
> > On Mon, Jul 10, 2023 at 11:33:38AM -0700, Ivan Babrou wrote:
> > > The following two commits added the same thing for tmpfs:
> > >
> > > * commit 2b4db79618ad ("tmpfs: generate random sb->s_uuid")
> > > * commit 59cda49ecf6c ("shmem: allow reporting fanotify events with f=
ile handles on tmpfs")
> > >
> > > Having fsid allows using fanotify, which is especially handy for cgro=
ups,
> > > where one might be interested in knowing when they are created or rem=
oved.
> > >
> > > Signed-off-by: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.=
org>
> > > ---
> > >  fs/kernfs/mount.c | 13 ++++++++++++-
> > >  1 file changed, 12 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> > > index d49606accb07..930026842359 100644
> > > --- a/fs/kernfs/mount.c
> > > +++ b/fs/kernfs/mount.c
> > > @@ -16,6 +16,8 @@
> > >  #include <linux/namei.h>
> > >  #include <linux/seq_file.h>
> > >  #include <linux/exportfs.h>
> > > +#include <linux/uuid.h>
> > > +#include <linux/statfs.h>
> > >
> > >  #include "kernfs-internal.h"
> > >
> > > @@ -45,8 +47,15 @@ static int kernfs_sop_show_path(struct seq_file *s=
f, struct dentry *dentry)
> > >       return 0;
> > >  }
> > >
> > > +int kernfs_statfs(struct dentry *dentry, struct kstatfs *buf)
> > > +{
> > > +     simple_statfs(dentry, buf);
> > > +     buf->f_fsid =3D uuid_to_fsid(dentry->d_sb->s_uuid.b);
> > > +     return 0;
> > > +}
> > > +
> > >  const struct super_operations kernfs_sops =3D {
> > > -     .statfs         =3D simple_statfs,
> > > +     .statfs         =3D kernfs_statfs,
> > >       .drop_inode     =3D generic_delete_inode,
> > >       .evict_inode    =3D kernfs_evict_inode,
> > >
> > > @@ -351,6 +360,8 @@ int kernfs_get_tree(struct fs_context *fc)
> > >               }
> > >               sb->s_flags |=3D SB_ACTIVE;
> > >
> > > +             uuid_gen(&sb->s_uuid);
> >
> > Since kernfs has as lot of nodes (like hundreds of thousands if not more
> > at times, being created at boot time), did you just slow down creating
> > them all, and increase the memory usage in a measurable way?
>=20
> This is just for the superblock, not every inode. The memory increase
> is one UUID per kernfs instance (there are maybe 10 of them on a basic
> system), which is trivial. Same goes for CPU usage.

Ah, ok, my fault, thanks for clearing that up.

thanks,

greg k-h
