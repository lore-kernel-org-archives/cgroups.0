From: "Jiri Slaby (SUSE)" <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3] block/blk-iocost (gcc13): keep large values in a new enum
Date: Tue, 13 Dec 2022 13:08:26 +0100
Message-ID: <20221213120826.17446-1-jirislaby@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670933310;
        bh=1tNxadmfkO3wj3an2rLdn3PtureG9sBU9F7brxxdtrU=;
        h=From:To:Cc:Subject:Date:From;
        b=rFY4pyCHiVD7KgWofs2wsmFjqM4rL08Dplh3GbhT9v7DJqVBDyvjDzATa8bB6cib3
         S3+6iIZgeD1l684fNA0IHiBdi1TiF2dNj+prfU+U9kdA9nwWyZksd38HhAfwi7pJd/
         VP+paDps1N+Ojb/Q00qQPFRgGYNuNvbl5ilUwZtRZmc9T58WWMU3JEKoZYXADkMKKM
         9QW7KHZe4k34GlxbCG/Do/pExBrOJGlck9Cpmk5EkAYO3U3FPWNtcRJZoMQk2ciJ55
         iBKv69j6Ra/XaMe2t5KQiKS/Nx5p9iVksp2zkaPBlqaBJlRGHupKNUe8wqAjYb6Kmv
         dIiOkw7waa/Dw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Jiri Slaby (SUSE)" <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Since gcc13, each member of an enum has the same type as the enum [1]. And
that is inherited from its members. Provided:
  VTIME_PER_SEC_SHIFT     = 37,
  VTIME_PER_SEC           = 1LLU << VTIME_PER_SEC_SHIFT,
  ...
  AUTOP_CYCLE_NSEC        = 10LLU * NSEC_PER_SEC,
the named type is unsigned long.

This generates warnings with gcc-13:
  block/blk-iocost.c: In function 'ioc_weight_prfill':
  block/blk-iocost.c:3037:37: error: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'long unsigned int'

  block/blk-iocost.c: In function 'ioc_weight_show':
  block/blk-iocost.c:3047:34: error: format '%u' expects argument of type 'unsigned int', but argument 3 has type 'long unsigned int'

So split the anonumois enum with large values to a separate enum, so
that they don't affect other members.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113

Cc: Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---

Notes:
    [v3] move more to a new enum (effectively split the enums)
    [v2] move to a new enum

 block/blk-iocost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index d1bdc12deaa7..549ddc9e0c6f 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -232,7 +232,9 @@ enum {
 
 	/* 1/64k is granular enough and can easily be handled w/ u32 */
 	WEIGHT_ONE		= 1 << 16,
+};
 
+enum {
 	/*
 	 * As vtime is used to calculate the cost of each IO, it needs to
 	 * be fairly high precision.  For example, it should be able to
-- 
2.39.0

