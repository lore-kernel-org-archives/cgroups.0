From: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/3] xattr: extract kmem_xattr code from tmpfs
Date: Thu, 1 Mar 2012 20:42:50 +0800
Message-ID: <CAJd=RBB+2r-Q8K1FQqPh90EdtAdmz3R8FWU48M_ePqyziNfcLw@mail.gmail.com>
References: <4F4F1459.4080300@cn.fujitsu.com>
	<4F4F146C.9090300@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=j2qXJB6+xSahWFKIABYsicAG0OY7iJWtxzePQIpeKtg=;
        b=Gknm3z/wm4g65xm/3nn8M7V23omarGR0rP/SXyebMcoVtT/oJPalssG9fYqsMsx1UA
         vSxucXiX6V7L1jnWHSoG+hBOXve8ZaXPhudpcd/5VgmpGzO6peuFeptJq0MPUyWpw2BA
         to0HfZH7MYgwFibgaVOcB6vfRP45a8aw0izic=
In-Reply-To: <4F4F146C.9090300-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Mar 1, 2012 at 2:17 PM, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org> wrote:
> +/*
> + * free all the xattrs
> + */
> +void kmem_xattrs_free(struct kmem_xattrs *xattrs)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct kmem_xattr *xattr, *node;
> +
> + =C2=A0 =C2=A0 =C2=A0 spin_lock(&xattrs->lock);
> + =C2=A0 =C2=A0 =C2=A0 list_for_each_entry_safe(xattr, node, &xattrs-=
>head, list) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(xattr->name)=
;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(xattr);
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock(&xattrs->lock);

In your work it is a library function, operations on &xattrs->head
are no longer allowed, say list_empty(), after it called, though I
dunno if such operations exist.

And kmem_xattrs is too close to kmem_xattr, kmem_xattr_list
is not pron of typo.

-hd

> +}
> +
[...]
> @@ -559,10 +551,7 @@ static void shmem_evict_inode(struct inode *inod=
e)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0} else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(info->sy=
mlink);
>
> - =C2=A0 =C2=A0 =C2=A0 list_for_each_entry_safe(xattr, nxattr, &info-=
>xattr_list, list) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(xattr->name)=
;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(xattr);
> - =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 kmem_xattrs_free(&info->xattrs);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(inode->i_blocks);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0shmem_free_inode(inode->i_sb);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0end_writeback(inode);
