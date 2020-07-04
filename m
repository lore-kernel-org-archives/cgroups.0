From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 03/13] Documentation/admin-guide: dm-integrity: drop doubled words
Date: Fri,  3 Jul 2020 20:20:10 -0700
Message-ID: <20200704032020.21923-4-rdunlap@infradead.org>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=OX5gHkwRjdsphqPt6oiGYwwyZUjS829HMpxoXk36jV8=; b=FE+o7+ShQZ2AiuFUBYQn85Da1f
        G2Yu2rsWT7l/PufkfBHi6+HVkOGIMo+xzFVFJRTjQAKFgoWNOEQl33q/JRSVGo25f5prdmn1+7ejY
        3d+xxkfejFHE+p2bYujzHfi8DIyAdx1vPt6MHoMN4EetW5KLS1SjqfybqxmbiEeOMYCJY99DvRSDs
        KvbXu8EGt1zxIdSPQh2vhvCB/yo7r1JmqrhZLesdsGDPLkENZnfOWFo1P08y/XCFq5BiPoNYQfqOy
        mXKg510Em8dbR8L2J1ZPqF17fz1qB5Tx7uewRboZ+Bf/6WZOacDFRmhy2YVQ74/WwoJmk1vKDvVtr
        mRTgU5PA==;
In-Reply-To: <20200704032020.21923-1-rdunlap@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org, platform-driver-x86@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

Drop the doubled words "on" and "the".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: dm-devel@redhat.com
---
 Documentation/admin-guide/device-mapper/dm-integrity.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200701.orig/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ linux-next-20200701/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -45,7 +45,7 @@ To use the target for the first time:
    will format the device
 3. unload the dm-integrity target
 4. read the "provided_data_sectors" value from the superblock
-5. load the dm-integrity target with the the target size
+5. load the dm-integrity target with the target size
    "provided_data_sectors"
 6. if you want to use dm-integrity with dm-crypt, load the dm-crypt target
    with the size "provided_data_sectors"
@@ -99,7 +99,7 @@ interleave_sectors:number
 	the superblock is used.
 
 meta_device:device
-	Don't interleave the data and metadata on on device. Use a
+	Don't interleave the data and metadata on the device. Use a
 	separate device for metadata.
 
 buffer_sectors:number
