From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: reset to root_mem_cgroup at bypassing
Date: Wed, 21 Dec 2011 09:13:47 +0900
Message-ID: <20111221091347.4f1a10d8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111219165146.4d72f1bb.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1112191218350.3639@eggly.anvils>
	<CABEgKgrk4X13V2Ra_g+V5J0echpj2YZfK20zaFRKP-PhWRWiYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CABEgKgrk4X13V2Ra_g+V5J0echpj2YZfK20zaFRKP-PhWRWiYQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>

On Tue, 20 Dec 2011 09:24:47 +0900
Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com> wrote:

> 2011/12/20 Hugh Dickins <hughd@google.com>:
> > On Mon, 19 Dec 2011, KAMEZAWA Hiroyuki wrote:
> >> From d620ff605a3a592c2b1de3a046498ce5cd3d3c50 Mon Sep 17 00:00:00 20=
01
> >> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >> Date: Mon, 19 Dec 2011 16:55:10 +0900
> >> Subject: [PATCH 2/2] memcg: reset lru to root_mem_cgroup in special =
cases.
> >>
> >> This patch is a fix for memcg-simplify-lru-handling-by-new-rule.patc=
h
> >>
> >> After the patch, all pages which will be onto LRU must have sane
> >> pc->mem_cgroup. But, in special case, it's not set.
> >>
> >> If task->mm is NULL or task is TIF_MEMDIE or fatal_signal_pending(),
> >> try_charge() is bypassed and the new charge will not be charged. And
> >> pc->mem_cgroup is unset even if the page will be used/mapped and add=
ed
> >> to LRU. To avoid this, =C2=A0this patch charges such pages to root_m=
em_cgroup,
> >> then, pc->mem_cgroup will be handled correctly.
> >>
> >> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >> ---
> >> =C2=A0mm/memcontrol.c | =C2=A0 =C2=A02 +-
> >> =C2=A01 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> index 0d6d21c..9268e8e 100644
> >> --- a/mm/memcontrol.c
> >> +++ b/mm/memcontrol.c
> >> @@ -2324,7 +2324,7 @@ nomem:
> >> =C2=A0 =C2=A0 =C2=A0 *ptr =3D NULL;
> >> =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;
> >> =C2=A0bypass:
> >> - =C2=A0 =C2=A0 *ptr =3D NULL;
> >> + =C2=A0 =C2=A0 *ptr =3D root_mem_cgroup;
> >> =C2=A0 =C2=A0 =C2=A0 return 0;
> >> =C2=A0}
> >>
> >> --
> >
> Thank you for review.
>=20
> > I'm dubious about this patch: certainly you have not fully justified =
it.
> >
> I sometimes see panics (in !pc->mem_cgroup check in lru code)
> when I stops test programs by Ctrl-C or some. That was because
> of this path. I checked this by adding a debug code to make
> pc->mem_cgroup =3D NULL in prep_new_page.
>=20
> > I speak from experience: I did *exactly* the same at "bypass" when
> > I introduced our mem_cgroup_reset_page(), which corresponds to your
> > mem_cgroup_reset_owner(); it seemed right to me that a successful
> > (return 0) call to try_charge() should provide a good *ptr.
> >
> ok.
>=20
> > But others (Ying and Greg) pointed out that it changes the semantics
> > of __mem_cgroup_try_charge() in this case, so you need to justify the
> > change to all those places which do something like "if (ret || !memcg=
)"
> > after calling it. =C2=A0Perhaps it is a good change everywhere, but t=
hat's
> > not obvious, so we chose caution.
> >
>=20
> > Doesn't it lead to bypass pages being marked as charged to root, so
> > they don't get charged to the right owner next time they're touched?
> >
> Yes. You're right.
> Hm. So, it seems I should add reset_owner() to the !memcg path
> rather than here.
>=20
Considering this again..

Now, we catch 'charge' event only once in lifetime of anon/file page.
So, it doesn't depend on that it's marked as PCG_USED or not.




> > In our internal kernel, I restored "bypass" to set *ptr =3D NULL as
> > before, but routed those callers that need it to continue on to
> > __mem_cgroup_commit_charge() when it's NULL, and let that do a
> > quick little mem_cgroup_reset_page() to root_mem_cgroup for this.
> >
> Yes, I'll prepare v2.
>=20

But ok, I'll go this way with some more description.

Thanks,
-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter=
.ca/
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
