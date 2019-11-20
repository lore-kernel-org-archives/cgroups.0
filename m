From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v4 3/9] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Wed, 20 Nov 2019 19:41:44 +0800
Message-ID: <bcf6a952-5b92-50ad-cfc1-f4d9f8f63172@linux.alibaba.com>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
 <1574166203-151975-4-git-send-email-alex.shi@linux.alibaba.com>
 <20191119160456.GD382712@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191119160456.GD382712@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, Aneesh Ku



=D4=DA 2019/11/20 =C9=CF=CE=E712:04, Johannes Weiner =D0=B4=B5=C0:
>> +
>> +	return lruvec;
> While this works in practice, it looks wrong because it doesn't follow
> the mem_cgroup_page_lruvec() rules.
>=20
> Please open-code spin_lock_irq(&pgdat->__lruvec->lru_lock) instead.
>=20

That's right. Thanks for suggestion!

>> @@ -1246,6 +1245,46 @@ struct lruvec *mem_cgroup_page_lruvec(struct page=
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
>> +	rcu_read_lock();
>> +	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>> +	spin_lock_irq(&lruvec->lru_lock);
>> +	rcu_read_unlock();
> The spinlock doesn't prevent the lruvec from being freed
>=20
> You deleted the rules from the mem_cgroup_page_lruvec() documentation,
> but they still apply: if the page is already !PageLRU() by the time
> you get here, it could get reclaimed or migrated to another cgroup,
> and that can free the memcg/lruvec. Merely having the lru_lock held
> does not prevent this.


Forgive my idiot, I still don't know the details of unsafe lruvec here.
From my shortsight, the spin_lock_irq(embedded a preempt_disable) could blo=
ck all rcu syncing thus, keep all memcg alive until the preempt_enabled in =
unspinlock, is this right?
If so even the page->mem_cgroup is migrated to others cgroups, the new and =
old cgroup should still be alive here.=20

>=20
> Either the page needs to be locked, or the page needs to be PageLRU
> with the lru_lock held to prevent somebody else from isolating
> it. Otherwise, the lruvec is not safe to use.

Do you mean that we may get the wrong lruvec->lru_lock if !PageLRU, so, the=
 page may got freed by others? Sorry I got last there.

Thanks
Alex
