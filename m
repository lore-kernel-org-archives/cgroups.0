From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v7 03/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 14 Jan 2020 14:33:58 +0800
Message-ID: <677cb490-35a4-4186-0935-6d71305a3a3e@linux.alibaba.com>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
 <1577264666-246071-4-git-send-email-alex.shi@linux.alibaba.com>
 <20200113154116.mwly5hl5yfvjkzl2@ca-dmjordan1.us.oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200113154116.mwly5hl5yfvjkzl2-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aneesh Kumar K.V



=D4=DA 2020/1/13 =CF=C2=CE=E711:41, Daniel Jordan =D0=B4=B5=C0:
> Hi Alex,
>=20
> On Wed, Dec 25, 2019 at 05:04:19PM +0800, Alex Shi wrote:
>> @@ -900,6 +904,29 @@ static inline struct lruvec *mem_cgroup_page_lruvec=
(struct page *page,
>>  {
>>  	return &pgdat->__lruvec;
>>  }
>> +#define lock_page_lruvec_irq(page)			\
>> +({							\
>> +	struct pglist_data *pgdat =3D page_pgdat(page);	\
>> +	spin_lock_irq(&pgdat->__lruvec.lru_lock);	\
>> +	&pgdat->__lruvec;				\
>> +})
>> +
>> +#define lock_page_lruvec_irqsave(page, flagsp)			\
>> +({								\
>> +	struct pglist_data *pgdat =3D page_pgdat(page);		\
>> +	spin_lock_irqsave(&pgdat->__lruvec.lru_lock, *flagsp);	\
>> +	&pgdat->__lruvec;					\
>> +})
>> +
>> +#define unlock_page_lruvec_irq(lruvec)			\
>> +({							\
>> +	spin_unlock_irq(&lruvec->lru_lock);		\
>> +})
>> +
>> +#define unlock_page_lruvec_irqrestore(lruvec, flags)		\
>> +({								\
>> +	spin_unlock_irqrestore(&lruvec->lru_lock, flags);	\
>> +})
>=20
> Noticed this while testing your series.  These are safe as inline functio=
ns, so
> I think you may have gotten the wrong impression when Johannes made this =
point:
>=20
> https://lore.kernel.org/linux-mm/20191119164448.GA396644-druUgvl0LCNAfugR=
pC6u6w@public.gmane.org/
>=20

Thanks for reminder! Daniel!

I write them to macro, since I guess it's more favorite for some guys. It's=
 do a bit more neat than function although cost a bit readablity.=20

Thanks a lot! :)
Alex
