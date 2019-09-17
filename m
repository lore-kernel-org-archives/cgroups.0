From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] blkcg: Export blkcg_conf_prep/finish() for bfq
Date: Tue, 17 Sep 2019 08:13:08 -0700
Message-ID: <20190917151308.GH3084169@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=2BszFrJE5DhvvCqO6dnoH5rt4IlU+zqhXXHVu1J4dUQ=;
        b=BdxsZV3xdouTBb85ev20LScZzJk9sHxCTS804kLTi4P+4cxV14+mdM/5k/CTfY7KYy
         QlIbcCNUMrm97b8uLRopqvPVyRIZWzE4h3GKMdK+b6Nxzijp/EzTlas3mw8Jc7C0q03Q
         z0GMOTss3RH52FWcirpt0t+ETLAx/ycrt2r6PRYvRj8iyP8tB0BjGNEuMdQ5TNGKvxz/
         HTJ5cTOptNPgmHGUkpqBjYcghQgHxfCvtUfOYAruMsjfvSNevICznZAXEw8Kv/MQLGxt
         z8h7yk2O4Y3phH9s8yE0gpXzECURVyKfHMKJyN+dW/wo7vWayo9UMyNkA6H/5LUhqKYc
         OKzQ==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Paolo Valente <paolo.valente@linaro.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

bfq module build is currently broken due to these two functions.  Fix
it by export them.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paolo Valente <paolo.valente@linaro.org>
---
 block/blk-cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -900,6 +900,7 @@ fail:
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(blkg_conf_prep);
 
 /**
  * blkg_conf_finish - finish up per-blkg config update
@@ -915,6 +916,7 @@ void blkg_conf_finish(struct blkg_conf_c
 	rcu_read_unlock();
 	put_disk_and_module(ctx->disk);
 }
+EXPORT_SYMBOL_GPL(blkg_conf_finish);
 
 static int blkcg_print_stat(struct seq_file *sf, void *v)
 {
