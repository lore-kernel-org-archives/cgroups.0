Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311211;
	b=gps2fDE+O980HXUwNhyCqItN/aVtw4UtTcnIx5xea7tni+tiDsHaaJm3akggTmqRWKrG
	 NbBY9t3Lmm5YMS1FUTpeMgOUUr1v7dA25joTbiQLbTN/AL86youB/veOImZ/DaT3TMzaF
	 DqfyIj3UhlLiFkRL2f8wfds3Vq5voCtFdsfBuMY4K2X43lJsRAG1+xt771Y1YtYd590S8
	 tlRxZGRYDuy1IyQ6rGY4UKpoOIISG9qv9EBVf3Tgek6mZN9V0juCU0U+S4myP37VT8yCx
	 Z4jqLJz4TafLg3e5zgYTpFfWfIYoWJvwf4+UqMWZn2kcn06qtJ1KdhOQPq00jp4zSzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311211;
	h=DMARC-Filter:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=hbY0RzxFM5S4ir9xTxtZ6iuWd15w11W3iqB+mvroyYQ=;
	b=AaqRStJfswLo7WnzC35S3e0tj6LEI9CwZQgkKSmpPN9zjhAQj46wfb3FfNLl/mmfNI1l
	 frlhrtMFbsR3kVKuLBaCHN4K7qTXi9iLTR+XBzLDhJG6qnIlpKnYWhjlyY1wbUOy8xXws
	 qpzXTLO4f4KuUehdFmPFZopzLyKU1lJY2g0suVJ41Q0Tc/gnMQxXUiLuqop40xK3OZWmF
	 iqcJ12zMftpq1L2Go8R1d/5ouV0gXLIySy3CqGeQib8BABr1EAgnG02fJ07xn3LcixPnr
	 x7DdQHgtT/DFjk5r5YdvoaA+7cX8rrkM4loqn8ylV9OY3Aa31YD00OlFf6kkdZC/efg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=i2Y39OAK;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12490606A335;
	Tue, 10 Nov 2026 11:46:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12490606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=i2Y39OAK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=hbY0RzxFM5S4ir9xTxtZ6iuWd15w11W3iqB+mvroyYQ=; b=i2Y39OAKDD7hr3QUivUv78G+OL
	n5jO35f1Bx7pUETtXw0IGi60mc3dkEEogbQC+IvFULrLl9/Y5Ima8+eCu+K/YEF0adnS2Fd3ylzqZ
	nMpVWQFvUqQsbZrioEYskqKBn49/ZVgidB5CJXjSDAUOyEIle3yRnBXe9Pb/fKD+i4Obj7pkoHMa2
	Fb3ftpWz2WS1KW2OP8Q1ugJTolMQrGbm2n0IIyYq12X9l7V//9LZeBk2qdFqF3INRBrtC0wx9KIRc
	qjfQlPeFQ9+u1t5FFtljEPE6QikTu7Qk1QVbKDSo7tIQ3PKM7tkBE3n71ZlUfkfxtDGZiKFfRsdD1
	A+sBEMaw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xQkJB-00CNSj-2Z;
	Tue, 10 Nov 2026 11:46:38 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v2 0/4] writeback: make slow writeback report more
 actionable
Date: Tue, 10 Nov 2026 03:39:26 -0800
Message-Id: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
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
X-B4-Tracking: v=1; b=H4sIAHMC82oC/3XNQQqDMBBA0auEWZuSxBrRVe9RRBIddagYmQTbI
 t69VOiy2794f4eITBihFjswbhQpLFALkwnoJreMKKmHWoBRxmqtCvlkSuhd92hjcvPcMq6Bk9S
 lKgvlbFVdLWQCVsaBXid8bzIBE8UU+H1+Nv2tP9L+IzctlfSD6nJfKZO74tajJ7dcAo/QHMfxA
 aSccuq9AAAA
