From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] ext4: replace ext4_io_submit->io_op with ->io_wbc
Date: Fri, 12 Jun 2015 17:02:22 -0500
Message-ID: <1434146543-26358-2-git-send-email-tj@kernel.org>
References: <1434146543-26358-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GKTNB6N3AkC35pgCR7F54HdLVaqh6vKhQXTjdeIwujk=;
        b=RIz1gt4cgoQc+cd+CDx3hMc+0QjgchrM7mlgLsKGmE8kmdGkLGX4ptZZW8K61GOqcW
         21AGEfpEeqN/vctNgCEqcpSLiUvbQtXsVVX/4eif191LwFAN5VpdE+kPEPt21WIp0T4x
         PJtpQzaBx+IMSVRmzmBNUm98jycLul8o3gc8S4Imsx3AZDMyAUk3NKYd3W96vOTPJg7H
         I6zd7Xo1108ogirRoM9Ik1C656hf3+MpKD5PxT5XXzwYs/0FZ9URiaaIJBQxq77fu/fO
         LPhb7puKCFivHvMoxg4j/usZKyptsGwzAF8qirWp7WrRS/qafqI5ealCO7JM9aa7L7w5
         Cllg==
In-Reply-To: <1434146543-26358-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, Tejun Heo <tj@kernel.org>

ext4_io_submit_init() takes the pointer to writeback_control to test
its sync_mode and determine between WRITE and WRITE_SYNC and records
the result in ->io_op.  This patch makes it record the pointer
directly and moves the test to ext4_io_submit().

This doesn't cause any noticeable differences now but having
writeback_control available throughout IO submission path will be
depended upon by the planned cgroup writeback support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/ext4.h    | 2 +-
 fs/ext4/page-io.c | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 009a059..74a4923 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -191,7 +191,7 @@ typedef struct ext4_io_end {
 } ext4_io_end_t;
 
 struct ext4_io_submit {
-	int			io_op;
+	struct writeback_control *io_wbc;
 	struct bio		*io_bio;
 	ext4_io_end_t		*io_end;
 	sector_t		io_next_block;
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index c5d81e8..3f80cb2 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -357,8 +357,10 @@ void ext4_io_submit(struct ext4_io_submit *io)
 	struct bio *bio = io->io_bio;
 
 	if (bio) {
+		int io_op = io->io_wbc->sync_mode == WB_SYNC_ALL ?
+			    WRITE_SYNC : WRITE;
 		bio_get(io->io_bio);
-		submit_bio(io->io_op, io->io_bio);
+		submit_bio(io_op, io->io_bio);
 		bio_put(io->io_bio);
 	}
 	io->io_bio = NULL;
@@ -367,7 +369,7 @@ void ext4_io_submit(struct ext4_io_submit *io)
 void ext4_io_submit_init(struct ext4_io_submit *io,
 			 struct writeback_control *wbc)
 {
-	io->io_op = (wbc->sync_mode == WB_SYNC_ALL ?  WRITE_SYNC : WRITE);
+	io->io_wbc = wbc;
 	io->io_bio = NULL;
 	io->io_end = NULL;
 }
-- 
2.4.2
