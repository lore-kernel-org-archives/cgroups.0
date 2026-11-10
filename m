Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311212;
	b=K0a6lBtKkdregFpHuzNyQLBHlm2VMsJs4NmqiueiLUHIRUg6c048rlEwIwRfcHlvwEnU
	 DmNjgr+L2i+nPkpLNjiYA9/bs8gydb5cAJQH8RXJ9pB7HIM3G9bMZzmj1eCjHzs1CTCeW
	 VEcDklDjdRr5yuSWxpsybhsHodexRoHIwpowM1zRnihlxHptnuDGqLsgLQnDUg9LE4VOC
	 fWnFZjls063rHxLwLurd2gt9f3QtjB0WR3lEFBqZpZzSNmj3pcJkDbVH4GD+6UCBO1nbu
	 07OwqA7LbRiq/9dxZovib3vwL9KpNSAPISvKEIC8SoOw6vjTgBsIG0t2VQP4PX4ZGRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311212;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=TMjTt/yM65LJnfLBEkqU4HceoGuAe/XUxe0Ej6UzqFs=;
	b=jQdrgGgfgFfoXAMT4bQYG7bGOGJgi2esdNbdu/Q+cJdlqS7EajnFEIXAx6tv9plYLLxT
	 RBxniq7jEIeJ+fa7ao2evWQGQ7+7edVoZB7TeEv+G3pAMP2tlHXNtbOkBqO/krloD5nEh
	 FMrrj1UQWkcEwcXH002TnVZYW2eIbAE9xLrBQZMK1t8jkwdizoQaYTv67O72NAhKNh9Nb
	 cE9HIZvSAdS+uymkOGhyyKiwoO0AEbrbcTCuYmMZcljrFlSGI2bJ4zp8wocxcnua3QYoB
	 iMPH9T4gK+41EZzJAVAjbfU6Fu+j4sCWgXBsXrgjyCBI5wiu0MfvNompmg2F9HJBLcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=iyixgFAg;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12412606A32E;
	Tue, 10 Nov 2026 11:46:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12412606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=iyixgFAg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=TMjTt/yM65LJnfLBEkqU4HceoGuAe/XUxe0Ej6UzqFs=; b=iyixgFAg9qREIYke8njMawXuIx
	m+6DM4Uqz9vuRKRMNTS0WtEuw7lwrRzO+dqy61GCeyqhy/5nfW/VPdGm+Q9QyBvuQGWkMSkMK7lPI
	MGk/hYTjmx9FbtzL9vBmtflZ6A1gUpXHjVEp/jB3Na/Q4SqPsQe2m+a/oZ/sRsfzEVunoXZSzi5+o
	pmLhZuxFG16tl6QgFE9g5fn/7IfTQYgAAee5GlO/OWWUy6qbfBFppcHComW9Sb11YqYo6l3AMb0hO
	61bPtWO+VfG30QK+x/Ewx8Usbm/VHCYUwt2AZWKncW5rYsxbB9rbccgIA2dXwP5XiQvhfjCnXWzZG
	nPDYeeqw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xQkJH-00CNSq-33;
	Tue, 10 Nov 2026 11:46:44 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 10 Nov 2026 03:39:27 -0800
Subject: [PATCH v2 1/4] writeback: add the missing newline to the slow
 writeback report
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
Message-Id: <20261110-writeback_stall_report-v2-1-9e0ed75074ca@debian.org>
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
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1238; i=leitao@debian.org;
 h=from:subject:message-id; bh=NeGmKN3thvdahCzcgtVy86L0XUPUwXecQRMKsZHaZVs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq8wQYn+tO0/VLlCpKrWAiFk/NDyAXlM8rdRiIY
 5NVV3z7jQmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCavMEGAAKCRA1o5Of/Hh3
 bWPjD/4+JCpUjzQC7+wpcfuUqpIQ257Du7Kdozk0zxWRhZyLexwAvUq8MrMgAjj9pnefRjX9WH3
 bWh8IdLz/x6p/emum/ddOOCpq3hS+yUpA/Nw95efr5YI8+ZvmnfA5ktJxMMv2sJz1oBmluexzFA
 nZeObq4sZfp5rXLA19Y7xnISHT2sbijtsVazm1m3J7obgvMW0MIgiKIfHB2pMEVOlxBa3i3lZQb
 SDnuQUj2GQHnRCUUSsvmSqF6vhFkp0dRey95qurL+iKwKPt9kIF5u0vXJEHWNQzLwUYEluPPYLJ
 McvMXURJb8e/B92meu65MID8Dl/2R/RkF3Qs0lUq97w9oqZzyUcGYzftDhvC/hOzGh/+mG7OWGm
 J7Z0jhZWaMpZe/VP7J8D+XYMv5uhZrw96OUGkxSc1Rr3hkq0EauSRPUszKGN/MmEJgIQ6lLqsrp
 OPVBX9zrFualqhV/iPBqMe2OpO5kM/4zZKY/FAz1VVs8WP6YrSrrCyLFblXa1cNheJiSgM0XGfi
 q+AAV7axQ6aiP1c9HaHF9cv8T5jhlpXvsFsiuBZNUQ/a3RevfIE300XwXtpANw7qu4lhGMipzqS
 8xT3Ci+znxzd8wA7nVV3xaEj+NHOdyfyPQ1QvQKO++VKHpyrwJfguFsWJpBK4+xXUaAfqZ53tx2
 GZBW8VwocVvy/9Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

wb_wait_for_completion_cb() reports a writeback wait that exceeds
hung_task_timeout_secs with a pr_info() that has no trailing newline.
printk() keeps such a record open for a continuation and does not
finalize it, so dmesg, the consoles and netconsole only see the report
once the next message is logged.

Terminate the message with a newline.

Fixes: d6e621590764 ("writeback: Add logging for slow writeback (exceeds sysctl_hung_task_timeout_secs)")
Cc: stable@vger.kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/fs-writeback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 15260cf2a29b09..01a00d7542b371 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -204,7 +204,7 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
 	done->progress_stamp = jiffies;
 	if (timeout && (waited_secs > timeout))
 		pr_info("INFO: The task %s:%d has been waiting for writeback "
-			"completion for more than %lu seconds.",
+			"completion for more than %lu seconds.\n",
 			current->comm, current->pid, waited_secs);
 
 	return !atomic_read(&done->cnt);

-- 
2.53.0-Meta

