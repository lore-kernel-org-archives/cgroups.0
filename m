Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793968091;
	b=xVI6J4Gh5jMyuP7SIYRBrXJ9dD8cinqj2lVtdjri8ZWdzRvUf7EjOctB38XSeV4Km0LB
	 6WUm2qb8VmZ3MJ6y0YaqEcJMcJCvfmrwoYr0k6hbc+UnoIjoOAvxx9Km3gFNDcKG44clw
	 apZ0brcT+z/udXQYTKIEzC4bxz5jZmJUBIvAlb31JVwCttFzDxdQV1qYpKs8o79jgNE5D
	 EpNoiwCxpwV8qzyNHJmE0bSbKPodKV8k3JZD1wCKWLaju3JC8O/IL7muEUu++yVUyDXnf
	 rcukCcsWBuRKE/l2BwoWgNh4jkQfI17HA8yY71fmzdS0ZHLxzxl8AL0sAKx/bol516g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793968091;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=gvU9Ll/eiIhTIGP9YekbSrp0PA62VwZ43mnN9JohyA8=;
	b=ibFpmumGaEXfkIVBtiwfZojJbR14BkKCc6MV61aMrS4gasCUroqjVGcohhAQx68FStFn
	 c2T0roO0xC0U0CxfVVwObE0Cg572OwpYaz4x0RYrUWf0JHDDhC3K8fDkDn1u2Nk2cu7UX
	 vcgAV5DijONgQwQQmjEeiyKZvmAXDcv+lDSBihz5k4bAY0B+obTQUx2kMJbb1ef8i3hOD
	 CdE1MGMtH9CZEm/V/PYaYniSoNANsnp8I7JIdjPluBqOUmnhhNYEr++jrP1i0AUDRL6l5
	 vzBHilrEKsMiClJzu7IC0rgymY8jSx3ExkvyMa809wSGYyuSm0ag/XTYgDyP2fvoX5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02B0606D81B;
	Fri,  6 Nov 2026 12:28:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B02B0606D81B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=gvU9Ll/eiIhTIGP9YekbSrp0PA62VwZ43mnN9JohyA8=; b=kriSbH89ZxwtRAa6ULhkqiNJJf
	TMaNoX6df9t3k6PGp1kYsjOs/Uk4kZlxd2LT9Ef0SVLrsbktATcTSLmjMZbnnyVnbTWWpurDISd+d
	JmstELL20CDQKrzTqq0bPXA53sRl103ypUpcJhT/R+rAYa+KbS0BxwjatXRBnjdmx+H7p+GL2b5Gz
	/xdfUVsC5BR13YX2wUFQ2uS/O/m8bqGuL2PKCYS3i3enLAd6v/7olOpcw8Evo+zvIWpMgG78xNUN4
	m3WmW0/zWol98h641oDlS5urIAKqVHsgB2c7urVMjSPBfchScJyINF7kaVchSMscNAexmiTMWOoUV
	gtQVcWgA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPJ2t-009HUA-2L;
	Fri, 06 Nov 2026 12:27:51 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Nov 2026 04:26:33 -0800
Subject: [PATCH 3/4] writeback: log the end of a slow writeback wait
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
Message-Id: <20261106-writeback_stall_report-v1-3-bf0c3b9023a5@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2421; i=leitao@debian.org;
 h=from:subject:message-id; bh=iWceDHwwzC7CtVXVGCT6gvnNpBmDPTUwLcY2UEonv3g=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq7cexBfiJ3VegtWonP+xsYLQRVNrpAkov7A9YO
 NvPZ0oPNouJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCau3HsQAKCRA1o5Of/Hh3
 be1dD/4nmrxOfJYJw/5P28bGYcp4gHuYsEy9nJmS7KV0gQju7E62cEKfqwun2aIGlpvay7dRID8
 cRLJGizJ4tudbbP4XCo5rOM30dE9DHgmSZTj1fnehuy7ZdYYdE1gWKZTpa/QNgZAZaWY/bgeTA0
 OhbYSoGs+rzin3e9Fo6Ko8rjtcUXoXGbqBrOQ0+9N5vgbJG9tk/+BKtpEB1abqAzWwtqJWxfCWD
 RrkqpjokGI3TNCFMHmHwYt0JdOne/nnqF8WYlnwLyQAG2va1YbIbmqqEPWEmpvij2tP3VefCfMA
 cCo0ytSjAtkAL3seve6NPqHdupdLI6godDCn2iqJ+CjrJnpj35Sk/zQ2sd7nXNeTsRAEnBBharh
 aHNM07S935HTyiLMvulRUH0HsgIuJ/GW/gsK50J4mP6nx/EYgDeJdgQnahVc9eUpkJ0KgWZVoZ0
 5SES4RL8biRgHO4lU9AonTVL+3nFktwndc6nSORxWZsN0edcM9eUOtGJGnZa/lhmgZ3bhj1rRrv
 98yB0/h334klPS7bNk03tvG4v01dm6wVMJcm47vRXvIqlkw7uDj0CzMA99RqDEEsjjzEfHI/Ecu
 ZV70VFYUA1zo9p2jGVqzuaNuPQ55geQxE1r/U+aj5UIaGtHdcfnn1k+w48Jb8JkdwV2aosyQtE3
 /ojLOEHIPKH8wpw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

A slow writeback wait ends with one more "has been waiting" report,
printed by the wakeup that sees the last work item complete:

  INFO: The task sync:180 has been waiting for writeback completion for more than 29 seconds.
        bdi 252:0, work items left: 0

That line reads as if the task were still waiting. To tell a slow
writeback from a stuck one, the reader has to notice that the reports
stopped, which is easy to miss in a busy log.

Report only while work items are outstanding, and log how long the wait
took once it is over:

  The task sync:181 waited 29 seconds for writeback completion on bdi 252:0

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/fs-writeback.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3dee9d65eaf721..cdb2631b8552e1 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -201,17 +201,18 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
 {
 	unsigned long timeout = sysctl_hung_task_timeout_secs;
 	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
+	int left = atomic_read(&done->cnt);
 
 	done->progress_stamp = jiffies;
-	if (timeout && (waited_secs > timeout)) {
+	if (left && timeout && (waited_secs > timeout)) {
 		pr_info("INFO: The task %s:%d has been waiting for writeback "
 			"completion for more than %lu seconds.\n",
 			current->comm, current->pid, waited_secs);
 		pr_info("      bdi %s, work items left: %d\n",
-			bdi_dev_name(bdi), atomic_read(&done->cnt));
+			bdi_dev_name(bdi), left);
 	}
 
-	return !atomic_read(&done->cnt);
+	return !left;
 }
 
 /**
@@ -228,9 +229,18 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
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

