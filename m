From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 11/14] bfq: disable idle for prio_expire under better_fairness
Date: Thu, 25 Mar 2021 14:57:55 +0800
Message-ID: <39653b15a904b5658b6fa23ad1021427ab18c15a.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=IC6S0GoA+Bjxyq4aIxKh/SpT8Ze+znH1bLzroU/O1D0=;
        b=SPxdsKnog7hbJTjFckkX1eoumaCRAFblwQSCB9HJ7ZRF6kknKczdyVvqZix1IzZs79
         kvOuqXawdOV4IeoHb5+OD5Nv1gW9Vxs++KWuJSwwl8RNndWoBP5kImZyEWiLz5ioDJYP
         WxoJt99R1WFWMfrLD0+hbkUWp1OP1AzbV5GuD0+Gf9Fg477xEn/sdqFpwquvwoIQ1qKy
         Xdgh1aKMEwhRt0ceYGDhPbsTNSZ5PSBxrRzfB3oFtWp6veXSdL/PCX5BxXBM0hPJV+u8
         UDoyQk2T80gCWtfEVhMgRkst2E29x+RSisP7Zj7dYWNHTnKRWn6qTXflxR0MR2NswveL
         QpRw==
In-Reply-To: <cover.1616649216.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1616649216.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <cover.1616649216.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Under better_fairness, if higher priority queue is waiting
for service=EF=BC=8Cdisable queue idle, so that a schedule can be
invoked in time. In addition to CLASS_IDLE, other queues
allow idle, so that we can better control buffer IO too.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.or=
g>
---
 block/bfq-iosched.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index be5b1e3..5aa9c2c 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4307,6 +4307,14 @@ static bool bfq_better_to_idle(struct bfq_queue *bfq=
q)
 		return true;
=20
 	/*
+	 * In better_fairness mode, we also put emphasis on Qos. The main
+	 * purpose of allowing idle here is to ensure better isolation
+	 * of Buffer IO.
+	 */
+	if (unlikely(bfqd->better_fairness))
+		return !(bfqd->bfq_slice_idle =3D=3D 0 || bfq_class_idle(bfqq));
+
+	/*
 	 * Idling is performed only if slice_idle > 0. In addition, we
 	 * do not idle if
 	 * (a) bfqq is async
@@ -4318,6 +4326,9 @@ static bool bfq_better_to_idle(struct bfq_queue *bfqq)
 	   bfq_class_idle(bfqq))
 		return false;
=20
+	if (bfq_may_expire_in_serv_for_prio(&bfqq->entity))
+		return false;
+
 	idling_boosts_thr_with_no_issue =3D
 		idling_boosts_thr_without_issues(bfqd, bfqq);
=20
--=20
1.8.3.1

