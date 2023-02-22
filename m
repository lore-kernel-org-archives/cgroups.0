From: "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Tue, 21 Feb 2023 16:37:59 -0800
Message-ID: <20230222003759.GO2948950@paulmck-ThinkPad-P17-Gen-1>
References: <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
 <CALvZod55K5zbbVYptq8ud=nKVyU1xceGVf6UcambBZ3BA2TZqA@mail.gmail.com>
 <Y/TMYa8DrocppXRu@casper.infradead.org>
 <CALvZod6UM1E6nGgfdORri90m3ju+yYeSeHBqyqutCP2A94WNKg@mail.gmail.com>
 <20230221182359.GJ2948950@paulmck-ThinkPad-P17-Gen-1>
 <Y/VEY2myhfWvB64+@P9FQF9L96D.corp.robot.car>
 <20230221223811.GK2948950@paulmck-ThinkPad-P17-Gen-1>
 <CALvZod7DaFeXFjYpnuP8U3QOjsQmKFHDMruB1-cm3Ly0HOH2FQ@mail.gmail.com>
 <20230221233824.GM2948950@paulmck-ThinkPad-P17-Gen-1>
 <Y/VahsJO3xNXi4CG@P9FQF9L96D.corp.robot.car>
Reply-To: paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677026280;
        bh=U3JyxAWOkhi4oz1iQIei0UlrbT0BOrvcTGqWTMnEkZY=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=nuyJyscZYgdy9Z9kPJjCoWU9IOYReu0RGu5qr9dWlW92LiuEpqfi2dIrRqAfsCXnA
         pVnjHqscO1+R9bvHyRjCbtynzXK5zx2KFZPVVE2JdzRgfMPSJuXImcwOR4lBtOHAzl
         mdMP/0s1fPSx8PzWX8BzcqZec4TWCncor6yzs3+UkN9D1DPWXv+GBdpubnRdYPY5ic
         2Vt1b2duwpCfCXaVZsn3xix+wPYeabYKTRA+rwkjjBBZ3h3HxM79+YN9gKhTMXk+N1
         esCmhyL12SsGhHlgw0pra/nOlzqYtF1KGKJBetcanh9xi0JfRtubMyVG9Ed+nyKUXP
         NBY1PBpxCEWaQ==
Content-Disposition: inline
In-Reply-To: <Y/VahsJO3xNXi4CG-+xijCwNIfdoLQcUKs7qKB+WAnPUfkyWGUBSOeVevoDU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 21, 2023 at 03:57:58PM -0800, Roman Gushchin wrote:
> On Tue, Feb 21, 2023 at 03:38:24PM -0800, Paul E. McKenney wrote:
> > On Tue, Feb 21, 2023 at 03:13:36PM -0800, Shakeel Butt wrote:
> > > On Tue, Feb 21, 2023 at 2:38 PM Paul E. McKenney <paulmck-DgEjT+Ai2yg=
dnm+yROfE0A@public.gmane.org> wrote:
> > > >
> > > > On Tue, Feb 21, 2023 at 02:23:31PM -0800, Roman Gushchin wrote:
> > > > > On Tue, Feb 21, 2023 at 10:23:59AM -0800, Paul E. McKenney wrote:
> > > > > > On Tue, Feb 21, 2023 at 08:56:59AM -0800, Shakeel Butt wrote:
> > > > > > > +Paul & Marco
> > > > > > >
> > > > > > > On Tue, Feb 21, 2023 at 5:51 AM Matthew Wilcox <willy-wEGCiKH=
e2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > > > > > > >
> > > > > > > > On Mon, Feb 20, 2023 at 10:52:10PM -0800, Shakeel Butt wrot=
e:
> > > > > > > > > On Mon, Feb 20, 2023 at 9:17 PM Roman Gushchin <roman.gus=
hchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> > > > > > > > > > > On Feb 20, 2023, at 3:06 PM, Shakeel Butt <shakeelb-h=
pIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > > > > > > > > >
> > > > > > > > > > > =EF=BB=BFOn Mon, Feb 20, 2023 at 01:09:44PM -0800, Ro=
man Gushchin wrote:
> > > > > > > > > > >>> On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao =
wrote:
> > > > > > > > > > >>> The knob for cgroup v2 memory controller: memory.oo=
m.group
> > > > > > > > > > >>> will be read and written simultaneously by user spa=
ce
> > > > > > > > > > >>> programs, thus we'd better change memcg->oom_group =
access
> > > > > > > > > > >>> with atomic operations to avoid concurrency problem=
s.
> > > > > > > > > > >>>
> > > > > > > > > > >>> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8Avxtiu=
Mwx3w@public.gmane.org>
> > > > > > > > > > >>
> > > > > > > > > > >> Hi Yue!
> > > > > > > > > > >>
> > > > > > > > > > >> I'm curious, have any seen any real issues which you=
r patch is solving?
> > > > > > > > > > >> Can you, please, provide a bit more details.
> > > > > > > > > > >>
> > > > > > > > > > >
> > > > > > > > > > > IMHO such details are not needed. oom_group is being =
accessed
> > > > > > > > > > > concurrently and one of them can be a write access. A=
t least
> > > > > > > > > > > READ_ONCE/WRITE_ONCE is needed here.
> > > > > > > > > >
> > > > > > > > > > Needed for what?
> > > > > > > > >
> > > > > > > > > For this particular case, documenting such an access. Tho=
ugh I don't
> > > > > > > > > think there are any architectures which may tear a one by=
te read/write
> > > > > > > > > and merging/refetching is not an issue for this.
> > > > > > > >
> > > > > > > > Wouldn't a compiler be within its rights to implement a one=
 byte store as:
