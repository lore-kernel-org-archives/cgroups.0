From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v13 01/18] mm: Add folio_nid()
Date: Mon, 12 Jul 2021 20:45:34 +0100
Message-ID: <20210712194551.91920-2-willy@infradead.org>
References: <20210712194551.91920-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Ls0PDTK4GmPt7o8GB9HWSuuERwLuQPqR3wzi6YV9cbE=; b=msR3r+CxymI9f1TqwdX859M2f8
        efT+6ox25yrnjVp3xSbuo1jNeYNQt9Mm91BMyQyib0fBd5lcHveUyoKoMqSea2uKsdOVNBejxvFxH
        RRjJW9oV+v1DKdrPlaJh/OoClBowrGno3ocy9gVJKmlTAYyEq8PPAaEOXOHBcZkEp/A+4lqsJKPha
        3R57wRTj0xzTnVbTRL0F+SPllevLR0VUmztl6eBJraPpxfo5kCHaKsjPHPKBdiZFqXUZb8qUUBb48
        MRWVNUgJ8Ifnc8DX+mX+cSOQX0jhrALm7IT9BQeR5MeE2DTWnVbrYZxx1mtI1HZyv0sOs1JTQzXOP
        RCUnMJUg==;
In-Reply-To: <20210712194551.91920-1-willy@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Christoph Hellwig <hch@lst.de>

This is the folio equivalent of page_to_nid().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/mm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a856c078e040..80f27eb151ba 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1427,6 +1427,11 @@ static inline int page_to_nid(const struct page *page)
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

