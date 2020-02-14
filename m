From: Jules Irenge <jbi.octave-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/30] mm/memcontrol: Add missing annotation for lock_page_lru()
Date: Fri, 14 Feb 2020 20:47:15 +0000
Message-ID: <20200214204741.94112-5-jbi.octave@gmail.com>
References: <0/30>
 <20200214204741.94112-1-jbi.octave@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XQbKLQ9ukje1bT/FheNFvSXPv2JzfMKZr476ojL2Is0=;
        b=O5ir4u/aNTfUulqZgaK74Gu8mBBzIqrjfADgTPMzLTzu1KAaf5QhfiF7kasEvy5r4K
         ErG2wMyrU7UIe0OHtzQefP/ASrTS2xW6pdSXgvPTDid60F1YgIP5XLH4vSUw/PECCgGv
         Pa4cg3cKyKakJj7xVxQ0ei/Rp6Od561Ee9nLUyaY5bPJGHcMYlszGui/5WsNIo3AiOp1
         8chcGs06TgYmRm4OU+BMsaiPP3+fjTxtzTIDU6vJLXvT8YZ9sTd+TmxgjbbvPUsJaof9
         8qPho5ezQRvGRyFcOCnQK+B6YW4RPQhq9zuSANGmyzBFVnDjnlJ6D97CHQo2DeXk/VHs
         Lxlg==
In-Reply-To: <20200214204741.94112-1-jbi.octave-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Jules Irenge <jbi.octave-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER MEMCG" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER MEMCG" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Sparse reports warning at lock_page_lry()

warning: context imbalance in lock_page_lru() - wrong count at exit

The root cause is the missing annotation at lock_page_lru()
Add the missing __acquires(&pgdat->lru_lock)

Signed-off-by: Jules Irenge <jbi.octave-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 22ddd557a69b..67dc9f1af0bf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2571,6 +2571,7 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 }
 
 static void lock_page_lru(struct page *page, int *isolated)
+	__acquires(&pgdat->lru_lock)
 {
 	pg_data_t *pgdat = page_pgdat(page);
 
-- 
2.24.1

