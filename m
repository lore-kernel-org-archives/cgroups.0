From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v20 15/20] mm/lru: introduce TestClearPageLRU
Date: Tue, 3 Nov 2020 11:02:15 +0800
Message-ID: <ae59cae4-48f4-a7e9-044a-86790e16e641@linux.alibaba.com>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-16-git-send-email-alex.shi@linux.alibaba.com>
 <20201102151008.GH724984@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20201102151008.GH724984@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Michal Hocko <mhocko@kernel.org>



=D4=DA 2020/11/2 =CF=C2=CE=E711:10, Johannes Weiner =D0=B4=B5=C0:
> On Thu, Oct 29, 2020 at 06:45:00PM +0800, Alex Shi wrote:
>> Currently lru_lock still guards both lru list and page's lru bit, that's
>> ok. but if we want to use specific lruvec lock on the page, we need to
>> pin down the page's lruvec/memcg during locking. Just taking lruvec
>> lock first may be undermined by the page's memcg charge/migration. To
>> fix this problem, we could clear the lru bit out of locking and use
>> it as pin down action to block the page isolation in memcg changing.
>=20
> Small nit, but the use of "could" in this sentence sounds like you're
> describing one possible solution that isn't being taken, when in fact
> you are describing the chosen locking mechanism.
>=20
> Replacing "could" with "will" would make things a bit clearer IMO.
>=20

Yes, 'will' is better here. Thanks!

>> So now a standard steps of page isolation is following:
>> 	1, get_page(); 	       #pin the page avoid to be free
>> 	2, TestClearPageLRU(); #block other isolation like memcg change
>> 	3, spin_lock on lru_lock; #serialize lru list access
>> 	4, delete page from lru list;
>> The step 2 could be optimzed/replaced in scenarios which page is
>> unlikely be accessed or be moved between memcgs.
>=20
> This is a bit ominous. I'd either elaborate / provide an example /
> clarify why some sites can deal with races - or just remove that
> sentence altogether from this part of the changelog.
>=20

A few scenarios here, so examples looks verbose or cann't describe whole.
Maybe removing above 2 lines "The step 2 could be optimzed/replaced in=20
scenarios which page is unlikely be accessed or be moved between memcgs."
is better.=20

Thanks!

>> This patch start with the first part: TestClearPageLRU, which combines
>> PageLRU check and ClearPageLRU into a macro func TestClearPageLRU. This
>> function will be used as page isolation precondition to prevent other
>> isolations some where else. Then there are may !PageLRU page on lru
>> list, need to remove BUG() checking accordingly.
>>
>> There 2 rules for lru bit now:
>> 1, the lru bit still indicate if a page on lru list, just in some
>>    temporary moment(isolating), the page may have no lru bit when
>>    it's on lru list.  but the page still must be on lru list when the
>>    lru bit set.
>> 2, have to remove lru bit before delete it from lru list.
>>
>> As Andrew Morton mentioned this change would dirty cacheline for page
>> isn't on LRU. But the lost would be acceptable in Rong Chen
>> <rong.a.chen@intel.com> report:
>> https://lore.kernel.org/lkml/20200304090301.GB5972@shao2-debian/
>>
>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
>> Acked-by: Hugh Dickins <hughd@google.com>
>> Cc: Hugh Dickins <hughd@google.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Michal Hocko <mhocko@kernel.org>
>> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: cgroups@vger.kernel.org
>> Cc: linux-mm@kvack.org
>=20
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>=20

Thanks!
Alex
