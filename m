From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] cgroup: add xattr support
Date: Tue, 6 Mar 2012 13:37:36 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1203061314400.17934@eggly.anvils>
References: <4F4F1459.4080300@cn.fujitsu.com> <20120304180516.GB20787@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=H5g4i8cm5Efz5BqVzdNXAoDzO7i1gKBR5MJw/BS/cZI=;
        b=Ycj/MpQ314ggCTjiERym+P9zxKMfeftDIkJcElXW3SkACvWzQfHZCHez4bvR9rtGIx
         LNbhtxPul9oimY9X6EWv+ML7cAwc/B/yunQEFUmXq8ZmpqRT/A4YYj00JRNfQj3pYe5G
         R86bvu7LkDb4tBAFc3qQivIez/dLrnDDv2OXn316K0AonUaHsymu6z3QyBLrpVw6rUWs
         JJT+Bi+C/ERuo6HO26pFMdP+rgp7uL1XhbeYjg0L7Z9cFzD63BX3LGhaWWNiUa136DcE
         Ye2YBT/lVnWEOju6Z8p1kokRmU8mEvW7RypoGtjQP971cB3izS7eC+t9u/d+jJfWZ/+I
         VfUg==
In-Reply-To: <20120304180516.GB20787-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sun, 4 Mar 2012, Tejun Heo wrote:
> On Thu, Mar 01, 2012 at 02:16:57PM +0800, Li Zefan wrote:
> > This can be used to attach metadata to a cgroup, which is required
> > by systemd.

I've not reviewed your patches in detail, but I'm very happy for most
of the shmem xattr code to move out to a library for use elsewhere.

Note that the linux-next mm/shmem.c now includes Jarkko Sakkinen's
shmem_initxattrs() work, maybe you can draw from that too.

> > 
> > As lazy as I am, here just quoted from Lennart for the detailed use
> > cases:
> 
> I much prefer this version but would prefer to deal with this in the
> next merge window as we're already on rc6.  On a cursory look...
> 
> * I'm not sure kmem_ is a good prefix.  It sucks that xattr values are
>   stored in kmem w/o size limit and we probably want to improve on
>   both fronts in the future.  Wouldn't it be better to name them
>   simple_*() and put them in fs/libfs.c?

Yes, simple_*() in fs/libfs.c sounds much better to me than kmem_*().

On the size limit issue, shmem has its own shmem_xattr_validate(),
which rejects XATTR_USER_PREFIX, and the patches leave that unchanged.

I don't know whether the cgroup xattrs need to support USER or not,
and I don't know what permissions would be involved if they do;
but it's an important concern.

Hugh

> 
> * I don't think we want CONFIG option for cgroupfs xattr.  Let's just
>   add a mount option.
