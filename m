From: Quanyang Wang <quanyang.wang-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Fri, 22 Oct 2021 19:03:42 +0800
Message-ID: <cd4d0dba-6818-12df-1d90-3ef5121e342f@windriver.com>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590> <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
 <YW1vuXh4C4tX9ZHP@T590> <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
 <YW78AohHqgqM9Cuw@blackbook> <YW98RTBdzqin+9Ko@T590>
 <7a21a20d-eb12-e491-4e69-4e043b3b6d8d@windriver.com>
 <YXBRyJMru/RbUQK5@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=JLn/mpF5qC5l+4kKG099Pvi3u0/i7Y4TFUasdJD2oa0=;
 b=kDoEZgjHwAdhi1TAWv0Lp3FX5S0k/eVNdxXEc57PgSVgT0ip26VME8ZxdjtyCxPzwZot
 2TWhiIC++PKq5nq3LDeF2egVi0B7SArFyeIIUWTj0eEAfXvqqB1gg3E4Gfv6mn7qOx0W
 J0Gq0mLDeoJpc7gtRssW/tt25cDyIZw89ts4gEvHBJtrgmyh7gWvJ5vsgKpPoxbam9fF
 S5JZAqeNAm6t+0Kk86kghO76j82XULkt3qTOtK56aHUOro/tvR/qGzWwptgLqL41HPJv
 Jj4BhUd7uUxHQ7HaRUlDnkRBWgUitWDPCFxGkIvrtmnbJF0xAAOm6gPe90Cvo3ZJJYfd Bw== 
In-Reply-To: <YXBRyJMru/RbUQK5@blackbook>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Michal,

On 10/21/21 1:28 AM, Michal Koutn=C3=BD wrote:
> On Wed, Oct 20, 2021 at 01:22:06PM +0800, Quanyang Wang <quanyang.wang-CW=
A4WttNNZF54TAoqtyWWQ@public.gmane.org> wrote:
>>> If only precpu_ref data is leaked, it is fine to add "Fixes: 2b0d3d3e4f=
cf",
>>> I thought cgroup_bpf_release() needs to release more for root cgroup, b=
ut
>>> looks not true.
>> For now, I can only observe that precpu_ref data is leaked when running =
ltp
>> testsuite.
>=20
> I assume you refer to ref->data. I considered the ref->percpu_count_ptr
> allocated with __alloc_percpu_gfp(). Could it be that kmemleak won't
> detect leaked percpu allocations?
Yes, kmemleak can't detect percpu allocations. I find some message about=20
this:

commit f528f0b8e53d
Author: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Date:   Mon Sep 26 17:12:53 2011 +0100

kmemleak: Handle percpu memory allocation

This patch adds kmemleak callbacks from the percpu allocator, reducing a
number of false positives caused by kmemleak not scanning such memory
blocks. The percpu chunks are never reported as leaks because of current
kmemleak limitations with the __percpu pointer not pointing directly to
the actual chunks.

Thanks,
Quanyang
>=20
> (The patch you sent resolves this as well, I'm just curious.)
>=20
> Michal
>=20
