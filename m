From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: mm/memcontrol.c:5364:1: warning: the frame size of 1032 bytes is
 larger than 1024 bytes [-Wframe-larger-than=]
Date: Thu, 14 Dec 2017 10:19:17 +0100
Message-ID: <20171214091917.GE16951@dhcp22.suse.cz>
References: <a16d8181-3bb4-90cc-3c4b-ac44529494ed@molgen.mpg.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a16d8181-3bb4-90cc-3c4b-ac44529494ed-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Paul Menzel <pmenzel+linux-cgroups-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, it+linux-cgroups-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org

On Thu 14-12-17 07:49:29, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> I enabled the undefined behavior sanitizer, and built Linus’ master branch
> under Ubuntu 17.10 with gcc (Ubuntu 7.2.0-8ubuntu3) 7.2.0.
> 
> ```
> $ grep UBSAN /boot/config-4.15.0-rc3+
> CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
> # CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
> CONFIG_UBSAN=y
> CONFIG_UBSAN_SANITIZE_ALL=y
> # CONFIG_UBSAN_ALIGNMENT is not set
> CONFIG_UBSAN_NULL=y
> ```
> 
> The warning below is shown when building Linux.
> 
> ```
> $ git describe --tags
> v4.15-rc3-37-gd39a01eff9af
> $ git log --oneline -1
> d39a01eff9af (HEAD -> master, origin/master, origin/HEAD) Merge tag
> 'platform-drivers-x86-v4.15-3' of
> git://git.infradead.org/linux-platform-drivers-x86
> […]
> $ make -j
> […]
> mm/memcontrol.c: In function ‘memory_stat_show’:
> mm/memcontrol.c:5364:1: warning: the frame size of 1032 bytes is larger than
> 1024 bytes [-Wframe-larger-than=]

Interesting. My compiler does this
$ scripts/stackusage mm/memcontrol.o
$ grep memory_stat_show /tmp/stackusage.1405.RTP8
./mm/memcontrol.c:5526  memory_stat_show        976     static

But this depends on the configuration because NR_VM_EVENT_ITEMS enables
some counters depending on the config. The stack is really large but
this is a function which is called from a shallow context wrt. stack so
we should fit into a single page. One way we could do, though, is to
make those large arrays static and use a internal lock around them.
Something like the following. What do you think Johannes?
---
From d2ef50c2722f8465b169d4f7fad865478c2e9fed Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Date: Thu, 14 Dec 2017 10:12:22 +0100
Subject: [PATCH] mm, memcg: reduce memory_stat_show stack footprint
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

scripts/stackusage says that memory_stat_show consumes a lot of stack
space
./mm/memcontrol.c:5526  memory_stat_show        976     static

The size can be even larger depending on the configuration. Paul Menzel
has even got the following warning for his distribution config:
mm/memcontrol.c: In function ‘memory_stat_show’:
mm/memcontrol.c:5364:1: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]

The stack usage should be safe because this function is called from
shallow context but let's make those two large arrays static and
synchronize callers by a mutex. This might slow heavy parallel memcg
stat readers. If this ever turns out to be a problem we can drop those
arrays altogether and print the current snapshots of those counters
(this would be more prone to get inconsistent results though).

Reported-by: Paul Menzel <pmenzel+linux-cgroups-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org>
Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
---
 mm/memcontrol.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8fa91d24a70b..784a4bd5fdf0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5526,8 +5526,9 @@ static int memory_events_show(struct seq_file *m, void *v)
 static int memory_stat_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
-	unsigned long stat[MEMCG_NR_STAT];
-	unsigned long events[MEMCG_NR_EVENTS];
+	static unsigned long stat[MEMCG_NR_STAT];
+	static unsigned long events[MEMCG_NR_EVENTS];
+	static DEFINE_MUTEX(stat_lock);
 	int i;
 
 	/*
@@ -5540,7 +5541,7 @@ static int memory_stat_show(struct seq_file *m, void *v)
 	 *
 	 * Current memory state:
 	 */
-
+	mutex_lock(&stat_lock);
 	tree_stat(memcg, stat);
 	tree_events(memcg, events);
 
@@ -5601,6 +5602,7 @@ static int memory_stat_show(struct seq_file *m, void *v)
 		   stat[WORKINGSET_ACTIVATE]);
 	seq_printf(m, "workingset_nodereclaim %lu\n",
 		   stat[WORKINGSET_NODERECLAIM]);
+	mutex_unlock(&stat_lock);
 
 	return 0;
 }
-- 
2.15.0

-- 
Michal Hocko
SUSE Labs
