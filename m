Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793968077;
	b=KaNcdgfQrMC2iYxVZdKnshiptqqpiseBKAOiGRWIgOSc2IMbRckQYCCbEJW2hOmKiYGC
	 xDsX18gVPb+SohwlNqGMZV14TXXNgfbdffd370vUN6ZOU4ooLprRDHan7XfAhGIlfyJVj
	 iANhppLb3Nm2khpDXLgSOrR3yOAMNEQhS7pXdFZ9wgo4NWBAcXZtCogYK/2WkPCJysbRS
	 N2FAc+5CCYahm9JDJHbSFGhyB7W60wqhuP9dn65ayGKi3cRXzzcVvVZ/aeLGWfSUuLlom
	 Qd1KQqQPjbyEaEHzfLzuclKgPz79w8TNySowx1q9irRJ6ga9Y1s5If6T0UcyBk7Sx0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793968077;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=jxg9YZCEig6aUovfMW9LERszjpC/Bi2+TpPnGTSoQi8=;
	b=UHQzGZ6Rx2kiioIUEc7LUscy+VdMhn15iMA4/eNUb6GudwpZgJlV5Ysfn1LAK6lTa4Bl
	 pb2CId9Umhc8+x0kHsZX2qXwhFgfZxnxO7XxETGHrTIBz+BLhn/jbTjCJwnjrc6UJHCI4
	 QtZiFpt/d54KAvcDCMKztEyuAn3ZB9nFKWkE2KQsb53dW0VvWi/DQIIMmy2gKZyCfJD5g
	 rVtX/DE/HkQa0s24VYcf6RrBQxLQdyJHV7sDvYS3kehS00dz6NIq+v3OvYSetzcqTKBGN
	 jtQ4/Qlj0CdITf3IXC/D9BzljDHWt3xXrOLWfHsbPIJjMuNd6mo2M7zTvNVefkCg+jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=vAKfrI77;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1546C606A329;
	Fri,  6 Nov 2026 12:27:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1546C606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=vAKfrI77
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=jxg9YZCEig6aUovfMW9LERszjpC/Bi2+TpPnGTSoQi8=; b=vAKfrI77DsSLod+Uczrvqv0Tjm
	ULrjeHLN2Rut6XqF70F/+op1bDdDobytns5RumRz1iCQtdGynoyR9fEa0SwQv6YpKI3SC8ykaUgY0
	i/SWyGlqVkJ82lNhPWpd5emu+d8doJhm52qVWwqwPkOYijL9rLtf0ZHHkvWfBV55sJvtw9oSMrAcX
	Rtumffo1xchJf9z5Nh0Ss8d9fZ/Z2vBLbPOKULbbkIjM/mgkT8VSEgE9LtRU+FZP8uSpX5JuCjQwi
	jDC0KLUFA3h4s32VBKUrZVWcjW9Xm9be30Kv0pm+ik9KStMV3cJOIUkesKqNHuFr+1cvcdm6HUCxR
	9x7JgBMQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPJ2i-009HTo-2N;
	Fri, 06 Nov 2026 12:27:40 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Nov 2026 04:26:31 -0800
Subject: [PATCH 1/4] writeback: add the missing newline to the slow
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
Message-Id: <20261106-writeback_stall_report-v1-1-bf0c3b9023a5@debian.org>
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
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1200; i=leitao@debian.org;
 h=from:subject:message-id; bh=hXkUpm8Ppkso7pz3WNB+6bMAnx3JDLSgoZdBoLm0PN0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq7cexSsgObTcm99v2R6oLzUKT4iRNgAWjgc1wj
 fhbzzMWk4aJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCau3HsQAKCRA1o5Of/Hh3
 bakDD/9OwZnPzwEaVdOCOEdmjSKRtZ3e3IIMxvSigJAkuxtCwyzcXS0/DwG/czZOVV0qUdveZs1
 13hwg4K5H65DpmE5q65wdYsoBQTaaYML5y4m+wgJLeBgAWF9lPikmN5lK5BbFDRPsoxJK7zOR97
 CH9UzLEICJChYXSSEKZUO+JTsFpHoJ/ZqLB65xjW14vnQioYxDjfQXcDguoe/H5hHKzp7i3Y91x
 4jrdnA4AytGZRHzLYFZUsSbufyR49hLdd0jZ39cum0od09Clc5rU6kBTqC49ew9Pcxe9924vrya
 4ONFnDU70eSshiysy7FDIOYE53Jy/liUfU+HXGGjk+SyKC3hJmJCCpzY0fyVefXTronP3feUbgf
 DMKOJg82Fnmy4jaLsc0UcajiWoXjEG9Vd3T9zUaoeqS0jHWDhhqstaSvraMdIQv+rEfULG5gWaa
 BCP3bJujtqpJof0ZMTbAuXcEcCf61lJlDmlCNgramOPSwxPETG5XbpyCEmXIMPGFToT13MbsXDQ
 w4gXLXe+kpiPQI2ODrOoTqlbikoAQ5Tns/dr2lAIb00cHHRuTYszNX0v9PFVCFmcPqbW7jYJx8r
 G/TsCjvSmEkAQLO8nP8wTDiY5OkUHoG2/lq4njN+OJD6l1fiYjNL7s1/VfTxh86INnx8pOusu15
 /ZmM5yj+D7ZKFYg==
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

