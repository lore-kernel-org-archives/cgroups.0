From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] PM/hibernate: remove the bogus call to get_gendisk in software_resume
Date: Fri, 25 Sep 2020 18:14:47 +0200
Message-ID: <20200925161447.1486883-3-hch@lst.de>
References: <20200925161447.1486883-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ksfrL9PUo8uW/j8LPVqdwsfYx8+SSBCrVtr6+p+r9KQ=; b=SgK+9JZNLAPx2gh+FchgvYcJnh
        5IFktPQWzPjSWeFrOn/PKUGdFpr1nEa3x7/cq6qHgX6YizKcwjEt2FxQo2xy966enzwuDjL0gfiNL
        g31+MOemaBM8uhwxFYO1hAA2P6/EvigC5CFwSSKU/xnBmUx29dCvMHYQh2mfyXGVGfOeEEfrlxdu7
        yFuxnjgAISiwg0tciqg5YMvN9cBmTA6DDH/HKKhobkoD/DsxJl4fxMRDrf/gQdvieHeU8m1jbb0J6
        Vin3XmdmQz6FAcFaHeEQHgTWSV2zJLAS3ZWaSeXrFxogLp4RZrkDRGmwX38nNOWe7od3F1Lsx5Eor
        8aJUTC9g==;
In-Reply-To: <20200925161447.1486883-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Minho Ban <mhban@samsung.com>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org

get_gendisk grabs a reference on the disk and file operation, so this
code will leak both of them while having absolutely no use for the
gendisk itself.

This effectively reverts commit 2df83fa4bce421f
("PM / Hibernate: Use get_gendisk to verify partition if resume_file is integer format")

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/power/hibernate.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index e7aa57fb2fdc33..7d0b99d2e69631 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -948,17 +948,6 @@ static int software_resume(void)
 
 	/* Check if the device is there */
 	swsusp_resume_device = name_to_dev_t(resume_file);
-
-	/*
-	 * name_to_dev_t is ineffective to verify parition if resume_file is in
-	 * integer format. (e.g. major:minor)
-	 */
-	if (isdigit(resume_file[0]) && resume_wait) {
-		int partno;
-		while (!get_gendisk(swsusp_resume_device, &partno))
-			msleep(10);
-	}
-
 	if (!swsusp_resume_device) {
 		/*
 		 * Some device discovery might still be in progress; we need
-- 
2.28.0

