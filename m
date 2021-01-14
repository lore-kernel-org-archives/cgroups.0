From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] cgroup-v1: add disabled controller check in
 cgroup1_parse_param()
Date: Thu, 14 Jan 2021 17:54:50 +0100
Message-ID: <YAB3Wuu+hFpN698N@blackbook>
References: <20201218061755.121205-1-chenzhou10@huawei.com>
 <YABDWvI2PWQpnv59@blackbook>
 <d4ba14b0-ee06-b793-a840-2c2ff369d890@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="G5CWgaLxblIFSK1F"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610643293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DRTWHPlrQiiVrNwf4oflLPIJjJTF+5vr64DIMf+QTzg=;
        b=KHpcDRFA4ImJgm0jszlZ5QuF1YjRRcDklHFKYmKcTHOppIbR9JtOCoQZRCer8cQKBcuzIq
        EM6SveYBqUYvVaun91OGPhpL0Ko4u+/DF0/O9mkaHXT/wC/M0ICIXU71iYnKojIT7f0dfx
        VwFQ5pJzaVHr2iO7YWrMt7Y2IQ/M3EE=
Content-Disposition: inline
In-Reply-To: <d4ba14b0-ee06-b793-a840-2c2ff369d890-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: chenzhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--G5CWgaLxblIFSK1F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 14, 2021 at 10:08:19PM +0800, chenzhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> In this case, at the beginning of function check_cgroupfs_options(), the mask
> ctx->subsys_mask will be 0. And if we mount without 'none' and 'name=' options,
> then in check_cgroupfs_options(), the flag ctx->all_ss will be set, that is, select all the subsystems.
But even then, the line
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/cgroup/cgroup-v1.c?h=v5.11-rc3#n1012
would select only 'enabled' controllers, wouldn't it?

It's possible I missed something but if this means that cgroup_no_v1=
doesn't hold to its expectations, I'd suggest adding proper Fixes: tag
to the patch.

Thanks,
Michal

--G5CWgaLxblIFSK1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmAAd1QACgkQia1+riC5
qSgWoQ/+IhQQDXjrTBF5Pw5vod0YE5rO2MUWtzh4d1tLQTjzBng8E1jnWV3jAsD8
wFqLWz3JxqFUQa9A0DEKWjwmHfu0ud0A6t/eCV24Xm6JoX8vcR1dVimMzCUd2Hjk
QINq+w81pOhqZX0vjGPRW8J1cf8jMjQgQ0nZmHxm11TaGuO5G3dvhVJuFAjXyvEy
568of571ti78CKzoa7zt5KK1ID2m3u3rk5WDuGGj4zlTg2QoqFOxrBprRaF/1eCu
0Fk+LKva7qmiGP87uXFt124432CQ8AAGG+fsAzcBqKuIFFxcpzyrnkP8jNRZS0xV
Sb7nZ7ivB50YyMJxorpXiRT2lhh+BtFbvydWuAs1PGh7z8B6AexE4XtF52XBeybB
MSpQJ/0E9LuesHjcEFXLzGwFe7Dw5N0u4pNrKo5QMh63PveCx7KxIcdBWXihuBJm
pDE9d707NJ2g4M4/88Hvs9QIiBmzOU9h/x2zKVNKMM4io7o51hUEHkUEG/4nb0/d
tUvH1jxlFPeQh4UoazlKnTMq3ljI1gi1mBq6ytoptxVxdu4rvhBNcrd+nuKcWKtu
vWwdZ8lh9crRwEWbLtIVY0flm2GX4Nu5xq/VF1y67QA1e+34NjwMX8a2GrrS1dBK
q/NvMQTk62NfRzjrh+uabF5pEcA/K7EvnKQLGasG1RYmvas3YoI=
=9rm1
-----END PGP SIGNATURE-----

--G5CWgaLxblIFSK1F--
