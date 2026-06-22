Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489D135F610
	for <cgroups@vger.kernel.org>; Mon, 22 Jun 2026 22:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782168335; cv=none; b=usIXEcSIsvzjgXSA1+KojTPQbjOG6GMMetXpOPFFzjfu9yKFYnJ9afoP1uu7zw05iv9AjE9jcjYq5skhceIQNc7juUMhVOy0M5gqI0m+/HX1V7XhO7oA7nl1poimJrMKzs9/gQGxctHgSsrZrVtlEXqVM3zoaDFSEwORQayIWp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782168335; c=relaxed/simple;
	bh=KybmFAdq3wMMq5XOfujR/fRgfNZpeYyn9SB6JQeP5Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtO1+r9hJ76uBlG+9ZzbjRfbmewtz0nQtmUkNMGjlyhO435MtNcgHbJr+QTiUk9GiKHeT6rnonY0surfVCxJdQJSpwkw5og4gQwtgDD4exOBXsVu27MZ7jmToxvc7JtNtg5seh2VmaGHJBruSocXnaPm7aLOrU+jskUiw7CFg74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E7+EKazf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E7+EKazf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782168329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WSmknMmY/bbdNvPSFThynPQguPcD+DU8JAxknhNRsSg=;
	b=E7+EKazfxZunz1a7F6tWmg27/d+EWYBz8jMW0qbsnfxGEpc9nz5ZbOeAt0Cm6Skv5ibUp8
	AjK80T7iQDKTAJElzZr2e9Us+vlwx+s0zD71bm6iwLL6Ud8SuldNz3p2TnVChqbdrSABw8
	xBO64JL40s6TFO/LJFc3JXVrRMapZQY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596-ars0eyaeNFyo0muoYq-evA-1; Mon,
 22 Jun 2026 18:45:26 -0400
X-MC-Unique: ars0eyaeNFyo0muoYq-evA-1
X-Mimecast-MFC-AGG-ID: ars0eyaeNFyo0muoYq-evA_1782168324
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BC721800D9C;
	Mon, 22 Jun 2026 22:45:24 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.2.16.103])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 785CC30A8;
	Mon, 22 Jun 2026 22:45:21 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 2/2] cgroup/cpuset: Rebind/migrate mm only for threadgroup leader in cpuset_update_tasks_nodemask()
Date: Mon, 22 Jun 2026 18:45:09 -0400
Message-ID: <20260622224509.1927419-2-longman@redhat.com>
In-Reply-To: <20260622224509.1927419-1-longman@redhat.com>
References: <20260622224509.1927419-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

As reported by sashiko [1], cpuset_update_tasks_nodemask() will do
mpol_rebind_mm() and possibly cpuset_migrate_mm() for all threads of
a multithreaded process. Since commit 3df9ca0a2b8b ("cpuset: migrate
memory only for threadgroup leaders"), cpuset_attach() had been updated
to rebind and migrate memory only for threadgroup leaders to mark the
group leader as the owner of the mm_struct.

To be consistent and avoid unnecessary performance overhead for heavily
multithreaded processes, follow the cpuset_attach() example and perform
memory rebind and migration only for threadgroup leaders.

Also add a paragraph in cgroup-v2.rst under cpuset.mems that the
threadgroup leader is the memory owner of that threadgroup. Therefore
the non-leading threads shouldn't be in other cgroups whose "cpuset.mems"
doesn't fully overleap that of the group leader.

[1] https://sashiko.dev/#/patchset/20260621032816.1806773-1-longman%40redhat.com

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 7 +++++++
 kernel/cgroup/cpuset.c                  | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 993446ab66d0..341037c7ec9d 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2527,6 +2527,13 @@ Cpuset Interface Files
 	a need to change "cpuset.mems" with active tasks, it shouldn't
 	be done frequently.
 
+	For a multithreaded process, the threadgroup leader is
+	considered the owner of the group's memory. Memory policy
+	rebinding and migration will only happen with respect to the
+	threadgroup leader. To avoid unexpected result, non-leading
+	threads shouldn't be put into another cgroup whose "cpuset.mems"
+	doesn't full overleap that of the threadgroup leader.
+
   cpuset.mems.effective
 	A read-only multiple values file which exists on all
 	cpuset-enabled cgroups.
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index bc0207fd6e57..27bc7a466468 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2659,6 +2659,10 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
 
 		cpuset_change_task_nodemask(task, &newmems);
 
+		/* Rebind and migrate mm only for task group leader */
+		if (task != task->group_leader)
+			continue;
+
 		mm = get_task_mm(task);
 		if (!mm)
 			continue;
-- 
2.54.0

