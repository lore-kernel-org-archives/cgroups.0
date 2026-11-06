Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793968077;
	b=1QN2wwjjNyMzVPr/tXw+NcYovCdRfCh14PgdbpntNfaYan2rAv0rZvjUIySA9dao0QU1
	 Gi44R74Go7bV5LVW1tncjTyCv/GTekOgPuC1ggnnI+TWorNDP5BYImubVlKgLzJLmc/Ux
	 6yH1V9ob/Q/q0UXEb1xkR9iHZXbTi0Kf2IRlWZQrx1b8aw7DvE4GU20q5vQdYxFo8c1/C
	 GcrdW/bJadx8MvoQZKjils1scCD3WVTURMBsEJq8/dVarhFkGXyWYM5X8ox2R4wswNscH
	 M1tj7R2cuXabFD6SjlnSEu02u8M6yxTfHE3UBvs62nZRzJc2191L4uvdx0vsDEn3JIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793968077;
	h=DMARC-Filter:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=NwiypONsoLZzkdBGuzeZ3yGbT8VUdMblEVHsZrbIo4U=;
	b=Ze6elPLPMBtZtXwweUEGbhg1F5kcBAhLB1EiY2kSpZ73hti7fok+u2GHACPn6ujbkO4a
	 Kxh3fYTunDFK6tEUyUsnZGyTV1GZpqhf3xwwS3QJRaW+2A7p70aJMVR6H3TuUk5DMAWiR
	 +LLgxaAxmlhVIU+rt8StzSLZVHI9XMucUW9N9pyTQc1RdVWnGkKQ0ad3dsgiOPkjXYEHx
	 ZnOQ7gk26WVmTYUzl1aVoQYDF/Y3mM8BtC2V+0tPPatHz+SdEmOjT9FMu6VPZQi+uGwKS
	 6tLU2A5Phg5ZROfZIfESRO8IvE+r7h09Nkwew0M0r/ZTCFjPVjZOUuEJKnGaHkaOHag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Ulq2Gtno;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3419C606A326;
	Fri,  6 Nov 2026 12:27:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3419C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Ulq2Gtno
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=NwiypONsoLZzkdBGuzeZ3yGbT8VUdMblEVHsZrbIo4U=; b=Ulq2Gtno2cozebVUNoQKeEA1oJ
	FKFj1scdcKVIIlbtFUj1G4qq76gHRSzxr3SXyBPYxI+YwqTJyygfee3hGIHAfly/8mmU7zdF8C6/Z
	VH6cR+UzBGI6eUamT8/llFce39TGw/5CYwU1g3MgtYmd9hars+tepDghiPy1Wp5r1APzyb/lzZdDH
	RFSwrQKkUHh7n0YzLIvbo/99Z9Pm+ji7oyw2rtH/l2Rc2L1XWQ4mvUpW6fnxFQxgW4jc0XgEWyU59
	ZQ46SilyLGloE9eRv5d1YMIb4Gt9rQBO6VzhCZO5kcXSfe8XC7SDlTPt3LZAsSBU92xb/1RqptETP
	FiUMgchA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPJ2c-009HTh-2h;
	Fri, 06 Nov 2026 12:27:35 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH 0/4] writeback: make slow writeback report more actionable
