Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793968090;
	b=TYA6xDdPIupT1iJfVglqK83LoSXwBZJ/bWBVB8Ed2aQRNRqTpRtl0cJYXP7DKKhaMKte
	 wTzG49GIfL0rWWujufFrwxutUgpq8A9kVyl00LgPJ4LVcCJefp1aOLG2PGUlHt/IDB4hC
	 KfKCZzx/diSGFbx4pz962ygp867lHIiK0XyAMEeAFuzLjXKMd3wJZhGMKjd6/anraSVQ5
	 H2PU/9E8uHmn3/4JkmFh4/eacQoRb9hLMBsIFmYsKTZe8wgf6TwIDroRB/5xxTy8hZAUi
	 tJ0hH7P9xUyB1lao7QjwyaEw8UoPe7oj+1gFdDk7VdLf2K1OVgj3G0SbNCDvcUETQyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793968090;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=2xXFaQslh1ktPeBKSCuZk9/R23tHT1fC6uCumCOv/+0=;
	b=3QWpQuGyg5+WAGpHY4dw/pqvP9NIHJO9p3JSA44g4ctFd1l4nRi1aQYEevqsKZ7Wc0R0
	 li7XC7dnSs9oQzKwmZyjaf8w0b1tNtsbIB+sP2o9KF68r4ZKpK4+DmTmsBl/ny2LUuzMP
	 U/yw7YnNeEM7mUNgayXronYaQqdTWjQ3GOrdFfQap1fxoZHj7T49x6evwFhMmwj8tldHb
	 VFy6SHl2nwIiGxqG7pINZgluVNt3Cx8NQdrIqX6oJx07nxM/WxyqBLqHOV6Z50NGLGgC/
	 aIFmG1lvbcbw7kyAy/XoEQ9hvU7BD4zF5tFXPflV6FJdPJGRZz5AXAimDt780SEbnqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b="iL/G31qz";
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0E6606A32C;
	Fri,  6 Nov 2026 12:28:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD0E6606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=iL/G31qz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=2xXFaQslh1ktPeBKSCuZk9/R23tHT1fC6uCumCOv/+0=; b=iL/G31qzO/t6eU7RfzxkVzPE/q
	vld4ozQOKZqn3RUYRb4Vu11OwtF2bkOapFX6hJSBlpVAY6FalSigIhJk/PTZBCD25FvsHGhg/zofV
	m0S4QBx5QMjkjJB2mjGT9wj9exjhATNUSQDK7cVRBOI0BM//EtWJyz7ligxWkL+6JWN14QlogyGeA
	ttfgAPVsx9z8bXqy3+Aa2QT4gu4kaEhKw6fKapP5F5Gjd6NU4JUXyM9EOIwWSLVfZ2i2Qubfy7lkd
	aZPwb4Ety+iZmtkqmJkK08+jDrtM72PdYsCylBNnkSR+UQkc85iXnsdawtUcPOME3/AgzklJ4FThz
	mwczTPYA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPJ2y-009HUO-3B;
	Fri, 06 Nov 2026 12:27:57 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Nov 2026 04:26:34 -0800
