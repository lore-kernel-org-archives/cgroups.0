From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v21 15/19] mm/compaction: do page isolation first in
 compaction
Date: Thu, 12 Nov 2020 11:35:23 +0800
Message-ID: <6d2d215e-fd72-b8cc-331f-189ea04a361d@linux.alibaba.com>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
 <1604566549-62481-16-git-send-email-alex.shi@linux.alibaba.com>
 <a0b8c198-6bd0-2ccb-fe55-970895c26a0b@suse.cz>
 <alpine.LSU.2.11.2011111803580.2174@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.11.2011111803580.2174@eggly.anvils>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com



=D4=DA 2020/11/12 =C9=CF=CE=E710:28, Hugh Dickins =D0=B4=B5=C0:
>>>   			 * Page become compound since the non-locked check,
>>>   			 * and it's on LRU. It can only be a THP so the order
>>> @@ -990,16 +1002,13 @@ static bool too_many_isolated(pg_data_t *pgdat)
> Completely off-topic, and won't matter at all when Andrew rediffs into
> mmotm: but isn't it weird that this is showing "too_many_isolated(",
> when actually the function is isolate_migratepages_block()?
>=20

My git version is too low for this. Thanks for reminder. the latest git
work fine on correct function name.

Thanks
