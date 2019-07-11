From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH] MAINTAINERS: add entry for block io cgroup
Date: Thu, 11 Jul 2019 13:19:47 +0300
Message-ID: <156284038698.3851.6531328622774377848.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1562840387; bh=Ys/8HwYgsYPGqfQr/FHJcIRKRrAYML5U69Kc2WYjDvw=;
        h=Message-ID:Date:To:From:Subject;
        b=KvoWyHT9WLqdhruSCfWOW/9NrniMBswJbPhJkmkMoI/vVJeKOmJXo1FEDgeIQ75oy
         L9rc06kE1tvrVw0vxT32b+rShXsM2E4kqa2lvIf3YuL4ooTJ3uU3Hvd8jrVdrFNTYM
         qy1RbiYRz4kixZ4D5cPi+Y+aMO8Dvx1Kn32xZ1R0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

This links mailing list cgroups@vger.kernel.org with related files.

$ ./scripts/get_maintainer.pl -f block/blk-cgroup.c
Jens Axboe <axboe@kernel.dk> (maintainer:BLOCK LAYER)
cgroups@vger.kernel.org (open list:CONTROL GROUP - BLOCK IO CONTROLLER (BLKIO))
linux-block@vger.kernel.org (open list:BLOCK LAYER)
linux-kernel@vger.kernel.org (open list)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 43ca94856944..906ba9ca015a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4148,6 +4148,15 @@ S:	Maintained
 F:	mm/memcontrol.c
 F:	mm/swap_cgroup.c
 
+CONTROL GROUP - BLOCK IO CONTROLLER (BLKIO)
+L:	cgroups@vger.kernel.org
+F:	Documentation/cgroup-v1/blkio-controller.rst
+F:	block/blk-cgroup.c
+F:	include/linux/blk-cgroup.h
+F:	block/blk-throttle.c
+F:	block/blk-iolatency.c
+F:	block/bfq-cgroup.c
+
 CORETEMP HARDWARE MONITORING DRIVER
 M:	Fenghua Yu <fenghua.yu@intel.com>
 L:	linux-hwmon@vger.kernel.org

