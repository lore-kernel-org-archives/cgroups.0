From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v6 02/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 17 Dec 2019 09:30:13 +0800
Message-ID: <286c11c2-480f-37d6-e9fe-91822f862cd6@linux.alibaba.com>
References: <1576488386-32544-1-git-send-email-alex.shi@linux.alibaba.com>
 <1576488386-32544-3-git-send-email-alex.shi@linux.alibaba.com>
 <20191216121427.GZ32169@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191216121427.GZ32169@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, shakeelb@google.com, hannes@cmpxchg.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, Aneesh Kum



=D4=DA 2019/12/16 =CF=C2=CE=E78:14, Matthew Wilcox =D0=B4=B5=C0:
> On Mon, Dec 16, 2019 at 05:26:18PM +0800, Alex Shi wrote:
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
> You still didn't fix this function.  Go back and look at my comment from
> the last time you sent this patch set.
>=20

Sorry for the misunderstanding. I guess what your want is fold the patch 9t=
h into this, is that right?
Any comments for the 9th patch?

Thanks
Alex
