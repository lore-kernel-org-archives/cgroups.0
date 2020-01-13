From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v7 01/10] mm/vmscan: remove unnecessary lruvec adding
Date: Mon, 13 Jan 2020 15:21:58 +0800
Message-ID: <8f0f9fd5-56d3-0ec3-e875-f2eb5e1e7971@linux.alibaba.com>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
 <1577264666-246071-2-git-send-email-alex.shi@linux.alibaba.com>
 <6c91fb0a-d4e0-d960-1cfd-62bef5cd15a5@yandex-team.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <6c91fb0a-d4e0-d960-1cfd-62bef5cd15a5@yandex-team.ru>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org
Cc: yun.wang@linux.alibaba.com



=E5=9C=A8 2020/1/10 =E4=B8=8B=E5=8D=884:39, Konstantin Khlebnikov =E5=86=99=
=E9=81=93:
> On 25/12/2019 12.04, Alex Shi wrote:
>> We don't have to add a freeable page into lru and then remove from it.
>> This change saves a couple of actions and makes the moving more clear.
>>
>> The SetPageLRU needs to be kept here for list intergrity. Otherwise:
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 #0 mave_pages_to_lru=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #1 releas=
e_pages
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (put_page_testzero())
>> =C2=A0=C2=A0=C2=A0=C2=A0 if (put_page_testzero())
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 !PageLRU //skip lru_lock
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_a=
dd(&page->lru,);
>> =C2=A0=C2=A0=C2=A0=C2=A0 else
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_add(&page->lru,)=
 //corrupt
>>
>> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Hugh Dickins <hughd@google.com>
>> Cc: yun.wang@linux.alibaba.com
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>> =C2=A0 mm/vmscan.c | 16 +++++++---------
>> =C2=A0 1 file changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 572fb17c6273..8719361b47a0 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1852,26 +1852,18 @@ static unsigned noinline_for_stack move_pages_=
to_lru(struct lruvec *lruvec,
>=20
> Here is another cleanup: pass only pgdat as argument.
>=20
> This function reavaluates lruvec for each page under lru lock.
> Probably this is redundant for now but could be used in the future (or =
your patchset already use that).

Thanks a lot for comments, Konstantin!

yes, we could use pgdat here, but since to remove the pgdat later, maybe =
better to save this change? :)

>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (!list_empty(list)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page =3D lru_to=
_page(list);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VM_BUG_ON_PAGE(=
PageLRU(page), page);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_del(&page->lru);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(!p=
age_evictable(page))) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 li=
st_del(&page->lru);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 spin_unlock_irq(&pgdat->lru_lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 putback_lru_page(page);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 spin_lock_irq(&pgdat->lru_lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 continue;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lruvec =3D mem_cgroup_page=
_lruvec(page, pgdat);
>> -
>=20
> Please leave a comment that we must set PageLRU before dropping our pag=
e reference.

Right, I will try to give a comments here.
=20
>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 SetPageLRU(page=
);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lru =3D page_lru(page);
>> -
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nr_pages =3D hpage_nr_page=
s(page);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 update_lru_size(lruvec, lr=
u, page_zonenum(page), nr_pages);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_move(&page->lru, &lru=
vec->lists[lru]);
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (put_=
page_testzero(page)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 __ClearPageLRU(page);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 __ClearPageActive(page);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 de=
l_page_from_lru_list(page, lruvec, lru);
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (unlikely(PageCompound(page))) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irq(&pgdat->lru_lock);
>> @@ -1880,6 +1872,12 @@ static unsigned noinline_for_stack move_pages_t=
o_lru(struct lruvec *lruvec,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 } else
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_add(&page->lru, &pages_to_free);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lr=
uvec =3D mem_cgroup_page_lruvec(page, pgdat);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lr=
u =3D page_lru(page);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nr=
_pages =3D hpage_nr_pages(page);
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 up=
date_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 li=
st_add(&page->lru, &lruvec->lists[lru]);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 nr_moved +=3D nr_pages;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> IMHO It looks better to in this way:>=20
> SetPageLRU()
>=20
> if (unlikely(put_page_testzero())) {
> =C2=A0<free>
> =C2=A0continue;
> }
>=20
> <add>

Yes, this looks better!

Thanks
Alex

>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>

