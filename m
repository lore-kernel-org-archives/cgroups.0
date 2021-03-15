From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
Date: Mon, 15 Mar 2021 19:34:15 +0100
Message-ID: <YE+op0MZKG41EALi@blackbook>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <20210304231946.2766648-2-vipinsh@google.com>
 <YEpod5X29YqMhW/g@blackbook>
 <YEu74hkEPEyvxC85@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="s/zzXfvrLmfa0Un9"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615833258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H+y7FsHAfr9H0V0nZlpCJwqn4arhOTDKupfGhSsi4L0=;
        b=KjlbibSfXB7NG662v+nqeUvX9bQmFZ6Tn4FZ8LSyV2Dy1wShX6HyGPkQ/3oP/oi8ltOa82
        p4LArpJEH3uiUS4qK5AotGb4JiNd6JM5FPMBGV9OllfNYp2H0+Bq9mcfUIPNFQ81bOWovM
        7fmYs578Xsmg19z3fl9mWp/3G2HomOI=
Content-Disposition: inline
In-Reply-To: <YEu74hkEPEyvxC85-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--s/zzXfvrLmfa0Un9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 12, 2021 at 11:07:14AM -0800, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
> We should be fine without atomic64_t because we are using unsigned
> long and not 64 bit explicitly. This will work on both 32 and 64 bit
> machines.
I see.

> But I will add READ_ONCE and WRITE_ONCE because of potential chances of
> load tearing and store tearing.
>=20
> Do you agree?
Yes.

> This was only here to avoid multiple reads of capacity and making sure
> if condition and seq_print will see the same value.
Aha.

> Also, I was not aware of load and store tearing of properly aligned
> and machine word size variables. I will add READ_ONCE and WRITE_ONCE
> at other places.
Yeah, although it's theoretical, I think it also serves well to annotate
such unsychronized accesses.

Thanks,
Michal

--s/zzXfvrLmfa0Un9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmBPqKEACgkQia1+riC5
qSihOg//SpH6gNPHIcbQ+iF47BrOX3zJwft1PTn3D8d3byIaot3/Sym+j12ttkQU
xstX/U3Mvimyouy50DFaYLiQ+EWMOPm8dzEw2nPOQFrL0bT6cjRdFnAzH7Y2m87c
GufRjzeGwn8H2dRTPHiUjc+ETQhdjIRUOL5yUgoJkDGmV1m63j4rQUS5JXoHuW/i
WH8ePRhc4SlGS/Ifgu3/+g0a3z+K46umCrHA9//BHI5gPyuvobyCdwIjrFekSDAq
5vWwp6YGavoX5ZoZALUpokgcZR/iVRhTpt5m6psuYFhb+i+sWi/jYVgAeGSzZgCU
G9uvFogZrPASTAHTss+MwdXoKUWWckG33D5MA8RtTXobewWrO7GcpTCFb79Mm0pF
JzdVgBuMMuphLjkXHgQnSX8wHQQ7R545TuaSLXZBM9AqDPFjScEwdi68qRKPqopt
wqqL64XiFnoICLnZjFpp11cL1gccY4cHYo71eNrVA1bdscO1iiO/c5xPbh9JD6cX
I/cwAksf9R+bW+XUWrgsDvx9VuCiWfhEtiT/obqgDyHEQfE7JtgVX2IDN1o1pLcM
+aGLPoyU/4Nc6aK898xqpJdzY/kCNB73YUuhdgH8lf1tY1P0myDTTivn7+XqZXd3
hfMM6u+AdaUZhqymfylaEnTpQpBH4VfRAsBS0SnFuUnT93GnkqU=
=+zv/
-----END PGP SIGNATURE-----

--s/zzXfvrLmfa0Un9--
