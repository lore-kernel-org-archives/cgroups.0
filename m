From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v2 08/11] bfq: disallow idle if CLASS_RT waiting for service
Date: Fri, 12 Mar 2021 19:08:42 +0800
Message-ID: <157b97d7bda348b657b09e9c5a294305cfe29329.1615527324.git.brookxu@tencent.com>
References: <cover.1615517202.git.brookxu@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=FSKEpSWVHV20pfrPvKA6p9/HfL/MH8Y0LwmULwrkplM=;
        b=Q69wXyuREdBCG9JuoDz6E0QKQmNabsXXZeI4+0yjvDeqW2TyfrRepIb7+5SyGkOyag
         oCPUq6Ru1g6ZcxAfAr37vgU4MT1BVD5TUp6r3X+ztdKAPNiA9DMVDqcAMASIXwM/2OCp
         ICVOraK3udBH4Sa4UCaRDyujHXwQ643iSCSJwAeQeaWnpzQruEh/cYto65VfGdn7MIX+
         56tn4/STBGaSBEEpxoZfxbzSjfEyzlTT/ZHd0dy6J6up/pHrAPy4Ax9PvL8gVCnHw6uj
         DVT//4Apv0RyFN8M4orNaskY4xlmDo6WHq0GJSutyfxtdnk09owdMM/DMTVEUfVb3p5z
         hrug==
In-Reply-To: <cover.1615517202.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1615527324.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <cover.1615527324.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

if CLASS_RT is waiting for service=EF=BC=8Cqueues belong
to other class disallow idle, so that a schedule
can be invoked in time.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.or=
g>
---
 block/bfq-iosched.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index a5f13589df79..9330043cdd53 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4263,6 +4263,11 @@ static bool bfq_better_to_idle(struct bfq_queue *bfq=
q)
 	if (unlikely(bfqd->strict_guarantees))
 		return true;
=20
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	if (!bfq_class_rt(bfqq) && bfqd->busy_groups[0])
+		return false;
+#endif
+
 	/*
 	 * Idling is performed only if slice_idle > 0. In addition, we
 	 * do not idle if
--=20
2.30.0

