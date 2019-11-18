From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v3 3/7] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 18 Nov 2019 19:55:43 +0800
Message-ID: <0bfa9a03-b095-df83-9cfd-146da9aab89a@linux.alibaba.com>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573874106-23802-4-git-send-email-alex.shi@linux.alibaba.com>
 <20191116043806.GD20752@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191116043806.GD20752@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <>



=D4=DA 2019/11/16 =CF=C2=CE=E712:38, Matthew Wilcox =D0=B4=B5=C0:
> On Sat, Nov 16, 2019 at 11:15:02AM +0800, Alex Shi wrote:
>> This is the main patch to replace per node lru_lock with per memcg
>> lruvec lock. It also fold the irqsave flags into lruvec.
>=20
> I have to say, I don't love the part where we fold the irqsave flags
> into the lruvec.  I know it saves us an argument, but it opens up the
> possibility of mismatched expectations.  eg we currently have:
>=20
> static void __split_huge_page(struct page *page, struct list_head *list,
> 			struct lruvec *lruvec, pgoff_t end)
> {
> ...
> 	spin_unlock_irqrestore(&lruvec->lru_lock, lruvec->irqflags);
>=20
> so if we introduce a new caller, we have to be certain that this caller
> is also using lock_page_lruvec_irqsave() and not lock_page_lruvec_irq().
> I can't think of a way to make the compiler enforce that, and if we don't,
> then we can get some odd crashes with interrupts being unexpectedly
> enabled or disabled, depending on how ->irqflags was used last.
>=20
> So it makes the code more subtle.  And that's not a good thing.

Hi Matthew,

Thanks for comments!

Here, the irqflags is bound, and belong to lruvec, merging them into togeth=
er helps us to take them as whole, and thus reduce a unnecessary code clues.
The only thing maybe bad that it may take move place in pg_data_t.lruvec, b=
ut there are PADDINGs to remove this concern.

As your concern for a 'new' caller, since __split_huge_page is a static hel=
per here, no distub for anyothers.

Do you agree on that?

>=20
>> +static inline struct lruvec *lock_page_lruvec_irq(struct page *page,
>> +						struct pglist_data *pgdat)
>> +{
>> +	struct lruvec *lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>> +
>> +	spin_lock_irq(&lruvec->lru_lock);
>> +
>> +	return lruvec;
>> +}
>=20
> ...
>=20
>> +static struct lruvec *lock_page_lru(struct page *page, int *isolated)
>>  {
>>  	pg_data_t *pgdat =3D page_pgdat(page);
>> +	struct lruvec *lruvec =3D lock_page_lruvec_irq(page, pgdat);
>> =20
>> -	spin_lock_irq(&pgdat->lru_lock);
>>  	if (PageLRU(page)) {
>> -		struct lruvec *lruvec;
>> =20
>> -		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>>  		ClearPageLRU(page);
>>  		del_page_from_lru_list(page, lruvec, page_lru(page));
>>  		*isolated =3D 1;
>>  	} else
>>  		*isolated =3D 0;
>> +
>> +	return lruvec;
>>  }
>=20
> But what if the page is !PageLRU?  What lruvec did we just lock?

like original pgdat->lru_lock, we need the lock from PageLRU racing. And it=
 the lruvec which the page should be.


> According to the comments on mem_cgroup_page_lruvec(),
>=20
>  * This function is only safe when following the LRU page isolation
>  * and putback protocol: the LRU lock must be held, and the page must
>  * either be PageLRU() or the caller must have isolated/allocated it.
>=20
> and now it's being called in order to find out which LRU lock to take.
> So this comment needs to be updated, if it's wrong, or this patch has
> a race.


Yes, the function reminder is a bit misunderstanding with new patch, How ab=
out the following changes:

- * This function is only safe when following the LRU page isolation
- * and putback protocol: the LRU lock must be held, and the page must
- * either be PageLRU() or the caller must have isolated/allocated it.
+ * The caller needs to grantee the page's mem_cgroup is undisturbed during
+ * using. That could be done by lock_page_memcg or lock_page_lruvec.

Thanks
Alex
