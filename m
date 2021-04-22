From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v3 00/16] memcg accounting from OpenVZ
Date: Thu, 22 Apr 2021 13:35:54 +0300
Message-ID: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=reHqD+1cR0ps7gy3gkbydZxVnFzyGfUJ+cMnsq3GRFI=; b=DJGzCDLKbZyY4cd4jD7
        1/iM0gXLiSp2ke7iAWAibxyVMx0TGmYZ24/7nXKmRfA+OHwalhW5CG7l13D4ZMHm8nYFwOPsvyIIn
        It5kGW9i+P74yvBiv7L5ngJUL21RHM2lkWvy9bTBt9tlmJIF/3XoOsOQ5LHQRNZneku0d5kjz2M=
In-Reply-To: <dddf6b29-debd-dcb5-62d0-74909d610edb-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe@kernel.d>

OpenVZ uses memory accounting 20+ years since v2.2.x linux kernels. 
Initially we used our own accounting subsystem, then partially committed
it to upstream, and a few years ago switched to cgroups v1.
Now we're rebasing again, revising our old patches and trying to push
them upstream.

We try to protect the host system from any misuse of kernel memory 
allocation triggered by untrusted users inside the containers.

Patch-set is addressed mostly to cgroups maintainers and cgroups@ mailing
list, though I would be very grateful for any comments from maintainersi
of affected subsystems or other people added in cc:

Compared to the upstream, we additionally account the following kernel objects:
- network devices and its Tx/Rx queues
- ipv4/v6 addresses and routing-related objects
- inet_bind_bucket cache objects
- VLAN group arrays
- ipv6/sit: ip_tunnel_prl
- scm_fp_list objects used by SCM_RIGHTS messages of Unix sockets 
- nsproxy and namespace objects itself
- IPC objects: semaphores, message queues and share memory segments
- mounts
- pollfd and select bits arrays
- signals and posix timers
- file lock
- fasync_struct used by the file lease code and driver's fasync queues 
- tty objects
- per-mm LDT

We have an incorrect/incomplete/obsoleted accounting for few other kernel
objects: sk_filter, af_packets, netlink and xt_counters for iptables.
They require rework and probably will be dropped at all.

Also we're going to add an accounting for nft, however it is not ready yet.

We have not tested performance on upstream, however, our performance team
compares our current RHEL7-based production kernel and reports that
they are at least not worse as the according original RHEL7 kernel.

v3:
- added new patches for other kind of accounted objects
- combined patches for ip address/routing-related objects
- improved description
- re-ordered and rebased for linux 5.12-rc8

v2:
- squashed old patch 1 "accounting for allocations called with disabled BH"
   with old patch 2 "accounting for fib6_nodes cache" used such kind of memory allocation 
- improved patch description
- subsystem maintainers added to cc:

Vasily Averin (16):
  memcg: enable accounting for net_device and Tx/Rx queues
  memcg: enable accounting for IP address and routing-related objects
  memcg: enable accounting for inet_bin_bucket cache
  memcg: enable accounting for VLAN group array
  memcg: ipv6/sit: account and don't WARN on ip_tunnel_prl structs
    allocation
  memcg: enable accounting for scm_fp_list objects
  memcg: enable accounting for new namesapces and struct nsproxy
  memcg: enable accounting of ipc resources
  memcg: enable accounting for mnt_cache entries
  memcg: enable accounting for pollfd and select bits arrays
  memcg: enable accounting for signals
  memcg: enable accounting for posix_timers_cache slab
  memcg: enable accounting for file lock caches
  memcg: enable accounting for fasync_cache
  memcg: enable accounting for tty-related objects
  memcg: enable accounting for ldt_struct objects

 arch/x86/kernel/ldt.c      |  7 ++++---
 drivers/tty/tty_io.c       |  4 ++--
 fs/fcntl.c                 |  3 ++-
 fs/locks.c                 |  6 ++++--
 fs/namespace.c             |  7 ++++---
 fs/select.c                |  4 ++--
 ipc/msg.c                  |  2 +-
 ipc/namespace.c            |  2 +-
 ipc/sem.c                  | 10 ++++++----
 ipc/shm.c                  |  2 +-
 kernel/cgroup/namespace.c  |  2 +-
 kernel/nsproxy.c           |  2 +-
 kernel/pid_namespace.c     |  2 +-
 kernel/signal.c            |  2 +-
 kernel/time/namespace.c    |  4 ++--
 kernel/time/posix-timers.c |  4 ++--
 kernel/user_namespace.c    |  2 +-
 mm/memcontrol.c            |  2 +-
 net/8021q/vlan.c           |  2 +-
 net/core/dev.c             |  6 +++---
 net/core/fib_rules.c       |  4 ++--
 net/core/scm.c             |  4 ++--
 net/dccp/proto.c           |  2 +-
 net/ipv4/devinet.c         |  2 +-
 net/ipv4/fib_trie.c        |  4 ++--
 net/ipv4/tcp.c             |  4 +++-
 net/ipv6/addrconf.c        |  2 +-
 net/ipv6/ip6_fib.c         |  4 ++--
 net/ipv6/route.c           |  2 +-
 net/ipv6/sit.c             |  5 +++--
 30 files changed, 59 insertions(+), 49 deletions(-)

-- 
1.8.3.1

