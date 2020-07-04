From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 02/13] Documentation/admin-guide: cgroup-v1/rdma: drop doubled word
Date: Fri,  3 Jul 2020 20:20:09 -0700
Message-ID: <20200704032020.21923-3-rdunlap@infradead.org>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-media-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=aRVEN4YU/BFDPd6cVTCzZUpu/CCVzRwNOQDbPEBZys4=; b=tJY95Xa0IAWCrSFHJ8hTCqVmCb
        PXAAOu78uVM3UWrMJkge+fpEUOzsWN6i1uIxsyLnmkkuQkJJKI8Wx/TOSwiCRs3GoeUv+ef/Odg/4
        DScwsH1ayFutkvn+JXl/8SAVMLiPQGYB0MUXTsWHuuWqq5ph52ziQX1HKD76p6hA9U7asFqXqBZeE
        9rhtY/avec+Vt38MW41IjTZHQyftEBAk/dryc/xxN2emvHd+r8wIzhVGs4AVI9JlrkZ3Em9tgS+5V
        Fz+a9iVry0UFDQ259p5zqFaxpP59X6EW0kDPHUScNKFFxI8sioWVwnTmsuLAIn7yc+3yPmOcbAc9k
        lOiOUrzQ==;
In-Reply-To: <20200704032020.21923-1-rdunlap@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org, platform-driver-x86@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

Drop the doubled word "echo".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: cgroups@vger.kernel.org
---
 Documentation/admin-guide/cgroup-v1/rdma.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/admin-guide/cgroup-v1/rdma.rst
+++ linux-next-20200701/Documentation/admin-guide/cgroup-v1/rdma.rst
@@ -114,4 +114,4 @@ Following resources can be accounted by
 
 (d) Delete resource limit::
 
-	echo echo mlx4_0 hca_handle=max hca_object=max > /sys/fs/cgroup/rdma/1/rdma.max
+	echo mlx4_0 hca_handle=max hca_object=max > /sys/fs/cgroup/rdma/1/rdma.max
