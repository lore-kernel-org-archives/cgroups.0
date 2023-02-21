From: "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Tue, 21 Feb 2023 10:23:59 -0800
Message-ID: <20230221182359.GJ2948950@paulmck-ThinkPad-P17-Gen-1>
References: <20230220230624.lkobqeagycx7bi7p@google.com>
 <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
 <CALvZod55K5zbbVYptq8ud=nKVyU1xceGVf6UcambBZ3BA2TZqA@mail.gmail.com>
 <Y/TMYa8DrocppXRu@casper.infradead.org>
 <CALvZod6UM1E6nGgfdORri90m3ju+yYeSeHBqyqutCP2A94WNKg@mail.gmail.com>
Reply-To: paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677003839;
        bh=9ofw9kmJ1/A9L4elUMt/ZOXxCnVJ5NivStbIGbYhioE=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=juAEGmzdsgfKKLgLJNn+Inn1X4C1M6/sxFFCnpsa66BydSQlHcBhJQ8BZlWZl3izN
         bJTP6eMwLJEaw0CGN50rbbw8xLUi/3lalJm/AvX09Ta6xCwYX3Pr82beAkwouT76FA
         xnGh8ybiK7K3uCfExn2Gc6EOOFLNJP9FgHRMCK+98Tqi/xWZJXK0fmnltLX+GTkqs4
         6LIv2HfpocPjQckppEZF9KSI5oITDttJW3l387+BkEOXlkf47QskdX1KRRysWBJ/4Q
         6sQF3JbaGB5hwfhVHYJr3WVojohK9l6pSGDnvFJ8qWFNExnhUmDpzEQZJi1PHPm4RV
         YNn+/e5k6iegg==
Content-Disposition: inline
In-Reply-To: <CALvZod6UM1E6nGgfdORri90m3ju+yYeSeHBqyqutCP2A94WNKg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 21, 2023 at 08:56:59AM -0800, Shakeel Butt wrote:
> +Paul & Marco
>=20
> On Tue, Feb 21, 2023 at 5:51 AM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7=
xHQ@public.gmane.org> wrote:
> >
> > On Mon, Feb 20, 2023 at 10:52:10PM -0800, Shakeel Butt wrote:
> > > On Mon, Feb 20, 2023 at 9:17 PM Roman Gushchin <roman.gushchin-fxUVXf=
tIFDnyG1zEObXtfA@public.gmane.org> wrote:
> > > > > On Feb 20, 2023, at 3:06 PM, Shakeel Butt <shakeelb-hpIqsD4AKlfQT=
0dZR+AlfA@public.gmane.org> wrote:
> > > > >
> > > > > =EF=BB=BFOn Mon, Feb 20, 2023 at 01:09:44PM -0800, Roman Gushchin=
 wrote:
> > > > >>> On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
> > > > >>> The knob for cgroup v2 memory controller: memory.oom.group
> > > > >>> will be read and written simultaneously by user space
> > > > >>> programs, thus we'd better change memcg->oom_group access
> > > > >>> with atomic operations to avoid concurrency problems.
> > > > >>>
> > > > >>> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public=
.gmane.org>
> > > > >>
> > > > >> Hi Yue!
> > > > >>
> > > > >> I'm curious, have any seen any real issues which your patch is s=
olving?
> > > > >> Can you, please, provide a bit more details.
> > > > >>
> > > > >
> > > > > IMHO such details are not needed. oom_group is being accessed
> > > > > concurrently and one of them can be a write access. At least
> > > > > READ_ONCE/WRITE_ONCE is needed here.
> > > >
> > > > Needed for what?
> > >
> > > For this particular case, documenting such an access. Though I don't
> > > think there are any architectures which may tear a one byte read/write
> > > and merging/refetching is not an issue for this.
> >
> > Wouldn't a compiler be within its rights to implement a one byte store =
as:
> >
> >         load-word
> >         modify-byte-in-word
> >         store-word
> >
> > and if this is a lockless store to a word which has an adjacent byte al=
so
> > being modified by another CPU, one of those CPUs can lose its store?
> > And WRITE_ONCE would prevent the compiler from implementing the store
> > in that way.
>=20
> Thanks Willy for pointing this out. If the compiler can really do this
> then [READ|WRITE]_ONCE are required here. I always have big bad
> compiler lwn article open in a tab. I couldn't map this transformation
> to ones mentioned in that article. Do we have name of this one?

No, recent compilers are absolutely forbidden from doing this sort of
thing except under very special circumstances.

Before C11, compilers could and in fact did do things like this.  This is
after all a great way to keep the CPU's vector unit from getting bored.
Unfortunately for those who prize optimization above all else, doing
this can introduce data races, for example:

	char a;
	char b;
	spin_lock la;
	spin_lock lb;

	void change_a(char new_a)
	{
		spin_lock(&la);
		a =3D new_a;
		spin_unlock(&la);
	}

	void change_b(char new_b)
	{
		spin_lock(&lb);
		b =3D new_b;
		spin_unlock(&lb);
	}

If the compiler "optimized" that "a =3D new_a" so as to produce a non-atomic
read-modify-write sequence, it would be introducing a data race.
And since C11, the compiler is absolutely forbidden from introducing
data races.  So, again, no, the compiler cannot invent writes to
variables.

What are those very special circumstances?

1.	The other variables were going to be written to anyway, and
	none of the writes was non-volatile and there was no ordering
	directive between any of those writes.

2.	The other variables are dead, as in there are no subsequent
	reads from them anywhere in the program.  Of course in that case,
	there is no need to read the prior values of those variables.

3.	All accesses to all of the variables are visible to the compiler,
	and the compiler can prove that there are no concurrent accesses
	to any of them.  For example, all of the variables are on-stack
	variables whose addresses are never taken.

Does that help, or am I misunderstanding the question?

							Thanx, Paul
