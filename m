From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v9 06/20] mm/thp: narrow lru locking
Date: Wed, 4 Mar 2020 16:51:45 +0800
Message-ID: <23cc4433-fe81-ec31-9281-3c9e8df5643b@linux.alibaba.com>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
 <1583146830-169516-7-git-send-email-alex.shi@linux.alibaba.com>
 <20200304080248.wuj3vqlz46ehhptg@box>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200304080248.wuj3vqlz46ehhptg@box>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



=D4=DA 2020/3/4 =CF=C2=CE=E74:02, Kirill A. Shutemov =D0=B4=B5=C0:
> On Mon, Mar 02, 2020 at 07:00:16PM +0800, Alex Shi wrote:
>> @@ -2564,6 +2565,9 @@ static void __split_huge_page(struct page *page, s=
truct list_head *list,
>>  		xa_lock(&swap_cache->i_pages);
>>  	}
>> =20
>> +	/* Lru list would be changed, don't care head's LRU bit. */
>> +	spin_lock_irqsave(&pgdat->lru_lock, flags);
>> +
>>  	for (i =3D HPAGE_PMD_NR - 1; i >=3D 1; i--) {
>>  		__split_huge_page_tail(head, i, lruvec, list);
>>  		/* Some pages can be beyond i_size: drop them from page cache */
>=20
> You change locking order WRT i_pages lock. Is it safe?
>=20

Thanks Kirill,

I think so. and lock_dep/proving has no complain.

Any problem addressed?

Alex
