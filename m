From: Hong Zhiguo <honkiko@gmail.com>
Subject: [PATCH v4 0/2] blk-throttle: simplify logic by token bucket algorithm
Date: Sun, 20 Oct 2013 20:11:10 +0800
Message-ID: <1382271072-15664-1-git-send-email-zhiguohong@tencent.com>
References: <20131018155532.GD2277@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nkKzdaroQ1dY+KXNrTMMgMq5uL6QKfXHKliO+rmBrI0=;
        b=BvJ+XaeIKPPjZuXAouGjS6di004ZWNNGqfwc2yoDLE7lFFprIJxUIQUhVXUJX/llT4
         beBnISUEVgIxRSsoXo+r8AhEI8ueG57ceYEdkeC5rN8M5xTdFMvIxECTRTrhfS+DRzXD
         V7uAGh9kLo5kkPRbKdLVHEM4DCAKyFFAaLfaP62JDCzbdBdgs5z7ptNQYvwn1dlK092G
         caOACpQ4bu5mfO3kgTeAi/DE5TFC5IACbkbYd8np9ExHARORve5ZwNHkBP/Dh18AAZNY
         hck5SQncmslQnqS8knNzOiUT1kmswN78ipGjJtBSxgFunjeukM5ixaZ91U9/xQb2cxY/
         dszw==
In-Reply-To: <20131018155532.GD2277@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, vgoyal@redhat.com
Cc: cgroups@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>

From: Hong Zhiguo <zhiguohong@tencent.com>

Based on the discussion with Vivek, Tejun and Jens.

Patch 1/2 implements basic token bucket rate limiting for blk-throttle.
Patch 2/2 adjusts some behavior for the cases pointed out by Vivek:
	- A huge bio may be allowed immediately after a long time of idle
	- When token is trimmed for above case, should not trim ancestors
	  when bio climbs up, instead, trim ancestors when bio is queued
	  on lowest child group.

Trimming of iops token is not necessary. Since a bio always costs _one_ 
iops token. Trimming it won't change the fact that current iops token is
zero or not.

I renamed "last_dispatch" back to "t_c"(Time Checkpoint, naming from network
code) because now it's not only updated when a bio is dispatched. See patch
2/2.

Thanks Vivek for the ancestor over-trim issue and the proposed solution.
I took another method inspired by Vivek's comments but different. Please
help to review it.

Hong Zhiguo (2):
  blk-throttle: simplify logic by token bucket algorithm
  blk-throttle: trim tokens generated for an idle tree

 block/blk-throttle.c | 321 ++++++++++++++-------------------------------------
 1 file changed, 87 insertions(+), 234 deletions(-)

-- 
1.8.1.2
