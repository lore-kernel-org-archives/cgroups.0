From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH] lib: fix stall in __bitmap_parselist()
Date: Wed,  4 Apr 2018 19:26:47 +0300
Message-ID: <20180404162647.15763-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=CAVIUMNETWORKS.onmicrosoft.com; s=selector1-cavium-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=x5CcCeLjSdB1YBATN0aRMSuZZIzeXc3qvXxP3rYvv/M=;
 b=E/wVjiLUnck0DGi+CQIdeBXvcw1jRDo3QqJFlUC9lRbjQ07UqGcY1h5GY3yaoAVbF3pZxM3cB45miiAAc2ozKehpqS66Uh3pdaQrpnBNdW088Jn8WixretHJFXPjz8E/cjhEiOOSVwKcqFjTkIjjXehs6bkD8K1g1k+pt2QmLmo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Yury Norov <ynorov@caviumnetworks.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, syzkaller-bugs@googlegroups.com, Noam Camus <noamca@mellanox.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Matthew Wilcox <mawilcox@microsoft.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Andrew Morton <akpm@linux-foundation.org>

syzbot is catching stalls at __bitmap_parselist() [1]. The trigger is

  unsigned long v = 0;
  bitmap_parselist("7:,", &v, BITS_PER_LONG);

which results in hitting infinite loop at

    while (a <= b) {
	    off = min(b - a + 1, used_size);
	    bitmap_set(maskp, a, off);
	    a += group_size;
    }

due to used_size == group_size == 0.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+6887cbb011c8054e8a3d@syzkaller.appspotmail.com>
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 lib/bitmap.c      | 2 +-
 lib/test_bitmap.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 9e498c77ed0e..a42eff7e8c48 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -607,7 +607,7 @@ static int __bitmap_parselist(const char *buf, unsigned int buflen,
 		/* if no digit is after '-', it's wrong*/
 		if (at_start && in_range)
 			return -EINVAL;
-		if (!(a <= b) || !(used_size <= group_size))
+		if (!(a <= b) || group_size == 0 || !(used_size <= group_size))
 			return -EINVAL;
 		if (b >= nmaskbits)
 			return -ERANGE;
diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index 756f20ad03db..de16f7869fb1 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -255,6 +255,10 @@ static const struct test_bitmap_parselist parselist_tests[] __initconst = {
 	{-EINVAL, "-1",	NULL, 8, 0},
 	{-EINVAL, "-0",	NULL, 8, 0},
 	{-EINVAL, "10-1", NULL, 8, 0},
+	{-EINVAL, "0-31:", NULL, 8, 0},
+	{-EINVAL, "0-31:0", NULL, 8, 0},
+	{-EINVAL, "0-31:0/0", NULL, 8, 0},
+	{-EINVAL, "0-31:1/0", NULL, 8, 0},
 	{-EINVAL, "0-31:10/1", NULL, 8, 0},
 };
 
-- 
2.14.1

