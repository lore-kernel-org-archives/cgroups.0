Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311219;
	b=fTeov6Ho/Zuk9otGuyULNy8ZSzVkAkfhwZPjm55oghm0FCZeq8RMRVQbucW1NhfJCZIG
	 vsMALre2fYY0hgspc0Jt6GtyPDz6TIk1YMqjZ7TfzmJJaORDfWqnOQBo+9T8oZBXBu0+f
	 cugLpyfvX9Uhue1aA5De4WNY5wHpC/TYqWGZl9qRsKORn+y4VCRQ+mio22AQoH0MMbdhT
	 PS7Z9Y+GN3SgNS5kNRLuTt097jsLx6syDwPXHhUBHzMbhUBz8zobfi0YOVd3VqPhhgfjB
	 eeY9ynpbqNlrcQh5BMw2Vco5sIvettAwXBpuEsAusdmJMENxCxN069vtPAjsQQTsA+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311219;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=gRVW2SlXZrQJCF/A0kq7pS5b8flQ/Sh7jAI5q7A4ms4=;
	b=UJtyxmfa3VhJqNknIziVVZHFAPt0I5wMMJ734WOgD+nLNCdXrbdvpJJhjiNN8j2hLBBF
	 Mp59eNggDTN6dgDjJguP9/VK3skLPbcTcCsF3erRemJIUGsm6Fux6XKB457xuug8iOpeC
	 INuVMPjg9Nw18F4ecIiJcjB7Z5KKXV1JyV+kX9LnE8E8+06oGeFTSZa3XFRmjySbjuq2w
	 o4bWm7tcAWRTR5WXwrs1WoK2qZ9o8UHom0HstNKy4XpC8Cyz/GJUan745jBT2I9dF26hM
	 sCS28hsuQfV8ezto8NdLOw0ZW24H0Ow3DbTmYU/h3nW3yX/yQyd/fxZ5wcv3GgJKNvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=EqAZ6bR2;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E9E60A381C;
	Tue, 10 Nov 2026 11:46:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47E9E60A381C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=EqAZ6bR2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=gRVW2SlXZrQJCF/A0kq7pS5b8flQ/Sh7jAI5q7A4ms4=; b=EqAZ6bR2kjWZmkur3br2mPpRhS
	2JP2wKrtXb402ZPLJlwHk3CCE3gzUDouicoZk9sekNwOabrgL1jw4R75fMkmGeLPKB2atHPN9y4Y+
	v4DhAzYggMrnFKCFfStatDp5v2wqf9e7bcaCVQIy9VS3c6S4VUy3CfGqCn7FqWLpYgPrtOfV2WmuJ
	Sv/NfeQzZq5o9oo+ooVIXDs2TyzucOQypasuYjEc51IBubfNI25MF3qluglyLu8yLlA25N/doqRWt
	1b/SyI0r57W9EzzzRzY3lJ72vSvubdpY2P6vAsNbn0KY7eVqgqR+QHxOFsPFaqIWns9NRc6mE87AH
	cZSchDGg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xQkJS-00CNTa-2O;
	Tue, 10 Nov 2026 11:46:55 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 10 Nov 2026 03:39:29 -0800
Subject: [PATCH v2 3/4] writeback: log the end of a slow writeback wait
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-writeback_stall_report-v2-3-9e0ed75074ca@debian.org>
References: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
In-Reply-To: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Julian Sun <sunjunchao@bytedance.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, cgroups@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2451; i=leitao@debian.org;
 h=from:subject:message-id; bh=u2qEqJa97IMYQjXULEzv1cq2WuUThXMDMARYrLe/reE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq8wQYnbNvAsZXal8d97AAOhUXQdWcdYAtPVoqf
 ThjeRURiG+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCavMEGAAKCRA1o5Of/Hh3
 bWa8D/0Q8o7HtSBw541Vvwgp2xYsXuYm7Xe9cEoo452XKnUFKjgfFRwYCTsua/Gq/sgxlgGF+Cq
 QOfmimWUKd1DYxOycjuKFQQ6HC61zgJX5+Q9xOEyHk1Q0+ff5suDwfUHQnp70yn3Lq8N2oGImyv
 32IjgGegUnsc/l/rYHnLDltFYVirWl2HMBviA4A76E9ouwWg7xAx5pS0ZFfwAsbxF/MqCy57Erc
 +ZfWJvaNxIMXKWX0pBTUpszVcjqHv/OYiyAbY36nLDRgBLqztr2TLgsxcwlEsakKS9gCKL6mTtb
 EIC9tgR84X6W2/V0RxxDLb3Pu2NOMiQcQ0p/pA3uYu1a2LWQFsPFW+nIh/iAIby8aml0cca8w27
 eHZ3YO1hATrFmzPBFWXj5nKh7X+j2FBgLGLTjcaE8j54Iuc2kMzlP9z6RY6+82tFyeDxG7i2ctg
 B/C06UYRYGBoYOXjAzjl2OIQu3UiaBgI4zZGkxkYVIvkZgD+Yv3zgOAhVMJAPOJIyysHe++yK+4
 L0HPoUprEbXv8i3s9rOdOYeliWgwXJ2ST5ix0KfVxqZTRqX2xqhnVZsf+V17azLTjMxkz60tSmS
 jf4la6GMq+tUhO3lBcQ/vTLkUEDK4zBMvUnC4rbXw3vfLzZJAkk+M9RFdcOvtDxLH7sbT660upR
 H8m2pgEYyG/IJ/w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

A slow writeback wait ends with one more "has been waiting" report,
printed by the wakeup that sees the last work item complete:

  [   31.763963] INFO: The task sync:276 has been waiting for writeback completion for more than 29 seconds (bdi 252:0, work items left: 0).

That line reads as if the task were still waiting. To tell a slow
writeback from a stuck one, the reader has to notice that the reports
stopped, which is easy to miss in a busy log.

Report only while work items are outstanding, and log how long the wait
took once it is over:

  [   31.807879] The task sync:275 waited 29 seconds for writeback completion on bdi 252:0

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/fs-writeback.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index c5e9e5c0d506a9..e2da4781b5e00b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -201,15 +201,16 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
 {
 	unsigned long timeout = sysctl_hung_task_timeout_secs;
 	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
+	int left = atomic_read(&done->cnt);
 
 	done->progress_stamp = jiffies;
-	if (timeout && (waited_secs > timeout))
+	if (left && timeout && (waited_secs > timeout))
 		pr_info("INFO: The task %s:%d has been waiting for writeback "
 			"completion for more than %lu seconds (bdi %s, work items left: %d).\n",
 			current->comm, current->pid, waited_secs,
-			bdi_dev_name(bdi), atomic_read(&done->cnt));
+			bdi_dev_name(bdi), left);
 
-	return !atomic_read(&done->cnt);
+	return !left;
 }
 
 /**
@@ -226,9 +227,18 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
 void wb_wait_for_completion(struct wb_completion *done,
 			    struct backing_dev_info *bdi)
 {
+	unsigned long timeout, waited;
+
 	done->wait_start = jiffies;
 	atomic_dec(&done->cnt);		/* put down the initial count */
 	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
+
+	timeout = sysctl_hung_task_timeout_secs;
+	waited = jiffies - done->wait_start;
+	if (timeout && waited > timeout * HZ)
+		pr_info("The task %s:%d waited %lu seconds for writeback completion on bdi %s\n",
+			current->comm, current->pid, waited / HZ,
+			bdi_dev_name(bdi));
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK

-- 
2.53.0-Meta