X-Change-ID: 20261105-writeback_stall_report-170750a69946
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3450; i=leitao@debian.org;
 h=from:subject:message-id; bh=tDJ++Af7+O4AhquRgYHiOK13KG8D1GnF3NPlto0zneA=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq8wQYtHhI/oKszB0e1xtawWAcoGeX226O8qce/
 EKj6+dxdU+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCavMEGAAKCRA1o5Of/Hh3
 bcG2D/4rlCu3WQSAMkq9YS/yA/bsW3D4kFIaKGgigSHX02WG5qO6O7lisQ6Cjjtm8hR+xO6n4GN
 L+23KZS954trl4EIRd9oh7zktc+8kMLZIbSDRd0ex1nDDkjxksbBSOP64TQsqt/ssLTPunD2Nie
 v7qPb0OmBze/MtyLH/bw7IByqEaeLJVqjbfic0B2f4ndRUAN1DbcPxux+4DKcr2YzZlTwk9iuIe
 FeESxWiJO2YRfG5ldvpsBeQBNybcNNc1s/aNFFJ8dpalx51+Flqnp4VWLXwlf5p7rzalWZYzElU
 0gr39q6oyyJ5PBZ6d96wvbbKyacaqiFLwsNVnXD8e7uj/bm6rnI4sd/bgGb90AHk55BXBA2cBoe
 lD88KM7EqRjS8Xta14Ho5heYeHhyCA7ewxwpw9UJhjlTMAAOgTKi9n2tD96/1QMWFQE05zlFo0O
 EYU//p7M5IPjyGMtbnsUCnr7QV7qsuxsduao+ZfKTZzPk2zkdkltXktVmTAoLKYCZSMUnJ7VvKj
 FAEg9ukR6pmINzE+oB7kyiA2d5FUR8CAedZHQm2tiqiUmlmrtxr7Eema3X4VqVtssH27sb9W6zw
 qcE5JHnXfNRCbsGF84qqxmhSxaIbAhHBcIUH0TogcVlCRPDs4YBKFPqurUjw+63soAv1h0eITCS
 MxlTkeAwFFz7s0Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Since v6.19, writeback waiters are woken while their writeback makes
progress, so a slow sync no longer trips the hung task detector.
Instead, a waiter past hung_task_timeout_secs logs:

  INFO: The task sync:180 has been waiting for writeback completion for more than 28 seconds.

Across the Meta fleet, this line is logged about 19,000 times a day
(the median over 40 days), and up to 82,000 times on a busy day.

Over one day, 194 hosts logged 16,858 of these lines for only about
2,000 waits, half of them longer than 160 seconds. Most reports were
printed twice, and a wait logged a median of 7 lines.

Going through these reports, a few things made them hard to use and
quickly act on:

1. The message has no trailing newline, so it only shows up once the
   next message is logged. Patch 1 fixes that, for stable.
2. It does not say which device is slow. Patch 2 adds the bdi and the
   number of work items left.
3. The end of the wait is logged as one more "has been waiting" line.
   Patch 3 logs the total wait instead.
4. It is printed every half timeout, often twice. Patch 4 wakes the
   waiter and prints it once per timeout.

With the series, a sync of files dirtied from two cgroups, on a null_blk
device throttled to 4 MB/s and with hung_task_timeout_secs set to 5,
logs:

  [    9.262814] INFO: The task sync:276 has been waiting for writeback completion for more than 5 seconds (bdi 252:0, work items left: 2).
  [   14.683024] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds (bdi 252:0, work items left: 2).
  [   20.103027] INFO: The task sync:276 has been waiting for writeback completion for more than 16 seconds (bdi 252:0, work items left: 2).
  [   25.222884] INFO: The task sync:276 has been waiting for writeback completion for more than 21 seconds (bdi 252:0, work items left: 2).
  [   30.542836] INFO: The task sync:276 has been waiting for writeback completion for more than 26 seconds (bdi 252:0, work items left: 2).
  [   33.562975] The task sync:276 waited 29 seconds for writeback completion on bdi 252:0

Without patch 4, the same test logs 18 reports.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- Print the bdi and the work items left on the report line itself (Jan)
- Patch 4: wake the waiter once per timeout instead of adding
  report_stamp (Jan); its changelog shows the hung task warnings that
  this can bring back
- Patch 4: the doubled reports come from wait_event() checking the
  condition twice per wakeup, not from the two flushers
- Collect Jan's Reviewed-by on patches 1 and 3 (patch 3 rebased on the
  one-line report)
- Link to v1: https://patch.msgid.link/20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org

---
Breno Leitao (4):
      writeback: add the missing newline to the slow writeback report
      writeback: name the bdi in the slow writeback report
      writeback: log the end of a slow writeback wait
      writeback: report a slow writeback wait once per timeout

 fs/fs-writeback.c           | 40 ++++++++++++++++++++++++++++------------
 include/linux/backing-dev.h |  3 ++-
 mm/memcontrol.c             |  2 +-
 3 files changed, 31 insertions(+), 14 deletions(-)
---
base-commit: 8b7179210b22f8e48a82c5ceacb9d56a9c4cfec4
change-id: 20261105-writeback_stall_report-170750a69946

Best regards,
--  
Breno Leitao <leitao@debian.org>

