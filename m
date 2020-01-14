From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v7 02/10] mm/memcg: fold lru_lock in lock_page_lru
Date: Tue, 14 Jan 2020 17:20:06 +0800
Message-ID: <2f3b6613-d107-6d89-2510-6d01c0ae0625@linux.alibaba.com>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
 <1577264666-246071-3-git-send-email-alex.shi@linux.alibaba.com>
 <36d7e390-a3d1-908c-d181-4a9e9c8d3d98@yandex-team.ru>
 <952d02c2-8aa5-40bb-88bb-c43dee65c8bc@linux.alibaba.com>
 <2ba8a04e-d8e0-1d50-addc-dbe1b4d8e0f1@yandex-team.ru>
 <a095d80d-8e34-c84f-e4be-085a5aae1929@linux.alibaba.com>
 <20200113163456.GA332@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20200113163456.GA332@bombadil.infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, shakeelb@google.com, hannes@cmpxchg.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>



=E5=9C=A8 2020/1/14 =E4=B8=8A=E5=8D=8812:34, Matthew Wilcox =E5=86=99=E9=81=
=93:
> On Mon, Jan 13, 2020 at 08:47:25PM +0800, Alex Shi wrote:
>> =E5=9C=A8 2020/1/13 =E4=B8=8B=E5=8D=885:55, Konstantin Khlebnikov =E5=86=
=99=E9=81=93:
>>>>> That's wrong. Here PageLRU must be checked again under lru_lock.
>>>> Hi, Konstantin,
>>>>
>>>> For logical remain, we can get the lock and then release for !PageLR=
U.
>>>> but I still can figure out the problem scenario. Would like to give =
more hints?
>>>
>>> That's trivial race: page could be isolated from lru between
>>>
>>> if (PageLRU(page))
>>> and
>>> spin_lock_irq(&pgdat->lru_lock);
>>
>> yes, it could be a problem. guess the following change could helpful:
>> I will update it in new version.
>=20
>> +       if (lrucare) {
>> +               lruvec =3D lock_page_lruvec_irq(page);
>> +               if (likely(PageLRU(page))) {
>> +                       ClearPageLRU(page);
>> +                       del_page_from_lru_list(page, lruvec, page_lru(=
page));
>> +               } else {
>> +                       unlock_page_lruvec_irq(lruvec);
>> +                       lruvec =3D NULL;
>> +               }
>=20
> What about a harder race to hit like a page being on LRU list A when yo=
u
> look up the lruvec, then it's removed and added to LRU list B by the
> time you get the lock?  At that point, you are holding a lock on the
> wrong LRU list.  I think you need to check not just that the page
> is still PageLRU but also still on the same LRU list.
>=20

Thanks for comments, Matthew!

We will check and lock lruvec after lock_page_memcg, so if it works well,=
 a page
won't moved from one lruvec to another. Also the later debug do this chec=
k, to
see if lruvec changed.

If you mean lru list not lruvec, It seems there is noway to figure out th=
e lru list
from a page now.

Thanks
Alex


