From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v2 09/11] bfq: disallow merge CLASS_RT with other class
Date: Fri, 12 Mar 2021 19:08:43 +0800
Message-ID: <9b3b89cf193896f459b5c59f58b65783df0f490c.1615527324.git.brookxu@tencent.com>
References: <cover.1615517202.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=SiVV6EtJZFIFkG/CEJdYUnLYJ8IcYQwEYTMUZJ4BL9Q=;
        b=YC4HWpCJruAgTzfDhVZNQ6U66EvejBlEQQyydGG0jwfqwp9h3Dr3L7Y3WwGt+Hex6X
         1Xcts7hqe3FXHQ5RbBV8FvZRFmKl+KXUbSGbNxR8oXPH/I4mU8cymvoEujoTS12WgP88
         uCNoDsD3/sCxjRs62AaH/We1Ys/QfFTEWsYgxmzEW3w6M8mS9HRiy4lCLZMH3Jch0/27
         1XLqZyIDbyok6EfcrmOhMjs8IkA9a51KFbeksGzEi+8TtCNyVeWMkJ4a0fVBzsZ6EIrC
         gs7q7HeVTxkD/6x3/YUNQg1mIkOxjx8rqVDk6IY5ry+ruSeK5RW/HS/SSlQ4YZTawn/Z
         3OYA==
In-Reply-To: <cover.1615517202.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1615527324.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <cover.1615527324.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

In EMQ, perhaps we should not merge the CLASS_RT queue
with other class queues. Otherwise, the delay of
CLASS_RT IO will increase.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 block/bfq-iosched.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 9330043cdd53..bb6cc8c9ddf5 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2623,6 +2623,9 @@ static bool bfq_may_be_close_cooperator(struct bfq_queue *bfqq,
 	if (!bfq_bfqq_sync(bfqq) || !bfq_bfqq_sync(new_bfqq))
 		return false;
 
+	if (bfq_class_rt(bfqq) && !bfq_class_rt(new_bfqq))
+		return false;
+
 	return true;
 }
 
-- 
2.30.0

