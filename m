From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 15/29] blk-cgroup: Fix memleak on error path
Date: Mon,  2 Nov 2020 20:19:14 -0500
Message-ID: <20201103011928.183145-15-sashal@kernel.org>
References: <20201103011928.183145-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366388;
        bh=qcbdQJkPEzwCb7hg1LS9ez+BtB+G8ki/aIpW5rjdbdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00Ve/23aWEkt7X7OY+pM86TCCWcnQWhMkUyVo2aGhtlLu3ywi0p5SjubHarGRSfyh
         KUWmDqmtGp8HlCp3IfGTplmMxXRP6+oDNLgk5k2qdrWxENS2H6RtfazhbTadmz3HSL
         tc+nQKrwbehJJFRfoWXUPYxEnLR2TaN/lIjy1/08=
In-Reply-To: <20201103011928.183145-1-sashal@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Gabriel Krisman Bertazi <krisman@collabora.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 52abfcbd57eefdd54737fc8c2dc79d8f46d4a3e5 ]

If new_blkg allocation raced with blk_policy change and
blkg_lookup_check fails, new_blkg is leaked.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 6e8f5e60b0982..67619f4e24907 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -682,6 +682,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		blkg = blkg_lookup_check(pos, pol, q);
 		if (IS_ERR(blkg)) {
 			ret = PTR_ERR(blkg);
+			blkg_free(new_blkg);
 			goto fail_unlock;
 		}
 
-- 
2.27.0

