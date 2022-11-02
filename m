From: Yuwei Guan <ssawgyw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] Some cleanup patches for block bfq
Date: Wed,  2 Nov 2022 19:43:49 +0800
Message-ID: <20221102114354.162-1-Yuwei.Guan@zeekrlife.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VSLHjqdkw/lLw+IqVBVeV4frjHysXQc6H/q1PnMBziA=;
        b=V8OgDZyvdcJnZupe2Ih2PUPQBXDrkTugSKD0mh8FYzx31VWzihmqZIx3wPnc4CtVya
         YUsipfsbEY7IFhg/BU25qKcIz/sHBf2srmJsPqI6kIGQbGdoqEQgI6d14Y93RX5okhmT
         Hw0MmHKjSyAx1BeDv72ENX/BL7kZ1wypFPpMjA1L7/lEG9bUIJ57KUICOwOX1RRGg7Nz
         st/LMiypd1okKkKVzvSSlt6yeSkq+xY/YuWhIs0jSK8eDBV6D8L8WSV8vE1QGHPoUVGa
         kcsLiYLmLbgWjZAQd2V+Sl7m6olQhCWEkgwEokDxMtYzWUrddHtkzmDXm5dSfVLD/HK2
         bnxA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yuwei.Guan-tZnZJQTKG+hl57MIdRCFDg@public.gmane.org

Hi,

This series contains some cleanup patches for block bfq.

Yuwei Guan (5):
  block, bfq: remove unnecessary meta_pending count
  block, bfq: remove unused bfq_log_bfqg
  block, bfq: remove redundant max_t() in bfq_bfqq_charge_time()
  block, bfq: change type for "prio_changed"
  block, bfq: change type for "bfq_large_burst_thresh"

 block/bfq-cgroup.c  |  2 +-
 block/bfq-iosched.c | 27 ++++++++++-----------------
 block/bfq-iosched.h | 12 ++----------
 block/bfq-wf2q.c    |  5 ++---
 4 files changed, 15 insertions(+), 31 deletions(-)

-- 
2.34.1

