From: xuejiufei <xuejiufei@gmail.com>
Subject: [RFC] distinguish foreground and background IOs in block throttle
Date: Mon, 25 Dec 2017 10:44:26 +0800
Message-ID: <1fa623a6-e374-de5e-477e-e604cb760f82@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=eYjv8GupDpVr6qWZCT2Ge+p9Va+A0rcFLwudGvyfBN0=;
        b=WJg6BQ37MSK2xrrbhfxKANpvLi7za5rKdorZQlEofmp0R2StgYbnNOtsmmeszwNLjd
         yZS/RYvA4S2namhvD//Wn8xLnzGvA3CR3bBVz5gLKgce9c2fA97P6NoDpwxh7g7rKlzw
         8ybgGfBGOQ9HVdT5os4pPnEjwS/2qJbLuNI5Z+z9GoN2jcm2jet8JsIYwns6GmpcRkho
         /1AUA/2XoABo25eZ7R8n+lNaX5qNXDWGERnep0NGih5WJmm/a+aaZgljSxbtzqnzNABL
         2PBI4PV8Zybqt9ghrn9lvIsj3/YWkM2GS3e0c1sR6yaCSACir4xy1PItGiRlTJbfJIZp
         fS6Q==
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@fb.com>, Shaohua Li <shli@kernel.org>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

Hi all,

Cgroup writeback is supported since v4.2. I found there exists a
problem in the following case.

A cgroup may send both buffer and direct/sync IOs. The foreground
thread will be stalled when periodic writeback IOs is flushed because
the service queue already has a plenty of writeback IOs, then
foreground IOs should be enqueued with its FIFO policy.

I wonder if we can distinguish foreground and background IOs in block
throttle to fix the above problem.

Any suggestion are always appreciated.


Thanks,
Jiufei
