From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 3/4] blk-iocost: fix divide by 0 error in calc_lcoefs()
Date: Sat, 25 Feb 2023 22:44:15 -0500
Message-ID: <20230226034417.775491-3-sashal@kernel.org>
References: <20230226034417.775491-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677383062;
        bh=GxVYJUnmCRUAqOLvMaiUZ3VD+2YUyiq7J1N2SUZ9Mok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ulyCmlw5C/ym5ENxH+80O7hP4NZr7JPCaO7+n10I3s7u6i3f3CUpA82w45Q7sPjHz
         1Ez+KgD9gMLhuJ8QG9N452dJffeLFL0dW7njm/pfZWFKztZRQDUghJXlswSQTf9PJP
         9Qt5wKpFbnft7AHwTkyAybrktlerbtZEA4PpkQ2So3KbejkPL3TCETqDfIz4eLoEJC
         fC2UUAJAqpQQEceEzO0Al8Y/o4feN4YJa/dvzqyuVlLR1g0iebSv8ZGKVRyuzZI3pV
         JioCpetbfcorxSJblQPPZvN4gS/kQhw2vebY5SGTSl44VO7ehfEJNM7CMwYQvmptWP
         O6+OA9E1+F1Gw==
In-Reply-To: <20230226034417.775491-1-sashal@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Li Nan <linan122@huawei.com>, Yu Kuai <yukuai3@huawei.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, josef@toxicpanda.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org

From: Li Nan <linan122@huawei.com>

[ Upstream commit 984af1e66b4126cf145153661cc24c213e2ec231 ]

echo max of u64 to cost.model can cause divide by 0 error.

  # echo 8:0 rbps=18446744073709551615 > /sys/fs/cgroup/io.cost.model

  divide error: 0000 [#1] PREEMPT SMP
  RIP: 0010:calc_lcoefs+0x4c/0xc0
  Call Trace:
   <TASK>
   ioc_refresh_params+0x2b3/0x4f0
   ioc_cost_model_write+0x3cb/0x4c0
   ? _copy_from_iter+0x6d/0x6c0
   ? kernfs_fop_write_iter+0xfc/0x270
   cgroup_file_write+0xa0/0x200
   kernfs_fop_write_iter+0x17d/0x270
   vfs_write+0x414/0x620
   ksys_write+0x73/0x160
   __x64_sys_write+0x1e/0x30
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

calc_lcoefs() uses the input value of cost.model in DIV_ROUND_UP_ULL,
overflow would happen if bps plus IOC_PAGE_SIZE is greater than
ULLONG_MAX, it can cause divide by 0 error.

Fix the problem by setting basecost

Signed-off-by: Li Nan <linan122@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20230117070806.3857142-5-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index ef287c33d6d97..4fdc8858a69a9 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -785,9 +785,14 @@ static void calc_lcoefs(u64 bps, u64 seqiops, u64 randiops,
 
 	*page = *seqio = *randio = 0;
 
-	if (bps)
-		*page = DIV64_U64_ROUND_UP(VTIME_PER_SEC,
-					   DIV_ROUND_UP_ULL(bps, IOC_PAGE_SIZE));
+	if (bps) {
+		u64 bps_pages = DIV_ROUND_UP_ULL(bps, IOC_PAGE_SIZE);
+
+		if (bps_pages)
+			*page = DIV64_U64_ROUND_UP(VTIME_PER_SEC, bps_pages);
+		else
+			*page = 1;
+	}
 
 	if (seqiops) {
 		v = DIV64_U64_ROUND_UP(VTIME_PER_SEC, seqiops);
-- 
2.39.0

