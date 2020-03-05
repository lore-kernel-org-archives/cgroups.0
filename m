From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: fix NULL pointer dereference in
 __mem_cgroup_usage_unregister_event
Date: Thu, 5 Mar 2020 15:07:44 +0100
Message-ID: <20200305140744.GY16139@dhcp22.suse.cz>
References: <5ee35fe7-2a90-ae71-9100-3f2833cbf252@gmail.com>
 <20200305092447.GQ16139@dhcp22.suse.cz>
 <1391a759-845e-11d4-09f4-9bd6e498db4f@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1391a759-845e-11d4-09f4-9bd6e498db4f-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 05-03-20 21:28:20, brookxu wrote:
[...]
> We can reproduce this problem in the following ways=EF=BC=9A
>=20
> 1. We create a new cgroup subdirectory and a new eventfd, and then we mon=
itor multiple memory thresholds of the cgroup through this eventfd
> 2. closing this eventfd, the system will call __mem_cgroup_usage_unregist=
er_event () multiple times to delete all events related to this eventfd.
>=20
> The first time __mem_cgroup_usage_unregister_event () is called, the syst=
em will clear all items related to this eventfd in thresholds-> primary.
> Since there is currently only one eventfd, thresholds-> primary becomes e=
mpty, so the system will set thresholds-> primary and hresholds-> spare
> to NULL. If at this time, the user creates a new eventfd and monitor the =
memory threshold of this cgroup, then the system will re-initialize
> thresholds-> primary. Then when the system call __mem_cgroup_usage_unregi=
ster_event () is called for the second time, because thresholds-> primary
> is not empty, the system will access thresholds-> spare, but thresholds->=
 spare is NULL, which will trigger a crash.
>=20
> In general, the longer it takes to delete all events related to this even=
tfd, the easier it is to trigger this problem.

Thank you for reproducing this on the current kernel and the above
description. That makes it much more easier to understand the underlying
problem. Please add it to the changelog. My memory about thresholds is
quite rusty so I will have to think about this more but I have some
coarse idea now at least.

--=20
Michal Hocko
SUSE Labs
