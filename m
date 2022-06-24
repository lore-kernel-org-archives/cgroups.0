From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] cpuset: Allow setscheduler regardless of manipulated
 task
Date: Fri, 24 Jun 2022 14:43:16 +0200
Message-ID: <20220624124316.GH16004@blackbody.suse.cz>
References: <20220623124944.2753-1-mkoutny@suse.com>
 <ab4bcd51-83c5-ae21-ddf6-607a31a7d6ac@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GpGaEY17fSl8rd50"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656074597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kbkT57a8V0dJcSqQrodxix/sir4fcRh67YaToWJTvHE=;
        b=ewI827+xmnQCyHqvi4SVwM8YXQrqPa90AuyZGpIe+rcogw9aqIprFe4iT597bsxYtmTnLS
        lVxPFb+CFLEQ9X3VNbp8J6uEM9ImjVdqKEa2F62aHcwBq4D7y+CiH0OcFpgi7ODhP0jixN
        fBsgE0c7lgpa9TwQZQzFyjALrQp1LWc=
Content-Disposition: inline
In-Reply-To: <ab4bcd51-83c5-ae21-ddf6-607a31a7d6ac-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>


--GpGaEY17fSl8rd50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 23, 2022 at 02:44:33PM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> That could be an issue.

The way how I understand here is that the privileged process isn't part
of contrained workload (if it were then, it can modify cpuset itself)
like debugging or tracing a code within a container entered by the
admin. The bypass could not be used to setscheduler (via migration) of
an arbitrary process.

> What do you mean by nothing effectively changes?

It's a freshly created child (after cpuset_css_online()), so it inherits
parent's attributes, so the migration from the parent to this child
doesn't affect CPU affinity etc.

> Since the check is done on a taskset level, if only one of the tasks in the
> taskset fails, the whole taskset fails. Maybe we should consider an option
> for task based migration. So all the tasks that can be migrated will be
> migrated and the rests will be left behind in the original cpuset.

Hm, I haven't thought about that. That might be in theory possible for
threaded controllers (like cpuset) but I imagine it'd a bit messy, in
particular for these implicit migrations upon controller enablement.

Thanks,
Michal

--GpGaEY17fSl8rd50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYrWxYgAKCRAkDQmsBEOq
uSK7AQDxSD0tP0e4c1MlmPs3gy70GRGHcWnbPa9H+VtXGrwCtgEA3seoFthswxlF
BlkMXOCW5rIUwjXRGQ/9u+FKiUXulg8=
=Q3D5
-----END PGP SIGNATURE-----

--GpGaEY17fSl8rd50--