Subject: [PATCH 4/4] writeback: report a slow writeback wait once per
 timeout
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
Message-Id: <20261106-writeback_stall_report-v1-4-bf0c3b9023a5@debian.org>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
In-Reply-To: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3599; i=leitao@debian.org;
 h=from:subject:message-id; bh=QXKI9SIu/Eds5pHpL1MLns0a6wtiNFTdigYu7otzjwM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq7cexGOIQ4gST4wB+rTUnGbrNRqBhpjCgYX9BW
 NvtvBMCWx+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCau3HsQAKCRA1o5Of/Hh3
 bYUBD/4reK513xbT38cDoDqzrTNVacq1LEms0wFUfY8K8QaNUXeaE2hDmhuKy+fyE76RBQKsJSq
 0gIUayfAQkoJHNAiS4oJihXsEd1JTxUkH8uWa+WRXumBlOK5un61ibF95g/lKKJwx5dtSGpQ+t9
 4G2N5ZiSo4uetBoU7qxqyQdQFeDkFQfJuMlHRm3G2uTLqO5EsT/Ws9/SruNmSctI6iO6yqyN/OC
 hguy5SFNifotoy0+O9zvmrDKkA7Zr8Fg3iDxJZopc4S9L25U6nTPnr+uwRXatatpdb5rYOPzWsy
 0NDTvY3lymKnLbnC4irDcJO5qBmN8EgdS9TFGsUZ6rShkYx52G+o4OAoF7gGXuLEMGVpBqQM35x
 Y0vGnx4kIIrNxoRebnUEjfSjGbsxst8rkQtP8e9xi0Rel+B0fU254/4Anx4bPozgGATgNoDSu0M
 srjJLe0spCvhcA7CHLzq6ksy2j0oactskh+SVdcvqX2UwYQlduqg1cuUfw6Bjx2ieSz0/PThv5b
 n4ncmGb4EoGKToCwbgDvXYDtbXkH0hG4ah5n+yJNhMPOXSgpEMDrn35Tt0uorjJlRlWBPAUIwpX
 wiDCDyROaBwd8F9gKKcK6hc+tKpi8efNgLUh/Bm58CCbDpdUMGmpYBFLChDpcJKViLfyPY5JRiP
 tWEzBTmcxdUer1Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

The slow writeback report is printed on every wakeup of the waiter past
hung_task_timeout_secs, and the waiter is woken more often than that.

Each flusher working for it wakes it once it has not run for half the
timeout. All waiters on a bdi share bdi->wb_waitq, so a wakeup meant for
one of them reaches all of them.

A sync of files dirtied from two cgroups, on a throttled null_blk device
with the timeout set to 5 seconds, gets a report every half timeout,
each printed twice, 18 reports for a 29 second wait:

  [   10.327992] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
  [   10.328000]       bdi 252:0, work items left: 2
  [   10.328003] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
  [   10.328004]       bdi 252:0, work items left: 2
  [   12.888187] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
  [   12.888195]       bdi 252:0, work items left: 2
  [   12.888197] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
  [   12.888198]       bdi 252:0, work items left: 2
  ...

Remember when the waiter last reported, and report again only once
another timeout has passed. The wakeups do not change, so the hung task
detector still sees the waiter making progress. The same test now
prints 5 reports:

  [    7.661129] INFO: The task sync:277 has been waiting for writeback completion for more than 5 seconds.
  [    7.661136]       bdi 252:0, work items left: 2
  [   13.241102] INFO: The task sync:277 has been waiting for writeback completion for more than 11 seconds.
  [   13.241109]       bdi 252:0, work items left: 2
  ...
  [   31.801068] The task sync:277 waited 29 seconds for writeback completion on bdi 252:0

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/fs-writeback.c                | 5 ++++-
 include/linux/backing-dev-defs.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index cdb2631b8552e1..8d354784326f7a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -204,7 +204,9 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
 	int left = atomic_read(&done->cnt);
 
 	done->progress_stamp = jiffies;
-	if (left && timeout && (waited_secs > timeout)) {
+	if (left && timeout &&
+	    time_after(jiffies, done->report_stamp + timeout * HZ)) {
+		done->report_stamp = jiffies;
 		pr_info("INFO: The task %s:%d has been waiting for writeback "
 			"completion for more than %lu seconds.\n",
 			current->comm, current->pid, waited_secs);
@@ -232,6 +234,7 @@ void wb_wait_for_completion(struct wb_completion *done,
 	unsigned long timeout, waited;
 
 	done->wait_start = jiffies;
+	done->report_stamp = done->wait_start;
 	atomic_dec(&done->cnt);		/* put down the initial count */
 	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
 
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 4f10849373150d..f9fd3b1bf4c609 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -67,6 +67,7 @@ struct wb_completion {
 	wait_queue_head_t	*waitq;
 	unsigned long progress_stamp;	/* The jiffies when slow progress is detected */
 	unsigned long wait_start;	/* The jiffies when waiting for the writeback work to finish */
+	unsigned long report_stamp;	/* The jiffies of the last report */
 };
 
 #define __WB_COMPLETION_INIT(_waitq)	\

-- 
2.53.0-Meta

