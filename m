Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311226;
	b=QyuLKtQ+TO3qqXFt6kDWG+G2jlrScbA9CujQQs2mlap5zfFFdnmlNXNwSoAEt/HBWANr
	 ZPY0EOkjheQLhmsu/KdTSjUXe6VCxlxat0kJw9ocdKwwlZ7TRPCDbNlP1l6ACXzZkjB6c
	 YtjJYTy1qmyzM/KplXUfYhwqKOMINonP3hz6ivtEy962GSWwNokPgTcHJEw17N/Fw2DXJ
	 8IBaCR5M/Cs0zGoQY5LOeRkZDvI4viXLhPvOd41CUmHpPQU9gx0qQfdjd1sS/zRujySAo
	 oufyZF38xxB64NImuRtMHroLGkzYej1fSDKkqmlx9YdXA2dqAD9kvMN+7ygiwxg0b9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311226;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=oyWJug/hBVWQQCOKqOZgk5LGIUN0CoIe/ztsrf1oXBc=;
	b=1KTSQ4N21liNas0NSC7bMpGlgZur8/iDhX85LxM4+Pj45yyiP+1ghK9FCtFGYH/LEJ+X
	 A/LitAPWX8uMrkJK9aDoJM7LcD02rwww1rlnICbLtXYNt3wjpUhTwTUSPypNhWlv/pQBY
	 hDVl0ggqiB/Yk0sSq3uvEJRaH2/xCqGYIF8CrbL+VMDyWx1LUvz10S9zI2/3jmm7+aRAt
	 U0Pmg3AEQfSrahNqNHevUDuhQRpZHOWVmT2uX4kw/f/o4yi6IYbza4kUbGzvW0+0M6H8P
	 mhpou53ekG343GhQgOK5QvogLlzvS/NND7Al62JrGp6dbc51OFtx20/CX4WrYX76MFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=v7Tk81Sm;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853E060A261D;
	Tue, 10 Nov 2026 11:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 853E060A261D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=v7Tk81Sm
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=oyWJug/hBVWQQCOKqOZgk5LGIUN0CoIe/ztsrf1oXBc=; b=v7Tk81Sm/v2CyqZbx+psXu5q2r
	ssSHq92OtmFNYq9p5nSX5H6ETCLNZaDmzyiYoLMcwEIYjnGonD3nH2rqOptn+9yDfOvhaZDLlrjah
	n+01f7wy1t38GU3DWbQHZoTVx0Cj393GzwFlgDDd7h3pwBtdflSreIvOkoR16mj+DCe9xMGwW6F6k
	VJ2VlS3g8ztZllnojNM2khGcjBYbaI4Y1HN5MQlcah1N3diBH2wKAbXCvlZraUq62E7Xg9B+CKIVN
	A6PNs+bVApeqaIbUaiyzbcNCggKSaOXgQW/5jYuVoAdDR0vpBnFrnd8Oc3qP/ANS4cC2YL4h4jDYJ
	Xtng5O4A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xQkJY-00CNU5-1A;
	Tue, 10 Nov 2026 11:47:00 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 10 Nov 2026 03:39:30 -0800
Subject: [PATCH v2 4/4] writeback: report a slow writeback wait once per
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
Message-Id: <20261110-writeback_stall_report-v2-4-9e0ed75074ca@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3643; i=leitao@debian.org;
 h=from:subject:message-id; bh=ajm8Ubwuv+zRBQCdQ86iU9Tq8be5/mg0MciPD2KAfKM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq8wQYEQeCZFOUQMESKbD8oigrM0FIkR0zqQxCW
 emSIIM8CryJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCavMEGAAKCRA1o5Of/Hh3
 beoXD/9lTXvWJYV+JVoPskFLodmlanyOBCnxB/KXdCaVc8sIlueOcnJ4XOL+C9wptJHQNxraHCm
 vSzn90Ve/YsPVW9Gr1o+/x3sliFDJH3vkw1SRkgNJeNsdCcPVwb+Py1+oJ1erUqWi+AVHPMzqV7
 1s55ySvBsDGrxFJCgktf3NGEja6hmny3CsNnFsCfnzCle0PLW08Ux6mghUNElv0+MCpab4zmPWO
 KylJh/zH7yJHvscZqbnIRNEcuGXiXsQZFTCJbUeMcaXaKm1rvxAuJV9kCGR2OwnK9grQ9ZsgaWs
 askY4XKVu4JCNwDWL4n/nBejkFMdgW3NOHoZbLTBwj/rseWdj/Zfh9gTjI1VLka4/VjTZZ/ZVoY
 5iGyZkjnwYYfRMzQcSeCxBOgQ2voM5zQmkzjRRNE4YMffLjWjzZG7YoPPHIMeOrj6mHhi6Pj7pP
 gOWX0/MbEu0RMV0Wxn415d3patjIBJGLbm+RMaQRibIY9kReYln6JvaC7Vshg8i4PLB5T95gIo+
 uxqChWUDybckZkNoX8lteGAhdnr4MR7jywgV/A2kSDcf4wNu6RKSZ9cP8TNNdhry47WsP/PmTKb
 1Oi1qS0HeANf5nn890ZJB6ViIM8FRFUkvPva9ZA7xjgVRfIILeKT7KMoWUOMNSx679mMHaV5Wcg
 SpgtKJuVjHoJ6gQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

