From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/2] block: cancel all throttled bios in del_gendisk()
Date: Thu, 27 Jan 2022 10:45:33 +0800
Message-ID: <630c162b-8bdd-d87e-0d80-c7a78ea267a5@huawei.com>
References: <20220110134758.2233758-1-yukuai3@huawei.com>
 <20220110134758.2233758-3-yukuai3@huawei.com> <Yd5FkuhYX9YcgQkZ@T590>
 <b416e6a6-f2c9-caf3-dacd-f937746207da@huawei.com>
 <YfF+yukISfkuc9IK@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YfF+yukISfkuc9IK-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2022/01/27 1:03, Tejun Heo =D0=B4=B5=C0:
> On Mon, Jan 24, 2022 at 11:50:11AM +0800, yukuai (C) wrote:
>> Both ways can fix the problem, which way do you prefer?
>=20
> Ming's suggested change seems simpler, no?

Hi,

Yes, if Ming don't mind, I can send a new version after Ming's
pathset "block: don't drain file system I/O on del_gendisk".

Thanks,
Kuai
