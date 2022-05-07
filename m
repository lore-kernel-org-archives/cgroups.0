From: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] mm/memcontrol: Export memcg->watermark via sysfs for v2
 memcg
Date: Fri, 6 May 2022 22:09:16 -0700
Message-ID: <20220507050916.GA13577@us192.sjc.aristanetworks.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1651900157;
        bh=zrzqKK70W/pOx1iBnr89i/xaqiudUyZePB/8DQdsNpA=;
        h=Date:From:To:Cc:Subject:From;
        b=yr0x5+aowZmQmo7lmY/5Wg6PNN8487hbz++VV/j4rk5A6Ko/8U6vVAsn43VRQh0FU
         knA6/6JPM+Lrb+jK31NXKsREjg1uMcE4wc3s4XHgU7BzJ8udqEWZa/3/eUr352XzaN
         24hILD5pM7m0SWvE4pMY5juLZUGzOTt9UWIoBADvbIr/wmeAm38mGFzkm9+PNsc9uj
         IIIbKDu9HO/avJ7DjP1HLdR5G4tf8F6U5144z4ezwNUzyNuFzOUD5qm9U1u0vxe7cg
         +v4E3DVGSZ8ZDLDUdvYks4sk1NJyVsFYSqWIj1F7Wp8G+QEhLN9o/Vr/8ppyL+qLmt
         LDKcg14kNUfIg==
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org

We run a lot of automated tests when building our software and run into
OOM scenarios when the tests run unbounded. v1 memcg exports
memcg->watermark as "memory.max_usage_in_bytes" in sysfs. We use this
metric to heuristically limit the number of tests that can run in
parallel based on per test historical data.

This metric is currently not exported for v2 memcg and there is no
other easy way of getting this information. getrusage() syscall returns
"ru_maxrss" which can be used as an approximation but that's the max
RSS of a single child process across all children instead of the
aggregated max for all child processes. The only work around is to
periodically poll "memory.current" but that's not practical for
short-lived one-off cgroups.

Hence, expose memcg->watermark as "memory.peak" for v2 memcg.

Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  7 +++++++
 mm/memcontrol.c                         | 13 +++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 69d7a6983f78..828ce037fb2a 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1208,6 +1208,13 @@ PAGE_SIZE multiple when read back.
 	high limit is used and monitored properly, this limit's
 	utility is limited to providing the final safety net.
 
+  memory.peak
+	A read-only single value file which exists on non-root
+	cgroups.
+
+	The max memory usage recorded for the cgroup and its
+	descendants since the creation of the cgroup.
+
   memory.oom.group
 	A read-write single value file which exists on non-root
 	cgroups.  The default value is "0".
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 725f76723220..88fa70b5d8af 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6098,6 +6098,14 @@ static u64 memory_current_read(struct cgroup_subsys_state *css,
 	return (u64)page_counter_read(&memcg->memory) * PAGE_SIZE;
 }
 
+static u64 memory_peak_read(struct cgroup_subsys_state *css,
+			    struct cftype *cft)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	return (u64)memcg->memory.watermark * PAGE_SIZE;
+}
+
 static int memory_min_show(struct seq_file *m, void *v)
 {
 	return seq_puts_memcg_tunable(m,
@@ -6361,6 +6369,11 @@ static struct cftype memory_files[] = {
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.read_u64 = memory_current_read,
 	},
+	{
+		.name = "peak",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = memory_peak_read,
+	},
 	{
 		.name = "min",
 		.flags = CFTYPE_NOT_ON_ROOT,
-- 
2.28.0

