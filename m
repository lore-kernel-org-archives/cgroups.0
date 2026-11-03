Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793692869;
	b=oHllev1kyjXgIj/puCMpq+m1cYETr7TnXuNtZirvZIBZKrYnyhj2ohBMR8+NJ8DKQk0q
	 zuvDaOuWkqV6UJmNhwreLgcAmjUGT3hoNrkWX09tyuHD1cOVzCLcxZao1lzdAvPkgg0fe
	 AgorRqIZol/dU3h5iUd0UodicLZHIxGiP74CwmbluuW4vIKhOyNeVwFu4IpPh50cPPfks
	 WghcXcDjQ7HrEQr7d8s6WU7DlXcPEJ3cjOM/pxdweqxQ/7l16VoGRqFQ6InF6ekzo5KXo
	 enHaSjt3MsVn6ObdHZ5LppbSNYSHgEWs/C/Vey1/neK+3GqScVmZhxnFv4VYm97i8eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793692869;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SqwVuuFMKCKR73bttjYygSAw+Vd4A3DCZlBKiSiMzKg=;
	b=cGJl/DOM7UurHFnbZkNsOIHs/ZT41xCI5t1muj632yjMVw33ED2VTR4EA3/omwpGS6QT
	 3Zkq2ysJ1QsEEQZR6SOkjq52iKbTIB/e/aqdz9VZccpdb7Rid5qB6CXB0qa03yvxk3Vp2
	 IXCtu3BYp779X0gjv8x8qys0k/D0RPtr/AzWhD/UWPASLXhNF5ACOq4I6Yb83iq+9ajIF
	 zc8Fn4r/vM4S5oDHSvy/9ni+dlrL5yx8M9Vb8DRL818rf4DRyxUt7gKlRON7hCL3/Rsuz
	 4iVY/X0JmQy1z53uw/LgoMaCHSk/rBCKLC9dIYYLMO5d3AdFjPcSEKPNFfYo12siQhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b="l+Xfiw/L";
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE88606A329
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:01:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CE88606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=l+Xfiw/L
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 13D1E3F6A0
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1793692867;
	bh=SqwVuuFMKCKR73bttjYygSAw+Vd4A3DCZlBKiSiMzKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=l+Xfiw/L24Srq5FjemCXGKVkefl3tHkQINqwr+aMB5OdqKqC/+EbPdlJ6SGCgm1HU
	 z8rT+9cpVlnSd4FTmNXnd1cAKH5Dst2kcoquY6EzBZXSX72KwwodLmQIqxvoF3K5tB
	 vdOspHXlaoUrTDH1A4gGWA03MdflOK1naLFkieu0hFbBIREEqz5O0628+mfmxKCtF/
	 w2xoOd+FRhiTTSJq7a1BCP9O4qMmq5+uyJA6dkLtk8q7vCiW+1BIMJ/CrNY/ooTq32
	 XNqZun6KE9tS6LNZPDloviVP7LotBGJfFSF7cmFepxBXYRzsNsJ/WBL4bvRI6qrAt0
	 ZFFssuVvgki+6jyQku3aInNmBqxDY9gs0uquQ+SDgTEgMqssdT0pjPCdCw2/NkXwF9
	 6VaMcakq1TDopqZyXWky73OAGEReAdd5aO82oGeBY1ExBEsZBbK7Nnqi3BccfgMaNv
	 F2sfXQbjOlTAH/6SfNyQO7t+kHnzivIk4DbP6WqzKC0PxFeoQ0iimNJCh+AsTgKhKr
	 q2TUvnkkxZp/SxnyblilbOItT9kwcYTarLJN1FmB/BXgm3ufRl1xbfoCxENogX6wNP
	 Zv/IPN2UBFk/vCk/i261gtLohhIDO3q3MEuNsJcdzai4CRrc/SxZD/LVRZ91ZPSShv
	 hOFwQAfdKEgVNXD7obLIu6KA=
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3698bd5392cso492837eec.1
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 00:01:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793692865; x=1794297665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SqwVuuFMKCKR73bttjYygSAw+Vd4A3DCZlBKiSiMzKg=;
        b=T31YqNSnd4/vk3lexnbLVumDEAPzlY4HbeNr02DG9P/cmVOFYsk0B2mhXgfSTLgjsi
         WGIYM1jWUq5Pir8LqrXrkilgkInZbwZaXU7p+W++iVqCCu28J6sruGN3AEHS+k2J5XyS
         UwMH4HRLBfh3yXSmG8Um5RFdzqBCdxs3Ctjk5c59EdOfmruO1sjh0jcIiNYp/AbF3tOt
         8RLGcmOJEmlvzIgptAuM4K7W1N6n4llPXLbQ6ch1ac7mSEzk1qQv1+nnT7CdkgaFCLk8
         6gyA+vFcB5g0mG/RsgDDucsPPnwx9Wr5iMZXhCKpyQYbrAm2oTIdaRd28tQnoPutkWXA
         TOPQ==
