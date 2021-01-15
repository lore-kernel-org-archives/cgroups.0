From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3] cgroup-v1: add disabled controller check in
 cgroup1_parse_param()
Date: Fri, 15 Jan 2021 12:51:03 +0100
Message-ID: <YAGBpwc+mG9fphkN@blackbook>
References: <20210115093717.79474-1-chenzhou10@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LRTQWv5FIzkk1CnV"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610711465; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rSrrwVVDuNBTwhNUys2eeIr+jYSEnX846ZDOze4F/Rc=;
        b=HWNLrfNPOalhS8svmVe4ZSZ/q0oY8x0nbXl0nhvwnhT/Jz8cppve72e6k7LhegCrSIcV9u
        /Mwz1SzLP5K6Am6CBfvCtlX2w9eMj46xOw2Ydfe/ZMKQ6SwXkv5XyAHt4Nz8ULGZSMGNbE
        8ugZZ0tww/KnkIenODnULjwSSlSRzJo=
Content-Disposition: inline
In-Reply-To: <20210115093717.79474-1-chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Chen Zhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, huawei.libin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


--LRTQWv5FIzkk1CnV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 15, 2021 at 05:37:17PM +0800, Chen Zhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>=
 wrote:
> [...]
>  kernel/cgroup/cgroup-v1.c | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

--LRTQWv5FIzkk1CnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmABgaMACgkQia1+riC5
qSgENQ//THZ0aN/jvVhGYM3k13t0jW/DWcpVSCaxQtWDesCT6o5KydDvmd/8b6O/
H+DeSBxPh1owPaYINJ1SfuRWNuaW3iXb40Lvpd/2COgIFg8cq4u/dHsbSLsE/xJh
qeKH3/rDoufm1XYqMEm98mjg2SRVKMTudRMA/TVvXyCO3y8lRyxHxmsxXPV+lf+I
+GcUlY/dWS4588b2cQDVL6n6SNk3ufu0fG+4SHWkw459K6MQvH42G30FsGOC7f75
r9lOPzOExYQSuE8nzC7aypsrBOPKuRvSSVayHndZsofFcZB7HCY1huCcEIUlOD8h
RT1Ndn7ehmJYE4Md5RoBYkTwGY4zGFkStCVZ4W6+GSWqISzFgmMtw8Orn51Pwsyx
wq0Ttc5sHPtnEJS7FvNhudC+wlMc7LftFfXqPodVg4JbjqPT1TpxELxk1ffEjEJy
//u6rC/GKSCPKCKS/E5lMDQVBPGLKl2swkcoE3lzMhY195V4y0Qd24nyEzzYAtP1
u83jxespxWdU96c3BrKIUYB4M54p+p3nbfw0wUytQCUE+fTCXdPtA/uzUIZfv+Su
M/Iafwifbdb7pufCFe19N/SxhDY34mD7Fc+ebno5nuCy3AIs2taVLa4knHDM6fOo
3n0GslcnwvQinaPYUToSjurm1kGwwMDv3T4f9pRpRGxyHEKnuLc=
=EyUt
-----END PGP SIGNATURE-----

--LRTQWv5FIzkk1CnV--
