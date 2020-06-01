From: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
Subject: [PATCH] blk-cgroup: don't account iostat for root cgroup
Date: Mon,  1 Jun 2020 16:11:41 -0700
Message-ID: <20200601231141.2218370-1-boris@bur.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=EJxQtXEmzgFV7qYlHbiD6rvXvA
        D6+GpjivfAKXYShn8=; b=pp/8RPm1nMDp8zDWGn+jMh9zTt5XUJaZJT5CvG0dcX
        JRhtGOWyadjxXEh4fVuAcsq7QZZ+zbesJ2IUYWrXUcVzXmFHd1i3e+L2DhzM/yx5
        IQ2i1htYsKcVQtZi6UFEJqUmkGpN21btMEvllx5NFZaCwLJVDDvSZoX5shfxHGzy
        q9ZSZ6izbtxumf20J6CWzmEWtB/tk53hIAI+g91CvsyVaasvZ7hqTnMr//FEUT1c
        LrpDWDXjwIwtI/FfH9dtaqpXvLvGGZwkoDzJM5y4fq9KGJK6I4BUrr/hQmYTq9FN
        6V9Tya8NxGIILvr9/dwWfuDtlrEQTQtAHfWXb6VmZOmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EJxQtXEmzgFV7qYlH
        biD6rvXvAD6+GpjivfAKXYShn8=; b=A+2N0452c36DE0qjKhBkM9RicotCU+OXG
        ZRRHrE+KyZdHSShWo/lWsb0ey7SWaUKHObn2xZiTSll0E38D+FBamXZ+hV6MLXFn
        1qSTbnPBQJabyiC4iqyPb2BlwizRAIorwWZRQx8oLPD+5IhsVuugofC2/Vw3mhpv
        /7zfOGE2VnvdDAg1QV5TQZv2q4tDFmhkHcrHtrmvZ5v/ZqV/8HEUmOGt+KLL0+KX
        gp0WA+ZRhGh0m4opyE5Cc0lmBJNpwKBHCQrC6wIAXyzgSjN6Esp+CH53yWrtxn9U
        dDSOtDwnI56QVbuUYiSGPP+Yom5QkttwYg08dBWl5odn/JpcWwOGw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>

This data is never flushed by rstat, so it is never used. We shouldn't
bother collecting it. We can access global disk stats to compute io
statistics for the root cgroup.

Signed-off-by: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
---
 include/linux/blk-cgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index a57ebe2f00ab..e9de4ec07182 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -591,7 +591,7 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 
 	throtl = blk_throtl_bio(q, blkg, bio);
 
-	if (!throtl) {
+	if (blkg->parent && !throtl) {
 		struct blkg_iostat_set *bis;
 		int rwd, cpu;
 
-- 
2.24.1

