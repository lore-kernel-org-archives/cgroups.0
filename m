From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 10:40:42 -0700
Message-ID: <CAJuCfpFYq7CZS4y2ZiF+AJHRKwnyhmZCk_uuTwFse26DxGh-qQ@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com> <20230503122839.0d9934c5@gandalf.local.home>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683135654; x=1685727654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VnWJwoqbKS+XkHViPIVupavn1s9FL+9QLrnitzrqP5g=;
        b=eK3o90MKtG0sAxJkQzBjjPPdgC8Naf0DW8LSnzzFyGy7r2iplN6tx8LRS+K1pesqQ/
         +dlPpm9XhI5MpmbmybPkhrAEcSQe8jXQWxke9zLF0oWZbujbmGNiLr16iUXkN33UUHSx
         XBXGIEWcktzdHazuLFLqwBuOkd1R9zqRh1rR05EQP6mEIW+Y870cMvkQ+YZdkTbO3EXe
         JnQPUyB6BIyM6BqPoFJBWX+ubIIjmGY6Y6TRZTV6HlKG9bq6FA2QoEZiVTg495moZLJm
         8j7J7Vy9fMLWKuo3JHmpkQUMBoO2kqt3hu+UuR0WJjg5iixGZu5y4Lvke1eQTwl5WZQa
         NpXA==
In-Reply-To: <20230503122839.0d9934c5-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, an

On Wed, May 3, 2023 at 9:28=E2=80=AFAM Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>=
 wrote:
>
> On Wed, 3 May 2023 08:09:28 -0700
> Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> > There is another issue, which I think can be solved in a smart way but
> > will either affect performance or would require more memory. With the
> > tracing approach we don't know beforehand how many individual
> > allocation sites exist, so we have to allocate code tags (or similar
> > structures for counting) at runtime vs compile time. We can be smart
> > about it and allocate in batches or even preallocate more than we need
> > beforehand but, as I said, it will require some kind of compromise.
>
> This approach is actually quite common, especially since tagging every
> instance is usually overkill, as if you trace function calls in a running
> kernel, you will find that only a small percentage of the kernel ever
> executes. It's possible that you will be allocating a lot of tags that wi=
ll
> never be used. If run time allocation is possible, that is usually the
> better approach.

True but the memory overhead should not be prohibitive here. As a
ballpark number, on my machine I see there are 4838 individual
allocation locations and each codetag structure is 32 bytes, so that's
152KB.

>
> -- Steve
