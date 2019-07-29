From: Chuhong Yuan <hslester96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/12] Replace strncmp with str_has_prefix
Date: Mon, 29 Jul 2019 23:13:23 +0800
Message-ID: <20190729151323.9226-1-hslester96@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=CReZX3ZIW9UVm3F381oja+qdURlLghUskZk6mGhexL4=;
	b=DF5eQiR/9iQxp/I05TpQxh96+yZz7SV9RG6uhl8zm5tQDkywRpo7tBrHo6+JYi9DMP
	aIHtjuXNygQy++dokdfX3GdSr9dlSz9bgGKf6DU4b9xcRtUDPafirv5OFFt7xntBUlZn
	j9XvmuoU2MOmMqnoKS+Lf5IRijAZXLO3YL5YivUqg9npFcmjI7ffrnyM4bxclXLs+p3V
	89IiySx2lv/p3CIxLGE/Lan/Kj6cJbPLYkh7Npa85VJ89wVuDve2mibdyFGFJyGUsvSq
	UdQYN969Ua7dgZYoTV74bAdwxPJ56h4tOpoaX8SKamq34W+W1tIrFUBiMsFps7A/3pBX
	3Y5A==
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, kgdb-bugreport-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Wessel <jason.wessel-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chuhong Yuan <hslester96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Rafael J . Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Peter Oberparleiter <oberpar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jessica Yu <jeyu-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>

The commit 72921427d46b
("string.h: Add str_has_prefix() helper function")
introduced str_has_prefix() to substitute error-prone
strncmp(str, const, len).

The commit b6b2735514bc
("tracing: Use str_has_prefix() instead of using fixed sizes")
has fixed some codes.

These patches use str_has_prefix to replace
such pattern of strncmp usages.

Chuhong Yuan (12):
  rdmacg: Replace strncmp with str_has_prefix
  kdb: Replace strncmp with str_has_prefix
  dma-debug: Replace strncmp with str_has_prefix
  gcov: Replace strncmp with str_has_prefix
  genirq/debugfs: Replace strncmp with str_has_prefix
  module: Replace strncmp with str_has_prefix
  power: Replace strncmp with str_has_prefix
  printk: Replace strncmp with str_has_prefix
  reboot: Replace strncmp with str_has_prefix
  sched: Replace strncmp with str_has_prefix
  userns: Replace strncmp with str_has_prefix
  watchdog: Replace strncmp with str_has_prefix

 kernel/cgroup/rdma.c        | 2 +-
 kernel/debug/kdb/kdb_main.c | 2 +-
 kernel/dma/debug.c          | 2 +-
 kernel/gcov/fs.c            | 2 +-
 kernel/irq/debugfs.c        | 2 +-
 kernel/module.c             | 2 +-
 kernel/power/hibernate.c    | 8 ++++----
 kernel/power/main.c         | 2 +-
 kernel/printk/braille.c     | 4 ++--
 kernel/printk/printk.c      | 6 +++---
 kernel/reboot.c             | 2 +-
 kernel/sched/debug.c        | 2 +-
 kernel/sched/isolation.c    | 4 ++--
 kernel/user_namespace.c     | 4 ++--
 kernel/watchdog.c           | 8 ++++----
 15 files changed, 26 insertions(+), 26 deletions(-)

-- 
2.20.1