The slow writeback report is printed on every wakeup of the waiter past
hung_task_timeout_secs, and twice each time.

Each flusher working for the waiter wakes it once it has not run for
half the timeout, so the hung task detector sees it make progress.

Since commit 84654c7f4730 ("wait: avoid spurious calls to
prepare_to_wait_event() in ___wait_event()"), wait_event() checks the
condition right after schedule() and again after
prepare_to_wait_event(), so each of those wakeups reports twice.

A sync of files dirtied from two cgroups, on a throttled null_blk device
with the timeout set to 5 seconds, gets 18 reports for a 29 second wait:

 INFO: The task sync:275 has been waiting for writeback completion for more than 7 seconds (bdi 252:0, work items left: 2).
 INFO: The task sync:275 has been waiting for writeback completion for more than 7 seconds (bdi 252:0, work items left: 2).
 INFO: The task sync:275 has been waiting for writeback completion for more than 10 seconds (bdi 252:0, work items left: 2).
 INFO: The task sync:275 has been waiting for writeback completion for more than 10 seconds (bdi 252:0, work items left: 2).
 ...

Set ->progress_stamp when the wait starts, so the first check does not
take a zero stamp for a timeout. The same test now prints 5 reports:

 INFO: The task sync:276 has been waiting for writeback completion for more than 5 seconds (bdi 252:0, work items left: 2).
 INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds (bdi 252:0, work items left: 2).
 ...
 The task sync:276 waited 29 seconds for writeback completion on bdi 252:0

The flusher only checks for progress between inodes, so the wakeups now
land on the first inode boundary past the timeout, a bit more than a
timeout apart. The hung task detector scans once per timeout, so it can
catch the waiter between two wakeups.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/fs-writeback.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e2da4781b5e00b..fcb7fb0196208b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -203,12 +203,13 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
 	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
 	int left = atomic_read(&done->cnt);
 
-	done->progress_stamp = jiffies;
-	if (left && timeout && (waited_secs > timeout))
+	if (left && timeout &&
+	    time_after(jiffies, done->progress_stamp + timeout * HZ))
 		pr_info("INFO: The task %s:%d has been waiting for writeback "
 			"completion for more than %lu seconds (bdi %s, work items left: %d).\n",
 			current->comm, current->pid, waited_secs,
 			bdi_dev_name(bdi), left);
+	done->progress_stamp = jiffies;
 
 	return !left;
 }
@@ -230,6 +231,7 @@ void wb_wait_for_completion(struct wb_completion *done,
 	unsigned long timeout, waited;
 
 	done->wait_start = jiffies;
+	done->progress_stamp = done->wait_start;
 	atomic_dec(&done->cnt);		/* put down the initial count */
 	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
 
@@ -2135,7 +2137,7 @@ static long writeback_sb_inodes(struct super_block *sb,
 
 		/* Report progress to inform the hung task detector of the progress. */
 		if (work->done && work->done->progress_stamp && timeout &&
-		   (jiffies - work->done->progress_stamp) > HZ * timeout / 2)
+		   (jiffies - work->done->progress_stamp) > HZ * timeout)
 			wake_up_all(work->done->waitq);
 
 		wbc_detach_inode(&wbc);

-- 
2.53.0-Meta

