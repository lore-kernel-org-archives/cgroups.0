From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Tue, 21 Feb 2023 08:56:59 -0800
Message-ID: <CALvZod6UM1E6nGgfdORri90m3ju+yYeSeHBqyqutCP2A94WNKg@mail.gmail.com>
References: <20230220230624.lkobqeagycx7bi7p@google.com> <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
 <CALvZod55K5zbbVYptq8ud=nKVyU1xceGVf6UcambBZ3BA2TZqA@mail.gmail.com> <Y/TMYa8DrocppXRu@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TfWrKhC0Efcbpjp7w2MXsBIaeBw0Ifz30UZjyvdXZU8=;
        b=T+TvPcrcFUKrIua4z6RQ1S+jaZ0P9bUBa/CVTFhVVu5KyCr2lY+itYJuXh8njQZOyO
         TUsUmevowwVhXmxwvkBfVYi4nDHO1oA2g+YerK6gzZS5pU2VFYt8ub8vt9ZyYGFjnrH2
         BOrqE4LH8nzrr2/mPQjW5Pi3d+T+crSDuEBRGZUqTN4t/YDHoOFMc4hU5knIy8DCk5sG
         TK/8HYz2FnR8oiJTGrdxBzlfnXICjNhWuJ+hau8wiabqlvl5Vl5+YhyfvV1gwnO33QCd
         R1ndg/MrlKjhTox2ibB+MD0EEzL2tNw4kRxtG7WhMsfdIW/GaPcCH/P/HmSKpv1fwzPM
         +lCQ==
In-Reply-To: <Y/TMYa8DrocppXRu-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

+Paul & Marco

On Tue, Feb 21, 2023 at 5:51 AM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Mon, Feb 20, 2023 at 10:52:10PM -0800, Shakeel Butt wrote:
> > On Mon, Feb 20, 2023 at 9:17 PM Roman Gushchin <roman.gushchin-fxUVXftIFDk@public.gmane.org=
v> wrote:
> > > > On Feb 20, 2023, at 3:06 PM, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wro=
te:
> > > >
> > > > =EF=BB=BFOn Mon, Feb 20, 2023 at 01:09:44PM -0800, Roman Gushchin w=
rote:
> > > >>> On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
> > > >>> The knob for cgroup v2 memory controller: memory.oom.group
> > > >>> will be read and written simultaneously by user space
> > > >>> programs, thus we'd better change memcg->oom_group access
> > > >>> with atomic operations to avoid concurrency problems.
> > > >>>
> > > >>> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > >>
> > > >> Hi Yue!
> > > >>
> > > >> I'm curious, have any seen any real issues which your patch is sol=
ving?
> > > >> Can you, please, provide a bit more details.
> > > >>
> > > >
> > > > IMHO such details are not needed. oom_group is being accessed
> > > > concurrently and one of them can be a write access. At least
> > > > READ_ONCE/WRITE_ONCE is needed here.
> > >
> > > Needed for what?
> >
> > For this particular case, documenting such an access. Though I don't
> > think there are any architectures which may tear a one byte read/write
> > and merging/refetching is not an issue for this.
>
> Wouldn't a compiler be within its rights to implement a one byte store as=
:
>
>         load-word
>         modify-byte-in-word
>         store-word
>
> and if this is a lockless store to a word which has an adjacent byte also
> being modified by another CPU, one of those CPUs can lose its store?
> And WRITE_ONCE would prevent the compiler from implementing the store
> in that way.
>

Thanks Willy for pointing this out. If the compiler can really do this
then [READ|WRITE]_ONCE are required here. I always have big bad
compiler lwn article open in a tab. I couldn't map this transformation
to ones mentioned in that article. Do we have name of this one?

thanks,
Shakeel
