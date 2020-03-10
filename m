From: "Daniel Xu" <dxu@dxuuu.xyz>
Subject: Re: [PATCH v2 2/4] kernfs: Add removed_size out param for
 simple_xattr_set
Date: Tue, 10 Mar 2020 11:20:44 -0700
Message-ID: <C17D34QG2G67.2DUOCLCXQI4RP@dlxu-fedora-R90QNFJV>
References: <20200305211632.15369-3-dxu@dxuuu.xyz>
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        content-transfer-encoding:content-type:in-reply-to:date:from:to
        :cc:subject:message-id; s=fm2; bh=5FlyFofPg7aTv586jLAdhujdZkMVwt
        aTjltq0mF7OD8=; b=xafPDPpdBEzAXboC3WYjQSk+mV62smjUftt64gACW+cqGt
        DY8Phzta7VFFjeCpoi7FJdgH/SyE+Md2cIFy9+YXBY3cMvJ6bpwchWu0c1a961LE
        VhldM8gONOE7T+y9GoJDQg4MGwroYLlhNAlcqzaWY1RlPVWy7biAiBnI8OYPx+N8
        Eo+psPb6sqNiud9CNJKC8+WCqWvnkGCFmFLoFl97Wes0FpjTA9p4rvwuJpNM/Gz8
        XEQf9m8bC2y6JyFVFgN0WrriCDG9r5SWlQCYNbqOv3tendXIjfYNQHd7gCnGVC6M
        6NoFHPpRZqu1FjZHdfhNKxG/oBay4qAUSN2SZueQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5FlyFo
        fPg7aTv586jLAdhujdZkMVwtaTjltq0mF7OD8=; b=m+m1A427Im9IndTacGJN53
        l3uFWjdDGVJgIJERUsd8aO6kPEy3U0s565d+ThVRcz1GdpdziGnJWD4S9Md6pInU
        ivy9e7yLt7d/DLkQ0ibHSHwyDUg7HB0toh5vIb/WtFYDN5xczG/On08I6P73lp1L
        PMgD2uuBWvSm0XWQjP1dUpp5iwc5G4cN9hwZMBazyRDkfGg6OKFbxTgj/wKHevxX
        dRmd/d53V63SxH/63KnU7gjKQ7NoXbdHUXNzkAWVq5JZgCB2R9Fe+sXH2fEAH7Ek
        3rWm6xUKoe3uRofBvIQ1BLV8CLjSE7xQVsi2wf3M1ImPgJVtWwM2OIFmNGYA/X6w
        ==
In-Reply-To: <20200305211632.15369-3-dxu@dxuuu.xyz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Daniel Xu <dxu@dxuuu.xyz>, cgroups@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, viro@zeniv.linux.org.uk
Cc: Daniel Xu <dxu@dxuuu.xyz>, shakeelb@google.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, kernel-team@fb.com

On Thu Mar 5, 2020 at 1:16 PM, Daniel Xu wrote:
> This helps set up size accounting in the next commit. Without this out
> param, it's difficult to find out the removed xattr size without taking
> a lock for longer and walking the xattr linked list twice.
>
>=20
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
> fs/kernfs/inode.c | 2 +-
> fs/xattr.c | 11 ++++++++++-
> include/linux/xattr.h | 3 ++-
> mm/shmem.c | 2 +-
> 4 files changed, 14 insertions(+), 4 deletions(-)
>
>=20
> diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
> index d0f7a5abd9a9..5f10ae95fbfa 100644
> --- a/fs/kernfs/inode.c
> +++ b/fs/kernfs/inode.c
> @@ -303,7 +303,7 @@ int kernfs_xattr_set(struct kernfs_node *kn, const
> char *name,
> if (!attrs)
> return -ENOMEM;
> =20
> - return simple_xattr_set(&attrs->xattrs, name, value, size, flags);
> + return simple_xattr_set(&attrs->xattrs, name, value, size, flags,
> NULL);
> }
> =20
> static int kernfs_vfs_xattr_get(const struct xattr_handler *handler,
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 0d3c9b4d1914..e13265e65871 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -860,6 +860,7 @@ int simple_xattr_get(struct simple_xattrs *xattrs,
> const char *name,
> * @value: value of the xattr. If %NULL, will remove the attribute.
> * @size: size of the new xattr
> * @flags: %XATTR_{CREATE|REPLACE}
> + * @removed_size: returns size of the removed xattr, -1 if none removed
> *
> * %XATTR_CREATE is set, the xattr shouldn't exist already; otherwise
> fails
> * with -EEXIST. If %XATTR_REPLACE is set, the xattr should exist;
> @@ -868,7 +869,8 @@ int simple_xattr_get(struct simple_xattrs *xattrs,
> const char *name,
> * Returns 0 on success, -errno on failure.
> */
> int simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
> - const void *value, size_t size, int flags)
> + const void *value, size_t size, int flags,
> + ssize_t *removed_size)
> {
> struct simple_xattr *xattr;
> struct simple_xattr *new_xattr =3D NULL;
> @@ -895,8 +897,12 @@ int simple_xattr_set(struct simple_xattrs *xattrs,
> const char *name,
> err =3D -EEXIST;
> } else if (new_xattr) {
> list_replace(&xattr->list, &new_xattr->list);
> + if (removed_size)
> + *removed_size =3D xattr->size;
> } else {
> list_del(&xattr->list);
> + if (removed_size)
> + *removed_size =3D xattr->size;
> }
> goto out;
> }
> @@ -908,6 +914,9 @@ int simple_xattr_set(struct simple_xattrs *xattrs,
> const char *name,
> list_add(&new_xattr->list, &xattrs->head);
> xattr =3D NULL;
> }
> +
> + if (removed_size)
> + *removed_size =3D -1;
> out:
> spin_unlock(&xattrs->lock);
> if (xattr) {
> diff --git a/include/linux/xattr.h b/include/linux/xattr.h
> index 6dad031be3c2..4cf6e11f4a3c 100644
> --- a/include/linux/xattr.h
> +++ b/include/linux/xattr.h
> @@ -102,7 +102,8 @@ struct simple_xattr *simple_xattr_alloc(const void
> *value, size_t size);
> int simple_xattr_get(struct simple_xattrs *xattrs, const char *name,
> void *buffer, size_t size);
> int simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
> - const void *value, size_t size, int flags);
> + const void *value, size_t size, int flags,
> + ssize_t *removed_size);
> ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs
> *xattrs, char *buffer,
> size_t size);
> void simple_xattr_list_add(struct simple_xattrs *xattrs,
> diff --git a/mm/shmem.c b/mm/shmem.c
> index aad3ba74b0e9..f47347cb30f6 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3243,7 +3243,7 @@ static int shmem_xattr_handler_set(const struct
> xattr_handler *handler,
> struct shmem_inode_info *info =3D SHMEM_I(inode);
> =20
> name =3D xattr_full_name(handler, name);
> - return simple_xattr_set(&info->xattrs, name, value, size, flags);
> + return simple_xattr_set(&info->xattrs, name, value, size, flags,
> NULL);
> }
> =20
> static const struct xattr_handler shmem_security_xattr_handler =3D {
> --
> 2.21.1
>
>=20

Adding Al Viro, who I forgot to add in the initial send. Will remember
on future sends.

Daniel
