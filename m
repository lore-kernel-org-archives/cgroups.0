From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 1/5] cgroups: Refactor children cgroups in memcg tests
Date: Sat, 23 Apr 2022 08:19:12 -0700
Message-ID: <EEC47283-0467-4C97-AAB2-73F17A97CE15@linux.dev>
References: <20220423113037.gnfysktiuzmfnpmp@dev0025.ash9.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1650727155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aW7jQR0KWBIkc4nx/X//lum8iJfo1esC27ROXDMIAM4=;
        b=tO1NY6Tjb52mvbTO2n1UoZ4ofdNFJe5Rn2F3aOr80/443JzWwjPwIHRZaB09H7e/SGTT+A
        DwxwMMOFZrWW7uiKMhXg/LEb0QHoJ001PDYSYQONXpFIWirG5EHMvcNcz4JIPAEkycaEAJ
        yYqK0l9Jyyn+PjxfPemSMfh0be1Ox3o=
In-Reply-To: <20220423113037.gnfysktiuzmfnpmp-2sxDN0k4oOr/D8ZFBB3Vemm1Eemhq0z/AL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org


> On Apr 23, 2022, at 4:30 AM, David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org> wrote:
>=20
> =EF=BB=BFOn Fri, Apr 22, 2022 at 04:04:15PM -0700, Roman Gushchin wrote:
>>=20
>=20
> Thanks for the reviews on this patchset, Roman. FYI I think Andrew already=

> merged these patches to the -mm tree. I'll send out a follow-on patch that=

> fixes everything you pointed out, both here and on the other patches in th=
e
> set.

The mm tree isn=E2=80=99t a git tree, but a collection of the text patches, m=
anaged by Andrew. So you can send a new version and Andrew can update it in p=
lace. It=E2=80=99s happening all the time: mostly for adding reviewed-by/ack=
ed-by tags etc, but for code updates as well.
It=E2=80=99s not uncommon for some patchset to mature while being in the mm t=
ree, this allows to include them into linux-next and give some more testing,=
 but without doing many reverts/fixups (Andrew is often squashing fixups int=
o the original patch too). So long story short, you can just send a new vers=
ion, especially because all changes all minor.

Thanks!=
