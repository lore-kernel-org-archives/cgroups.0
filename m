From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v9 04/20] mm/thp: move lru_add_page_tail func to
 huge_memory.c
Date: Wed, 4 Mar 2020 16:13:43 +0800
Message-ID: <3b18a429-25fd-df28-1bf3-57bcd38c6cd8@linux.alibaba.com>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
 <1583146830-169516-5-git-send-email-alex.shi@linux.alibaba.com>
 <20200304074719.e6unbgdop2r3jhk2@box>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200304074719.e6unbgdop2r3jhk2@box>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org



=D4=DA 2020/3/4 =CF=C2=CE=E73:47, Kirill A. Shutemov =D0=B4=B5=C0:
> On Mon, Mar 02, 2020 at 07:00:14PM +0800, Alex Shi wrote:
>> The func is only used in huge_memory.c, defining it in other file with a
>> CONFIG_TRANSPARENT_HUGEPAGE macro restrict just looks weird.
>>
>> Let's move it close user.
>=20
> I don't think it's strong enough justification. I would rather keep all
> lru helpers in one place.
>=20

Thanks for comments, Kirill,

If it's a common used func, yes.

But if you look into details of this func, it's thp used only func.=20

Thanks
Alex
