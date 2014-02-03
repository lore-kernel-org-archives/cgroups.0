From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] nfs: include xattr.h from fs/nfs/nfs3proc.c
Date: Mon, 3 Feb 2014 15:43:19 -0500
Message-ID: <20140203204319.GI30250@htj.dyndns.org>
References: <20140203193107.GH30250@htj.dyndns.org>
 <F2DD11A7-8D32-4E1E-BB4D-7384F0932B2D@primarydata.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=IzG+qMWXmrHcSmKt+F6muo9FFzMn1mZrTxk8j1Fy+G0=;
        b=FPsi0FapKSh/ZzvcJ40BVSDzwjE1C/aSL9PKtTVWdqduCaJ1RfGDhpriRfqkLRlTdM
         dsZQHI4y9AEzeqQY7/Dkl9C8HXbiav2LXfPBsSTw06ZVQTuVKZi50m1LhQWzEZpi5La3
         ZqL5z8ueGSDzpeKrSC1oWW7EqZ2HLoj8LX8nuPNueh3VBHsYVm6sya7lyf0EngI03+/c
         T3U+sW9+LMvHkgsRalVOc0WndvpXNMZnZrSE6S04mwQ/ZqtItP5MnVaXuZB0sqX+7X7i
         3WL4irPO4GXrGwl5O+oXNDFVBk/4dZXmJ/uaK3otHZu0qWCkwqqPJLT6zRWb/y9ZkS9y
         x0BA==
Content-Disposition: inline
In-Reply-To: <F2DD11A7-8D32-4E1E-BB4D-7384F0932B2D-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: Dr Fields James Bruce <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linuxnfs <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Feb 03, 2014 at 02:48:13PM -0500, Trond Myklebust wrote:
>=20
> On Feb 3, 2014, at 14:31, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>=20
> > fs/nfs/nfs3proc.c is making use of xattr but was getting linux/xatt=
r.h
> > indirectly through linux/cgroup.h, which will soon drop the inclusi=
on
> > of xattr.h.  Explicitly include linux/xattr.h from nfs3proc.c so th=
at
> > compilation doesn't fail when linux/cgroup.h drops linux/xattr.h.
> >=20
> > As the following cgroup changes will depend on these changes, it
> > probably would be easier to route this through cgroup branch.  Woul=
d
> > that be okay?
> >=20
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
>=20
> EWRONGMAINTAINER=E2=80=A6 :-)
>=20
> Acked-by: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>

Oopsy, thanks! :)

--=20
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
