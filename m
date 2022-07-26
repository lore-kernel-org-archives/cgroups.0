From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND 3/3 cgroup/for-5.20] cgroup: Make !percpu
 threadgroup_rwsem operations optional
Date: Tue, 26 Jul 2022 07:33:22 -1000
Message-ID: <YuAlYlPTMbuDjINF@slm.duckdns.org>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
 <YtDvU4jRPSsarcNp@slm.duckdns.org>
 <YtDvl7Qjc5zI3e/b@slm.duckdns.org>
 <YtwFjPnCtw8ySnuv@slm.duckdns.org>
 <20220726143257.GA23882@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=csi8DKhXQqGuLjHDX+zKw1RSlMGZo6HFF9ZyuowCuq4=;
        b=U/SdxptusQuSzFDIruTYLSWMcIba2U5OWiLGu6pkSYGjb1Nx+wNeOoSNQjBOMkxTKz
         zXq9A7gaHKIYjoND1POiRg2zHsufOsMWHHkUyfhwXmVE2gDM5PI+lb8bJX77ZshlVSQ3
         BD/GGKqArAy8NjtbJgFpXv+4ypVe67LSLaNtXmXAf4e07P01qocpHVaitOV1Dt74CRmh
         5iHsteyTsCkZfWuARYvMkM5T0Z9VWKmGwohbrXhhqpaBWb035bzWnKwrHMieeFGdVRWn
         nRQLftN8+acOuqZpW5qWFezxRsXd+GHg9ojbmsZZUUqBS684vqgS93NXMfDN0V3j1rTM
         O2SA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220726143257.GA23882-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Jul 26, 2022 at 04:32:57PM +0200, Michal Koutn=FD wrote:
> On Sat, Jul 23, 2022 at 04:28:28AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yR=
OfE0A@public.gmane.org> wrote:
> > This makes the hotter paths - fork and exit - slower as they're always
> > forced into the slow path. There is no reason to force this on everyone
> > especially given that more common static usage pattern can now complete=
ly
> > avoid write-locking the rwsem. Write-locking is elided when turning on =
and
> > off controllers on empty sub-trees and CLONE_INTO_CGROUP enables seedin=
g a
> > cgroup without grabbing the rwsem.
>=20
> Just a practical note that CLONE_INTO_CGROUP may not be so widespread
> yet [1][2].
> But generally, the change makes sense to me.

Yeah, I was disappoinetd that it wasn't being used by systemd already. It'd
be great if the glibc situation can be rectified soon because this is a much
better interface.

> > +	CGRP_ROOT_FAVOR_DYNMODS =3D (1 << 4),
> > +
> > +	/*
> >  	 * Enable cpuset controller in v1 cgroup to use v2 behavior.
> >  	 */
> > -	CGRP_ROOT_CPUSET_V2_MODE =3D (1 << 4),
> > +	CGRP_ROOT_CPUSET_V2_MODE =3D (1 << 16),
> > =20
> >  	/*
> >  	 * Enable legacy local memory.events.
> >  	 */
> > -	CGRP_ROOT_MEMORY_LOCAL_EVENTS =3D (1 << 5),
> > +	CGRP_ROOT_MEMORY_LOCAL_EVENTS =3D (1 << 17),
> > =20
> >  	/*
> >  	 * Enable recursive subtree protection
> >  	 */
> > -	CGRP_ROOT_MEMORY_RECURSIVE_PROT =3D (1 << 6),
> > +	CGRP_ROOT_MEMORY_RECURSIVE_PROT =3D (1 << 18),
>=20
> Why this new gap in flag bits?

To distinguish core and per-controller flags.

Thanks.

--=20
tejun
