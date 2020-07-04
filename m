From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 13/13] Documentation/admin-guide: xfs: drop doubled word
Date: Fri,  3 Jul 2020 20:20:20 -0700
Message-ID: <20200704032020.21923-14-rdunlap@infradead.org>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=0aHjQ55hFxq6STzE8jcPc++LJg3Ht8D7yJwufSR30/I=; b=crtyVFUUrVpKua+McHYUoIje7r
        u9Z4eU/Yh+Lf+I6E8teepx4m84OpgMhb3cSfbkkeCJNmNQJAwLLP9WL67m0hdI/rW/63LUPbt1qkf
        RRyVxT2iL8djwXVmOJf92BhmdplTayXrRVe2MOjTL/CrqZ2whCkgD9ZEJ84QB3O7bBqZIhNAeESH1
        QQ4BZubJwj5hj8SDMoO/ulG0wC4LSNxXfW58XwQfnCwPPXqG1AcXSb8ceMPuq063UWFE1QQ6V0QGu
        ZaHlK10StFUDZ8gPV1qSto9E643B/WRyGF/mNlWQBa5ymyFfB1IbMKYyG7gxHuFjfvcFovndXHrOR
        d8hk8i6A==;
In-Reply-To: <20200704032020.21923-1-rdunlap@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org, platform-driver-x86@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

Drop the doubled word "for".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
---
 Documentation/admin-guide/xfs.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/admin-guide/xfs.rst
+++ linux-next-20200701/Documentation/admin-guide/xfs.rst
@@ -133,7 +133,7 @@ When mounting an XFS filesystem, the fol
 	logbsize must be an integer multiple of the log
 	stripe unit configured at **mkfs(8)** time.
 
-	The default value for for version 1 logs is 32768, while the
+	The default value for version 1 logs is 32768, while the
 	default value for version 2 logs is MAX(32768, log_sunit).
 
   logdev=device and rtdev=device
