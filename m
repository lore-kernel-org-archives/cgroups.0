From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v11 3/8] cgroup/cpuset: Allow no-task partition to have
 empty cpuset.cpus.effective
Date: Mon, 13 Jun 2022 16:02:06 +0200
Message-ID: <20220613140206.GA6910@blackbody.suse.cz>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-4-longman@redhat.com>
 <YqYlCRywdgSYtwKk@slm.duckdns.org>
 <YqYlOQjKtQCBsQuT@slm.duckdns.org>
 <ce3106c1-a3c4-b449-bafc-6940d672bd94@redhat.com>
 <YqanEZZooeZwtutA@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655128928; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dH96i6OHzwC4qIcatlfFaUeHgKDc3G4KvUuOT69KD6U=;
        b=jKmUvylV66P3EkHqBQvMGTtVkWvt3Wx/VA/PZBaOos9trJT4344bWhR6bLjSmrFKY20UEl
        StmiA+zFdv2T74AbHfLh2YLHX7k3Vg9sqDrqaSJPEgdZHIWaU5wTS00B0KEGoy5/XNqkFT
        UQXWzd05W3OVdfDU/9WRQ8W9KcenvM0=
Content-Disposition: inline
In-Reply-To: <YqanEZZooeZwtutA-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 12, 2022 at 04:55:13PM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> But how would that happen? A lot of other things would break too if that
> were to happen.

cpuset is a threaded controller where the internal-node-constraint does
not hold. So the additional condition for cpuset migrations is IMO
warranted (and needed if there's no "fall up").

Michal

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYqdDXAAKCRAkDQmsBEOq
uVxRAPwMiG5QiY65xj/WyfY3nCUyKyx+lDQh6bCpufc5IIQORgD9FIrNztTt7lmR
ic79LsvKPERP5RiY2PezetNtf5xH9wA=
=VnhP
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
