From: Martin Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Wed, 22 Feb 2023 01:00:00 +0800
Message-ID: <CADfL_jBDNZiEWbnn+w9+FhSRPzVwP872XBbhYTZwny8Jzr4bDw@mail.gmail.com>
References: <20230220230624.lkobqeagycx7bi7p@google.com> <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sC+l61qoknT1eRg99Cptt6lYzgJ7/E5pHZ5cZZg+HEA=;
        b=E3v/fWrkgoLvZ5IU6Z/wsyMkwmei+5ld4ItC04k3iIZ/mrR1aWYZlDsmoHnjBrrxBj
         dBYd+W2meo9XHLZHLYVjzfYEUj5KdyEJf6JrkN4kN63PSxA+AnLFe7DmjpSg1XKxDTTB
         jEwWgDK73jGLbxzC1UmyWwop6BZZaO6vd+9lPJ51CBQ4sykllhsRambNSkSek8QvjM2A
         Y2aavvHy04zSorbnx18YIDRUYQTTfWjsEwjxN0yO/l5RGOtoA4ubiRO/63oottneqqxR
         IZHNhaQSILIxj/MdRF3MSaXJF5L0v+FFpiqXgVF8O7KStGWfantC/txGgB21EhbI7xMY
         bq7g==
In-Reply-To: <6563189C-7765-4FFA-A8F2-A5CC4860A1EF-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Tue, Feb 21, 2023 at 1:17 PM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> w=
rote:
>
> > On Feb 20, 2023, at 3:06 PM, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > =EF=BB=BFOn Mon, Feb 20, 2023 at 01:09:44PM -0800, Roman Gushchin wrote=
:
> >>> On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
> >>> The knob for cgroup v2 memory controller: memory.oom.group
> >>> will be read and written simultaneously by user space
> >>> programs, thus we'd better change memcg->oom_group access
> >>> with atomic operations to avoid concurrency problems.
> >>>
> >>> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> Hi Yue!
> >>
> >> I'm curious, have any seen any real issues which your patch is solving=
?
> >> Can you, please, provide a bit more details.
> >>
> >
> > IMHO such details are not needed. oom_group is being accessed
> > concurrently and one of them can be a write access. At least
> > READ_ONCE/WRITE_ONCE is needed here.
>
> Needed for what?
>
> I mean it=E2=80=99s obviously not a big deal to put READ_ONCE()/WRITE_ONC=
E() here, but I struggle to imagine a scenario when it will make any differ=
ence. IMHO it=E2=80=99s easier to justify a proper atomic operation here, e=
ven if it=E2=80=99s most likely an overkill.
>
> My question is very simple: the commit log mentions =E2=80=9C=E2=80=A6 to=
 avoid concurrency problems=E2=80=9D, so I wonder what problems are these.

Thanks for your watching!
This topic is found in code review by coincidence, so no real issues
recorded for now. I checked other read/write callbacks about other knobs,
most of them use READ_ONCE/WRITE_ONCE on the user setting variable.
Actually I am curious as well why this interface doesn't use
READ_ONCE/WRITE_ONCE, is there any other synchronization mechanism I
didn't notice yet?

>
> Also there are other similar cgroup interfaces without READ_ONCE()/WRITE_=
ONCE().
>
> Thanks!
