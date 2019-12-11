From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v5 2/8] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Wed, 11 Dec 2019 11:51:47 +0800
Message-ID: <b86dc335-fad6-01a1-77ba-3d2a9d5c4c22@linux.alibaba.com>
References: <1575978384-222381-1-git-send-email-alex.shi@linux.alibaba.com>
 <1575978384-222381-3-git-send-email-alex.shi@linux.alibaba.com>
 <20191210134133.GI32169@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191210134133.GI32169@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, shakeelb@google.com, hannes@cmpxchg.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, Aneesh Kum



=D4=DA 2019/12/10 =CF=C2=CE=E79:41, Matthew Wilcox =D0=B4=B5=C0:
> On Tue, Dec 10, 2019 at 07:46:18PM +0800, Alex Shi wrote:
>> -static void lock_page_lru(struct page *page, int *isolated)
>> +static struct lruvec *lock_page_lru(struct page *page, int *isolated)
>>  {
>> -	pg_data_t *pgdat =3D page_pgdat(page);
>> +	struct lruvec *lruvec =3D lock_page_lruvec_irq(page);
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
> I still don't understand how this is supposed to work for !PageLRU
> pages.  Which lruvec have you locked if this page isn't on an LRU?
>=20

Good question. We could just fold it under PageLRU and no meaning changes.
Is this better to has this patch?

Thanks
Alex

commit 0f4b66d4a42397d57638352b738c3f9658003e44
Author: Alex Shi <alex.shi@linux.alibaba.com>
Date:   Wed Dec 11 11:31:53 2019 +0800

    mm/memcg: fold lock in lock_page_lru

    According to the calling path of commit_charge, the lrucare is bound
    with PageLRU, so we could just fold it under PageLRU. This has no
    functional change.

    Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
    Cc: Johannes Weiner <hannes@cmpxchg.org>
    Cc: Michal Hocko <mhocko@kernel.org>
    Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: cgroups@vger.kernel.org
    Cc: linux-mm@kvack.org
    Cc: linux-kernel@vger.kernel.org

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 833df0ce1bc1..4fe2252cf437 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2622,9 +2622,10 @@ static void cancel_charge(struct mem_cgroup *memcg, =
unsigned int nr_pages)

 static struct lruvec *lock_page_lru(struct page *page, int *isolated)
 {
-       struct lruvec *lruvec =3D lock_page_lruvec_irq(page);
+       struct lruvec *lruvec =3D NULL;

        if (PageLRU(page)) {
+               lruvec =3D lock_page_lruvec_irq(page);

                ClearPageLRU(page);
                del_page_from_lru_list(page, lruvec, page_lru(page));
@@ -2638,17 +2639,18 @@ static struct lruvec *lock_page_lru(struct page *pa=
ge, int *isolated)
 static void unlock_page_lru(struct page *page, int isolated,
                                struct lruvec *locked_lruvec)
 {
-       struct lruvec *lruvec;
+       if (isolated) {
+               struct lruvec *lruvec;

-       unlock_page_lruvec_irq(locked_lruvec);
-       lruvec =3D lock_page_lruvec_irq(page);
+               if (locked_lruvec)
+                       unlock_page_lruvec_irq(locked_lruvec);
+               lruvec =3D lock_page_lruvec_irq(page);

-       if (isolated) {
                VM_BUG_ON_PAGE(PageLRU(page), page);
                SetPageLRU(page);
                add_page_to_lru_list(page, lruvec, page_lru(page));
+               unlock_page_lruvec_irq(lruvec);
        }
-       unlock_page_lruvec_irq(lruvec);
 }

 static void commit_charge(struct page *page, struct mem_cgroup *memcg,
