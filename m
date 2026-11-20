Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795189192;
	b=c8bntt8cbjqDsBOtu5q1Cq0lcJstTET5DpTfd93oEQdy6ycYHY79ZttvsvnlI6/urmor
	 nuLymqJ47ke1mq5zojhERnl3BWqkns/u5+xP4rvzvchcYENCW88vrHubsdSH4q1l2CzMu
	 bVSfXh8Y4z9YN287O7xCd+r++Oqb2cgb8VTxdVw3K0l0JYPwWEgH+7Vj5R20AnbO6yTRh
	 LXnVeBTHkpmKrBV5aka7ktS+pTHjuMU+HK7hemXvRdD9MDfO4tbd5VswSsIcsqBH0gP2H
	 F6X3NBrdlRhKOKvYgA2Mq5dRmZj6p/zCuivzgZEO8/UEecFPWLBh0RPGGhAtxIrsZmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795189192;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jn+/Prnek8JqUOnxYbtVgNU+Atd7uT15342oBo1hEcs=;
	b=vpHuTJ12UPHol1FFpXPD/h8KaGl96koLwbRfEh50DG1aY+G9vBYA4xIGDYDczMdBvbCz
	 SJlJyawFBZ064kolOUHnb01RqotBRRZAfeT0yEtFHm0VQestf58sdYmyBBpnaFir0obCN
	 fctwQpLjM+B/1CwnpSyQIWd1lvB8aWGc86fUuAYSZWgyAGWMBVMusKanrNmQbRAdsz07O
	 IggFtODFaPhkczeCXieIQ7+VM1qbsOfANUH59giCsjn2ukqb2y7DhkjFLEg32fs7159AK
	 RdLhq9xrIE0vg2Ll0S87HWM3C8MA1r2UijAf7qkU37f58C8+nl0tHTa+zRjA73x+0cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MoHDevHy;
	arc=none smtp.remote-ip=74.125.231.138
