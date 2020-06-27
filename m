From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/14] cgroup: unexport cgroup_rstat_updated
Date: Sat, 27 Jun 2020 09:31:56 +0200
Message-ID: <20200627073159.2447325-12-hch@lst.de>
References: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=/aQSpo4n3xdtcdftvKvpaQvh2VA9RA7aMy8HIr4zPtc=; b=Ct6ICbrdi+RdZnvBXmsBtJLXgd
        JyygBSI7zac+fAOFdtzFfO5pB3w5jxxzoRyF3zvrexxkDBNYOfEBbAHTAaZaOcFQ4YsnFdnEW9lCA
        redVfqYvEHSd2b+evoixC9bsJJ3lipbPl9SX/+Usc95saeL0OIIc2NZGNhV52k3SVtDbtXSnWFZIE
        ZyiuwFNKcsJgY/seQavqFWtu9yydvuhdZcQRPYZtdGVCV5h/VUHHyenRHE2wo1+bS9V4pSQmmOUag
        dJx3sW2qxWhk1UdRNYfGgF8MHs+8WRmq9wnFoCbgKD9djg5otbgJvNW7VYmRzFgoPqFXSDe/ZNnnt
        v6cdokcA==;
In-Reply-To: <20200627073159.2447325-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

cgroup_rstat_updated is only used by core block code, no need to
export it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/cgroup/rstat.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index b6397a186ce9c8..d51175cedfca4f 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -64,7 +64,6 @@ void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 
 	raw_spin_unlock_irqrestore(cpu_lock, flags);
 }
-EXPORT_SYMBOL_GPL(cgroup_rstat_updated);
 
 /**
  * cgroup_rstat_cpu_pop_updated - iterate and dismantle rstat_cpu updated tree
-- 
2.26.2

