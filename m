From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: PROBLEM: cgroup cost too much memory when transfer small files
 to tmpfs
Date: Fri, 24 Jul 2020 09:55:08 +0200
Message-ID: <20200724075508.GF4061@dhcp22.suse.cz>
References: <2E04DD7753BE0E4ABABF0B664610AD6F2620CAF7@dggeml528-mbx.china.huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2E04DD7753BE0E4ABABF0B664610AD6F2620CAF7-vMFu1QFWtjo1LvNSbZiozgK1hpo4iccwjNknBlVQO8k@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jingrui <jingrui-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lizefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, caihaomin <caihaomin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Weiwei (N)" <wick.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Tue 21-07-20 11:19:52, jingrui wrote:
[...]
> systemd related issue: https://github.com/systemd/systemd/issues/16499

Well, I would be really careful with one-off and short lived cgroups.
Firstly there are charges which cannot be easily reparented and secondly
even if the memory footprint is reduced there would be still memcgs
standing in the way.

[...]
> 1. Do we have any idea to descrease cgroup memory cost in this case?

Others have already commented on this.

> 2. When user remove cgroup directory, does it possible associated file memory to root cgroup?

We used to do that in the past but removed it by b2052564e66d ("mm:
memcontrol: continue cache reclaim from offlined groups"). Please read
through the changelog for the reasoning behind.

> 3. Can we provide an option that do not associate memory with cgroup in tmpfs?

What is the reason to run under !root cgroup in those sessions if you do
not care about accounting anyway? tmpfs is a persistent charge until the
file is removed. So if those outlive the session then you either want
them to be charged to somebody or you do not care about accounting at
all, no? Or could you explain your usecase some more?
-- 
Michal Hocko
SUSE Labs
