From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH 14/14] mm/lru: fix the comments of lru_lock
Date: Tue, 20 Aug 2019 22:21:39 +0800
Message-ID: <bf8be185-e757-cf05-999d-56bfb83f1bc9@linux.alibaba.com>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
 <1566294517-86418-15-git-send-email-alex.shi@linux.alibaba.com>
 <20190820140019.GB24642@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190820140019.GB24642@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Vlastimil Babka <vbabka@suse.cz>, Ira Weiny <ira.weiny@intel.com>, Jesper Dangaard Brouer <brouer@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Jann Horn <jannh@google.com>, Logan Gunthorpe <logang@deltatee.com>, Souptick Joarder <jrdr.linux@gmail.com>, Ralph Campbell <rcampbell@nvidia.com>, "Tobin C. Harding" <tobin@kernel.org>, Michal Hocko <mhocko@suse.com>, Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Pavel



=D4=DA 2019/8/20 =CF=C2=CE=E710:00, Matthew Wilcox =D0=B4=B5=C0:
> On Tue, Aug 20, 2019 at 05:48:37PM +0800, Alex Shi wrote:
>> @@ -159,7 +159,7 @@ static inline bool free_area_empty(struct free_area =
*area, int migratetype)
>>  struct pglist_data;
>> =20
>>  /*
>> - * zone->lock and the zone lru_lock are two of the hottest locks in the=
 kernel.
>> + * zone->lock and the lru_lock are two of the hottest locks in the kern=
el.
>>   * So add a wild amount of padding here to ensure that they fall into s=
eparate
>>   * cachelines.  There are very few zone structures in the machine, so s=
pace
>>   * consumption is not a concern here.
>=20
> But after this patch series, the lru lock is no longer stored in the zone.
> So this comment makes no sense.

Yes, It's need reconsider here. thanks for opoint out.

>=20
>> @@ -295,7 +295,7 @@ struct zone_reclaim_stat {
>> =20
>>  struct lruvec {
>>  	struct list_head		lists[NR_LRU_LISTS];
>> -	/* move lru_lock to per lruvec for memcg */
>> +	/* perf lruvec lru_lock for memcg */
>=20
> What does the word 'perf' mean here?

sorry for typo, could be s/perf/per/ here.

Thanks
Alex

=20
