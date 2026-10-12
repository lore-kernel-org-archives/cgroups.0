Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0038E47607A
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 09:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791798576; cv=none; b=eGeycTZEttSqQXv/nJeqlJqRNWjCwOQe2BW282YL3vRfsUDrg8xviPUKqACdQV9txKAYGvJg8VlRj0fKPPyYbKqnzOG1DDLmOPqXvBxFJ7/wjzxzHA9V4siwK1Jq+kblv0Nuz7TEmrzuGpbh+VYPeByrNDKdEVz+079RCCqBY4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791798576; c=relaxed/simple;
	bh=/o8DbhUa8w3SHvoeC4yYCFodh4VMe2LhHW/nE5IhWpo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KKtiD9U33hofMvLwuaEgwJvsuSgNPm9IChtx8T2cvnpHNC30XzkkiTnMGRfOoSkbAayaZvyUcbCLqlmeyKgmabL7iE3OmusbKa5dMHEhz7CSPirHsg6jX2T8aqp4YmeaQvIExQtYzAQVIpGEy7mytwysZH+ftOrYyb8uk3Ln93Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h3yHXy3W; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h3yHXy3W"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8897e83332fso1550914b3a.1
        for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 02:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791798573; x=1792403373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AcV0tDx3s3vnrx2NYfd9pGnewnwOmP1EvF1UHeoFl6M=;
        b=h3yHXy3WqBIsTWGFXaXvjLfPOLmgJc5jA6yC66ZStJEXLloEjh1TyG4VKjACsLKrlI
         UbHq7w/fbszNbGAYthU6AFm2Z/U3xRlz+2kla68tlgWeZj0IHCzVpgD8Zkdc3dJrIbPd
         7w3MdyTHBv+KFrxouDT+6+sKhdSRUjLbdi3YzcfzynIbn1MaZti9DAaYxnyreInqcwog
         2DL9S79jrkK3qm++n6pfGfFLRNf3nhpOnfmwNi6vzc4JVzaJRfq0EyHhTzWyTWbKHuKZ
         AEsHs+s3GN6sKcu+Zs4jzllRqof5rNSM/6s9yrtL9FsHhq+IFhgKHnabBYWBq5WMIsb+
         5yDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791798573; x=1792403373;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AcV0tDx3s3vnrx2NYfd9pGnewnwOmP1EvF1UHeoFl6M=;
        b=CaUCFeoUuK/jHwdfhmP/kV1KfHXZfWi6p7mSw67EBjyBcdAC9my2KCxDfukn6Vr6av
         rWcnP0daX8hJmIpoDkjKJZMyvWDTaaNicCWDtZIPGv/J4UPAcl5tb2jYKJUjsuo7KKfy
         ZUnyLdtzwQ2LMIX7/icBmtqluEICw68Q8/UhPiQgIYsY/zySRf66Kd8TpJeN9DS5WGFs
         8od00jbACcqRa4tSD5Qq6lfeeFCqSAPJiW4rqu4WUPNkJWmbIYZqZNkk26SyOOeXR4p0
         1o84thmvWnPFnymsIXor0tiTLFOkyudheRwn7Shyz3UjUk9cHz1SziS3LDiMOirPiNAy
         CdsA==
X-Gm-Message-State: AFq9FYLl0gQUvIBKMtnB/Plsv/UCbrplkwjTIgiyeE1jZ7Il8eLIVVV8
	aC+9jsaOAQNqx+ZGkdjgeGdHQqwU/+wvn7qFKDyVIiu8ajsqQ0vjfCCe
X-Gm-Gg: AYBFou0NZM5+WwaZnlYpJ5/T9XyG9lTzWOCSZk5XZtviXe/jRTtfyMW9Z/eJ0vKMF5W
	z/v+ypxmKWwGqDrFUiGCRn3n2Shr8UDNqE7RD/1TNU4P/+owUwZy+GJlVOAo7NamzbLdaWsLOS5
	vn00b9t/ZXSCle9J/+OZwS0zyKVYPQtC39DIhMFUAcGpsn6ZwObH20POzY7/ZmY68ESILrHZKBk
	jslLw75dCk0pW3mxWiyWbbDHVrfkrh6apTlOCmwJAAJIyMzUBcFZm3fPLePwgWEbkRaCQ/pssRe
	UzOp+BuwiUxi+h93pNzqVUW0I5aLBeopHYya40gzRrJn9ccnk/IhUA8nd49EJgZ/fmDmDnYg9hd
	kMN7NQJ2SGFF+YY3Uopfp4Zl4vdPfD3yjUTJ5v354ihnMrOoNpUIVrEkO9aQxvSPXNSjxgAqIuh
	EkbBXU6LIKOREqM46Svves95Hwj84CeG0Za0ZqqfWuQ0Z/dqp+nyCa3WwiUTo6zp5qEjJ2pazLV
	J7wWcN5uReRc1EUb/eZbLu6AgK+LzxxYP9/ZQWD
X-Received: by 2002:aa7:9308:0:b0:878:3705:571d with SMTP id d2e1a72fcca58-896a47e04b0mr5886470b3a.41.1791798573142;
        Mon, 12 Oct 2026 02:49:33 -0700 (PDT)
Received: from obadmin-Precision-3680.atlascopco.group ([136.226.232.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c4996be6sm3974435b3a.58.2026.10.12.02.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 02:49:32 -0700 (PDT)
From: Sahaj Chaudhari <sahaj123.sc@gmail.com>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] selftests/cgroup: test pids.events notification
Date: Mon, 12 Oct 2026 15:20:11 +0530
Message-ID: <20261012095011.3188830-1-sahaj123.sc@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Handle a failed read of the inotify event before comparing its signed ssize_t result with sizeof(struct inotify_event). This avoids treating -1 as a large unsigned length and inspecting the uninitialized event buffer.

Link: https://lore.kernel.org/r/20261007063516.1192279-1-sahaj123.sc@gmail.com
Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
---
 tools/testing/selftests/cgroup/test_pids_local_events.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_pids_local_events.c b/tools/testing/selftests/cgroup/test_pids_local_events.c
index fa501e209187..59885901fbf5 100644
--- a/tools/testing/selftests/cgroup/test_pids_local_events.c
+++ b/tools/testing/selftests/cgroup/test_pids_local_events.c
@@ -90,7 +90,11 @@ static int test_pids_events_notify(const char *root)
 		goto cleanup;
 	}
 	n = read(inotify_fd, event_buf.bytes, sizeof(event_buf.bytes));
-	if (n < sizeof(struct inotify_event) ||
+	if (n < 0) {
+		reason = "failed to read pids.events notification";
+		goto cleanup;
+	}
+	if ((size_t)n < sizeof(struct inotify_event) ||
 	    !(event_buf.align.mask & IN_MODIFY)) {
 		reason = "received no pids.events modify notification";
 		goto cleanup;
-- 
2.43.0

