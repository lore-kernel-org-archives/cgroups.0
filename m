From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: switch blk-cgroup to work on gendisk v3
Date: Wed,  1 Feb 2023 14:41:04 +0100
Message-ID: <20230201134123.2656505-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=jNtog0tFommlAH5fgq5rss1HEcJ0iwL22Z02J2TVgn8=; b=0Ezd3HL1p1KeWaRUMkQUtmF9R1
        oAMT6RXAOyDFxHP4JvcB2U6+oLQCApPEfpixW5D1aAAIl7aMfXTTW8r779rdaFkj9smQYsWov0iyN
        XMC+b+jun+Vi2gLY/FaUS5LgikMAQvULTBnoRI+QlN9KqdLGVoOdbVspznNowuobnz5mdJUJmGsnB
        D+oOqbcETHFXdN8Yz0KWnEbEXfsmugpKPcFu1I32ca6TBp26jmaH8NMAZqP+vlv1gHldA1RUHdfR7
        3s/KR+UJ0jUbIMHaRVpVNvDj3vVBpW8s6fFMoRohDM45EZUqBayxcqwxfEgC00JGaPfZgEjphojhH
        YvbTRXPw==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

blk-cgroup works on only on live disks and "file system" I/O from bios.
This all the information should be in the gendisk, and not the
request_queue that also exists for pure passthrough request based
devices.

Changes since v2:
 - drop the patch to revert the async blkg freeing
 - simplify error unwinding when failing to allocate a blkg
 - add back the dead queue/disk check in blkg_alloc
 - split two patches to better document the changes
 - add another blk-wbt cleanup patch
 - rewrite a commit log
 - another typo fix

Changes since v1:
 - use the local disk variable in wbt_init instead of q->disk
 - various spelling fixes

Diffstat:
 block/bfq-cgroup.c        |   18 +--
 block/bfq-iosched.c       |    6 -
 block/blk-cgroup-rwstat.c |    2 
 block/blk-cgroup.c        |  231 +++++++++++++++++++++-------------------------
 block/blk-cgroup.h        |   38 +++----
 block/blk-iocost.c        |   40 +++----
 block/blk-iolatency.c     |   41 +++-----
 block/blk-ioprio.c        |    6 -
 block/blk-mq-debugfs.c    |   10 -
 block/blk-rq-qos.c        |   67 +++++++++++++
 block/blk-rq-qos.h        |   66 -------------
 block/blk-settings.c      |    1 
 block/blk-stat.c          |    3 
 block/blk-sysfs.c         |    5 
 block/blk-throttle.c      |   31 +++---
 block/blk-wbt.c           |  116 ++++++++++++++++++-----
 block/blk-wbt.h           |   98 +------------------
 block/genhd.c             |   17 +--
 include/linux/blkdev.h    |   12 +-
 include/linux/sched.h     |    2 
 kernel/fork.c             |    2 
 mm/swapfile.c             |    2 
 22 files changed, 395 insertions(+), 419 deletions(-)
