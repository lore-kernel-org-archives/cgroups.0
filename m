From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v9 07/20] mm/lru: introduce TestClearPageLRU
Date: Tue, 3 Mar 2020 12:11:34 +0800
Message-ID: <9cacdc21-9c1f-2a17-05cb-e9cf2959cef5@linux.alibaba.com>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
 <1583146830-169516-8-git-send-email-alex.shi@linux.alibaba.com>
 <20200302141144.b30abe0d89306fd387e13a92@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200302141144.b30abe0d89306fd387e13a92-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org



=D4=DA 2020/3/3 =C9=CF=CE=E76:11, Andrew Morton =D0=B4=B5=C0:
>> -		if (PageLRU(page)) {
>> +		if (TestClearPageLRU(page)) {
>>  			lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>> -			ClearPageLRU(page);
>>  			del_page_from_lru_list(page, lruvec, page_lru(page));
>>  		} else
>=20
> The code will now get exclusive access of the page->flags cacheline and
> will dirty that cacheline, even for !PageLRU() pages.  What is the
> performance impact of this?
>=20

Hi Andrew,

Thanks a lot for comments!

I was tested the whole patchset with fengguang's case-lru-file-readtwice
https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/
which is most sensitive case on PageLRU I found. There are no clear perform=
ance
drop.

On this single patch, I just test the same case again, there is still no pe=
rf
drop. some data is here on my 96 threads machine:

		no lock_dep	w lock_dep and few other debug option
w this patch, 	50.96MB/s		32.93MB/s
w/o this patch, 50.50MB/s		33.53MB/s


And also no any warning from Intel 0day yet.

Thanks a lot!
Alex
