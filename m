From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: Iterate tasks that did not finish do_exit()
Date: Mon, 20 Jan 2020 15:56:48 +0100
Message-ID: <20200120145635.GA30904@blackbody.suse.cz>
References: <20200116043612.52782-1-surenb@google.com>
 <20200117151533.12381-1-mkoutny@suse.com>
 <20200117151533.12381-3-mkoutny@suse.com>
 <20200117172806.GK2677547@devbig004.ftw2.facebook.com>
 <CAJuCfpFqEUVFXsjD8XcCKsGXKTf72r0Ek5_1yqu_k5UZAssKTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJuCfpFqEUVFXsjD8XcCKsGXKTf72r0Ek5_1yqu_k5UZAssKTw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, kernel-team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, JeiFeng Lee <linger.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Tom Cherry <tomcherry-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 17, 2020 at 10:41:29AM -0800, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Tested-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Thanks.

> > Yeah, this looks fine to me.  Any chance you can order this before the
> > clean up so that we can mark it for -stable.
> +1 for reordering. Makes it easier to backport.
The grounds still need to be prepared for css_task_iter to store
additional information. Let me see how the preceding changes can be
minimized.

Michal

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl4lv7AACgkQia1+riC5
qSjnlQ//WGljOTcfv0L0yWBKqXL3O0PLyuPdsN+7v3R9YLMlZy1NE0YMJjm2cbii
cC0lB8Lr4kg8R1IuUh8Iks+eIFNGMmBRzxChxzm4DTEPkB6i775f67ELwxWw6xFD
H/oHvQKfvQUt3r/vVfyG8bRsJvpLjVViiRq1fy6SkX0UgVuDcchKFYOUaeaJAcB/
d7JRVvtvyV11ruAKx7nK+GTBhCLCdgcqh4ZTKEc2dtB7CWp7JCHKbyw5Y/sic/zc
XDilupblbFI6zerlS6ojzptQbuMPdZ09dG/e2xJK9K/crVaE837opkVISg0MPzrc
eDdXKz3j5P/koE5nvwfv+GCuZ1hIqn8asmmrn6hwl2RMeb0I6ah4hVYTEbPJ/d8v
wB9csLCQDFJx/meZfuESumssrCofS++SQfsQR43lR8oilNefg2j+EZgcOHOfVYY/
iHu8M3RR1ClosYvjNIs0sU/i+9s2jGZpCfA0P0WWbSLPMvMSt/Gx+TE8iiHAaztb
G/lCm1cvWIEWcXbGvRG91YjKDWMxqTpV9ZceIyEMKQudqpYyTFQr4QBhdE+djb1r
e6+88ykq8nYxT9G1SDcYCA03OyouKIm5TBfObcdvZptAh2szrI9cATC3lEz/Dj4f
cfvdIA0PwZgLaccFAIc75NAY6IQJhcK/t6rqsE2fxiEofvrfiXI=
=VU1C
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
