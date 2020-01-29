From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup.c: Use built-in RCU list checking
Date: Wed, 29 Jan 2020 15:22:55 +0100
Message-ID: <20200129142255.GE11384@blackbody.suse.cz>
References: <20200118031051.28776-1-madhuparnabhowmik10@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200118031051.28776-1-madhuparnabhowmik10-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: madhuparnabhowmik10-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org, rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, frextrite-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello.

On Sat, Jan 18, 2020 at 08:40:51AM +0530, madhuparnabhowmik10-Re5JQEeQqe8Av=
xtiuMwx3w@public.gmane.org wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik10-Re5JQEeQqe8AvxtiuMwx3w@publ=
ic.gmane.org>
>=20
> list_for_each_entry_rcu has built-in RCU and lock checking.
> Pass cond argument to list_for_each_entry_rcu() to silence
> false lockdep warning when  CONFIG_PROVE_RCU_LIST is enabled
> by default.
I assume if you've seen the RCU warning, you haven't seen the warning
from cgroup_assert_mutex_or_rcu_locked() above.=20

The patch makes sense to me from the consistency POV.

Acked-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

Michal