Received: from mail-oo2-f10.google.com (mail-oo2-f10.google.com [74.125.231.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B56606A334
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 15:39:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1B56606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MoHDevHy
Received: by mail-oo2-f10.google.com with SMTP id 006d021491bc7-716d85c01f6so339023eaf.0
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 07:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795189191; x=1795793991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jn+/Prnek8JqUOnxYbtVgNU+Atd7uT15342oBo1hEcs=;
        b=MoHDevHykIXNy24eaf7OpJHNAun9HRFoRVQQqU+FyXQK0e8C6a69dPG3KhUlzpjg+j
         DKFY4DtZZnFwqy+Vigs9qYwa7XmkdnKk0v1bBdJS5vdFeQyHc+HXJf2f6Yau2UMvpQM2
         uMTqPukQU08MkSzfLi5s1plzVLXka8e3k99dTQHanEqopJuxlWAELJJg50jaC/lBSKQ9
         8MFWJ5lCn7nAJg6OeXUlkjwpj+OAM/b6EsXalG/ToY/8p4wy8Gk1Yb/fWYfARs+w8KLl
         /mJ3tReQ5gJ02LOZBvAjnZSkiwJJaFlOUseqrtAY2GYkXPaNF2lyz5ybvAP6wwMB2WUa
         XTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795189191; x=1795793991;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jn+/Prnek8JqUOnxYbtVgNU+Atd7uT15342oBo1hEcs=;
        b=p5DEqbMF0AOJpgpqtH06+ohJfUjwl7NldZS24uT3eERU/y7xa/1TuICk/hhwlL/hNq
         gSXkQ59XXuNPm6ojXb4Tu0wAV3LbyYCvDzylQ5Q36IaIZrmx0aZvLj/7senNwwHaN6xc
         Pug3AFlkjTPSsR20b2vwuuEolsrwDTdXmggexBQGyZXnpECmWGCedCE8IOIn6uLQTXs5
         BYxXC6kYPEaX5WXZIc//wk7aR/cgTWHTc9BZBuKB94oEbELWGBKdAhabCv8xsv/afNQk
         jQWNtCWpWcX6+NJ5DcZepaT8GRKm4qN1EK7bZLH9/+BAZFz7/dxHGg/ajc2en3NPWEYY
         Fo5Q==
X-Forwarded-Encrypted: i=1; AL+hErGQivrlYkQMqyTrOVay3ZcNwZLde7yKlyAYkEASkI8y7WlROMT5ffI/fBRuqXCrznnC3PLLp9M8@vger.kernel.org
X-Gm-Message-State: APuU4Z+Kqmr4PR+zTcSQroBcHcQk0BNrACpYSDV9s3FC8LmAvoVIOiWn
	RBS0HZkpturhAcneD+Rlk6A87m6WvrkzbrAde9cL7jvtSMGObudVycfj
X-Gm-Gg: AYBFou3jx6D9k2Tx2M5hQHS+AGcMWTPw7bKAw6QZvpQrN3BFR53qTvikMb6DjYKLc1N
	7vnmBH52oYl113RUtqYQ2l2u/icOYC7/v/AbBgmcExYkpfMM1MWC9UTP4xm0T1Z0FBelSQP9bby
	HIXDAzLqF0m958kn3KJ2h5mz7grK9Vcs7itmC4ihMTnejtqW4IzLkvpPB4VWU+GdqWhzACNKIa2
	f09hQGe+VyIbNdSx16PdoAXSMNMOJ/cjpvraAARkldO6gDReJUucJvZT8EupvhTOenYg8DUjUT/
	4YE6Nnaqfi5BKWRn58QL/Xh2wALNLnxOoXa2K7F1HoS4GUtkafXt0bC/+i+lO49U+qiMic9B/UP
	bgTTVzZJLJBMb5qKXNkNCgZWUMocVlKpAJLof72LvaMjFtM2jNW6HawNILJ7GTFSNlEstq3PeuZ
	eI96KdDyxktNn2uEuSjwyjjjq2/vODs283ZfRudVMIKCG/SRj15xnHj71q95rE/b2zE6iSm/S52
	UDDnQXcC0o+UybmL6eR70IKyZacldvkJrP7kugnCXUWeq2+GYkcP6U0E/h2ByKbpend63v2YS3P
	h4BQcTngWoVB271UiPODo4zZQC7a7MlviamtinDEFLja10XzuwDlaKNkQIbmsGlfbtCN1FLQlPn
	pzHOZjM5/yX0SwCw/GeGMCpdnofeO7l7zLXcLwA==
X-Received: by 2002:a05:6820:c5d1:20b0:71b:c46:3ac9 with SMTP id 006d021491bc7-71b39401a4emr1770546eaf.25.1795189189676;
        Fri, 20 Nov 2026 07:39:49 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-71b38058102sm1950557eaf.6.2026.11.20.07.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:39:49 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: axboe@kernel.dk
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	josef@toxicpanda.com,
	bvanassche@acm.org,
	cuitao@kylinos.cn,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH v3] blk-ioprio: check capabilities before promoting a cgroup to RT
Date: Fri, 20 Nov 2026 15:39:39 +0000
Message-ID: <20261120153939.81178-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ioprio_set() and the per-request I/O priority of aio and io_uring only
hand out IOPRIO_CLASS_RT to tasks that have CAP_SYS_ADMIN or
CAP_SYS_NICE. The io.prio.class cgroup attribute has no such check.
Writing "promote-to-rt", or its alias "none-to-rt", to it changes the
requests of the cgroup to the RT class.

The attribute exists in every cgroup that has the io controller enabled
and it is not hierarchical. A user that got a cgroup delegated owns the
files of the child cgroups it creates there, so it can create a child
cgroup, move into it and write "promote-to-rt" to its io.prio.class.
Its requests are then issued with IOPRIO_CLASS_RT although ioprio_set()
fails with -EPERM for the same task, and mq-deadline dispatches them
before the best-effort requests of everybody else.

The delegation model in Documentation/admin-guide/cgroup-v2.rst expects
the settings of all resource controllers to be hierarchical, so that a
delegatee can only distribute further what it received from its parent.
This attribute lets it raise the priority class of its own requests
instead.

Require CAP_SYS_ADMIN or CAP_SYS_NICE for the two policies that raise
the priority class, like ioprio_check_cap() does. Check the credentials
of the task that opened the file, like cgroup_release_agent_write()
does, so that the check cannot be bypassed by passing the file
descriptor to a privileged program. The other policies are left alone.

Fixes: 556910e39249 ("block: Introduce the ioprio rq-qos policy")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
Changes in v3:
- Include <linux/user_namespace.h> instead of <linux/cred.h> for
  init_user_ns (Bart).
- Add the Reviewed-by tag from Bart.

Changes in v2:
- Check the credentials of the task that opened the file with
  file_ns_capable() instead of the credentials of the writer (Bart).
- Document the requirement in cgroup-v2.rst (Bart).

v2: https://lore.kernel.org/all/20261117111157.2968-1-dennylin0707@gmail.com/
v1: https://lore.kernel.org/all/20261116090529.69650-1-dennylin0707@gmail.com/

 Documentation/admin-guide/cgroup-v2.rst | 3 +++
 block/blk-ioprio.c                      | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..4424f9cf583e 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2409,6 +2409,9 @@ that attribute:
   none-to-rt
 	Deprecated. Just an alias for promote-to-rt.
 
+Selecting promote-to-rt or none-to-rt requires CAP_SYS_ADMIN or CAP_SYS_NICE
+in the initial user namespace.
+
 The following numerical values are associated with the I/O priority policies:
 
 +----------------+---+
diff --git a/block/blk-ioprio.c b/block/blk-ioprio.c
index 8fa8bca35062..7fabac24dbfa 100644
--- a/block/blk-ioprio.c
+++ b/block/blk-ioprio.c
@@ -14,8 +14,10 @@
 
 #include <linux/blk-mq.h>
 #include <linux/blk_types.h>
+#include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/user_namespace.h>
 #include "blk-cgroup.h"
 #include "blk-ioprio.h"
 #include "blk-rq-qos.h"
@@ -91,6 +93,10 @@ static ssize_t ioprio_set_prio_policy(struct kernfs_open_file *of, char *buf,
 	ret = sysfs_match_string(policy_name, buf);
 	if (ret < 0)
 		return ret;
+	if ((ret == POLICY_PROMOTE_TO_RT || ret == POLICY_NONE_TO_RT) &&
+	    !file_ns_capable(of->file, &init_user_ns, CAP_SYS_ADMIN) &&
+	    !file_ns_capable(of->file, &init_user_ns, CAP_SYS_NICE))
+		return -EPERM;
 	blkcg->prio_policy = ret;
 	return nbytes;
 }
-- 
2.43.0

