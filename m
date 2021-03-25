From: brookxu <brookxu.cn@gmail.com>
Subject: [PATCH v3 12/14] bfq: disable merging between different groups under better_fairness
Date: Thu, 25 Mar 2021 14:57:56 +0800
Message-ID: <d31d9a4bc5705adc0b6669b48470fcaabf55074a.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ZZvw7/YnAvbuz3MYm/09eOTBXS+Szbh8Xu21JXaDC18=;
        b=A5MwuGnBLXyxo1pNxzLhQUC1BCejhCEC8eQEep08Z+a+m2RfBsIU+6isYbN7js2fpI
         jjkbVmee3EPb+2fDE30FjVmQc7QtHnOLSzFfaObbLfd9T8zni8h2cDnaBBP38ue13hHk
         HR4cNYODcN4OIrVlkNLHh2J5QZjZ+C/qhcS8v5PdccuELOCUhqJ7jnFnKm5JmwL2FmPE
         J+bwS8yOkJv+vk8NCWANCP3/fDkf+GCEHbhYSxD9bsoc8Yk7QgaNZA5zVEsudsJVoxPJ
         4VjLXwuA7INBQdt0tA+RxEroUa9tPBGhx5rUhreTd5MHorZLxDHpWAAyX0W+aN473Zt3
         PM3g==
In-Reply-To: <cover.1616649216.git.brookxu@tencent.com>
In-Reply-To: <cover.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

In order to better guarantee the Qos for each group, we do not
allow queues of different groups to be merged.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 block/bfq-iosched.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 5aa9c2c..f4a99f9 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2665,6 +2665,9 @@ static bool bfq_may_be_close_cooperator(struct bfq_queue *bfqq,
 	if (!bfq_bfqq_sync(bfqq) || !bfq_bfqq_sync(new_bfqq))
 		return false;
 
+	if (!bfq_bfqq_may_inject(bfqq, new_bfqq))
+		return false;
+
 	return true;
 }
 
-- 
1.8.3.1

