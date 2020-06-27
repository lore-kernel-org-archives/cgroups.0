From: Christoph Hellwig <hch@lst.de>
Subject: drive-by blk-cgroup cleanups
Date: Sat, 27 Jun 2020 09:31:45 +0200
Message-ID: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=N+m/TXktm7C+5rnFX+JYBp/qnm40iMw/fl+XJO+IQXQ=; b=WcBaL3YXkyCLpW49SEw94Y7D7m
        KWLLqqIf2P69pD8tAY359N3kZtCw5LoPgZKsURUZH2Qukvx25sNRUgk3v9T0orAQ9etd19GFMwoZD
        c66gs10ktq3G6v+WWjcxpSciiwaHav362XO47NiGVoZznIG6j+FMh0/uCdPcv1byY7QzaVqFkemJg
        72Ax6ywHK0a62Dppe7UEOgY5E/005452+fFhjLyJMUzfmV2q/dqgt2BbvlSECDuNPLLri1gjSGV1Z
        hzQfPe/jU7lascGNtDABHjfzAFsOG0k2ysNNSLa631LuB2fCkJTrm1eWVsvfISjbt9X9BGVbCAjfN
        OitVpYQA==;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

Hi all,

while looking into another "project" I ended up wading through the
blkcq code for research and found a bunch of lose ends.  So here is
a bunch of drive-by cleanups for the code.

Diffstat:
 block/bio.c                |  143 +----------------------------------
 block/blk-cgroup.c         |  182 +++++++++++++++++++++++++++++++++++++--------
 block/blk-core.c           |    7 +
 block/blk-throttle.c       |   10 +-
 block/blk.h                |    2 
 drivers/md/dm.c            |    5 -
 include/linux/bio.h        |    9 --
 include/linux/blk-cgroup.h |  101 ------------------------
 kernel/cgroup/rstat.c      |    1 
 mm/page_io.c               |   17 ++++
 10 files changed, 192 insertions(+), 285 deletions(-)
