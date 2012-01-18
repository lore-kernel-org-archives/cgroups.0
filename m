From: Sha <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: revise how we re-populate root directory
Date: Wed, 18 Jan 2012 15:23:45 +0800
Message-ID: <CAFj3OHUQzShbmdCKYhWMum=hqM5XqK-_wcDyUajnZ1XWFGX1Xg@mail.gmail.com>
References: <4F13DA90.2000603@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=eRdWfUu2QcFiR5Ko4GF0UJY2nUfIOrvj1A3ky2t8dgI=;
        b=E8RiEHjSkgBqoawRzXJuJfc1HHj3BiSY9h+GXGtm4wB/Wz8yFbAZ9D3wA4z12g/bCe
         H/CGp4y4QqFdyVsOeiNJ57d5sddtqx7/9ge3V0+UP9hUUyDeGGMxFOqRv0mp1prE0cBf
         5Vjf23umugG4awP1lStn9WmxgwpedaxMJ1g6c=
In-Reply-To: <4F13DA90.2000603-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

Hi Zefan,

On Mon, Jan 16, 2012 at 4:06 PM, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org> wrote:
> When remounting cgroupfs with some subsystems added to it and some
> removed, cgroup will remove all the files in root directory and then
> re-popluate it.
>
> What I'm doing here is, only remove files which belong to subsystems =
that
> are to be unbound, and only create files for newly-added subsystems.
> The purpose is to have all other files untouched.
>
> This is a preparation for cgroup xattr support.
>
> Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> ---
> =C2=A0include/linux/cgroup.h | =C2=A0 11 +++---
> =C2=A0kernel/cgroup.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 92 ++++++++=
+++++++++++++++++++++++----------------
> =C2=A02 files changed, 67 insertions(+), 36 deletions(-)
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index e9b6021..13db9e8 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -327,6 +327,9 @@ struct cftype {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t max_write_len;
>
> + =C2=A0 =C2=A0 =C2=A0 /* The subsystem this cgroup file belongs to *=
/
> + =C2=A0 =C2=A0 =C2=A0 struct cgroup_subsys *subsys;
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int (*open)(struct inode *inode, struct fi=
le *file);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t (*read)(struct cgroup *cgrp, struc=
t cftype *cft,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0struct file *file,
> @@ -419,16 +422,14 @@ struct cgroup_scanner {
> =C2=A0* called by subsystems from within a populate() method
> =C2=A0*/
> =C2=A0int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *=
subsys,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0const struct cftype *cft);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stru=
ct cftype *cft);
>
> =C2=A0/*
> =C2=A0* Add a set of new files to the given cgroup directory. Should
> =C2=A0* only be called by subsystems from within a populate() method
> =C2=A0*/
> -int cgroup_add_files(struct cgroup *cgrp,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 struct cgroup_subsys *subsys,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 const struct cftype cft[],
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 int count);
> +int cgroup_add_files(struct cgroup *cgrp, struct cgroup_subsys *subs=
ys,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
struct cftype cft[], int count);
>
> =C2=A0int cgroup_is_removed(const struct cgroup *cgrp);
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index a5d3b53..c4ed6fe 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -781,6 +781,8 @@ static int cgroup_mkdir(struct inode *dir, struct=
 dentry *dentry, umode_t mode);
> =C2=A0static struct dentry *cgroup_lookup(struct inode *, struct dent=
ry *, struct nameidata *);
> =C2=A0static int cgroup_rmdir(struct inode *unused_dir, struct dentry=
 *dentry);
