From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v2 0/8] memcg accounting from OpenVZ
Date: Mon, 15 Mar 2021 15:22:51 +0300
Message-ID: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCXwU4FXpFSuBc5/wFYrPNQuRITNdbEhp7YK+3FecE8=;
 b=NoSErGEmRB6WLqv+nDiGd+ml4CDqITahdG6HZQiK4yNIEhK0bT/OhnWGTpOuyU2vScRAVRJQ7z/50j4rDqwA4UXg3SgTx+4ooqJzY4/+Boitp4GMizIYCA/p97vEwskuFXEI4gerF5sCDm3t3ibTk6azh2Fuk3CzLxUxoFJocJw=
In-Reply-To: <YEnWUrYOArju66ym-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

OpenVZ used own accounting subsystem since 2001 (i.e. since v2.2.x linux kernels) 
and we have accounted all required kernel objects by using our own patches.
When memcg was added to upstream Vladimir Davydov added accounting of some objects
to upstream but did not skipped another ones.
Now OpenVZ uses RHEL7-based kernels with cgroup v1 in production, and we still account
"skipped" objects by our own patches just because we accounted such objects before.
We're working on rebase to new kernels and we prefer to push our old patches to upstream. 

v2:
- squashed old patch 1 "accounting for allocations called with disabled BH"
   with old patch 2 "accounting for fib6_nodes cache" used such kind of memory allocation 
- improved patch description
- subsystem maintainers added to cc:

Vasily Averin (8):
  memcg: accounting for fib6_nodes cache
  memcg: accounting for ip6_dst_cache
  memcg: accounting for fib_rules
  memcg: accounting for ip_fib caches
  memcg: accounting for fasync_cache
  memcg: accounting for mnt_cache entries
  memcg: accounting for tty_struct objects
  memcg: accounting for ldt_struct objects

 arch/x86/kernel/ldt.c | 7 ++++---
 drivers/tty/tty_io.c  | 4 ++--
 fs/fcntl.c            | 3 ++-
 fs/namespace.c        | 5 +++--
 mm/memcontrol.c       | 2 +-
 net/core/fib_rules.c  | 4 ++--
 net/ipv4/fib_trie.c   | 4 ++--
 net/ipv6/ip6_fib.c    | 2 +-
 net/ipv6/route.c      | 2 +-
 9 files changed, 18 insertions(+), 15 deletions(-)

-- 
1.8.3.1

