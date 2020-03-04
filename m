From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v9 02/20] mm/memcg: fold lock_page_lru into commit_charge
Date: Wed, 4 Mar 2020 15:19:46 +0800
Message-ID: <4131e7d9-acad-4372-73b1-6fa1b0b251ef@linux.alibaba.com>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200304031335.9784-1-hdanton@sina.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200304031335.9784-1-hdanton@sina.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hillf Danton <hdanton@sina.com>
Cc: cgroups@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org



=D4=DA 2020/3/4 =C9=CF=CE=E711:13, Hillf Danton =D0=B4=B5=C0:
>>  	 * Nobody should be changing or seriously looking at
>>  	 * page->mem_cgroup at this point:
>> @@ -2633,8 +2611,13 @@ static void commit_charge(struct page *page, stru=
ct mem_cgroup *memcg,
>>  	 */
>>  	page->mem_cgroup =3D memcg;
>> =20
> Well it is likely to update memcg for page without lru_lock held even if
> more care is required, which is a change added in the current semantic and
> worth a line of words in log.
>=20

the lru_lock is guard for lru list, not for page->mem_cgroup, seem no need =
to highlight this point. Do we?

Thanks
Alex
