From: Ignat Korchagin <ignat-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH] kernfs: attach uuid for every kernfs and report it in fsid
Date: Mon, 10 Jul 2023 19:43:00 +0100
Message-ID: <CALrw=nHZhczbY0BOOieTCMnYM8AnobU4ka+wfoOO+uxA9=pMjw@mail.gmail.com>
References: <20230710183338.58531-1-ivan@cloudflare.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1689014592; x=1691606592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TYRuesch5+38l9pcAr9ykkVr7diDWpCsFfENU0WyrxE=;
        b=S/q3ZU3Iydew6W5Z9meqNFt+b36KVi/V6IUz0VW9joILZuKQOnZKUKxuc6/DSRdaCS
         rgTpNyPWZ6/2lVacY5oQrZdeWSa9vrpXq4jRcP3L5qfmmOrxLAd/49EyYw87VpyEzSJr
         NA/HWAn0d5BWsQF9Rd+n2P3KPTcwmzYWlFUmY=
In-Reply-To: <20230710183338.58531-1-ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon, Jul 10, 2023 at 7:33=E2=80=AFPM Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org> w=
rote:
>
> The following two commits added the same thing for tmpfs:
>
> * commit 2b4db79618ad ("tmpfs: generate random sb->s_uuid")
> * commit 59cda49ecf6c ("shmem: allow reporting fanotify events with file =
handles on tmpfs")
>
> Having fsid allows using fanotify, which is especially handy for cgroups,
> where one might be interested in knowing when they are created or removed=
.
>
> Signed-off-by: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
> ---
>  fs/kernfs/mount.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> index d49606accb07..930026842359 100644
> --- a/fs/kernfs/mount.c
> +++ b/fs/kernfs/mount.c
> @@ -16,6 +16,8 @@
>  #include <linux/namei.h>
>  #include <linux/seq_file.h>
>  #include <linux/exportfs.h>
> +#include <linux/uuid.h>
> +#include <linux/statfs.h>
>
>  #include "kernfs-internal.h"
>
> @@ -45,8 +47,15 @@ static int kernfs_sop_show_path(struct seq_file *sf, s=
truct dentry *dentry)
>         return 0;
>  }
>
> +int kernfs_statfs(struct dentry *dentry, struct kstatfs *buf)

This probably should be declared static

> +{
> +       simple_statfs(dentry, buf);
> +       buf->f_fsid =3D uuid_to_fsid(dentry->d_sb->s_uuid.b);
> +       return 0;
> +}
> +
>  const struct super_operations kernfs_sops =3D {
> -       .statfs         =3D simple_statfs,
> +       .statfs         =3D kernfs_statfs,
>         .drop_inode     =3D generic_delete_inode,
>         .evict_inode    =3D kernfs_evict_inode,
>
> @@ -351,6 +360,8 @@ int kernfs_get_tree(struct fs_context *fc)
>                 }
>                 sb->s_flags |=3D SB_ACTIVE;
>
> +               uuid_gen(&sb->s_uuid);
> +
>                 down_write(&root->kernfs_supers_rwsem);
>                 list_add(&info->node, &info->root->supers);
>                 up_write(&root->kernfs_supers_rwsem);
> --
> 2.41.0
>

Ignat