Date: Fri, 06 Nov 2026 04:26:30 -0800
Message-Id: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
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
X-B4-Tracking: v=1; b=H4sIAHvH7WoC/x3MUQqDMBAFwKss79tAIhoxVyklRLttl4rKJqgg3
 l3oHGBOZFbhjEAnlDfJsswI5CrC+E3zh428EAi1rb1ztjW7SuEhjb+YS5qmqLwuWozrbNfa5Pu
 +8agIq/Jbjn/8eF7XDdljRqtoAAAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3335; i=leitao@debian.org;
 h=from:subject:message-id; bh=1HmsM4AmOu1Z2b61jfdJLukN4nebCK9JA4xCaLqawJk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq7cexdV0P/wi9k7Ii4huksYbn7v1NjChk3inU1
 3b4BgEFIAKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCau3HsQAKCRA1o5Of/Hh3
 bZbqD/sG6F4YNxE6zVSdVXQRyXNr0ImaQGVClKuo+AjvsLcnbyE6d46B80pR6vPYgU61oD3KBJ0
 MpNeJyj8gh3G2sJqdxVKwEW56gvY17zTbfLQLmip3IEiBidfe77rvM5CYrizlowLDcaaXAMq8o+
 ToI9m6tjlDvMoX/FZx02QUCLou1sMMF78B6FZIc8C0e+klHmme/+fPotUvHsbBm2VwuEtc9bbAa
 nT9RphAsfrzDTwvlsfIAfcJhknM9a5vkl9+Fn3jqX70trWZcAawP8ovMBUXZnwSq2o1ktcSHX98
 Q/Osb8goyIvEp5LJq02/GoEnoRcp6USB2SK5krK26BOu2xiF6HBEO45IlCc7v6T4gEZor0OJ54K
 3SSzUkgKuaIv4D2xpY2cEADO5Hi9G2NM+65ndmsbjjQQmApWYew+SlLIeVzKxFnLl+E95j+H0xZ
 oWIO2yqIqN5NCSnt7bltva5ePrIAJ5RWkM8IcavueMjck6V0EdW7YLm/0cdYvDY/Cy4+SAu2s15
 ycD0FaY2RGHcPaXdC6HqI4R/ajzWjffLK7APrnWQILcul3kORjy217bZTN9SBpCvCknQ0DHOq/r
 4N5J/7dNVlbopT/VLdXqvUMqNAF/RNuwFUhHzWnPJQV8PVEN5gRXxy08BCEpt16xJ3RXhdEmd5E
 QwN9QsIXME0EuFg==
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
4. It is printed every half timeout, often twice. Patch 4 prints it
   once per timeout.

With the series, a sync of files dirtied from two cgroups, on a null_blk
device throttled to 4 MB/s and with hung_task_timeout_secs set to 5,
logs:

  [    7.632999] INFO: The task sync:275 has been waiting for writeback completion for more than 5 seconds.
  [    7.633006]       bdi 252:0, work items left: 2
  [   12.913256] INFO: The task sync:275 has been waiting for writeback completion for more than 10 seconds.
  [   12.913263]       bdi 252:0, work items left: 2
  [   18.353245] INFO: The task sync:275 has been waiting for writeback completion for more than 16 seconds.
  [   18.353252]       bdi 252:0, work items left: 2
  [   23.633304] INFO: The task sync:275 has been waiting for writeback completion for more than 21 seconds.
  [   23.633312]       bdi 252:0, work items left: 2
  [   28.893299] INFO: The task sync:275 has been waiting for writeback completion for more than 26 seconds.
  [   28.893307]       bdi 252:0, work items left: 2
  [   31.792987] The task sync:275 waited 29 seconds for writeback completion on bdi 252:0

Without patch 4, the same test logs 18 reports.

One question I left open: the report uses pr_info(). The hung task
warning these waiters used to trigger uses pr_err(), which still reaches
the consoles, netconsole included, with "quiet" on the command line
(console loglevel 4). The report does not, and pr_warn() would not
either. Should it be pr_err()?

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Breno Leitao (4):
      writeback: add the missing newline to the slow writeback report
      writeback: name the bdi in the slow writeback report
      writeback: log the end of a slow writeback wait
      writeback: report a slow writeback wait once per timeout

 fs/fs-writeback.c                | 37 ++++++++++++++++++++++++++++---------
 include/linux/backing-dev-defs.h |  1 +
 include/linux/backing-dev.h      |  3 ++-
 mm/memcontrol.c                  |  2 +-
 4 files changed, 32 insertions(+), 11 deletions(-)
---
base-commit: 8b7179210b22f8e48a82c5ceacb9d56a9c4cfec4
change-id: 20261105-writeback_stall_report-170750a69946

Best regards,
--  
Breno Leitao <leitao@debian.org>

