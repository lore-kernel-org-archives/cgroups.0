From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Tue, 21 Feb 2023 13:51:29 +0000
Message-ID: <Y/TMYa8DrocppXRu@casper.infradead.org>
References: <20230220230624.lkobqeagycx7bi7p@google.com>
 <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
 <CALvZod55K5zbbVYptq8ud=nKVyU1xceGVf6UcambBZ3BA2TZqA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=NEdXprvhxHyHHSPQOtkKZLXBLzv1Cy2bQgCVUfMHYac=; b=bH66sA8fhWiJwQgo9PIB7tMy5k
        CksVVbZTIHgCQSPNdPeVxN0HKxQ1+pV9FYrnABQ3mTEqaH7e1DRPYTwHZYBtSYyXZZWkl8y3Z68zq
        uQFaZrRSGbPJjxA/REMS6x8QUqcbMZ8qJeQKFzvwdyFT8wL5o/x2mhz5dHl2YFUDSnfQyymSPy8lx
        FAkT6yQ9vuZLtc5WTQoo3oTYkHeGORlrSkJhFeNKSLbHLDY9ayuIgtw7AEwx/Pb4/9QHd+lXRXmHn
        rVqTpfRYBenwXyzvbVqvMDx7Sk/DmvQdOJO+34bkSxQdt7ZAIvHFZ7eOl0ME9lDFuAn9uvJ+fpjNG
        0W6/FiLw==;
Content-Disposition: inline
In-Reply-To: <CALvZod55K5zbbVYptq8ud=nKVyU1xceGVf6UcambBZ3BA2TZqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Feb 20, 2023 at 10:52:10PM -0800, Shakeel Butt wrote:
> On Mon, Feb 20, 2023 at 9:17 PM Roman Gushchin <roman.gushchin-fxUVXftIFD=
nyG1zEObXtfA@public.gmane.org> wrote:
> > > On Feb 20, 2023, at 3:06 PM, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR=
+AlfA@public.gmane.org> wrote:
> > >
> > > =EF=BB=BFOn Mon, Feb 20, 2023 at 01:09:44PM -0800, Roman Gushchin wro=
te:
> > >>> On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
> > >>> The knob for cgroup v2 memory controller: memory.oom.group
> > >>> will be read and written simultaneously by user space
> > >>> programs, thus we'd better change memcg->oom_group access
> > >>> with atomic operations to avoid concurrency problems.
> > >>>
> > >>> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gma=
ne.org>
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
>=20
> For this particular case, documenting such an access. Though I don't
> think there are any architectures which may tear a one byte read/write
> and merging/refetching is not an issue for this.

Wouldn't a compiler be within its rights to implement a one byte store as:

	load-word
	modify-byte-in-word
	store-word

and if this is a lockless store to a word which has an adjacent byte also
being modified by another CPU, one of those CPUs can lose its store?
And WRITE_ONCE would prevent the compiler from implementing the store
in that way.

