From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Thu, 23 Feb 2023 13:31:44 -0400
Message-ID: <Y/ejAKU7l8DFrkR8@nvidia.com>
References: <Y/UEkNn0O65Pfi4e@nvidia.com>
 <Y/UIURDjR9pv+gzx@slm.duckdns.org>
 <Y/Ua6VcNe/DFh7X4@nvidia.com>
 <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
 <Y/UiQmuVwh2eqrfA@nvidia.com>
 <87o7pmnd0p.fsf@nvidia.com>
 <Y/YRJNwwvqp7nKKt@nvidia.com>
 <87k009nvnr.fsf@nvidia.com>
 <Y/bHNO7A8T3QQ5T+@nvidia.com>
 <Y/ct88JBeQuSmCuj@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wji/GRjWBVE1P0YGFUl7ByKFVOA8jASXwOT45H07NyI=;
 b=YoHCS7+LQOpFToa7nA2ttQfew2SmTsIwjdk5SiZfTyliOW+mm0BcEd6zqlFoKKN+PhCFvJ5K1JoVnJnkA39WlASHJEoQckYRC8zb+tLsGyBFJ1FSzmAqSIZ7m0jb2XdJMOuaE+RzmnK5Rh2549RWKvhrHytZIyLKaxGy1Zoycf4BtZ5JM99Y5xBHoQeWRKnLFMUrOFcucJerY0XORl9LlVPMBLRiiCIBq7ve44FKk/XzUbKZBBMHlyfsQWBXmYmD6R0kiyuW4Vbvw8gCzIb7Z0t/3ZmDXaFyUHgTuLRakMidQIzTCUQDC/9+6Cka2PKbjp3Njoej6v75CvikpuM8gA==
Content-Disposition: inline
In-Reply-To: <Y/ct88JBeQuSmCuj-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Feb 23, 2023 at 09:12:19AM +0000, Daniel P. Berrang=C3=A9 wrote:

> The memory limits we can set on VMs are somewhat limited. In general
> we prefer to avoid setting any hard per-VM memory cap by default.

So if you don't use hard limits on the memcg..

But to do this with a hard limit:
=20
> We do still have to apply some tuning for VFIO, around what amount
> of memory it is allowed to lock, but that is not so bad as we just
> need to allow it to lock guest RAM which is known + an finite extra
> amount, so don't need to take account of all of QEMU's memory
> allocations in general.

Will need its own controller, right?

Jason
