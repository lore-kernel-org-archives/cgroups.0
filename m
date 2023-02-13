From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: fix circular disk reference in blk-cgroup
Date: Mon, 13 Feb 2023 11:41:31 +0100
Message-ID: <20230213104134.475204-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=QFZ+a29GeVUTeCrKA7f2ruTlAoD7iMuLbB/uIVPnxW0=; b=rMSPJdjGCN8rptqoedEr8hCkvc
        VjM2QSg+CneSLRfeKsGg6vl/T4GO5mQ/PUlb5AjqRH61rdqLpjL4l94ToR+lK5OytBh2g20AMNnl7
        RRP5mfvMPEhufK2vYM2L2GM9TAoj9eTTEca6p8a8YzHmB1gQYubUbhTyCpwgiB362SFH99d8cFf3n
        tGZ/+y+qgbAOzDxjygjZ6a05xuOrKxYeNho7mtp1Z7EF8d1NS8irPDQ/90MTPMfBp2sSLgWtBNOlu
        SWA1qChSFjh9My1Xf+gWOD/TH0zSc7DARAEPuo1mMURewDrq0harT5Dl4m5v3kRg1lHnTbFCSE1+S
        dIld38bw==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

the third patch fixes a problem in haivng a circular disk reference
for blkgs.  The first two patches clean up blk-throttle to avoid
queue->disk refernece that get torn down in disk_release but could
in theory be used in the pd_free handler.

Diffstat:
 block/blk-cgroup.c     |   12 +++++++++---
 block/blk-throttle.c   |   39 ++++++++++++++++-----------------------
 include/linux/blkdev.h |    8 +++-----
 3 files changed, 28 insertions(+), 31 deletions(-)
