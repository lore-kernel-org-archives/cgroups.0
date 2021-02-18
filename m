From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 8/8] kselftests: cgroup: update kmem test for new
 vmstat implementation
Date: Thu, 18 Feb 2021 16:37:41 +0100
Message-ID: <YC6JxXU9qJLKpfdQ@blackbook>
References: <20210209163304.77088-1-hannes@cmpxchg.org>
 <20210209163304.77088-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fHNhrTm/0V5/xRS3"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613662663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T8xSuHg5FcxqaUiLy/07VNaVdH7jpOGpygmlG0tFCPA=;
        b=fk2s0A3B16v2RiDa7GjCZaWyaQgL9PvIP9RoEVXWSsjtARABYF/FSs6+DmzvHF8Wte5/ma
        LgmgEeJI8gl10ZEF4UgMh+/K9JVOtJWaT8bko36a0xvOQ25hWaXT1key0aC3pZEsD1l2vJ
        ZZGsq+kQ/RcYb5zQQAQvhTnMSTJWnpM=
Content-Disposition: inline
In-Reply-To: <20210209163304.77088-9-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org


--fHNhrTm/0V5/xRS3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 11:33:04AM -0500, Johannes Weiner <hannes@cmpxchg.o=
rg> wrote:
> ---
>  tools/testing/selftests/cgroup/test_kmem.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>


--fHNhrTm/0V5/xRS3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmAuicUACgkQia1+riC5
qSiQLQ//c6i9TdMWD82nlSR/w1T8wAEzFaMzXDQxgqpXL/eOSYOvQoG0bruyPwWf
TotGZU/GtFSEYkHXHEnWb7ZO/7RK9EeQN9WS0XBg4w3CtU/Gv4TZLP+k3dZfoM+C
GTrO9N820v6ez66phHpKgwWhUIfg6iPaJ8uP7SCt/GTJb/4lOLuf47ddnomrWMwn
j3BcSZhzcZQtptN3diL0aoBmZJ+y0Mo/Xo7bx4omEIv91st9SE4f6hQwVBtZpfqG
DkLTJBVTJ3Vu2t0ADeao9vAru0Ylp5/SOb9qPYsSq+JGaornjg9MAmHRrzg2IKHo
35qJQTplQRqZtNRSMySXVTf7Ntz7D42xRPDw0yFjXA6J/NWtOw4yvnP/X0dTuArO
Yeu1+8vDFGyhEWU+UFPUFggvyr4HzbbH7WQxmmTKUqFILkkp+4KZwDjWkUXr+jzp
TSqAk34EkO1luhKQPMwcP1e2RUIfXbV32ZYiq0gT/si/KC22NG4IfKni5tuJHEAT
eHBvBRcpwypqxI1Y0258CFOCaFmfH1toJ0M3j4zlElUnNhYsqc1GD08ymaI/q7QF
UtLuo4ARokvUtm3eZROk1ACe69lnYk0Vu5cb76tfRci0gWmHAg8KqlV+cCpK7Km6
vT/s3Enga86z6iuOsSp+8NJxddhx2uH0O6EDQSa2CudGRPSXn74=
=SFWt
-----END PGP SIGNATURE-----

--fHNhrTm/0V5/xRS3--
