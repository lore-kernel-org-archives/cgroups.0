From: "Daniel Xu" <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: Add option to enable user xattrs
Date: Tue, 03 Mar 2020 11:19:57 -0800
Message-ID: <C11FYO0Q9WJU.2MLRRFOQ3E878@dlxu-fedora-R90QNFJV>
References: <20200303131921.GB5186@mtj.thefacebook.com>
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        content-transfer-encoding:content-type:in-reply-to:date:cc
        :subject:from:to:message-id; s=fm2; bh=SqCNlbZH8ocvAyttYISsWHKwX
        84caUapAFPB6jsa97s=; b=g6MaKLrIMsUaGb1UjRYqWoDzQokUD1CiYDB2v26mW
        DaLlYLeLS7bZH7ruoRAUXrskg5Y8BaC9PXkjU2hPgmq8izaqMud9Tf7NAMApdcsm
        1DMGlUcfDbgoQ73mk1gXpgpYEYWhDMMHAvAJBxiUJJbqPy/HgFuVAbgTZo5ewc+e
        ZHbIdhNrL5oxK8ZS6wQDnO7h5PKRmE/68zdbtwSERuEPnTXqJ864sZOJCaKDIY9J
        wNDjUp2bwIpEAhvIDOejKoYuc+GGqVAJ/elOHfpr8s01lJs5PWJqRU6wpFkffqBa
        Y74qFJOEjUzr2YHxRJTbx/d1sxGvY88cg/WMYzP3gzlLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SqCNlb
        ZH8ocvAyttYISsWHKwX84caUapAFPB6jsa97s=; b=0/MOFvBYBmX+f+lBEXqMky
        oN3rZdVK00aHz/c17ts+U4rsUj52+C9HYF0NvUUndt5SOkFjjdh/GhpwptYNCh5h
        yWgQn+HqrM52+LP4mCbY5uWJmAisbdVEyVSdDifufbXkUoU3xIBBof/638HM7AVq
        XENKYXuvw34Ef9rCRVP1jhTmgJpzOJZZJ7NjU1/1klDWGX2IUjzXf/BNETHDfNes
        83Z5l8wPs8FefxVKPihttZe3qe46c8WJwzuIwO8cdsxvCiMcIAJKJP5w9ScyO8ja
        kQ3QIEEowvN9T6p/8eSjPaevEZ6OXVNmYS+bTyb8HRXyju3/HD7jcqXrMcnHnVDg
        ==
In-Reply-To: <20200303131921.GB5186-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue Mar 3, 2020 at 8:19 AM, Tejun Heo wrote:
> Hello,
>
>=20
> On Mon, Mar 02, 2020 at 05:39:00PM -0800, Daniel Xu wrote:
> > +static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handl=
er,
> > +				     struct dentry *unused, struct inode *inode,
> > +				     const char *suffix, const void *value,
> > +				     size_t size, int flags)
> > +{
> ...
> > +	if (value && atomic_inc_return(nr) > KERNFS_MAX_USER_XATTRS) {
> > +		ret =3D -ENOSPC;
> > +		goto dec_out;
> > +	}
>
>=20
> So, we limit the number of user xattrs here but
>
>=20
> > +	ret =3D kernfs_vfs_xattr_set(handler, unused, inode, suffix, value,
> > +				   size, flags);
>
>=20
> This will call into simple_xattr_set() which doesn't put any further
> restriction on size and just calls GFP_KERNEL kmalloc on it allowing
> users incur high-order allocations. Maybe it'd make sense to limit
> both the number and size?

Ah yeah good point. Will add.
