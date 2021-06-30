From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v3 01/18] mm: Add folio_nid()
Date: Wed, 30 Jun 2021 05:00:17 +0100
Message-ID: <20210630040034.1155892-2-willy@infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=4M1RMjp1sHStCMlmNe7eYn2fAPfqamAD/pAGYiqL3n0=; b=UwhPCJerldFihrwtXHNJHqabcZ
        YOMDupabJSqcrUfNNo3/nalt5CP2DtpDO9MlQq4bzk/jMonK/U9FciycMAGimGYPIxM0li0CXco9a
        qwTqO4VIVW3DRZ2uWG0SSbaobc3Tb0zEsakks3F9N79CV+PgsSVmYGHAI6XoW6ljE/BlDVPjBokY1
        FBKnqsCKNguz89FOlIWYpP9NMuw78GhS83wDZPIUmxBLVV27LttCUgTEmZ5O/VVhIBRM7e/aVtIoQ
        BjpRB3m03CXKYuck65gL8JB6qQdqk2hy6eXMti3FXpaFVUxn/g8KHqPQdWDBZBuHEvdcKQuwVIGem
        Jvy3SiHA==;
In-Reply-To: <20210630040034.1155892-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This is the folio equivalent of page_to_nid().

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 include/linux/mm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7ad3c8a115ae..48d2ccd9f8c3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1429,6 +1429,11 @@ static inline int page_to_nid(const struct page *page)
 }
 #endif
 
+static inline int folio_nid(const struct folio *folio)
+{
+	return page_to_nid(&folio->page);
+}
+
 #ifdef CONFIG_NUMA_BALANCING
 static inline int cpu_pid_to_cpupid(int cpu, int pid)
 {
-- 
2.30.2

