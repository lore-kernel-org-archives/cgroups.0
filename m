From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: [PATCH 5.15 121/159] block/blk-iocost (gcc13): keep large values in a new enum
Date: Wed,  7 Jun 2023 22:17:04 +0200
Message-ID: <20230607200907.635181797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1686171712;
        bh=3g1ezkSeNovKyNA/mYRnkKvsFp4NaVHgDIm4yL0ohA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCBKLAI5qdA2mToaPW/eWLYpXW2HGo7G5X7Z81GYFO5xaQXDHrgOue4NJM0We1vQM
         7WiOvqRQENEsOkhxhv7zRIc0RTS0I0o91U3kJ9Q0G4iK2Prv9sgz6lxPcFECzwrvQc
         Ay1XgrvajT4Vg4SzFJngyOU9320qbr+7nW1RjFrQ=
In-Reply-To: <20230607200903.652580797-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Jiri Slaby (SUSE)" <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

From: Jiri Slaby (SUSE) <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

commit ff1cc97b1f4c10db224f276d9615b22835b8c424 upstream.

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

So split the anonymous enum with large values to a separate enum, so
that they don't affect other members.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113

Cc: Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Link: https://lore.kernel.org/r/20221213120826.17446-1-jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Signed-off-by: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
---
 block/blk-iocost.c |    2 ++
 1 file changed, 2 insertions(+)

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


