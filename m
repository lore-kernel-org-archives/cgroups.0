From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v20 18/20] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 3 Nov 2020 12:58:29 +0800
Message-ID: <eb099842-ed15-2d86-2a65-67f1f41999fb@linux.alibaba.com>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-19-git-send-email-alex.shi@linux.alibaba.com>
 <ef279dfe-afa5-45cb-4013-6c34169ff55e@linux.alibaba.com>
 <20201102204136.GB740958@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20201102204136.GB740958@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Michal Hocko <mhocko@kernel.org>, Yang Shi <yang.shi@linux.alibaba.com>



=D4=DA 2020/11/3 =C9=CF=CE=E74:41, Johannes Weiner =D0=B4=B5=C0:
> On Fri, Oct 30, 2020 at 10:49:41AM +0800, Alex Shi wrote:
>>
>>
>> @@ -1367,6 +1380,51 @@ struct lruvec *mem_cgroup_page_lruvec(struct page=
 *page, struct pglist_data *pgd
>>  	return lruvec;
>>  }
>> =20
>> +struct lruvec *lock_page_lruvec(struct page *page)
>> +{
>> +	struct lruvec *lruvec;
>> +	struct pglist_data *pgdat =3D page_pgdat(page);
>> +
>> +	rcu_read_lock();
>> +	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>> +	spin_lock(&lruvec->lru_lock);
>> +	rcu_read_unlock();
>> +
>> +	lruvec_memcg_debug(lruvec, page);
>> +
>> +	return lruvec;
>> +}
>> +
>> +struct lruvec *lock_page_lruvec_irq(struct page *page)
>> +{
>> +	struct lruvec *lruvec;
>> +	struct pglist_data *pgdat =3D page_pgdat(page);
>> +
>> +	rcu_read_lock();
>> +	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>> +	spin_lock_irq(&lruvec->lru_lock);
>> +	rcu_read_unlock();
>> +
>> +	lruvec_memcg_debug(lruvec, page);
>> +
>> +	return lruvec;
>> +}
>> +
>> +struct lruvec *lock_page_lruvec_irqsave(struct page *page, unsigned lon=
g *flags)
>> +{
>> +	struct lruvec *lruvec;
>> +	struct pglist_data *pgdat =3D page_pgdat(page);
>> +
>> +	rcu_read_lock();
>> +	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>> +	spin_lock_irqsave(&lruvec->lru_lock, *flags);
>> +	rcu_read_unlock();
>> +
>> +	lruvec_memcg_debug(lruvec, page);
>> +
>> +	return lruvec;
>> +}
>=20
> As these are used quite widely throughout the VM code now, it would be
> good to give them kerneldoc comments that explain the interface.
>=20
> In particular, I think it's necessary to explain the contexts from
> which this is safe to use (in particular wrt pages moving between
> memcgs - see the comment in commit_charge()).
>=20
> I'm going to go through the callsites that follow and try to identify
> what makes them safe. It's mostly an exercise to double check our
> thinking here.
>=20
> Most of them are straight-forward, and I don't think they warrant
> individual comments. But some do, IMO. And it appears at least one
> actually isn't safe yet:

Thanks a lot reminder. is the following comments fine?

/**
 * lock_page_lruvec - return lruvec for the locked page.
 * @page: the page
 *
 * This series functions should be used in either conditions:
 * PageLRU is cleared or unset
 * or, page->_refcount is zero
 */
struct lruvec *lock_page_lruvec(struct page *page)
{

....

>> @@ -274,9 +270,8 @@ void lru_note_cost(struct lruvec *lruvec, bool file,=
 unsigned int nr_pages)
>>  {
>>  	do {
>>  		unsigned long lrusize;
>> -		struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>> =20
>> -		spin_lock_irq(&pgdat->lru_lock);
>> +		spin_lock_irq(&lruvec->lru_lock);
>>  		/* Record cost event */
>>  		if (file)
>>  			lruvec->file_cost +=3D nr_pages;
>> @@ -300,7 +295,7 @@ void lru_note_cost(struct lruvec *lruvec, bool file,=
 unsigned int nr_pages)
>>  			lruvec->file_cost /=3D 2;
>>  			lruvec->anon_cost /=3D 2;
>>  		}
>> -		spin_unlock_irq(&pgdat->lru_lock);
>> +		spin_unlock_irq(&lruvec->lru_lock);
>>  	} while ((lruvec =3D parent_lruvec(lruvec)));
>>  }
>=20
> This is safe because it either comes from
>=20
> 	1) the pinned lruvec in reclaim, or
>=20
> 	2) from a pre-LRU page during refault (which also holds the
> 	   rcu lock, so would be safe even if the page was on the LRU
> 	   and could move simultaneously to a new lruvec).
>=20
> The second one seems a bit tricky. It could be good to add a comment
> to lru_note_cost_page() that explains why its mem_cgroup_page_lruvec()
> is safe.

Thanks for pointed, is the following comments fine?
diff --git a/mm/swap.c b/mm/swap.c
index 9fe5ff9a8111..55ccc93ffb49 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -264,6 +264,13 @@ void lru_note_cost(struct lruvec *lruvec, bool file, u=
nsigned int nr_pages)
        do {
                unsigned long lrusize;

+               /*
+                * Hold lruvec->lru_lock is safe here, since
+                * 1) The pinned lruvec in reclaim, or
+                * 2) From a pre-LRU page during refault (which also holds =
the
+                *    rcu lock, so would be safe even if the page was on th=
e LRU
+                *    and could move simultaneously to a new lruvec).
+                */
                spin_lock_irq(&lruvec->lru_lock);
                /* Record cost event */
>=20
>> @@ -364,13 +359,13 @@ static inline void activate_page_drain(int cpu)
>> =20
>>  static void activate_page(struct page *page)
>>  {
>> -	pg_data_t *pgdat =3D page_pgdat(page);
>> +	struct lruvec *lruvec;
>> =20
>>  	page =3D compound_head(page);
>> -	spin_lock_irq(&pgdat->lru_lock);
>> +	lruvec =3D lock_page_lruvec_irq(page);
>=20
> I don't see what makes this safe. There is nothing that appears to
> lock out a concurrent page move between memcgs/lruvecs, which means
> the following could manipulate an unlocked lru list:
>=20

This funtion is for !CONFIG_SMP, could the cpu be preempt with RT kernel?

>>  	if (PageLRU(page))
>> -		__activate_page(page, mem_cgroup_page_lruvec(page, pgdat));
>> -	spin_unlock_irq(&pgdat->lru_lock);
>> +		__activate_page(page, lruvec);
>> +	unlock_page_lruvec_irq(lruvec);
>>  }
>>  #endif
>=20
> Shouldn't this be something like this?
>=20
> 	if (TestClearPageLRU()) {
> 		lruvec =3D lock_page_lruvec_irq(page);
> 		__activate_page(page, lruvec);
> 		unlock_page_lruvec_irq(lruvec);
> 		SetPageLRU(page);
> 	}

But anyway, your new changes are more beautiful and logcially. I will change
to this.

Thanks a lot!
Alex
