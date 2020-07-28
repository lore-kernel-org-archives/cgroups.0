From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] mm: memcontrol: restore proper dirty throttling when memory.high changes
Date: Tue, 28 Jul 2020 09:52:09 -0400
Message-ID: <20200728135210.379885-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EtW0ADoRwQtOsaGG7oJlooe3S87y53RN1USDHS3OX1k=;
        b=n1QWWvhgXYfYFQhyOqcZpff1NCZlRpZRU+M57YX8VkjXTtd3GqfnDkYU0Ml146ZUTZ
         EMUF3jGXqq0ZC+jlxfvAVMjoHJNWyaygZPYp4hXRevNGlGHVvpyCD8PlVbquWCb5nH4w
         UzI+8KI2BOpWhsINM70UMwN4agULCxVCtHtZj8ZAUgZk2Mz6MbJ3wids2nV60eUD5OT2
         G5sgsBxiIAMoMM42EOEJipYA/duIJUeWlfrsrEeW+/D40GXy1ycVavy2AIRGeLsLtIh6
         AUs2Y7iVWX1FTqBsZUxSi2UE2j1cv4OU9emJT+b4CA49q6ooCVZ3b/20TcvF6D0xPnw0
         Q+mw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Commit 8c8c383c04f6 ("mm: memcontrol: try harder to set a new
memory.high") inadvertently removed a callback to recalculate the
writeback cache size in light of a newly configured memory.high limit.

Without letting the writeback cache know about a potentially heavily
reduced limit, it may permit too many dirty pages, which can cause
unnecessary reclaim latencies or even avoidable OOM situations.

This was spotted while reading the code, it hasn't knowingly caused
any problems in practice so far.

Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 13f559af1ab6..805a44bf948c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6071,6 +6071,7 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 			break;
 	}
 
+	memcg_wb_domain_size_changed(memcg);
 	return nbytes;
 }
 
-- 
2.27.0

