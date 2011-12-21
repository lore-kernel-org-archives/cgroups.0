From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: reset to root_mem_cgroup at bypassing
Date: Wed, 21 Dec 2011 13:00:56 +0900
Message-ID: <20111221130056.2f4a39b2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111219165146.4d72f1bb.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1112191218350.3639@eggly.anvils>
	<CABEgKgrk4X13V2Ra_g+V5J0echpj2YZfK20zaFRKP-PhWRWiYQ@mail.gmail.com>
	<20111221091347.4f1a10d8.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1112201847500.1310@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.LSU.2.00.1112201847500.1310@eggly.anvils>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hugh Dickins <hughd@google.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>

On Tue, 20 Dec 2011 19:25:04 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> On Wed, 21 Dec 2011, KAMEZAWA Hiroyuki wrote:
> > On Tue, 20 Dec 2011 09:24:47 +0900
> > Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com> wrote:
> > > 2011/12/20 Hugh Dickins <hughd@google.com>:
> > >=20
> > > > I speak from experience: I did *exactly* the same at "bypass" whe=
n
> > > > I introduced our mem_cgroup_reset_page(), which corresponds to yo=
ur
> > > > mem_cgroup_reset_owner(); it seemed right to me that a successful
> > > > (return 0) call to try_charge() should provide a good *ptr.
> > > >
> > > ok.
> > >=20
> > > > But others (Ying and Greg) pointed out that it changes the semant=
ics
> > > > of __mem_cgroup_try_charge() in this case, so you need to justify=
 the
> > > > change to all those places which do something like "if (ret || !m=
emcg)"
> > > > after calling it. =C2=A0Perhaps it is a good change everywhere, b=
ut that's
> > > > not obvious, so we chose caution.
> > > >
> > > > Doesn't it lead to bypass pages being marked as charged to root, =
so
> > > > they don't get charged to the right owner next time they're touch=
ed?
> > > >
> > > Yes. You're right.
> > > Hm. So, it seems I should add reset_owner() to the !memcg path
> > > rather than here.
> > >=20
> > Considering this again..
> >=20
> > Now, we catch 'charge' event only once in lifetime of anon/file page.
> > So, it doesn't depend on that it's marked as PCG_USED or not.
>=20
> That's an interesting argument, I hadn't been looking at it that way.
> It's not true of swapcache, but I guess we don't need to preserve its
> peculiarities in this case.
>=20
> I've not checked the (ret || !memcg) cases yet to see if any change
> needed there.
>=20
> I certainly like that the success return guarantees that memcg is set.
>=20
Hmm. Ok, then....I'll update patch description to be precise.
And check I can remove !memcg case in the same patch. Then, repost v2.

Thanks,
-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter=
.ca/
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
