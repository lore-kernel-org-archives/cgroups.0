From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 07/13] Documentation/admin-guide: pnfs-scsi-server: drop doubled word
Date: Fri,  3 Jul 2020 20:20:14 -0700
Message-ID: <20200704032020.21923-8-rdunlap@infradead.org>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-media-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=NxLHP+9cFhtU3n1OYnw9N90/6GroG0s0rwbqmFTSb6o=; b=kdlQ3P5n9vkkqj1ly+uWdiMMtM
        Exf5dBIyd7H1wc5cxeAxqlwv/2Un9/BIrbYJXUcVKUmrMpYU4knuAT5//TN8Pn3KGBUQEmWescrtC
        T4EP5rVfc+p30Jwt9ueo27TcoRyQiJL2HPkBychrVGwgev8EXNraang584WgoG8ypw+ApdA21wkhu
        tVxlVkCIeTP5Ca8+MxuXO2aTo9+kfdWW+TXsgdOF3p98hImfRBkh1PUYwBQqE7b3MJcqE1Z8dqj1w
        200gdii7HIynKZmL6xQX6rwATVSlCTYK7zVM7nvmTgz0OCoVIsKEQ9NAjwiebLFgDlWU7lbYHMklg
        l4/rBZUw==;
In-Reply-To: <20200704032020.21923-1-rdunlap@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org, platform-driver-x86@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

Drop the doubled word "with".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: linux-nfs@vger.kernel.org
---
 Documentation/admin-guide/nfs/pnfs-scsi-server.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/admin-guide/nfs/pnfs-scsi-server.rst
+++ linux-next-20200701/Documentation/admin-guide/nfs/pnfs-scsi-server.rst
@@ -9,7 +9,7 @@ which in addition to handling all the me
 also hands out layouts to the clients so that they can directly access the
 underlying SCSI LUNs that are shared with the client.
 
-To use pNFS SCSI layouts with with the Linux NFS server, the exported file
+To use pNFS SCSI layouts with the Linux NFS server, the exported file
 system needs to support the pNFS SCSI layouts (currently just XFS), and the
 file system must sit on a SCSI LUN that is accessible to the clients in
 addition to the MDS.  As of now the file system needs to sit directly on the
