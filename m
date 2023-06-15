From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] mm/memcontrol: add check for allocation failure in mem_cgroup_init()
Date: Thu, 15 Jun 2023 07:32:26 +0000
Message-ID: <20230615073226.1343-2-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1686814362; x=1689406362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fNxDzGJxt2Rtrqq4SUvAlNEkp/z3fWK6RSnN1kjt4g4=;
        b=KEuKbPWosv9iUFbOmk/dVUFWj71DFPDvQ7CbfsaMugZZDa8k//E8CAEE0n7vr+1f9j
         LuaB0+g520Fb2VC8JF2Ke6qTtXHB+JzbKxSjCpCxOC9+m6pzYQjTgltBzMdNNNeet8Ea
         TA9tu43p8KzKc8oCUgqgD54eZUaQvLI/G36bAbrWX2vpG6RWPW0E2Yk20bIdnngUwFnx
         D1g4aYowz3lb2PduXbvRW/O2vQlVUUk6t5e9VKATy19FtWYWUTaAZlJk+ItZuMhRmNEr
         ZqgledtelE5KdFama0C4457YvSAPiqJd6KA8hxamKJH0N860sPoNcs9G9Wa6jhBqj3x8
         THYQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mhocko-IBi9RG/b67k@public.gmane.org
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

If mem_cgroup_init() fails to allocate mem_cgroup_tree_per_node, we
should not try to initilaize it. Add check for this case to avoid
potential NULL pointer dereference.

Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c73c5fb33f65..7ebf64e48b25 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7422,6 +7422,8 @@ static int __init mem_cgroup_init(void)
 		struct mem_cgroup_tree_per_node *rtpn;
 
 		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
+		if (!rtpn)
+			continue;
 
 		rtpn->rb_root = RB_ROOT;
 		rtpn->rb_rightmost = NULL;
-- 
2.25.1

