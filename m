From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v3 3/7] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 19 Nov 2019 18:10:09 +0800
Message-ID: <1199177d-6f34-3aae-3eb6-8fac42f070a1@linux.alibaba.com>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573874106-23802-4-git-send-email-alex.shi@linux.alibaba.com>
 <20191119021058.auxc6g7vmgf7d5gg@ca-dmjordan1.us.oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191119021058.auxc6g7vmgf7d5gg@ca-dmjordan1.us.oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, yang.shi@linux.alibaba.com, willy@infradead.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientje>



=D4=DA 2019/11/19 =C9=CF=CE=E710:10, Daniel Jordan =D0=B4=B5=C0:
>> -	if (pgdat)
>> -		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
>> +
>>  	release_pages(pvec->pages, pvec->nr);
>>  	pagevec_reinit(pvec);
>>  }
> Why can't you keep the locking pattern where we only drop and reacquire i=
f the
> lruvec changes?  It'd save a lot of locks and unlocks if most pages were =
from
> the same memcg and node, or the memory controller were unused.
>=20

Good catching! This issue will be fixed in the next patch which introduce r=
elock_ function.

Thanks!
