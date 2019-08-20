From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH 01/14] mm/lru: move pgdat lru_lock into lruvec
Date: Tue, 20 Aug 2019 22:11:28 +0800
Message-ID: <9980292a-a073-201c-ae06-c8cdbc9f98af@linux.alibaba.com>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
 <1566294517-86418-2-git-send-email-alex.shi@linux.alibaba.com>
 <20190820134032.GA24642@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190820134032.GA24642@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>, Pavel Tatashin <pasha.tatashin@oracle.com>, Arun KS <arunks@codeaurora.org>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Hugh Dickins <hughd@google.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrea Arcangeli <aarc>



=D4=DA 2019/8/20 =CF=C2=CE=E79:40, Matthew Wilcox =D0=B4=B5=C0:
> On Tue, Aug 20, 2019 at 05:48:24PM +0800, Alex Shi wrote:
>> +++ b/include/linux/mmzone.h
>> @@ -295,6 +295,9 @@ struct zone_reclaim_stat {
>> =20
>>  struct lruvec {
>>  	struct list_head		lists[NR_LRU_LISTS];
>> +	/* move lru_lock to per lruvec for memcg */
>> +	spinlock_t			lru_lock;
>=20
> This comment makes no sense outside the context of this patch.
>=20

Right, Thanks for point out this. will remove it in v2.

Thanks
Alex
