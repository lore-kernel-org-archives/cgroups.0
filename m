Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795490215;
	b=S54EzGxhugf+7tpHM60juRM1BIXjqMSSnwwJANUI1A6ehij2oCGQm1W7iOnaNyUbHsZq
	 gSNnW1y5vgkWLZvrIT8HQ8DQm+W9zd+hv9lTSPcp0el+fQp0Kdx2xUddFr66vvi/RpAEB
	 jjJmZhE2aV+XyF6uZ+O6T55CXax1z3XsitbZXlo1e4DeHRgxeR07Wn77asYpd8Qo7AQT2
	 g6Bx8In1aSdjIYOATkBzZroMM4BUn4LMbyhpdqz+itb46UI23kx6wiGI5MRTkzMwpj+ys
	 MpjqVLzKiT4YwV9cbCARdasap2fysicxThH1leDZzT3nIJNk36+RRYxCH6iMrNZlzTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795490215;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=EKCwUBMZXEgwJsoK8+iw5jP9TfBZ6zy/Sv767cpvROI=;
	b=aPHgE2MZ9Jjlc+0Wk604raSjUkO0oduBttWS0qy5PFs0QcEAv7kR0oM8K6aBNgIwcO/V
	 Jyw7jMBKiAzxz8ntL/w3d50XDbogDPkrumyN1RDCvu3iurLajUyluB/SiA6YnnCaKRQpf
	 AS/0aHa+9dPX27ZkkCO8NC80xYpWRdJ0Pb0I1Dcf0qCVJW7hvGo7oLCWfGLjfqu/nHAFz
	 uVnFZ3FhQGLA+kmn5sGK6+bSoVPErd2L32LmZtSHPo00RB8xHIKUBPF8ntVjbc2M84aOU
	 ymCy/PZKBr5Le411zkUyon1r/FatbWs4LcqRbwo9/L3pPjK1YmVINu9Inl6fsgH8gCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WFpGA4KB;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0079606A327
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 03:16:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0079606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WFpGA4KB
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so31538535e9.3
        for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 19:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795490213; x=1796095013; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EKCwUBMZXEgwJsoK8+iw5jP9TfBZ6zy/Sv767cpvROI=;
        b=WFpGA4KB996Tu7hKVOnRNmXinER0wbZZXQoxSH7+GXHZ8IoVoxqX7VnyceUOGOqCNs
         WkwohfjDJenHbBSN+VDFxM2jVYwJ8IsOMdUJ2yz+783MhZ1kpbN8C2aVQkAx5KJFz/6O
         VoHrdCqbgxoKlKyvZ+U9LVvXgz7LODsr+/gzoTyfTFZ2ObuAaHFNkRR3uThSRrIGEf6T
         kVDFjPQO3n6MC8I6N7LGXTU/ajuZq9bf060LgWVpNeeuXGSKK++WWXIx9uxb5q8duH+A
         qSAZeckM2cwFAL6//k1WNoopWbqqksKVmOE8m2sd0JcbqjW1nI6dj3XaA604/Jvf2A5C
         94+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795490213; x=1796095013;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EKCwUBMZXEgwJsoK8+iw5jP9TfBZ6zy/Sv767cpvROI=;
        b=BXNrAVKpr4PRwvMw6/8OtX+FsThy9H4U3jUqsLVDwbu4LcQk3h64qe6h6UJCJkYKLy
         UvVKIhzTdT26oYigRns+Hz3PvK8kaes8ixydRvBjLGZIRR12502qDIMrlKw5PsOvLr7U
         1VMBn0JIMos7Wgv3V/GneIPtxbs2ZUDXOzMHSm65hyzo3VaWL532qQuSbepC8emsiNqw
         dEOuG7ck/j8n3U8hBle2TMD1tKCHytulNd2h2O1pA+t1jyJTbOgvVpExHgB0P4q3fEID
         MXmbneCFPvvBLxGAQU5H43JEvhOYfWmOv8vXuypbuRiRGj0hV/s6wV5Bq08AbM51txkL
         hRfQ==
X-Forwarded-Encrypted: i=1; AL+hErHFxB8vWMV6YJIzfSvvAewij4OG26P2z0wySNXristt5Zyle1MsmVklDYkS1e8rJt+Mjw8DUkP+@vger.kernel.org
X-Gm-Message-State: APuU4Z9UQSFE4AbOE4B0hU7+Ma10Y61yusPJdV1TDru6h4XD03yy8hcG
	gHeibVyPGR31Z2DLHr+VJ9UimBbd+vQPyifsabFFS6AJj8Vc0Bq9nfix
