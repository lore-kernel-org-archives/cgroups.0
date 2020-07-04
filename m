From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 01/13] Documentation/admin-guide: cgroup-v2: drop doubled word
Date: Fri,  3 Jul 2020 20:20:08 -0700
Message-ID: <20200704032020.21923-2-rdunlap@infradead.org>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=v3to2sgHc1QVReX422OXkm9R4yx3s+sZ/QxCA2U3Qmo=; b=taJdNT58TuHsRqiei7ea6NUisP
        EtY14yX4mCeRinnwVry/Uu0nT7qWV//7xInhrXjQe0yaZhcMW771WfVTjm9aUgXaJj9wAaHl3cKJ/
        hL1hqPOtLQzngxrbgXph4OOakmR5SutLNr39V3f8EVT1p+DOClRGKyCASH9x9C1I+T+QjB887zRNz
        oMOygfqs8SRm/7kWu6HB1q/glBTMXBJu7dt7RQHN8cyFf54XA5q2/uhaXbexy4jmxWTzyCBZYpPSY
        oXvGYQtRZwpq+ENmUCkKnZZ6hiE5GVYRw/7kiwA3U18+Pbgu03ksXgppWt1AjiMNBwEa1mL6UrvRU
        5JYJIv3g==;
In-Reply-To: <20200704032020.21923-1-rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Darrick J . Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Drop the doubled word "of".

Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 Documentation/admin-guide/cgroup-v2.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/admin-guide/cgroup-v2.rst
+++ linux-next-20200701/Documentation/admin-guide/cgroup-v2.rst
@@ -2047,7 +2047,7 @@ RDMA
 ----
 
 The "rdma" controller regulates the distribution and accounting of
-of RDMA resources.
+RDMA resources.
 
 RDMA Interface Files
 ~~~~~~~~~~~~~~~~~~~~
