From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [HMM-CDM 0/5] Cache coherent device memory (CDM) with HMM
Date: Wed, 14 Jun 2017 16:11:39 -0400
Message-ID: <20170614201144.9306-1-jglisse@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 43A6880464
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Balbir Singh <balbirs-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>, Aneesh Kumar <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>

Cache coherent device memory apply to architecture with system bus
like CAPI or CCIX. Device connected to such system bus can expose
their memory to the system and allow cache coherent access to it
from the CPU.

Even if for all intent and purposes device memory behave like regular
memory, we still want to manage it in isolation from regular memory.
Several reasons for that, first and foremost this memory is less
reliable than regular memory if the device hangs because of invalid
commands we can loose access to device memory. Second CPU access to
this memory is expected to be slower than to regular memory. Third
having random memory into device means that some of the bus bandwith
wouldn't be available to the device but would be use by CPU access.

This is why we want to manage such memory in isolation from regular
memory. Kernel should not try to use this memory as last resort
when running out of memory, at least for now.

This patchset add a new type of ZONE_DEVICE memory (DEVICE_PUBLIC)
that is use to represent CDM memory. This patchset build on top of
the HMM patchset that already introduce a new type of ZONE_DEVICE
memory for private device memory (see HMM patchset).

The end result is that with this patch if a device is in use in
a process you might have private anonymous memory or file back
page memory using ZONE_DEVICE (MEMORY_PUBLIC). Thus care must be
taken to not overwritte lru fields of such pages.

Hence all core mm changes are done to address assumption that any
process memory is back by a regular struct page that is part of
the lru. ZONE_DEVICE page are not on the lru and the lru pointer
of struct page are use to store device specific informations.

Thus this patch update all code path that would make assumptions
about lruness of a process page.

patch 01 - deals with all the core mm functions
patch 02 - add an helper to HMM for hotplug of CDM memory
patch 03 - preparatory patch for memory controller changes
patch 04 - update memory controller to properly handle
           ZONE_DEVICE pages when uncharging
patch 05 - kernel configuration updates and cleanup

git tree:
https://cgit.freedesktop.org/~glisse/linux/log/?h=hmm-cdm-v2


Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Balbir Singh <balbirs-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Cc: Aneesh Kumar <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>

Jérôme Glisse (5):
  mm/device-public-memory: device memory cache coherent with CPU
  mm/hmm: add new helper to hotplug CDM memory region
  mm/memcontrol: allow to uncharge page without using page->lru field
  mm/memcontrol: support MEMORY_DEVICE_PRIVATE and MEMORY_DEVICE_PUBLIC
  mm/hmm: simplify kconfig and enable HMM and DEVICE_PUBLIC for ppc64

 fs/proc/task_mmu.c       |   2 +-
 include/linux/hmm.h      |   7 +-
 include/linux/ioport.h   |   1 +
 include/linux/memremap.h |  21 +++++
 include/linux/mm.h       |  16 ++--
 kernel/memremap.c        |  13 ++-
 mm/Kconfig               |  30 +++----
 mm/gup.c                 |   7 ++
 mm/hmm.c                 |  89 +++++++++++++++++--
 mm/madvise.c             |   2 +-
 mm/memcontrol.c          | 226 ++++++++++++++++++++++++++++++-----------------
 mm/memory.c              |  46 ++++++++--
 mm/migrate.c             |  60 ++++++++-----
 mm/swap.c                |  11 +++
 14 files changed, 389 insertions(+), 142 deletions(-)

-- 
2.9.3