X-Forwarded-Encrypted: i=1; AKwUvBzBC1ozJs9Zr4w5lvDYQEY7YuAhdIO14nEhk+KxL9R0Vnu0KcuZck+Sws5AoNN8nSPO6YzjrLZ4@vger.kernel.org
X-Gm-Message-State: APuU4Z9EoRDMNwEgYE6ZA4QdvBQF8XAulPipKbSm4/QznFiLqQLTgzGW
	sS3crIBlj1mD8C9dErgbIxcOUF7IVLm7hJwQ5PmDxERLacJp469CBUXNnfLMJhwbbH4oTJhO+ha
	y8cobYGgUD0/LWECFTdCvSPJKWnfJk8shI7z+LL4ejJS3lL9UIEKFOw3egMT1Nwcq4SK74fSbM7
	Q=
X-Gm-Gg: AYBFou2ipF8hKP4QAixxsepn8+83M+NAkaknoD+Znrx+mnH+AsAhwWSVU5EwwQX8KCa
	Z06VrhT4/QFJltsTD1FN5ixqZ9blLiBuh0Kbu+I9MQnVHVhhESMTS7zIP4FxQar9GGoqcInpsZ1
	kKy+NxV3ju92/HJs8GYEaeSlf4ZEOR9fTme0PZ0fEazBpieIFXVimUKHt41ON64UPn8b9Y3jqpw
	X72Kclz+iNB97Uchk3OQn7Qi6KNRyEj2Tozoc5pDcVKhGXCmxb2jKoC7Jrw/Ns/5XjDNBaNePRR
	7ykd2EidHqXLN2kQB8n5C+X20gkx2CMZB2/s+efD1S5TmqGvUBymJC0+Zd3SeScaYi/doo7zjUQ
	JX0sPsuu01f2YsH+4/YaumwML0CjPjT0L3l0d0g2V2KW2DlvNodFe48jRYQaXRl3gbZZsjpCvGf
	xhJvgHUV25jWEhluAa0g==
X-Received: by 2002:a05:7300:f587:b0:35a:3b98:b428 with SMTP id 5a478bee46e88-36a424011f5mr16276692eec.12.1793692865041;
        Tue, 03 Nov 2026 00:01:05 -0800 (PST)
X-Received: by 2002:a05:7300:f587:b0:35a:3b98:b428 with SMTP id 5a478bee46e88-36a424011f5mr16276664eec.12.1793692864506;
        Tue, 03 Nov 2026 00:01:04 -0800 (PST)
Received: from Garunix (122-58-163-222-fibre.sparkbb.co.nz. [122.58.163.222])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm37885274eec.4.2026.11.03.00.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:01:03 -0800 (PST)
From: Matthew Ruffell <matthew.ruffell@canonical.com>
To: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH 5/6] cgroup/cpuset: Don't wait for memory migration when cpuset.mems is written with O_NONBLOCK
Date: Tue,  3 Nov 2026 20:59:39 +1300
Message-ID: <20261103075940.110308-6-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103075940.110308-1-matthew.ruffell@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
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

From: Caron Wills <caron.wills@pulsar.com>

Writing cpuset.mems migrates the memory of every task in the cpuset on
the ordered cpuset_migrate_mm_wq, and since commit 3514309e0322
("cpuset: Defer flushing of the cpuset_migrate_mm_wq to task_work") the
writer flushes that workqueue from task_work before returning to
userspace, so that the write appears synchronous (the design of commit
e93ad19d0564 ("cpuset: make mm migration asynchronous")). The writer
therefore sleeps in TASK_UNINTERRUPTIBLE for as long as all queued
migrations take. On a system with isolated CPUs running SCHED_FIFO tasks
that was measured at 2 to 10 minutes (LP: #2165410), and it is unbounded
in principle: a migration blocked behind a starved kworker or a slow
expedited grace period holds up every migration queued after it.

The writer is usually systemd. It applies AllowedMemoryNodes= from PID 1
itself, and since v259 it opens every cgroup v2 attribute file with
O_NONBLOCK precisely to opt into asynchronous semantics wherever the
kernel offers them (src/basic/cgroup-util.c, cg_set_attribute(), citing
the memory.max/memory.high behaviour of commit c8e6002bd611 ("memcg:
introduce non-blocking limit setting option")). While PID 1 is stuck in
the flush, logind cannot create sessions and SSH logins fail.

Honour O_NONBLOCK the same way memcg does: skip the task_work flush when
the file was opened non-blocking and let the migration complete in the
background. Blocking writers keep the synchronous behaviour and the
cgroup.procs attach path is unchanged.

This does not make the migration any faster; it only stops the writer,
in practice init, from being held hostage by it.

Link: https://bugs.launchpad.net/bugs/2165410
Signed-off-by: Caron Wills <caron.wills@pulsar.com>
Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 kernel/cgroup/cpuset.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3219f927c35e..439b55a310fe 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3482,7 +3482,16 @@ ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	free_cpuset(trialcs);
 out_unlock:
 	cpuset_update_sd_hk_unlock();
-	if (of_cft(of)->private == FILE_MEMLIST)
+	/*
+	 * Memory migration runs on cpuset_migrate_mm_wq and the writer
+	 * normally waits for it before returning to userspace, so that the
+	 * write appears synchronous. A writer that opened the file with
+	 * O_NONBLOCK asks not to wait: let the migration finish in the
+	 * background, like memory.max and memory.high skip synchronous
+	 * reclaim for non-blocking writers.
+	 */
+	if (of_cft(of)->private == FILE_MEMLIST &&
+	    !(of->file->f_flags & O_NONBLOCK))
 		schedule_flush_migrate_mm();
 	return retval ?: nbytes;
 }
-- 
2.55.0

