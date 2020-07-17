From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v16 05/22] mm/thp: move lru_add_page_tail func to
 huge_memory.c
Date: Fri, 17 Jul 2020 13:13:21 +0800
Message-ID: <045c70c7-e4e4-c1d1-b066-c359ef9f15a5@linux.alibaba.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594429136-20002-6-git-send-email-alex.shi@linux.alibaba.com>
 <924c187c-d4cb-4458-9a71-63f79e0a66c8@linux.alibaba.com>
 <20200716131706.h6c5nob4somfmegp@box>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200716131706.h6c5nob4somfmegp@box>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



=D4=DA 2020/7/16 =CF=C2=CE=E79:17, Kirill A. Shutemov =D0=B4=B5=C0:
> On Thu, Jul 16, 2020 at 04:59:48PM +0800, Alex Shi wrote:
>> Hi Kirill & Matthew,
>>
>> Is there any concern from for the THP involved patches?
>=20
> It is mechanical move. I don't see a problem.
>=20

Many thanks! Kirill,

Do you mind to give a reviewed-by?

And rre they ok for patch 6th,7th and 14th?

Thanks a lot!
Alex
