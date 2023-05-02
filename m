From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in string_get_size's output
Date: Tue, 2 May 2023 08:33:57 +0300
Message-ID: <CAHp75VdK2bgU8P+-np7ScVWTEpLrz+muG-R15SXm=ETXnjaiZg@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <20230501165450.15352-2-surenb@google.com>
 <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
 <ZFAUj+Q+hP7cWs4w@moria.home.lan> <b6b472b65b76e95bb4c7fc7eac1ee296fdbb64fd.camel@HansenPartnership.com>
 <ZFCA2FF+9MI8LI5i@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683005674; x=1685597674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qrcuuma9akhRKA9cVsiv9Wp3Fts3/L+OpcqEI96PfXk=;
        b=QF1HVjPTepvbrQ9oJRLkb6f8AJvX+hO2zQE2ZY/l3fUgEFOfqL1wf8m0RGFQ4awGlN
         sWkxd9j28poLLl8dBgEc54m1kLx91P31/J3vbCIAx0/CoGXAsbwCOE363uYJGP9GkB5b
         3lymi+vNqj9QoS17H6nGkbM5o+IGDFDB9cd/G6K1hJSdkvWt972kMNAdb/+wzno7m9jZ
         f0XwZxnSXtuHXZc3vW87bizP3VIj3Spc6/Cesx4fCw9piQPSAItNDleA+xpCa+67Mn+G
         vzbu6giNBfMNRicZ3wSxkGrbLyqmcdrr5AdLiwR1ViUDz037I1qTRRGrjMrCbz3a2XiY
         9TDQ==
In-Reply-To: <ZFCA2FF+9MI8LI5i-jC9Py7bek1znysI04z7BkA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowe

On Tue, May 2, 2023 at 6:18=E2=80=AFAM Kent Overstreet
<kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> On Mon, May 01, 2023 at 10:22:18PM -0400, James Bottomley wrote:

...

> > > If someone raises a specific objection we'll do something different,
> > > otherwise I think standardizing on what userspace tooling already
> > > parses is a good idea.
> >
> > If you want to omit the space, why not simply add your own variant?  A
> > string_get_size_nospace() which would use most of the body of this one
> > as a helper function but give its own snprintf format string at the
> > end.  It's only a couple of lines longer as a patch and has the bonus
> > that it definitely wouldn't break anything by altering an existing
> > output.
>
> I'm happy to do that - I just wanted to post this version first to see
> if we can avoid the fragmentation and do a bit of standardizing with
> how everything else seems to do that.

Actually instead of producing zillions of variants, do a %p extension
to the printf() and that's it. We have, for example, %pt with T and
with space to follow users that want one or the other variant. Same
can be done with string_get_size().

--=20
With Best Regards,
Andy Shevchenko
