From: Christoph Hellwig <hch@lst.de>
Subject: make the blkcg and blkcg structures private
Date: Wed, 20 Apr 2022 06:27:08 +0200
Message-ID: <20220420042723.1010598-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Be3+26XptxIgmQQhBiL/mWzc+JWO9oS3P5KTSt/Lrqk=; b=hMv3QDFCmWfi2+JDhtKD7KhE/3
        wULxYat5Sc9vH8PgIDI6QRjrF5fBoxMYfPtpMILb9xkSlX/X7RmhSoRdRv/rb5ht3QrKXo9deJo63
        yYa8sQo0B9qXe/aTORpycq/9vh2IW3bYNGEWgEtDCu4OBzKonnQUwFebUnP/GGsjOOP/f1C0b+W5a
        w7bPbOrwGfiC3CrEiyQsNFtiS/EZEbth6mnT1NZPRrx4q2s765BKAxwDpkyflpDPYYQg7RexFpSev
        QjUPQyCbWsVjgR1jQGybXjLsFzJnkR2vXAB/v0wbEpBCBOBDERK9AZPa2RSnC2Sia+a6Araprwjzo
        z+2sCbsw==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, Tejun Heo <tj@kernel.org>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-nvme@lists.infradead.org, linux-mm@kvack.org

Hi all,

this series cleans up various lose end in the blk-cgroup code to make it
easier to follow in preparation of reworking the blkcg assignment for
bios.  The biggest change is that most of <linux/blk-cgroup.h> is now
taken private into block/.

Diffstat:
 block/Makefile                |    1 
 block/bfq-iosched.h           |    4 
 block/blk-cgroup-fc-appid.c   |   57 +++++++++
 block/blk-cgroup.c            |  154 ++++++++++++++++++++-----
 block/blk-cgroup.h            |  138 +++++++++++++++-------
 block/blk-throttle.c          |    2 
 drivers/block/loop.c          |   12 +
 drivers/nvme/host/fc.c        |   26 +---
 drivers/scsi/lpfc/lpfc_scsi.c |    4 
 include/linux/backing-dev.h   |    6 
 include/linux/blk-cgroup.h    |  258 ++----------------------------------------
 include/linux/blktrace_api.h  |   10 -
 include/linux/kthread.h       |    4 
 kernel/kthread.c              |    1 
 kernel/trace/blktrace.c       |   26 ++--
 mm/backing-dev.c              |   19 +--
 mm/readahead.c                |    1 
 mm/swapfile.c                 |    1 
 18 files changed, 343 insertions(+), 381 deletions(-)
