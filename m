From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 0/9] memcg accounting from OpenVZ
Date: Tue, 9 Mar 2021 11:03:38 +0300
Message-ID: <5affff71-e503-9fb9-50cb-f6d48286dd52@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M6uPTswKNmLvexfE4/75jOdnrZwI9g4iTWJL/mKN+8g=;
 b=dgDJo6Xnm42fPBfYY3hUmPlYwHhQxEC8yfdhS9qj58rAtya0VBKyo85rONiajYrpVXMFKbnLX2FyRZ6q1VZJza/Jux55PDRB9wyZ31r3e8RrSH/2t6uqsPvIJP2tlbVyAfzwfYJqNZOA6FnXa47xffBT6yys77lxGNHnObpxbbo=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

OpenVZ many years accounted memory of few kernel objects,
this helps us to prevent host memory abuse from inside memcg-limited container.

Vasily Averin (9):
  memcg: accounting for allocations called with disabled BH
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

