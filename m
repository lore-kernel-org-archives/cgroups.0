From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v3 3/7] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 19 Nov 2019 18:04:35 +0800
Message-ID: <85702d50-daf0-ece8-9a5d-e4b860ef2f99@linux.alibaba.com>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573874106-23802-4-git-send-email-alex.shi@linux.alibaba.com>
 <20191118161126.GB365174@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191118161126.GB365174@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.c>



=D4=DA 2019/11/19 =C9=CF=CE=E712:11, Johannes Weiner =D0=B4=B5=C0:
> On Sat, Nov 16, 2019 at 11:15:02AM +0800, Alex Shi wrote:
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 62470325f9bc..cf274739e619 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1246,6 +1246,42 @@ struct lruvec *mem_cgroup_page_lruvec(struct page=
 *page, struct pglist_data *pgd
>>  	return lruvec;
>>  }
>> =20
>> +struct lruvec *lock_page_lruvec_irq(struct page *page,
>> +					struct pglist_data *pgdat)
>> +{
>> +	struct lruvec *lruvec;
>> +
>> +again:
>> +	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>> +	spin_lock_irq(&lruvec->lru_lock);
>=20
> This isn't safe. Nothing prevents the page from being moved to a
> different memcg in between these two operations, and the lruvec having
> been freed by the time you try to acquire the spinlock.
>=20
> You need to use the rcu lock to dereference page->mem_cgroup and its
> lruvec when coming from the page like this.

Hi Johannes,

Yes, you are right. Thank a lot to point out this!
Could we use rcu lock to guard the lruvec till lruvec->lru_lock getten?

+struct lruvec *lock_page_lruvec_irq(struct page *page,
+                                       struct pglist_data *pgdat)
+{
+       struct lruvec *lruvec;
+
+again:
+       rcu_read_lock();
+       lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+       spin_lock_irq(&lruvec->lru_lock);
+       rcu_read_unlock();
+
+       /* lruvec may changed in commit_charge() */
+       if (lruvec !=3D mem_cgroup_page_lruvec(page, pgdat)) {
+               spin_unlock_irq(&lruvec->lru_lock);
+               goto again;
+       }
+
+       return lruvec;
+}
>=20
> You also need to use page_memcg_rcu() to insert the appropriate
> lockless access barriers, which mem_cgroup_page_lruvec() does not do
> since it's designed for use with pgdat->lru_lock.
>=20

Since the page_memcg_rcu can not know it under a spin_lock, guess the follo=
wing enhance is fine:
@@ -1225,7 +1224,7 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *pa=
ge, struct pglist_data *pgd
                goto out;
        }

-       memcg =3D page->mem_cgroup;
+       memcg =3D READ_ONCE(page->mem_cgroup);
        /*


Millions thanks!
Alex