X-Gm-Gg: AZFdTZc+FqhP/K1LW1LAAyVGc/Hbi3e6SPNvkmjjvEr7dC/4QLGRfFR9/5D2GdgSlNa
	TBsGsYpo7AQ5wJSC7gfL9VP+JZfCusigej+1auOmUJpkYfMB6ptuDZw5dFMxHa5HHeDMMczgBrB
	kpW9NjJLF/xIVwzNeiCQLHzHPv2V3MdIY12ftAUKqoopCx2Z9vWPtiKUbYAwispyCRkFRE+7V+U
	5JNFlS3FfOJm1VUzsaVgD0N/O0V6aaNRsrKYjQxqtw8ANQVOpXKD6M+1/nO5JCKh75vNyYgfj+z
	fkR2IIMmGexrROzHxNZbEgOT7/6vOjkwoT/kpeDUNnFrEv2uCWe2Go5EZ2FoSSE7Je+8x0HrFhb
	5MB+Tt0pCE5AFnmDTlJQ7TeTf1x9YDzfHIa2eWmW97+zPhHFIDuwVmgrLqWjsmvpOsaqpgUyKI/
	W0pWkjSfowGQFfdPJ8IMQi/9C/MDBFQAeXUAhuVqHYA7ymjvTfFSEZshUNuJ+BJuL+P/d/BSRoA
	eRT3O7fDcCJ294dOkxm6UvV0KhKvv4rVBBqL1Sq/B18ELz4zaoluxMXWidfcP9WGgaqcH4f+xCn
	KofohAl7LSg1yKZzDRpbpZNfRm8dkOg3qXSH4LcVoxNet8HZTzNKbah/YL/V+7oUkcgyXmvis3z
	kqB9oYwbyugHuXJw8+ODGFo1e3Cfw5omywEhQJFP80TuwZpjnr9obpFRvleJuxjGvtgyMpSkUl3
	OOsK22imye9bPLuFPI9PnzXd6BYbKUHeHB
X-Received: by 2002:a05:600c:1389:b0:4bb:6519:477e with SMTP id 5b1f17b1804b1-4bb88813b35mr273527695e9.17.1795490212815;
        Mon, 23 Nov 2026 19:16:52 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a02-3100-ad33-0d01-f099-1558-bc26-fd06.310.pool.telefonica.de. [2a02:3100:ad33:d01:f099:1558:bc26:fd06])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884911e3sm473350865e9.6.2026.11.23.19.16.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 19:16:52 -0800 (PST)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: bpf@vger.kernel.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Puranjay Mohan <puranjay@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH bpf-next v2] cgroup/rstat: disable preemption in css_rstat_updated()
Date: Tue, 24 Nov 2026 04:16:42 +0100
Message-Id: <20261124031642.40616-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

BPF programs can call css_rstat_updated() with preemption enabled.
The kfunc calls __css_rstat_updated(), which requires preemption to
be disabled while it queues an rstat update. A cgroup iterator can
hit the lockdep assertion on both RT and non-RT kernels. The
cgroup_hierarchical_stats selftest can also hit it on PREEMPT_RT:
spin_lock_irqsave() on trace_cgroup_path_lock leaves preemption and
interrupts enabled there.

Disable preemption in the BPF wrapper after validating the CPU and
before calling __css_rstat_updated().

Fixes: 36df6e3dbd7e ("cgroup: make css_rstat_updated nmi safe")
Reported-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Closes: https://lore.kernel.org/r/20251119111402.153727-1-jiayuan.chen@linux.dev/
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Assisted by an LLM.

v2 places the preemption guard in the kfunc as Alexei requested:
https://lore.kernel.org/r/DN26CP5BB6O7.23ALW6CZUBYSD@gmail.com/
Since 8817005efbdf split out the BPF-only wrapper, v2 does not add
preemption operations to the in-kernel callers discussed when Jiayuan
proposed the earlier kernel-side version in November 2025:
https://lore.kernel.org/r/20251121040655.89584-1-jiayuan.chen@linux.dev/
v1: https://lore.kernel.org/r/20261121082843.44614-1-kmehltretter@gmail.com/

Tested in x86-64 KVM guests with lockdep on bpf-next 9867c61abbd4
(base and v2) and 2bf3351c5f89 (v2). Both tests passed on all 24 boots.

  Boots with an rstat warning               base     v2   rebased v2
  PREEMPT_RT, cgroup_hierarchical_stats      2/2    0/2          0/2
  PREEMPT_RT, iter/cgroup                    2/2    0/2          0/2
  PREEMPT (!RT), cgroup_hierarchical_stats   0/2    0/2          0/2
  PREEMPT (!RT), iter/cgroup                 2/2    0/2          0/2

 kernel/cgroup/rstat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index de816a43db9f..d72fe721cea0 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -131,6 +131,7 @@ __bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
 	if (unlikely(cpu < 0 || cpu >= nr_cpu_ids || !cpu_possible(cpu)))
 		return;
 
+	guard(preempt)();
 	__css_rstat_updated(css, cpu);
 }
 

base-commit: 2bf3351c5f894697e8443eeef5333d4c4ce90cab
