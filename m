From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/10] blkcg: separate blkcg_conf_get_disk() out of blkg_conf_prep()
Date: Wed, 10 Jul 2019 13:51:21 -0700
Message-ID: <20190710205128.1316483-4-tj@kernel.org>
References: <20190710205128.1316483-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NSsXuJroaDqOlhMryi+iSYceW4KouvHH84idtExmGM0=;
        b=NuEfAEexdKe5z2kFDQNehIrB3aMB/hR+imA+acy7jtmdbjM2moXZf9UjPyRMqFUn7s
         PeGzkykFUiy3lBsdvRk03i9+xNY1FZYnYDeuNgzAKrK7T4dXIVOuZCtGobmHPS8S1Ge9
         +8zzZEyqPNhZw7ml2Q3Hce8U/K5GD0YpG1eHNZGgueLEDIscaK1MIsdGYPK4GlalISdb
         MU+p4BMnlTYl33MBfDtIFmE5kvqgZt69reT1+uqiOwpBDpKCnkP9dXCnBYcIrAqCglSN
         pINjO8k4G1kK9ovCBSXNPzb0+xAi9KSYMwvKPojE8DThJSFVAhUrLpt2tCchqcS9tiTX
         ZsQw==
In-Reply-To: <20190710205128.1316483-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

Separate out blkcg_conf_get_disk() so that it can be used by blkcg
policy interface file input parsers before the policy is actually
enabled.  This doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c         | 62 ++++++++++++++++++++++++++------------
 include/linux/blk-cgroup.h |  1 +
 2 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 818e50b4cc7a..aed46a2c553e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -753,6 +753,44 @@ static struct blkcg_gq *blkg_lookup_check(struct blkcg *blkcg,
 	return __blkg_lookup(blkcg, q, true /* update_hint */);
 }
 
+/**
+ * blkg_conf_prep - parse and prepare for per-blkg config update
+ * @inputp: input string pointer
+ *
+ * Parse the device node prefix part, MAJ:MIN, of per-blkg config update
+ * from @input and get and return the matching gendisk.  *@inputp is
+ * updated to point past the device node prefix.  Returns an ERR_PTR()
+ * value on error.
+ *
+ * Use this function iff blkg_conf_prep() can't be used for some reason.
+ */
+struct gendisk *blkcg_conf_get_disk(char **inputp)
+{
+	char *input = *inputp;
+	unsigned int major, minor;
+	struct gendisk *disk;
+	int key_len, part;
+
+	if (sscanf(input, "%u:%u%n", &major, &minor, &key_len) != 2)
+		return ERR_PTR(-EINVAL);
+
+	input += key_len;
+	if (!isspace(*input))
+		return ERR_PTR(-EINVAL);
+	input = skip_spaces(input);
+
+	disk = get_gendisk(MKDEV(major, minor), &part);
+	if (!disk)
+		return ERR_PTR(-ENODEV);
+	if (part) {
+		put_disk_and_module(disk);
+		return ERR_PTR(-ENODEV);
+	}
+
+	*inputp = input;
+	return disk;
+}
+
 /**
  * blkg_conf_prep - parse and prepare for per-blkg config update
  * @blkcg: target block cgroup
@@ -772,25 +810,11 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	struct gendisk *disk;
 	struct request_queue *q;
 	struct blkcg_gq *blkg;
-	unsigned int major, minor;
-	int key_len, part, ret;
-	char *body;
-
-	if (sscanf(input, "%u:%u%n", &major, &minor, &key_len) != 2)
-		return -EINVAL;
-
-	body = input + key_len;
-	if (!isspace(*body))
-		return -EINVAL;
-	body = skip_spaces(body);
+	int ret;
 
-	disk = get_gendisk(MKDEV(major, minor), &part);
-	if (!disk)
-		return -ENODEV;
-	if (part) {
-		ret = -ENODEV;
-		goto fail;
-	}
+	disk = blkcg_conf_get_disk(&input);
+	if (IS_ERR(disk))
+		return PTR_ERR(disk);
 
 	q = disk->queue;
 
@@ -856,7 +880,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 success:
 	ctx->disk = disk;
 	ctx->blkg = blkg;
-	ctx->body = body;
+	ctx->body = input;
 	return 0;
 
 fail_unlock:
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 930631cad5cf..b0eacec11037 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -233,6 +233,7 @@ struct blkg_conf_ctx {
 	char				*body;
 };
 
+struct gendisk *blkcg_conf_get_disk(char **inputp);
 int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		   char *input, struct blkg_conf_ctx *ctx);
 void blkg_conf_finish(struct blkg_conf_ctx *ctx);
-- 
2.17.1

