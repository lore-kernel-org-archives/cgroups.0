From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v4 3/9] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Wed, 20 Nov 2019 19:50:33 +0800
Message-ID: <ae58bcc4-cb47-7c66-d190-531299fb7b42@linux.alibaba.com>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
 <1574166203-151975-4-git-send-email-alex.shi@linux.alibaba.com>
 <20191119155704.GP20752@bombadil.infradead.org>
 <20191119164448.GA396644@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191119164448.GA396644@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, shakeelb@google.com, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, "Aneesh Kumar K.V" <aneesh.kuma>



=D4=DA 2019/11/20 =C9=CF=CE=E712:44, Johannes Weiner =D0=B4=B5=C0:
> On Tue, Nov 19, 2019 at 07:57:04AM -0800, Matthew Wilcox wrote:
>> On Tue, Nov 19, 2019 at 08:23:17PM +0800, Alex Shi wrote:
>>> +static inline struct lruvec *lock_page_lruvec_irqsave(struct page *pag=
e,
>>> +				struct pglist_data *pgdat, unsigned long *flags)
>>> +{
>>> +	struct lruvec *lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>>> +
>>> +	spin_lock_irqsave(&lruvec->lru_lock, *flags);
>>> +
>>> +	return lruvec;
>>> +}
>>
>> This should be a macro, not a function.  You basically can't do this;
>> spin_lock_irqsave needs to write to a variable which can then be passed
>> to spin_unlock_irqrestore().  What you're doing here will dereference the
>> pointer in _this_ function, but won't propagate the modified value back =
to
>> the caller.  I suppose you could do something like this ...
>=20
> This works because spin_lock_irqsave and local_irq_save() are
> macros. It boils down to '*flags =3D arch_local_irq_save()' in this
> function, and therefor does the right thing.
>=20
> We exploit that in quite a few places:
>=20
> $ git grep 'spin_lock_irqsave(.*\*flags' | wc -l
> 39
>=20

Yes, thank you all for point this!
