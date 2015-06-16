From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] ext4: replace ext4_io_submit->io_op with ->io_wbc
Date: Tue, 16 Jun 2015 18:53:12 -0400
Message-ID: <1434495193-31182-2-git-send-email-tj@kernel.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UL7SnUZBwuUe/iv8iU0pkFQSLBIrwqExbsgwShLy3Ls=;
        b=X7UdBj93XoQWytqi2jIhxXFiu+iaLBgcEtlqVH+c9TAhMy9B/lwY7NoC1vhGBtViB+
         30vWW1lhf1O9NZPCdZxF5LAfPgpGZwMqEJ6FKz9pAfK95Ke7XoNEuc9OOcVCWcJDTBG6
         rm8YHfN7zz1C+eb9sh6AgGdxzj4f3dhKpCJ+o6MPll/ovWc2J2KM+eR7F3UOkiEH9Htc
         XDoAatzUQlGD3b3/cQ3ntuDBgIFKiUoTw1KnX/7GEjrk74J7Ws6l4wU7i6LIvvUHdPBu
         0DEDUpkhqh7FOGD3pmUD4hmc/Mpy1mBUzZkBp7IPOF3z5rtEUS5KBolp7dMGdhyWtZ/q
         0hwQ==
In-Reply-To: <1434495193-31182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org, kernel-team@fb.com, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, Tejun Heo <tj@kernel.org>

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
2.4.3
