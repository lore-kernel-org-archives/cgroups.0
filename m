From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Tue, 21 Feb 2023 14:23:31 -0800
Message-ID: <Y/VEY2myhfWvB64+@P9FQF9L96D.corp.robot.car>
References: <20230220230624.lkobqeagycx7bi7p@google.com>
 <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
 <CALvZod55K5zbbVYptq8ud=nKVyU1xceGVf6UcambBZ3BA2TZqA@mail.gmail.com>
 <Y/TMYa8DrocppXRu@casper.infradead.org>
 <CALvZod6UM1E6nGgfdORri90m3ju+yYeSeHBqyqutCP2A94WNKg@mail.gmail.com>
 <20230221182359.GJ2948950@paulmck-ThinkPad-P17-Gen-1>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677018239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UDfWngDlcfpQfS3lJyJErPkVc/zetFCIA0DaxdQx8j8=;
        b=qqNpFu34+tok07/qJ6ppdjFXYB1QVP7gxaaGQKi3W4IgdsQwHf+s1amOT1lklN/0TMvdCH
        r9OcEf07ib6npxvTrdXrmmf/QSomZkg9iPHy5I1pmP+q2LwT648nhR4teqyQfH4qMlfKTW
        u08RfLlGhWIuN57NayTtJ/Bw02glWss=
Content-Disposition: inline
In-Reply-To: <20230221182359.GJ2948950@paulmck-ThinkPad-P17-Gen-1>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 21, 2023 at 10:23:59AM -0800, Paul E. McKenney wrote:
> On Tue, Feb 21, 2023 at 08:56:59AM -0800, Shakeel Butt wrote:
> > +Paul & Marco
> >=20
> > On Tue, Feb 21, 2023 at 5:51 AM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAw=
A7xHQ@public.gmane.org> wrote:
> > >
> > > On Mon, Feb 20, 2023 at 10:52:10PM -0800, Shakeel Butt wrote:
> > > > On Mon, Feb 20, 2023 at 9:17 PM Roman Gushchin <roman.gushchin-fxUV=
XftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> > > > > > On Feb 20, 2023, at 3:06 PM, Shakeel Butt <shakeelb-hpIqsD4AKlf=
QT0dZR+AlfA@public.gmane.org> wrote:
> > > > > >
> > > > > > =EF=BB=BFOn Mon, Feb 20, 2023 at 01:09:44PM -0800, Roman Gushch=
in wrote:
> > > > > >>> On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
> > > > > >>> The knob for cgroup v2 memory controller: memory.oom.group
> > > > > >>> will be read and written simultaneously by user space
> > > > > >>> programs, thus we'd better change memcg->oom_group access
> > > > > >>> with atomic operations to avoid concurrency problems.
> > > > > >>>
> > > > > >>> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@publ=
ic.gmane.org>
> > > > > >>
> > > > > >> Hi Yue!
> > > > > >>
> > > > > >> I'm curious, have any seen any real issues which your patch is=
 solving?
> > > > > >> Can you, please, provide a bit more details.
> > > > > >>
> > > > > >
> > > > > > IMHO such details are not needed. oom_group is being accessed
> > > > > > concurrently and one of them can be a write access. At least
> > > > > > READ_ONCE/WRITE_ONCE is needed here.
> > > > >
> > > > > Needed for what?
> > > >
> > > > For this particular case, documenting such an access. Though I don't
> > > > think there are any architectures which may tear a one byte read/wr=
ite
> > > > and merging/refetching is not an issue for this.
> > >
> > > Wouldn't a compiler be within its rights to implement a one byte stor=
e as:
> > >
> > >         load-word
> > >         modify-byte-in-word
> > >         store-word
> > >
> > > and if this is a lockless store to a word which has an adjacent byte =
also
> > > being modified by another CPU, one of those CPUs can lose its store?
> > > And WRITE_ONCE would prevent the compiler from implementing the store
> > > in that way.
> >=20
> > Thanks Willy for pointing this out. If the compiler can really do this
> > then [READ|WRITE]_ONCE are required here. I always have big bad
> > compiler lwn article open in a tab. I couldn't map this transformation
> > to ones mentioned in that article. Do we have name of this one?
>=20
> No, recent compilers are absolutely forbidden from doing this sort of
> thing except under very special circumstances.
>=20
> Before C11, compilers could and in fact did do things like this.  This is
> after all a great way to keep the CPU's vector unit from getting bored.
> Unfortunately for those who prize optimization above all else, doing
> this can introduce data races, for example:
>=20
> 	char a;
> 	char b;
> 	spin_lock la;
> 	spin_lock lb;
>=20
> 	void change_a(char new_a)
> 	{
> 		spin_lock(&la);
> 		a =3D new_a;
> 		spin_unlock(&la);
> 	}
>=20
> 	void change_b(char new_b)
> 	{
> 		spin_lock(&lb);
> 		b =3D new_b;
> 		spin_unlock(&lb);
> 	}
>=20
> If the compiler "optimized" that "a =3D new_a" so as to produce a non-ato=
mic
> read-modify-write sequence, it would be introducing a data race.
> And since C11, the compiler is absolutely forbidden from introducing
> data races.  So, again, no, the compiler cannot invent writes to
> variables.
>=20
> What are those very special circumstances?
>=20
> 1.	The other variables were going to be written to anyway, and
> 	none of the writes was non-volatile and there was no ordering
> 	directive between any of those writes.
>=20
> 2.	The other variables are dead, as in there are no subsequent
> 	reads from them anywhere in the program.  Of course in that case,
> 	there is no need to read the prior values of those variables.
>=20
> 3.	All accesses to all of the variables are visible to the compiler,
> 	and the compiler can prove that there are no concurrent accesses
> 	to any of them.  For example, all of the variables are on-stack
> 	variables whose addresses are never taken.
>=20
> Does that help, or am I misunderstanding the question?

Thank you, Paul!

So it seems like READ_ONCE()/WRITE_ONCE() are totally useless here.
Or I still miss something?

Thanks!
