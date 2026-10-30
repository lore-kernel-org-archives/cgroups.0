Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793387244;
	b=bXviJeL3q6KRnudfsoSqCgdOPhM0u5wPvoA6MkcO0DzEGWWqrBo1FDwqGPgOxpoe4ZtH
	 f3C+KaB71Hfte5LeWmuBzfcl3SQknToZlGhH8ljSBO8VK/+3hTqj89Ljcm8XgblVEj47m
	 Wx8qGlz1QzUacltQQBJNPa10HHycboY43pTlcJFf2iebO1SR+ylpvpnCXmPH66cdfhume
	 B4BBYOqg4cVcRGvM/nYLe72bq8DUAv1JLAb/T7fwC4nwwwLx87ZE0Qkc+0PkY0sJpZlg9
	 /udsfNFWeUzL/LgYlHEWtMcLDutlAe8OGodZNi69tJ0Mbrm6o0BHCoHkLx7Oj2K92Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793387244;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=BIWa6dw2X7C5nOWkBsFg63lzb7TY9QTwWIt+LekagAA=;
	b=VQJxzCGbKZDPniFDHqBad8mtaGNfzG6GEcMufMS2LlXqxpNwNC4HvU+8YVYPevLT2MK5
	 VpiQnZwiNHX299xruZ/burZ7fl1PTqd8YTrnu38wTmI/eI1qkGgAnDPiOJQMXGnWb9kDK
	 F0a9FdFG8b0EDhCrtfzLRc09eh33pwe2B+5CqjEbhuoior7lINGRjfuUTZdSLIyBiRa3V
	 12+6P9S8/gPFAxjU7fgvOMT+fgCOzcllH8VbB9lPUnWVYPS5hCRgN0lHNBUvqU2tBW9jo
	 WypoQ21ZgxykEfRclczcW+SA8A51og1NAmlyGxwBHuNb3DzwF5aZyZ0ZFh0zRhswgew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dPkEjEbb;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FD5606A33B
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 19:07:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1FD5606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dPkEjEbb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793387242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BIWa6dw2X7C5nOWkBsFg63lzb7TY9QTwWIt+LekagAA=;
	b=dPkEjEbbKwlqZm2hkjnixBqIRGOS4SWk63vPZmPjwlIeqW4ZCVDET9mRyxOmoACs/1Y8oH
	t5aP9mssqMBRjmcqoELy8K/PRwKRUsEB6N9svr/PFboIhieaC+QIVJbf+tpUgh4uq9Jlr3
	oK6zQWEQHN42cxTVHCqX5Q91KzA9FIM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-Ipy9X0yUMgKBdBJbJVbAsQ-1; Fri,
 30 Oct 2026 15:07:18 -0400
X-MC-Unique: Ipy9X0yUMgKBdBJbJVbAsQ-1
X-Mimecast-MFC-AGG-ID: Ipy9X0yUMgKBdBJbJVbAsQ_1793387237
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE34E180063B;
	Fri, 30 Oct 2026 19:07:16 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 241F61956088;
	Fri, 30 Oct 2026 19:07:14 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v2 2/3] cgroup/cpuset: Recompute effective cpumask in update_cpumasks_hier() after calling update_parent_effective_cpumask()
Date: Fri, 30 Oct 2026 15:07:00 -0400
Message-ID: <20261030190701.78308-3-longman@redhat.com>
In-Reply-To: <20261030190701.78308-1-longman@redhat.com>
References: <20261030190701.78308-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

It is reported by sashiko that calling update_parent_effective_cpumask()
may clobber tmp->new_cpus when update_sibling_cpumasks() needs to be
called due to possible change in the parent's effective_cpus value.
Therefore the new effective cpumask has to be recomputed after calling
update_parent_effective_cpumask() to get a correct value back into
tmp->new_cpus.

Fixes: f0af1bfc27b5 ("cgroup/cpuset: Relax constraints to partition & cpus changes")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 39c81a0a8ab9..ed014ecb770c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2359,12 +2359,12 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 			update_parent_effective_cpumask(cp, partcmd_update, NULL, tmp);
 			/*
 			 * Capture current partition_root_state as it may have
-			 * changed. Recompute effective cpumask if changed.
+			 * changed. Always recompute effective cpumask as tmp->new_cpus
+			 * may be clobbered when update_sibling_cpumasks() is called
+			 * within update_parent_effective_cpumask().
 			 */
 			new_prs = cp->partition_root_state;
-			if (new_prs != old_prs) {
-				compute_effective_cpumask(tmp->new_cpus, cp, parent);
-			}
+			compute_effective_cpumask(tmp->new_cpus, cp, parent);
 		}
 
 		spin_lock_irq(&callback_lock);
-- 
2.56.0

