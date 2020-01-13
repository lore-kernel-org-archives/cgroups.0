From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH v7 02/10] mm/memcg: fold lru_lock in lock_page_lru
Date: Mon, 13 Jan 2020 12:55:59 +0300
Message-ID: <2ba8a04e-d8e0-1d50-addc-dbe1b4d8e0f1@yandex-team.ru>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
 <1577264666-246071-3-git-send-email-alex.shi@linux.alibaba.com>
 <36d7e390-a3d1-908c-d181-4a9e9c8d3d98@yandex-team.ru>
 <952d02c2-8aa5-40bb-88bb-c43dee65c8bc@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
	t=1578909361; bh=tfWEf85Tg93V8jfj/kRU8NVn5c39kp85P+atbWGt+tM=;
	h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
	b=XmwXyts9sUV12nUE4N1YSxf4tvNZDuR2Ax8TvGvRhsh26jDwzbTHtJ99/Mlp6VqtB
	 /AYBkrEzUXcCxSzePb6NELBf292iLyFGmNdmZlMZGMCS1/0JVKkw2VGFtnDeFj+HEA
	 Vxi2Izzl7c6DKKT3UT00eui5YKjhKoMkMkTm2wwY=
In-Reply-To: <952d02c2-8aa5-40bb-88bb-c43dee65c8bc@linux.alibaba.com>
Content-Language: en-CA
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Alex Shi <alex.shi@linux.alibaba.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>



On 13/01/2020 12.45, Alex Shi wrote:
>=20
>=20
> =E5=9C=A8 2020/1/10 =E4=B8=8B=E5=8D=884:49, Konstantin Khlebnikov =E5=86=
=99=E9=81=93:
>> On 25/12/2019 12.04, Alex Shi wrote:
>>>  =C2=A0From the commit_charge's explanations and mem_cgroup_commit_ch=
arge
>>> comments, as well as call path when lrucare is ture, The lru_lock is
>>> just to guard the task migration(which would be lead to move_account)
>>> So it isn't needed when !PageLRU, and better be fold into PageLRU to
>>> reduce lock contentions.
>>>
>>> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>> Cc: Michal Hocko <mhocko@kernel.org>
>>> Cc: Matthew Wilcox <willy@infradead.org>
>>> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: cgroups@vger.kernel.org
>>> Cc: linux-mm@kvack.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>  =C2=A0 mm/memcontrol.c | 9 ++++-----
>>>  =C2=A0 1 file changed, 4 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index c5b5f74cfd4d..0ad10caabc3d 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -2572,12 +2572,11 @@ static void cancel_charge(struct mem_cgroup *=
memcg, unsigned int nr_pages)
>>>  =C2=A0 =C2=A0 static void lock_page_lru(struct page *page, int *isol=
ated)
>>>  =C2=A0 {
>>> -=C2=A0=C2=A0=C2=A0 pg_data_t *pgdat =3D page_pgdat(page);
>>> -
>>> -=C2=A0=C2=A0=C2=A0 spin_lock_irq(&pgdat->lru_lock);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (PageLRU(page)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pg_data_t *pgdat =3D page=
_pgdat(page);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct lruvec=
 *lruvec;
>>>  =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_irq(&pg=
dat->lru_lock);
>>
>> That's wrong. Here PageLRU must be checked again under lru_lock.
> Hi, Konstantin,
>=20
> For logical remain, we can get the lock and then release for !PageLRU.
> but I still can figure out the problem scenario. Would like to give mor=
e hints?

That's trivial race: page could be isolated from lru between

if (PageLRU(page))
and
spin_lock_irq(&pgdat->lru_lock);

>=20
>=20
>>
>>
>> Also I don't like these functions:
>> - called lock/unlock but actually also isolates
>> - used just once
>> - pgdat evaluated twice
>=20
> That's right. I will fold these functions into commit_charge.
>=20
> Thanks
> Alex
>=20