> > > > > > > >
> > > > > > > >         load-word
> > > > > > > >         modify-byte-in-word
> > > > > > > >         store-word
> > > > > > > >
> > > > > > > > and if this is a lockless store to a word which has an adja=
cent byte also
> > > > > > > > being modified by another CPU, one of those CPUs can lose i=
ts store?
> > > > > > > > And WRITE_ONCE would prevent the compiler from implementing=
 the store
> > > > > > > > in that way.
> > > > > > >
> > > > > > > Thanks Willy for pointing this out. If the compiler can reall=
y do this
> > > > > > > then [READ|WRITE]_ONCE are required here. I always have big b=
ad
> > > > > > > compiler lwn article open in a tab. I couldn't map this trans=
formation
> > > > > > > to ones mentioned in that article. Do we have name of this on=
e?
> > > > > >
> > > > > > No, recent compilers are absolutely forbidden from doing this s=
ort of
> > > > > > thing except under very special circumstances.
> > > > > >
> > > > > > Before C11, compilers could and in fact did do things like this=
.  This is
> > > > > > after all a great way to keep the CPU's vector unit from gettin=
g bored.
> > > > > > Unfortunately for those who prize optimization above all else, =
doing
> > > > > > this can introduce data races, for example:
> > > > > >
> > > > > >     char a;
> > > > > >     char b;
> > > > > >     spin_lock la;
> > > > > >     spin_lock lb;
> > > > > >
> > > > > >     void change_a(char new_a)
> > > > > >     {
> > > > > >             spin_lock(&la);
> > > > > >             a =3D new_a;
> > > > > >             spin_unlock(&la);
> > > > > >     }
> > > > > >
> > > > > >     void change_b(char new_b)
> > > > > >     {
> > > > > >             spin_lock(&lb);
> > > > > >             b =3D new_b;
> > > > > >             spin_unlock(&lb);
> > > > > >     }
> > > > > >
> > > > > > If the compiler "optimized" that "a =3D new_a" so as to produce=
 a non-atomic
> > > > > > read-modify-write sequence, it would be introducing a data race.
> > > > > > And since C11, the compiler is absolutely forbidden from introd=
ucing
> > > > > > data races.  So, again, no, the compiler cannot invent writes to
> > > > > > variables.
> > > > > >
> > > > > > What are those very special circumstances?
> > > > > >
> > > > > > 1.  The other variables were going to be written to anyway, and
> > > > > >     none of the writes was non-volatile and there was no orderi=
ng
> > > > > >     directive between any of those writes.
> > > > > >
> > > > > > 2.  The other variables are dead, as in there are no subsequent
> > > > > >     reads from them anywhere in the program.  Of course in that=
 case,
> > > > > >     there is no need to read the prior values of those variable=
s.
> > > > > >
> > > > > > 3.  All accesses to all of the variables are visible to the com=
piler,
> > > > > >     and the compiler can prove that there are no concurrent acc=
esses
> > > > > >     to any of them.  For example, all of the variables are on-s=
tack
> > > > > >     variables whose addresses are never taken.
> > > > > >
> > > > > > Does that help, or am I misunderstanding the question?
> > > > >
> > > > > Thank you, Paul!
> > > > >
> > > > > So it seems like READ_ONCE()/WRITE_ONCE() are totally useless her=
e.
> > > > > Or I still miss something?
> > > >
> > > > Yes, given that the compiler will already avoid inventing data-race=
-prone
> > > > C-language accesses to shared variables, so if that was the only re=
ason
> > > > that you were using READ_ONCE() or WRITE_ONCE(), then READ_ONCE() a=
nd
> > > > WRITE_ONCE() won't be helping you.
> > > >
> > > > Or perhaps better to put it a different way...  The fact that the c=
ompiler
> > > > is not permitted to invent data-racy reads and writes is exactly why
> > > > you do not normally need READ_ONCE() and WRITE_ONCE() for accesses =
in
> > > > lock-based critical sections.  Instead, you only need READ_ONCE() a=
nd
> > > > WRITE_ONCE() when you have lockless accesses to the same shared var=
iables.
> > >=20
> > > This is lockless access to memcg->oom_group potentially from multiple
> > > CPUs, so, READ_ONCE() and WRITE_ONCE() are needed, right?
> >=20
> > Agreed, lockless concurrent accesses should use READ_ONCE() and WRITE_O=
NCE().
> > And if either conflicting access is lockless, it is lockless.  ;-)
>=20
> Now I'm confused, why we should use it here?
> Writing is happening from a separate syscall (a single write from a sysca=
ll),
> reading is happening from a oom context. The variable is boolean, it's ei=
ther
> 0 or 1. What difference READ_ONCE()/WRITE_ONCE() will make here?
> Thanks!

In practice, not much difference other than documenting shared accesses.
Which can be valuable.

In theory, when you do a normal C-language store, the compiler is within
its rights to use the variable for temporary storage between the time
of the last read from that variable and the next write to that variable.
Back to practice, I have not heard of this happening for shared variables.
On the other hand, compilers really do this for on-stack variables whose
addresses are not taken, which is one of the reasons that gdb might say
that the variable is optimized out when you try to look at its value.

So the potential is there, and if it was my code, I would therefore use
READ_ONCE() and WRITE_ONCE().

							Thanx, Paul
