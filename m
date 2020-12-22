From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH 1/3] mm/memcg: revise the using condition of
 lock_page_lruvec function series
Date: Tue, 22 Dec 2020 13:23:06 +0800
Message-ID: <be915778-2f0e-17a3-c44e-889bda0bc12d@linux.alibaba.com>
References: <1608186532-81218-1-git-send-email-alex.shi@linux.alibaba.com>
 <alpine.LSU.2.11.2012211827560.1045@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.11.2012211827560.1045@eggly.anvils>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



=D4=DA 2020/12/22 =C9=CF=CE=E711:01, Hugh Dickins =D0=B4=B5=C0:
> On Thu, 17 Dec 2020, Alex Shi wrote:
>=20
>> The series function could be used under lock_page_memcg(), add this and
>> a bit style changes following commit_charge().
>>
>> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
>> Cc: Hugh Dickins <hughd@google.com>
>=20
> This patch, or its intention,
> Acked-by: Hugh Dickins <hughd@google.com>
> but rewording suggested below, and requested above -
> which left me very puzzled before eventually I understood it.
> I don't think we need to talk about "a bit style changes",
> but the cross-reference to commit_charge() is helpful.
>=20
> "
> lock_page_lruvec() and its variants are safe to use under the same
> conditions as commit_charge(): add lock_page_memcg() to the comment.
> "

Thanks a lot, Hugh. Yes, your commit log are far more better than mine. :)

I will resent with your changes and Ack.

Thanks!
Alex

>=20
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Michal Hocko <mhocko@kernel.org>
>> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: cgroups@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  mm/memcontrol.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index b80328f52fb4..e6b50d068b2f 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1345,10 +1345,11 @@ void lruvec_memcg_debug(struct lruvec *lruvec, s=
truct page *page)
>>   * lock_page_lruvec - lock and return lruvec for a given page.
>>   * @page: the page
>>   *
>> - * This series functions should be used in either conditions:
>> - * PageLRU is cleared or unset
>> - * or page->_refcount is zero
>> - * or page is locked.
>> + * This series functions should be used in any one of following conditi=
ons:
>=20
> These functions are safe to use under any of the following conditions:
>=20
>> + * - PageLRU is cleared or unset
>> + * - page->_refcount is zero
>> + * - page is locked.
>=20
> Remove that full stop...
>=20
>> + * - lock_page_memcg()
>=20
> ... and, if you wish (I don't care), add full stop at the end of that lin=
e.
>=20
> Maybe reorder those to the same order as listed in commit_charge().
> Copy its text exactly? I don't think so, actually, I find your wording
> (e.g. _refcount is zero) more explicit: good to have both descriptions.
>=20
>>   */
>>  struct lruvec *lock_page_lruvec(struct page *page)
>>  {
>> --=20
>> 2.29.GIT
