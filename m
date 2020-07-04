From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 08/13] Documentation/admin-guide: arm-ccn: drop doubled word
Date: Fri,  3 Jul 2020 20:20:15 -0700
Message-ID: <20200704032020.21923-9-rdunlap@infradead.org>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=0XLS9Rcvj09LtgGfVKUIZyZrmGOYd4UjCrzrWHy1+1s=; b=TXiZaQormlTtVEDg7USvjAjN9M
        AEc4Ojj1xm3khtsjz/TxDwH9GGiE1M3eLN8329NG74Pv80aEnoZyvEgOTANv4HIouoqhGrHI118gO
        f8BVLC+gr0TUOKK2AcxYELqfTOJO3bWUpFSedyZUzdxg73jSnzVxqbbGUqUZRYfIgIOeXUuxvwCA8
        Mc6zkXL/92sYXS2UgknQ+IOy+6GVEHCNrzTqbnD+Qj8fKKUmISEA/Apj1W4u+h9FfWM3FhDz2xX8n
        PH1V/yr5/uzV5WEbesL/RIWE5nyCh1BTH0TzTxlcnsfNWVh10TOg9iMvdwNF26dw/xP0a0L9hvpy3
        TuUBb6Dg==;
In-Reply-To: <20200704032020.21923-1-rdunlap@infradead.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org, platform-driver-x86@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

Drop the doubled word "as".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/admin-guide/perf/arm-ccn.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/admin-guide/perf/arm-ccn.rst
+++ linux-next-20200701/Documentation/admin-guide/perf/arm-ccn.rst
@@ -27,7 +27,7 @@ Crosspoint PMU events require "xp" (inde
 and "vc" (virtual channel ID).
 
 Crosspoint watchpoint-based events (special "event" value 0xfe)
-require "xp" and "vc" as as above plus "port" (device port index),
+require "xp" and "vc" as above plus "port" (device port index),
 "dir" (transmit/receive direction), comparator values ("cmp_l"
 and "cmp_h") and "mask", being index of the comparator mask.
 
