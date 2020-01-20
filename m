From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v8 03/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 20 Jan 2020 20:58:09 +0800
Message-ID: <9ee80b68-a78f-714a-c727-1f6d2b4f87ea@linux.alibaba.com>
References: <1579143909-156105-1-git-send-email-alex.shi@linux.alibaba.com>
 <1579143909-156105-4-git-send-email-alex.shi@linux.alibaba.com>
 <20200116215222.GA64230@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200116215222.GA64230@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, Aneesh Ku



=D4=DA 2020/1/17 =C9=CF=CE=E75:52, Johannes Weiner =D0=B4=B5=C0:

> You simply cannot serialize on page->mem_cgroup->lruvec when
> page->mem_cgroup isn't stable. You need to serialize on the page
> itself, one way or another, to make this work.
>=20
>=20
> So here is a crazy idea that may be worth exploring:
>=20
> Right now, pgdat->lru_lock protects both PageLRU *and* the lruvec's
> linked list.
>=20
> Can we make PageLRU atomic and use it to stabilize the lru_lock
> instead, and then use the lru_lock only serialize list operations?
>=20

Hi Johannes,

I am trying to figure out the solution of atomic PageLRU, but is=20
blocked by the following sitations, when PageLRU and lru list was protected
together under lru_lock, the PageLRU could be a indicator if page on lru li=
st
But now seems it can't be the indicator anymore.
Could you give more clues of stabilization usage of PageLRU?
 =20

__page_cache_release/release_pages/compaction            __pagevec_lru_add
if (TestClearPageLRU(page))                              if (!PageLRU())
                                                                lruvec_lock=
();
                                                                list_add();
        			                                lruvec_unlock();
        			                                SetPageLRU() //position 1
        lock_page_lruvec_irqsave(page, &flags);
        del_page_from_lru_list(page, lruvec, ..);
        unlock_page_lruvec_irqrestore(lruvec, flags);
                                                                SetPageLRU(=
) //position 2
Thanks a lot!
Alex

> I.e. in compaction, you'd do
>=20
> 	if (!TestClearPageLRU(page))
> 		goto isolate_fail;
> 	/*
> 	 * We isolated the page's LRU state and thereby locked out all
> 	 * other isolators, including cgroup page moving, page reclaim,
> 	 * page freeing etc. That means page->mem_cgroup is now stable
> 	 * and we can safely look up the correct lruvec and take the
> 	 * page off its physical LRU list.
> 	 */
> 	lruvec =3D mem_cgroup_page_lruvec(page);
> 	spin_lock_irq(&lruvec->lru_lock);
> 	del_page_from_lru_list(page, lruvec, page_lru(page));
>=20
> Putback would mostly remain the same (although you could take the
> PageLRU setting out of the list update locked section, as long as it's
> set after the page is physically linked):
>=20
> 	/* LRU isolation pins page->mem_cgroup */
> 	lruvec =3D mem_cgroup_page_lruvec(page)
> 	spin_lock_irq(&lruvec->lru_lock);
> 	add_page_to_lru_list(...);
> 	spin_unlock_irq(&lruvec->lru_lock);
>=20
> 	SetPageLRU(page);
>=20
> And you'd have to carefully review and rework other sites that rely on
> PageLRU: reclaim, __page_cache_release(), __activate_page() etc.
>=20
> Especially things like activate_page(), which used to only check
> PageLRU to shuffle the page on the LRU list would now have to briefly
> clear PageLRU and then set it again afterwards.
>=20
> However, aside from a bit more churn in those cases, and the
> unfortunate additional atomic operations, I currently can't think of a
> fundamental reason why this wouldn't work.
>=20
> Hugh, what do you think?
>=20
