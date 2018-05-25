From: TSUKADA Koutaro <tsukada@ascade.co.jp>
Subject: Re: [PATCH v2 0/7] mm: pages for hugetlb's overcommit may be able to
 charge to memcg
Date: Fri, 25 May 2018 10:51:50 +0900
Message-ID: <504b1ca0-9030-29be-4657-9cc18575eacb@ascade.co.jp>
References: <e863529b-7ce5-4fbe-8cff-581b5789a5f9@ascade.co.jp>
 <240f1b14-ed7d-4983-6c52-be4899d4caa5@oracle.com>
 <8711fed5-fc35-a11a-3a17-740a9dca1f2a@ascade.co.jp>
 <20180522185407.GC20441@dhcp22.suse.cz>
 <455b1a07-d7e3-102b-65e7-3892947b7675@ascade.co.jp>
 <20180524082044.GW20441@dhcp22.suse.cz>
 <b2afbff6-b59f-7105-3808-64d41bd4a3a8@ascade.co.jp>
 <20180524132414.GI20441@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524132414.GI20441@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, David Rientjes <rientjes@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Marc-Andre Lureau <marcandre.lureau@redhat.com>, Punit Agrawal <punit.agrawal@arm.com>, Dan Williams <dan.j.williams@intel.com>, Vlastimil Babka <vbabka@suse.cz>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On 2018/05/24 22:24, Michal Hocko wrote
[...]> I do not see anything like that. adjust_pool_surplus is simply and
> accounting thing. At least the last time I've checked. Maybe your
> patchset handles that?

As you said, my patch did not consider handling when manipulating the
pool. And even if that handling is done well, it will not be a valid
reason to charge surplus hugepage to memcg.

[...]
>> Absolutely you are saying the right thing, but, for example, can mlock(2)ed
>> pages be swapped out by reclaim?(What is the difference between mlock(2)ed
>> pages and hugetlb page?)
> 
> No mlocked pages cannot be reclaimed and that is why we restrict them to
> a relatively small amount.

I understood the concept of memcg.

[...]
> Fatal? Not sure. It simply tries to add an alien memory to the memcg
> concept so I would pressume an unexpected behavior (e.g. not being able
> to reclaim memcg or, over reclaim, trashing etc.).

As you said, it must be an alien. Thanks to the interaction up to here,
I understood that my solution is inappropriate. I will look for another
way.

Thank you for your kind explanation.

-- 
Thanks,
Tsukada


