From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove unneeded return value of
 cgroup_rm_cftypes_locked()
Date: Tue, 11 Jul 2023 13:21:39 +0200
Message-ID: <cwqcmeqxglkd32crmc7fw57hhrrihtqnkle5ympniuthkg6j6w@fmyd7jxvffhi>
References: <20230701073856.2095425-1-linmiaohe@huawei.com>
 <ue4duahv6scnn64zgduuhiyq2gh33w7x5ftdffw3uqcn4ahyd2@txxtxf2fkzp2>
 <7d3323ab-f796-6846-ab08-5d48734595e1@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fhkx5cds4otewh5u"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1689074501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vowglESr1KoOEcY4XXmA0mTe20uS/zqvChy0ToqbJlw=;
        b=GwL+qkZnIy2QFgfpjgTPLJlEV//u+2813Bb38189aR7Zm2/gNFOmWRZ8RAhRnJyIYzbwNI
        t72sniEI3ZdmVcZtwEBOnhAZhIJXBLes2THAO86pREcYVEDzLzTMFDk4/pbpK2S19BzEBe
        xEkiN2Fos24yBO10UsreHSv79mJOKQM=
Content-Disposition: inline
In-Reply-To: <7d3323ab-f796-6846-ab08-5d48734595e1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--fhkx5cds4otewh5u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 11, 2023 at 10:58:48AM +0800, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>=
 wrote:
> +/* It builds upon cgroup_addrm_files()'s. */
>  static void cgroup_rm_cftypes_locked(struct cftype *cfts)
>  {
>         lockdep_assert_held(&cgroup_mutex);
>=20

I meant adding the reasoning to the commit message -- swallowing errors
on removal is fine because cgroup_addrm_files() won't fail at removal.
It's a minor remark for the future readers ;-)

Michal

--fhkx5cds4otewh5u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZK07QQAKCRAGvrMr/1gc
jq21AQCWPqVs+XV9Vu8QeN38R34dWAgvPGj9y4EfFgTQDIWk4QEAqcd+aEHRGC2i
onMUJSBPVSf3GqVIjpW7MNZ5aAaKPAE=
=GCjq
-----END PGP SIGNATURE-----

--fhkx5cds4otewh5u--
