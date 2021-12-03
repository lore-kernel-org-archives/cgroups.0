From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v8 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Fri, 3 Dec 2021 19:25:00 +0100
Message-ID: <20211203182500.GD16798@blackbody.suse.cz>
References: <20211018143619.205065-6-longman@redhat.com>
 <20211115193122.GA16798@blackbody.suse.cz>
 <8f68692b-bd8f-33fd-44ae-f6f83bf2dc00@redhat.com>
 <20211116175411.GA50019@blackbody.suse.cz>
 <293d7abf-aff6-fcd8-c999-b1dbda1cffb8@redhat.com>
 <YaZbXArNIMNvwJD/@slm.duckdns.org>
 <2347fe66-dc68-6d58-e63b-7ed2b8077b48@redhat.com>
 <Yaem+r/YZ9BNXv9R@slm.duckdns.org>
 <4a021678-1896-2d16-4075-f626c7ab8513@redhat.com>
 <8f56f7a3-1d4b-679b-7348-d8ecb4ef3d6c@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638555902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eV3OmMVm/NWdly/P2YCXm8g5vG08JX/vYpooIV4zaHM=;
        b=P7zR711xL2stvUGx6l6vVCieltuwJ7iV6UsAhFInFLaRmH8OJdSujjmdkyf4YrNrIT79E/
        ZYuQCHGjcPMPXVGMFoAqnhbzDrq9e3ZueDbczIi9W0+stZnoOhH7yqYmjT3d7uzr/o4F3D
        ArNTust0WbmyWA/ziUPunMb3o5HF4ds=
Content-Disposition: inline
In-Reply-To: <8f56f7a3-1d4b-679b-7348-d8ecb4ef3d6c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Longman.

On Wed, Dec 01, 2021 at 08:28:09PM -0500, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> 1) The limitation that "cpuset.cpus" has to be a superset of child's
> "cpuset.cpus" has been removed as a new patch to remove that limitation w=
ill
> be added.

Superb!

> 2) The initial transition from "member" to partition root now requires th=
at
> "cpuset.cpus" overlap with that of the parent's "cpuset.cpus" instead of
> being a superset.

That's sensible.

> For the transition back to "member", I haven't changed the current wording
> of forcing child partition roots to become "member" yet. If you think
> keeping them as invalid partition root is better, I can made that change
> too.

I wrote I was indifferent about this in a previous mail but when I think
about it now, switching to invalid root is perhaps better than switching
to member since it'd effectively mean that modifications of the parent
config propagate (permanently) also to a descendant config, which is
an undesired v1-ism.


> Please let me know what other changes you would like to see.

I hope my remarks below are just clarifications and not substantial
changes. Besides that I find your new draft good. Thanks!

> [...]

> =A0=A0 =A0An invalid partition root can be reverted back to a valid one
> =A0=A0 =A0if none of the validity constraints of a valid partition root
> =A0=A0 =A0are violated.

s/can be/will be/=20

(I understand the intention is to make it asynchronously and
automatically, i.e. without writing into the affected descendant(s)
cpuset.partition again.)

> =A0=A0 =A0Poll and inotify events are triggered whenever the state of
> =A0=A0 =A0"cpuset.cpus.partition" changes.=A0 That includes changes cause=
d by
> =A0=A0 =A0write to "cpuset.cpus.partition", cpu hotplug and other changes
> =A0=A0 =A0that make the partition invalid.

-> that change validity status

(In accordance with the comment above.)


Michal

--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTiq06H1IhXbF2mqzsiXqxkP0JkRwUCYapg+AAKCRAiXqxkP0Jk
R60gAQCV8E8cIvOn/Hr5KboWD+7obSggVivpR3LxikBIuT9raQD+OptMUIwAN0Mk
MnWqFSlaobxSAqN0VorYNkJ17mv9dAc=
=q7Dx
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--
