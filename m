From: "Daniel Xu" <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: Add option to enable user xattrs
Date: Tue, 03 Mar 2020 11:37:28 -0800
Message-ID: <C11GC2SN5D18.2S00I3KONE9ZE@dlxu-fedora-R90QNFJV>
References: <C11FYO0Q9WJU.2MLRRFOQ3E878@dlxu-fedora-R90QNFJV>
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        content-transfer-encoding:content-type:in-reply-to:date:to:cc
        :subject:from:message-id; s=fm2; bh=u0IrEIXKCPqF9SikuisdIghTkg0j
        7+8C1skbUGpp0p8=; b=hg/CFqGAMIkShJAKOhOwEMupcwe/MBOezh6zMZhlEclX
        XLJTZigMmqeY4trM0DekrEP28xXqiqiCrjYpVvzqj0gBycW6Ro+kXdwgGNEqp6N9
        TIB6jrPjnfM7wi3EFVjjbAzdR5ktH93gCsn/f7tCmJVlICfhu62flm0AvWKVedAI
        w7x3pg2Bi79SKa3vaDiASVdCvlT7hWkm7seFAq620B7ELVMK+U7DkvLJGommnkq6
        opxhPzkLBgBuHjoeCVqKIpQXbxWJZ660HnkiEpBQYxl6KLkol7mEsLfHz7Oj8k/J
        sef+JBjijk6rFC4xjTSrjs2+/MknHeyyL0imdExfcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=u0IrEI
        XKCPqF9SikuisdIghTkg0j7+8C1skbUGpp0p8=; b=lW323dlAALeDy5hsb+8RmK
        SGDUenHi6HLukau7SutbXUDiNzQmN+KXAYWgW//+bpSA6n4FvJFQ96pIVV3E9UeE
        6F/gSYi0NKVrZJU/doPWBtIujyTyfwEjDrYO7Xkrkvw8g4acZGapBzM6w7ZQjc3I
        UnXJ0k73TjZRkT0JlgVsMO0kMvpGlEDp6GftHgSeL4Gb1kI5J9dMFDUFfrsIZD1Q
        nKg7xpY2Wloe+lXVEj5tpNgDR0vTblzhA4+c5Jr276wYN5rFEhnkxjVfQzMqh91G
        X4tdUITmVRsS47jbRbzIGL5hNtPujg4ZJg0scPmEpkzKuUvKJgdeDihgp4EjwtKQ
        ==
In-Reply-To: <C11FYO0Q9WJU.2MLRRFOQ3E878@dlxu-fedora-R90QNFJV>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue Mar 3, 2020 at 11:19 AM, Daniel Xu wrote:
> On Tue Mar 3, 2020 at 8:19 AM, Tejun Heo wrote:
> > Hello,
> >
> >=20
> > On Mon, Mar 02, 2020 at 05:39:00PM -0800, Daniel Xu wrote:
> > > +static int kernfs_vfs_user_xattr_set(const struct xattr_handler *han=
dler,
> > > +				     struct dentry *unused, struct inode *inode,
> > > +				     const char *suffix, const void *value,
> > > +				     size_t size, int flags)
> > > +{
> > ...
> > > +	if (value && atomic_inc_return(nr) > KERNFS_MAX_USER_XATTRS) {
> > > +		ret =3D -ENOSPC;
> > > +		goto dec_out;
> > > +	}
> >
> >=20
> > So, we limit the number of user xattrs here but
> >
> >=20
> > > +	ret =3D kernfs_vfs_xattr_set(handler, unused, inode, suffix, value,
> > > +				   size, flags);
> >
> >=20
> > This will call into simple_xattr_set() which doesn't put any further
> > restriction on size and just calls GFP_KERNEL kmalloc on it allowing
> > users incur high-order allocations. Maybe it'd make sense to limit
> > both the number and size?
>
>=20
> Ah yeah good point. Will add.
>

It looks like in fs/xattr.c:setxattr, there is already:

    ...
    if (size) {
        if (size > XATTR_SIZE_MAX)
            return -E2BIG;
    ...

where XATTR_SIZE_MAX is defined as 64k. Do you want it even smaller?


Thanks,
Daniel
