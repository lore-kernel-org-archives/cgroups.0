From: Martin Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Wed, 22 Feb 2023 01:00:00 +0800
Message-ID: <CADfL_jCtXEju4QsSig1-CBE_3ai_NgJOorVc1mk3+W=metkPJg@mail.gmail.com>
References: <20230220230624.lkobqeagycx7bi7p@google.com> <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
 <CALvZod55K5zbbVYptq8ud=nKVyU1xceGVf6UcambBZ3BA2TZqA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676998871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JRQwKwj8b0XKFHecLezQ5DNfFD4GoTefbmEJjJYT/FE=;
        b=ABXQQSlSlcD3PY+8NQlv8y2MBo2ClB335AEhs+OTZHjLnQl/o4G2B7C4jxBfADZGXj
         z0oxUj78k1BjtCfktO89Yr/n4aNh0mpG7XMMUwUl+HfBnWxyPxolmRERbX0kkl0ta+XQ
         C8r9fXF6DnNTNfkh6KwdEVnOJiMwswlFrzF6cpnLS4hRAsX0Mzkw+4kyboIMpl5VDUIM
         Z7FqUNY6266OhC97ZEK4gmrj4+L/nqYhrKdWxJFcS43V17DZDWIYHCEZpB1w2UG5uK6g
         LFQ2UhX1Nh7ga9LO9t35TOByzPoyt1C5L43/pt7jk5QtLc1ddtHjsTbf4EfLFQQERUML
         YiIA==
In-Reply-To: <CALvZod55K5zbbVYptq8ud=nKVyU1xceGVf6UcambBZ3BA2TZqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Tue, Feb 21, 2023 at 2:52 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Mon, Feb 20, 2023 at 9:17 PM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>=
 wrote:
> >
> > > On Feb 20, 2023, at 3:06 PM, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote=
:
> > >
> > > =EF=BB=BFOn Mon, Feb 20, 2023 at 01:09:44PM -0800, Roman Gushchin wro=
te:
> > >>> On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
> > >>> The knob for cgroup v2 memory controller: memory.oom.group
> > >>> will be read and written simultaneously by user space
> > >>> programs, thus we'd better change memcg->oom_group access
> > >>> with atomic operations to avoid concurrency problems.
> > >>>
> > >>> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > >>
> > >> Hi Yue!
> > >>
> > >> I'm curious, have any seen any real issues which your patch is solvi=
ng?
> > >> Can you, please, provide a bit more details.
> > >>
> > >
> > > IMHO such details are not needed. oom_group is being accessed
> > > concurrently and one of them can be a write access. At least
> > > READ_ONCE/WRITE_ONCE is needed here.
> >
> > Needed for what?
>
> For this particular case, documenting such an access. Though I don't
> think there are any architectures which may tear a one byte read/write
> and merging/refetching is not an issue for this.
>
> >
> > I mean it=E2=80=99s obviously not a big deal to put READ_ONCE()/WRITE_O=
NCE() here, but I struggle to imagine a scenario when it will make any diff=
erence. IMHO it=E2=80=99s easier to justify a proper atomic operation here,=
 even if it=E2=80=99s most likely an overkill.
> >
> > My question is very simple: the commit log mentions =E2=80=9C=E2=80=A6 =
to avoid concurrency problems=E2=80=9D, so I wonder what problems are these=
.
> >
> > Also there are other similar cgroup interfaces without READ_ONCE()/WRIT=
E_ONCE()
>
> Yeah and those are v1 interfaces e.g. oom_kill_disable, swappiness,
> soft_limit. These definitely need [READ|WRITE]_ONCE primitive.
>
> Yue, can you update your patch and convert all accesses to these
> fields through [READ|WRITE]_ONCE ?

Sure, it will take some time to update my patch later. I think most of
the accesses use [READ|WRITE]_ONCE already, only few interfaces need to
update.
