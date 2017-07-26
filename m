From: Dima Zavin <dmitriyz-FA3Td6GO0iIAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH] mm/slub: fix a deadlock due to incomplete patching of cpusets_enabled()
Date: Wed, 26 Jul 2017 09:50:22 -0700
Message-ID: <20170726165022.10326-1-dmitriyz@waymo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Cliff Spradlin <cspradlin-FA3Td6GO0iIAvxtiuMwx3w@public.gmane.org>

In codepaths that use the begin/retry interface for reading
mems_allowed_seq with irqs disabled, there exists a race condition that
stalls the patch process after only modifying a subset of the
static_branch call sites.

This problem manifested itself as a dead lock in the slub
allocator, inside get_any_partial. The loop reads
mems_allowed_seq value (via read_mems_allowed_begin),
performs the defrag operation, and then verifies the consistency
of mem_allowed via the read_mems_allowed_retry and the cookie
returned by xxx_begin. The issue here is that both begin and retry
first check if cpusets are enabled via cpusets_enabled() static branch.
This branch can be rewritted dynamically (via cpuset_inc) if a new
cpuset is created. The x86 jump label code fully synchronizes across
all CPUs for every entry it rewrites. If it rewrites only one of the
callsites (specifically the one in read_mems_allowed_retry) and then
waits for the smp_call_function(do_sync_core) to complete while a CPU is
inside the begin/retry section with IRQs off and the mems_allowed value
is changed, we can hang. This is because begin() will always return 0
(since it wasn't patched yet) while retry() will test the 0 against
the actual value of the seq counter.

The fix is to cache the value that's returned by cpusets_enabled() at the
top of the loop, and only operate on the seqlock (both begin and retry) if
it was true.

The relevant stack traces of the two stuck threads:

  CPU: 107 PID: 1415 Comm: mkdir Tainted: G L  4.9.36-00104-g540c51286237 #4
  Hardware name: Default string Default string/Hardware, BIOS 4.29.1-20170526215256 05/26/2017
  task: ffff8817f9c28000 task.stack: ffffc9000ffa4000
  RIP: smp_call_function_many+0x1f9/0x260
  Call Trace:
    ? setup_data_read+0xa0/0xa0
    ? ___slab_alloc+0x28b/0x5a0
    smp_call_function+0x3b/0x70
    ? setup_data_read+0xa0/0xa0
    on_each_cpu+0x2f/0x90
    ? ___slab_alloc+0x28a/0x5a0
    ? ___slab_alloc+0x28b/0x5a0
    text_poke_bp+0x87/0xd0
    ? ___slab_alloc+0x28a/0x5a0
    arch_jump_label_transform+0x93/0x100
    __jump_label_update+0x77/0x90
    jump_label_update+0xaa/0xc0
    static_key_slow_inc+0x9e/0xb0
    cpuset_css_online+0x70/0x2e0
    online_css+0x2c/0xa0
    cgroup_apply_control_enable+0x27f/0x3d0
    cgroup_mkdir+0x2b7/0x420
    kernfs_iop_mkdir+0x5a/0x80
    vfs_mkdir+0xf6/0x1a0
    SyS_mkdir+0xb7/0xe0
    entry_SYSCALL_64_fastpath+0x18/0xad

  ...

  CPU: 22 PID: 1 Comm: init Tainted: G L  4.9.36-00104-g540c51286237 #4
  Hardware name: Default string Default string/Hardware, BIOS 4.29.1-20170526215256 05/26/2017
  task: ffff8818087c0000 task.stack: ffffc90000030000
  RIP: int3+0x39/0x70
  Call Trace:
    <#DB> ? ___slab_alloc+0x28b/0x5a0
    <EOE> ? copy_process.part.40+0xf7/0x1de0
    ? __slab_alloc.isra.80+0x54/0x90
    ? copy_process.part.40+0xf7/0x1de0
    ? copy_process.part.40+0xf7/0x1de0
    ? kmem_cache_alloc_node+0x8a/0x280
    ? copy_process.part.40+0xf7/0x1de0
    ? _do_fork+0xe7/0x6c0
    ? _raw_spin_unlock_irq+0x2d/0x60
    ? trace_hardirqs_on_caller+0x136/0x1d0
    ? entry_SYSCALL_64_fastpath+0x5/0xad
    ? do_syscall_64+0x27/0x350
    ? SyS_clone+0x19/0x20
    ? do_syscall_64+0x60/0x350
    ? entry_SYSCALL64_slow_path+0x25/0x25

Reported-by: Cliff Spradlin <cspradlin-FA3Td6GO0iIAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dima Zavin <dmitriyz-FA3Td6GO0iIAvxtiuMwx3w@public.gmane.org>
---

We were reproducing the issue here with some regularity on ubuntu 14.04
running v4.9 (v4.9.36 at the time). The patch applies cleanly to 4.12 but
was only compile-tested there.

This is kind of a hacky solution that solves our immediate issue, but looks
like a more general problem and can affect other unsuspecting users of
these APIs. I suppose an irqs-off seqlock loop that is optimized away via
static_branch rewrites is rare. And, technically, it actually would be ok
except for the all-cpu sync in the x86 jump-label code between each entry
re-write. I don't know enough about all the implications of changing that,
or anything else in this path so I went with a targeted "fix" and rely on
the collective wisdom here to sort out what the correct solution to the
problem should be.

 include/linux/cpuset.h | 14 ++++++++++++--
 mm/slub.c              | 13 +++++++++++--
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index bfc204e70338..2a0f217413c6 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -111,12 +111,17 @@ extern void cpuset_print_current_mems_allowed(void);
  * causing process failure. A retry loop with read_mems_allowed_begin and
  * read_mems_allowed_retry prevents these artificial failures.
  */
+static inline unsigned int raw_read_mems_allowed_begin(void)
+{
+	return read_seqcount_begin(&current->mems_allowed_seq);
+}
+
 static inline unsigned int read_mems_allowed_begin(void)
 {
 	if (!cpusets_enabled())
 		return 0;
 
-	return read_seqcount_begin(&current->mems_allowed_seq);
+	return raw_read_mems_allowed_begin();
 }
 
 /*
@@ -125,12 +130,17 @@ static inline unsigned int read_mems_allowed_begin(void)
  * update of mems_allowed. It is up to the caller to retry the operation if
  * appropriate.
  */
+static inline bool raw_read_mems_allowed_retry(unsigned int seq)
+{
+	return read_seqcount_retry(&current->mems_allowed_seq, seq);
+}
+
 static inline bool read_mems_allowed_retry(unsigned int seq)
 {
 	if (!cpusets_enabled())
 		return false;
 
-	return read_seqcount_retry(&current->mems_allowed_seq, seq);
+	return raw_read_mems_allowed_retry(seq);
 }
 
 static inline void set_mems_allowed(nodemask_t nodemask)
diff --git a/mm/slub.c b/mm/slub.c
index edc79ca3c6d5..7a6c74851250 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1847,6 +1847,7 @@ static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
 	enum zone_type high_zoneidx = gfp_zone(flags);
 	void *object;
 	unsigned int cpuset_mems_cookie;
+	bool csets_enabled;
 
 	/*
 	 * The defrag ratio allows a configuration of the tradeoffs between
@@ -1871,7 +1872,14 @@ static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
 		return NULL;
 
 	do {
-		cpuset_mems_cookie = read_mems_allowed_begin();
+		if (cpusets_enabled()) {
+			csets_enabled = true;
+			cpuset_mems_cookie = raw_read_mems_allowed_begin();
+		} else {
+			csets_enabled = false;
+			cpuset_mems_cookie = 0;
+		}
+
 		zonelist = node_zonelist(mempolicy_slab_node(), flags);
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 			struct kmem_cache_node *n;
@@ -1893,7 +1901,8 @@ static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
 				}
 			}
 		}
-	} while (read_mems_allowed_retry(cpuset_mems_cookie));
+	} while (csets_enabled &&
+		 raw_read_mems_allowed_retry(cpuset_mems_cookie));
 #endif
 	return NULL;
 }
-- 
2.14.0.rc0.400.g1c36432dff-goog
