From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v2 4/8] mm/lru: only change the lru_lock iff page's lruvec
 is different
Date: Wed, 13 Nov 2019 10:26:24 +0800
Message-ID: <297ad71c-081c-f7e1-d640-8720a0eeeeba@linux.alibaba.com>
References: <1573567588-47048-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573567588-47048-5-git-send-email-alex.shi@linux.alibaba.com>
 <20191112143624.GA7934@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191112143624.GA7934@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Andrey Ryabinin <aryabinin@virtuozzo.com>, swkhack <swkhack@gmail.com>, "Potyra, Stefan" <Stefan.Potyra@elektrobit.com>, Jason Gunthorpe <jgg@ziepe.ca>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Peng Fan <peng.fan@n>

hi Matthew,

Thanks a lot for comments!

=D4=DA 2019/11/12 =CF=C2=CE=E710:36, Matthew Wilcox =D0=B4=B5=C0:
> On Tue, Nov 12, 2019 at 10:06:24PM +0800, Alex Shi wrote:
>> +/* Don't lock again iff page's lruvec locked */
>> +static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
>> +					struct lruvec *locked_lruvec)
>> +{
>> +	struct pglist_data *pgdat =3D page_pgdat(page);
>> +	struct lruvec *lruvec;
>> +
>> +	rcu_read_lock();
>> +	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>> +
>> +	if (locked_lruvec =3D=3D lruvec) {
>> +		rcu_read_unlock();
>> +		return lruvec;
>> +	}
>> +	rcu_read_unlock();
>=20
> Why not simply:
>=20
> 	rcu_read_lock();
> 	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
> 	rcu_read_unlock();
>=20
> 	if (locked_lruvec =3D=3D lruvec)

The rcu_read_unlock here is for guarding the locked_lruvec/lruvec comparsio=
n.
Otherwise memcg/lruvec maybe changed, like, from memcg migration etc. I gue=
ss.
=20
> 		return lruvec;
>=20
> Also, why are you bothering to re-enable interrupts here?  Surely if
> you're holding lock A with interrupts disabled , you can just drop lock A,
> acquire lock B and leave the interrupts alone.  That way you only need
> one of this variety of function, and not the separate irq/irqsave variant=
s.
>=20

Thanks for the suggestion! Yes, if only do re-lock, it's better to leave th=
e irq unchanging. but, when the locked_lruvec is NULL, it become a first ti=
me lock which irq or irqsave are different. Thus, in combined function we n=
eed a nother parameter to indicate if it do irqsaving. So comparing to a ex=
tra/indistinct parameter, I guess 2 inline functions would be a bit more si=
mple/cleary?=20

Thanks a lot!
Alex