> =C2=A0static int cgroup_populate_dir(struct cgroup *cgrp);
> +static int cgroup_repopulate_dir(struct cgroup *cgrp, unsigned long =
added_bits,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long removed_bits);
> =C2=A0static const struct inode_operations cgroup_dir_inode_operation=
s;
> =C2=A0static const struct file_operations proc_cgroupstats_operations=
;
>
> @@ -882,34 +884,44 @@ static void remove_dir(struct dentry *d)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0dput(parent);
> =C2=A0}
>
> -static void cgroup_clear_directory(struct dentry *dentry)
> +static void cgroup_clear_directory(struct dentry *dentry, bool remov=
e_all,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long removed_=
bits)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 struct list_head *node;
> + =C2=A0 =C2=A0 =C2=A0 LIST_HEAD(head);
> + =C2=A0 =C2=A0 =C2=A0 struct dentry *d, *node;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(!mutex_is_locked(&dentry->d_inode->=
i_mutex));
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(&dentry->d_lock);
> - =C2=A0 =C2=A0 =C2=A0 node =3D dentry->d_subdirs.next;
> - =C2=A0 =C2=A0 =C2=A0 while (node !=3D &dentry->d_subdirs) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dentry *d =3D=
 list_entry(node, struct dentry, d_u.d_child);
> + =C2=A0 =C2=A0 =C2=A0 list_for_each_entry_safe(d, node, &dentry->d_s=
ubdirs, d_u.d_child) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cftype *cft=
 =3D d->d_fsdata;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!remove_all &&=
 cft->subsys &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !tes=
