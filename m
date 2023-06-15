From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] mm/memcontrol: do not tweak node in mem_cgroup_init()
Date: Thu, 15 Jun 2023 07:32:25 +0000
Message-ID: <20230615073226.1343-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1686814358; x=1689406358;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CdSuqedJEIbRKqsNMW9S5G/OsjR68rCgzUTpBoDLnEM=;
        b=iU852+gDGJfi782GaPH9x2wg+XeTiQfHnMpKe82njSX7LmSgor6PAYAv0eEFGaz83T
         V469KupOqNbHHXNJ4Jefz2GB3bC4LZjS2faO6A6T5HWzH2FFEcITh2Zsgk5/t3sKWY44
         NkzEhL0j/+VTAue8L4PvlYkIgx+veA8rgIpczK6FpJUpuYTWFAXj5VvB6se0797A+t3J
         mgGiwwWbHp4YJ3r4k0RWOusTLSUkzwa+q0OoRPly9mGKor87OeO/SXxdU8wAQ+Wd053g
         AJyBa0S3RjgNzLNNkJdtpb63/NRDm0Z0H1NOH05Zft4GUThQFhik4A5One3CXwpQ3lUh
         nI7g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mhocko-IBi9RG/b67k@public.gmane.org
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

mem_cgroup_init() request for allocations from each possible node, and
it's used to be a problem because NODE_DATA is not allocated for offline
node. Things have already changed since commit 09f49dca570a9 ("mm: handle
uninitialized numa nodes gracefully"), so it's unnecessary to check for
!node_online nodes here.

Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4b27e245a055..c73c5fb33f65 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7421,8 +7421,7 @@ static int __init mem_cgroup_init(void)
 	for_each_node(node) {
 		struct mem_cgroup_tree_per_node *rtpn;
 
-		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
-				    node_online(node) ? node : NUMA_NO_NODE);
+		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
 
 		rtpn->rb_root = RB_ROOT;
 		rtpn->rb_rightmost = NULL;
-- 
2.25.1

