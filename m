From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] [PATCH 3/7 v2] memcg: remove PCG_MOVE_LOCK flag from
 pc->flags
Date: Tue, 24 Jan 2012 13:59:38 +0900
Message-ID: <20120124135938.dc9bae10.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113174019.8dff3fc1.kamezawa.hiroyu@jp.fujitsu.com>
	<20120117164605.GB22142@tiehlicka.suse.cz>
	<20120118091226.b46e0f6e.kamezawa.hiroyu@jp.fujitsu.com>
	<20120118104703.GA31112@tiehlicka.suse.cz>
	<20120119085309.616cadb4.kamezawa.hiroyu@jp.fujitsu.com>
	<CALWz4ixAT411PZMwngh17V8VZEDGbMNNzbWFwbpC5M-JO+TVOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CALWz4ixAT411PZMwngh17V8VZEDGbMNNzbWFwbpC5M-JO+TVOQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ying Han <yinghan@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, cgroups@vger.kernel.org, "bsingharora@gmail.com" <bsingharora@gmail.com>

On Mon, 23 Jan 2012 14:05:33 -0800
Ying Han <yinghan@google.com> wrote:

> On Wed, Jan 18, 2012 at 3:53 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Wed, 18 Jan 2012 11:47:03 +0100
> > Michal Hocko <mhocko@suse.cz> wrote:
> >
> >> On Wed 18-01-12 09:12:26, KAMEZAWA Hiroyuki wrote:
> >> > On Tue, 17 Jan 2012 17:46:05 +0100
> >> > Michal Hocko <mhocko@suse.cz> wrote:
> >> >
> >> > > On Fri 13-01-12 17:40:19, KAMEZAWA Hiroyuki wrote:
> >> [...]
> >> > > > This patch removes PCG_MOVE_LOCK and add hashed rwlock array
> >> > > > instead of it. This works well enough. Even when we need to
> >> > > > take the lock,
> >> > >
> >> > > Hmmm, rwlocks are not popular these days very much.
> >> > > Anyway, can we rather make it (source) memcg (bit)spinlock inste=
ad. We
> >> > > would reduce false sharing this way and would penalize only page=
s from
> >> > > the moving group.
> >> > >
> >> > per-memcg spinlock ?
> >>
> >> Yes
> >>
> >> > The reason I used rwlock() is to avoid disabling IRQ. =C2=A0This r=
outine
> >> > will be called by IRQ context (for dirty ratio support). =C2=A0So,=
 IRQ
> >> > disable will be required if we use spinlock.
> >>
> >> OK, I have missed the comment about disabling IRQs. It's true that w=
e do
> >> not have to be afraid about deadlocks if the lock is held only for
> >> reading from the irq context but does the spinlock makes a performan=
ce
> >> bottleneck? We are talking about the slowpath.
> >> I could see the reason for the read lock when doing hashed locks bec=
ause
> >> they are global but if we make the lock per memcg then we shouldn't
> >> interfere with other updates which are not blocked by the move.
> >>
> >
> > Hm, ok. In the next version, I'll use per-memcg spinlock (with hash i=
f necessary)
>=20
> Just want to make sure I understand it, even we make the lock
> per-memcg, there is still a false sharing of pc within one memcg. Do
> we need to demonstrate the effect ?
>=20

Hmm, I'll try some. Account_move occurs when

 a) a task is moved to other cgroup
 b) a cgroup is removed.

I think checking case a) will be enough because there is no task in a mem=
cg
while it is being removed. Then, I'll measure performace of file mapping
while moving task repeatedly. There will be spinlock conflict.

- I'll consider to make the range of spinlock small.
- I'll consider have a hash of spinlock or spinlock based of page-zone an=
d types.
  (It's easy to make spinlock as to be per-memcg-per-zone.)

> Also, I don't get the point of why spinlock instead of rwlock in this c=
ase?
>=20
From Documentation/spinlocks.txt

>    NOTE! reader-writer locks require more atomic memory operations than
>    simple spinlocks.  Unless the reader critical section is long, you
>    are better off just using spinlocks.

>    NOTE! We are working hard to remove reader-writer spinlocks in most
>    cases, so please don't add a new one without consensus.  (Instead, s=
ee
>    Documentation/RCU/rcu.txt for complete information.)
>=20

I don't have enough strong motivation to use rwlock.
But if rwlock works enough well rather than spinlocks, it will be a choic=
e.

Thanks,
-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter=
.ca/
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