t_bit(cft->subsys->subsys_id, &removed_bits))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 continue;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_nest=
ed(&d->d_lock, DENTRY_D_LOCK_NESTED);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_del_init(node=
);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_move(&d->d_u.=
d_child, &head);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (d->d_inode=
) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0/* This should never be called on a cgroup
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 * directory with child cgroups */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0BUG_ON(d->d_inode->i_mode & S_IFDIR);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0dget_dlock(d);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 spin_unlock(&d->d_lock);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 spin_unlock(&dentry->d_lock);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&d->d_=
lock);
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock(&dentry->d_lock);
> +
> + =C2=A0 =C2=A0 =C2=A0 list_for_each_entry_safe(d, node, &head, d_u.d=
_child) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&d->d_lo=
ck);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_del_init(&d->=
d_u.d_child);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&d->d_=
lock);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (d->d_inode) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0d_delete(d);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0simple_unlink(dentry->d_inode, d);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0dput(d);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 spin_lock(&dentry->d_lock);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 spin_unlock(&d->d_lock);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 node =3D dentry->d=
_subdirs.next;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> - =C2=A0 =C2=A0 =C2=A0 spin_unlock(&dentry->d_lock);
> =C2=A0}
>
> =C2=A0/*
> @@ -919,7 +931,7 @@ static void cgroup_d_remove_dir(struct dentry *de=
ntry)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct dentry *parent;
>
> - =C2=A0 =C2=A0 =C2=A0 cgroup_clear_directory(dentry);
> + =C2=A0 =C2=A0 =C2=A0 cgroup_clear_directory(dentry, true, 0);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0parent =3D dentry->d_parent;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(&parent->d_lock);
> @@ -1284,6 +1296,7 @@ static int cgroup_remount(struct super_block *s=
b, int *flags, char *data)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cgroupfs_root *root =3D sb->s_fs_in=
fo;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cgroup *cgrp =3D &root->top_cgroup;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cgroup_sb_opts opts;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long added_bits, removed_bits;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&cgrp->dentry->d_inode->i_mutex=
);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&cgroup_mutex);
> @@ -1294,6 +1307,9 @@ static int cgroup_remount(struct super_block *s=
b, int *flags, char *data)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_unloc=
k;
>
> + =C2=A0 =C2=A0 =C2=A0 added_bits =3D opts.subsys_bits & ~root->subsy=
s_bits;
> + =C2=A0 =C2=A0 =C2=A0 removed_bits =3D root->subsys_bits & ~opts.sub=
sys_bits;
> +

Should it be the following=EF=BC=9F=EF=BC=9A
          added_bits =3D opts.subsys_bits & ~root->actual_subsys_bits;
          removed_bits =3D root->actual_subsys_bits & ~opts.subsys_bits=
;

Thanks,
Sha

> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Don't allow flags or name to change at =
remount */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (opts.flags !=3D root->flags ||
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(opts.name && strcmp(opts.na=
me, root->name))) {
> @@ -1308,8 +1324,8 @@ static int cgroup_remount(struct super_block *s=
b, int *flags, char *data)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_unloc=
k;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> - =C2=A0 =C2=A0 =C2=A0 /* (re)populate subsystem files */
> - =C2=A0 =C2=A0 =C2=A0 cgroup_populate_dir(cgrp);
> + =C2=A0 =C2=A0 =C2=A0 /* re-populate subsystem files */
> + =C2=A0 =C2=A0 =C2=A0 cgroup_repopulate_dir(cgrp, added_bits, remove=
d_bits);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (opts.release_agent)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strcpy(root->r=
elease_agent_path, opts.release_agent);
> @@ -2710,16 +2726,17 @@ static umode_t cgroup_file_mode(const struct =
cftype *cft)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return mode;
> =C2=A0}
>
> -int cgroup_add_file(struct cgroup *cgrp,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0struct cgroup_subsys *subsys,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0const struct cftype *cft)
> +int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsy=
s,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stru=
ct cftype *cft)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct dentry *dir =3D cgrp->dentry;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct dentry *dentry;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int error;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0umode_t mode;
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CF=
TYPE_NAME + 2] =3D { 0 };
> +
> + =C2=A0 =C2=A0 =C2=A0 cft->subsys =3D subsys;
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (subsys && !test_bit(ROOT_NOPREFIX, &cg=
rp->root->flags)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strcpy(name, s=
ubsys->name);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strcat(name, "=
=2E");
> @@ -2740,10 +2757,8 @@ int cgroup_add_file(struct cgroup *cgrp,
> =C2=A0}
> =C2=A0EXPORT_SYMBOL_GPL(cgroup_add_file);
>
> -int cgroup_add_files(struct cgroup *cgrp,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 struct cgroup_subsys *subsys,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 const struct cftype cft[],
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 int count)
> +int cgroup_add_files(struct cgroup *cgrp, struct cgroup_subsys *subs=
ys,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
struct cftype cft[], int count)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int i, err;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i < count; i++) {
> @@ -3703,26 +3718,27 @@ static struct cftype cft_release_agent =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.max_write_len =3D PATH_MAX,
> =C2=A0};
>
> -static int cgroup_populate_dir(struct cgroup *cgrp)
> +static int __cgroup_populate_dir(struct cgroup *cgrp, unsigned long =
added_bits)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int err;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cgroup_subsys *ss;
>
> - =C2=A0 =C2=A0 =C2=A0 /* First clear out any existing files */
> - =C2=A0 =C2=A0 =C2=A0 cgroup_clear_directory(cgrp->dentry);
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D cgroup_add_files(cgrp, NULL, files=
, ARRAY_SIZE(files));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err < 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return err;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cgrp =3D=3D cgrp->top_cgroup) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((err =3D cgrou=
p_add_file(cgrp, NULL, &cft_release_agent)) < 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D cgroup_add=
_file(cgrp, NULL, &cft_release_agent);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err < 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return err;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for_each_subsys(cgrp->root, ss) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ss->populate &=
& (err =3D ss->populate(ss, cgrp)) < 0)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return err;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (test_bit(ss->s=
ubsys_id, &added_bits) && ss->populate) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 err =3D ss->populate(ss, cgrp);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (err < 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return err;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* This cgroup is ready now */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for_each_subsys(cgrp->root, ss) {
> @@ -3739,6 +3755,20 @@ static int cgroup_populate_dir(struct cgroup *=
cgrp)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0}
>
> +static int cgroup_populate_dir(struct cgroup *cgrp)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return __cgroup_populate_dir(cgrp, cgrp->root-=
>subsys_bits);
> +}
> +
> +static int cgroup_repopulate_dir(struct cgroup *cgrp, unsigned long =
added_bits,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long removed_bits)
> +{
> + =C2=A0 =C2=A0 =C2=A0 /* First clear out files */
> + =C2=A0 =C2=A0 =C2=A0 cgroup_clear_directory(cgrp->dentry, false, re=
moved_bits);
> +
> + =C2=A0 =C2=A0 =C2=A0 return __cgroup_populate_dir(cgrp, added_bits)=
;
> +}
> +
> =C2=A0static void init_cgroup_css(struct cgroup_subsys_state *css,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cgroup_subsys *ss,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cgroup *cgrp)
> --
> 1.7.3.1
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
