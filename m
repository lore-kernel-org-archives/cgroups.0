From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: move bio cgroup punting into btrfs
Date: Mon, 27 Mar 2023 09:49:46 +0900
Message-ID: <20230327004954.728797-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=J34aMK6n+O5EOaIOD1zXvzTxUfNPfAeP9gPFHmYCaGA=; b=4M3uK7D06M5LGjDiFkWczeT12G
        Pr/zv02t1WWrUSI1ZtKKyr4dSQBLuK86287W6gGZfpKr49g/XufKv582wRFvV84PxJS/CZ2IbAL32
        5mCxz4UXT6WQArvCuCArUftBki8/SVAx/KAi3kaGC+GAh0lEOvyTEVaSraNm2S5zaV29s/9QlpU2J
        FzCW7xq/xIRFxXbxUvdR0YHhdVsF8MtMFdAEdQSEWYvt7tCvs5qrc5ZAueo2MJAM6D/9PWl8SsrdY
        mL9PnLJs3vWh7Hl/gIwdSoBVonA7tYt1FU1XPWkCVgBFjvkZ4vussqUzn/iKmd/lFGI26P8pzmsl7
        i13m7J7Q==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

the current code to offload bio submission into a cgroup-specific helper
thread when sent from the btrfs internal helper threads is a bit ugly.

This series moves it into btrfs with minimal interference in the core
code.

I also wonder if the better way to handle this in the long would be to
to allow multiple writeback threads per device and cgroup, which should
remove the need for both the btrfs submission helper workqueue and the
per-cgroup threads.

Diffstat:
 block/Kconfig             |    3 +
 block/blk-cgroup.c        |   78 +++++++++++++++++++++++++---------------------
 block/blk-cgroup.h        |   15 +-------
 block/blk-core.c          |    3 -
 fs/btrfs/Kconfig          |    1 
 fs/btrfs/bio.c            |   12 ++++---
 fs/btrfs/bio.h            |    3 +
 fs/btrfs/compression.c    |    8 ----
 fs/btrfs/compression.h    |    1 
 fs/btrfs/extent_io.c      |    6 +--
 fs/btrfs/inode.c          |   37 +++++++++++----------
 include/linux/bio.h       |    5 ++
 include/linux/blk_types.h |   18 ++--------
 include/linux/writeback.h |    5 --
 14 files changed, 94 insertions(+), 101 deletions(-)
