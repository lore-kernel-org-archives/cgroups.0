From: Dave Hansen <dave.hansen@intel.com>
Subject: memcg/kmem panics
Date: Wed, 19 Jun 2019 15:50:45 -0700
Message-ID: <e5cfe17c-a59f-b1d1-19ce-590245106068@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>

I have a bit of a grievance to file.  :)

I'm seeing "Cannot create slab..." panic()s coming from
kmem_cache_open() when trying to create memory cgroups on a Fedora
system running 5.2-rc's.  The panic()s happen when failing to create
memcg-specific slabs because the memcg code passes through the
root_cache->flags, which can include SLAB_PANIC.

I haven't tracked down the root cause yet, or where this behavior
started.  But, the end-user experience is that systemd tries to create a
cgroup and ends up with a kernel panic.  That's rather sad, especially
for the poor sod that's trying to debug it.

Should memcg_create_kmem_cache() be, perhaps filtering out SLAB_PANIC
from root_cache->flags, for instance?  That might make the system a bit
less likely to turn into a doorstop if and when something goes mildly
wrong.  I've hacked out the panic()s and the system actually seems to
boot OK.

BTW, this particular system has some persistent memory in it.  I suspect
there's something wrong where the slab code is trying to create slabs
for pmem-only nodes.  But,
