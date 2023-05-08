From: Petr =?UTF-8?B?VGVzYcWZw61r?= <petr-hIRrMMry8ebtwjQa/ONI9g@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Mon, 8 May 2023 20:59:39 +0200
Message-ID: <20230508205939.0b5b485c@meshulam.tesarici.cz>
References: <20230501165450.15352-1-surenb@google.com>
        <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
        <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com>
        <ZFN1yswCd9wRgYPR@dhcp22.suse.cz>
        <ZFfd99w9vFTftB8D@moria.home.lan>
        <20230508175206.7dc3f87c@meshulam.tesarici.cz>
        <ZFkb1p80vq19rieI@moria.home.lan>
        <20230508180913.6a018b21@meshulam.tesarici.cz>
        <ZFkjRBCExpXfI+O5@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tesarici.cz; s=mail;
        t=1683572382; bh=uZkqx7aKUtaW85glkXkWc2KSVWl1+jLzvm0vqmvOK4k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oMA1JDBfpJw4sW7xwHIesfwzVvuWGRfEibImYMO8MGVZr8iRllWIfuu/0e/mR8S35
         iSTkGom3l2vCdobWQ2bfVa6nZe4sueYcQ8TRCacsjjA5CE1u6g+C6TnyFwqEgekR80
         QJhrpkc85RcLvfsJty39syGBqRtbVmBD8gRTuYp0lKs/3I0TMuZAwoFEzyxCISt87Q
         jFclnxrFT242I64DoHaTh7hEShSdJRQAi3f8B9Gi+6bMke4t3VWU3TXk/2b2p3mKb+
         ZKQmv+XMh4jxUtnY4XLyIY3pSmPZPhKIaboj506ssLQOCqeMss+Ypkje+lMahARxZd
         uaDOOK7Oe/wvA==
In-Reply-To: <ZFkjRBCExpXfI+O5-jC9Py7bek1znysI04z7BkA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Mon, 8 May 2023 12:28:52 -0400
Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:

> On Mon, May 08, 2023 at 06:09:13PM +0200, Petr Tesa=C5=99=C3=ADk wrote:
> > Sure, although AFAIK the index does not cover all possible config
> > options (so non-x86 arch code is often forgotten). However, that's the
> > less important part.
> >=20
> > What do you do if you need to hook something that does conflict with an
> > existing identifier? =20
>=20
> As already happens in this patchset, rename the other identifier.
>=20
> But this is C, we avoid these kinds of conflicts already because the
> language has no namespacing

This statement is not accurate, but I agree there's not much. Refer to
section 6.2.3 of ISO/IEC9899:2018 (Name spaces of identifiers).

More importantly, macros also interfere with identifier scoping, e.g.
you cannot even have a local variable with the same name as a macro.
That's why I dislike macros so much.

But since there's no clear policy regarding macros in the kernel, I'm
merely showing a downside; it's perfectly fine to write kernel code
like this as long as the maintainers agree that the limitation is
acceptable and outweighed by the benefits.

Petr T

> it's going to be a pretty rare situtaion
> going forward. Most of the hooking that will be done is done with this
> patchset, and there was only one identifier that needed to be renamed.
>=20

