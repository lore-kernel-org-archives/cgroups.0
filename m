From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] blk-throttle: enable io throttle for root in cgroup
 v2
Date: Mon, 27 Sep 2021 07:08:52 -1000
Message-ID: <YVH6pLUONhmvhTMK@slm.duckdns.org>
References: <20210909140815.2600858-1-yukuai3@huawei.com>
 <20210917174103.GC13346@blackbody.suse.cz>
 <CACGdZYJiLuh6kED_tdWkYqbHDXc_18m-XJbevp-ri5ansvbtYg@mail.gmail.com>
 <37f8c687-8549-104a-2501-532a0cfc9a48@huawei.com>
 <20210921134414.GE4091@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=icdhatsIVMpVj9yFW17RwQuR1S0u1I+iYgg1GU5p9cg=;
        b=ZMz3hfxwpz4U36m5O/CYL7j1TR5S3j0rERHxQWLDXoJkRLldkBdniIGZLVHf9Iit5d
         Ecfe2rMtWI53lH6H7AXxEgdRL/M1bsKthqaf1i/A3XJEpNQqe9UzQLfrrxOboq/hOvYI
         4Bwuza8gO3r6TeSr6m+M5Eiv2gzQYeRvyeuwXV7M2uZeVy1hj8m0O3vGG9v8kzUD4MTB
         PY7nVeQM2AX4z265SOWlctIjaPzpr9PjGT+KrvnYle0zWd5ZXTp1jpaIhwgYWcCLy3HW
         V0akiE9PrGLppPnC6Lp5xh4hKko3DuVWP7aJ9iISiwNuJbM0Xk/jhJDPOjfOFFbnm7+q
         AYiQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210921134414.GE4091-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Khazhy Kumykov <khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello,

On Tue, Sep 21, 2021 at 03:44:14PM +0200, Michal Koutn=FD wrote:
> On 2021/09/18 3:58, Khazhy Kumykov wrote:
> > (This does also bring up: if this is a useful thing, would it make
> > sense to tie to the device, vs. requiring cgroup. We happen to use
> > cgroups so that requirement doesn't affect us).
>=20
> Good point, That's IMO a better idea, it'd be more consistent with other
> resources for which there exist global (cgroup independent) kernel
> constraints (e.g. threads-max sysctl, mem=3D cmdline, cpu hotplug) that
> double the root cgroup contraint role.

This is why I usually try to push root-cgroup level features outside cgroup
because it really doesn't have much to do with cgroups at the root level.
For visibility stuff, we do replicate quite a bit in the root level because
not doing so becomes too painful for users but for control I'm more
hesitant.

One side-way solution could be using iocost. It doesn't have root-level
control per-se but it does configure per-device attributes which define what
the device can and is allowed to do so that it can be used as the basis for
weighted fair distribution. Even if IO control is disabled from the root
level, it'll still modulate the device according to the parameters.

> OTOH, this also deepens the precedent of init NS root cgroup being
> special (more special than a container's root cgroup).

While it does seem like an aesthetical wrinkle, I don't think this is a
practical problem. System root being different is a given whether
aesthetically pleasing or not (not the most important but we have
CONFIG_CGROUPS after all). I don't think it'll lead anywhere good to try to
mask the differences.

Thanks.

--=20
tejun
