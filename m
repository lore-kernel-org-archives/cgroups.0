Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795249735;
	b=tQ1NacpaFBOBtjDJ0iBXWKrwBr10Paq4zgyE5IJ/k0LLw9CXmPSvg4yUtSuviSBK2ala
	 mVyvMqf1mhwE+Z4ozzp+cU4tJdN7HWk9LVjLWeRQ9jzcsxvAi/uLLZ9Q7nElyYtOG32Qg
	 wKo/toqju4AaNe57w30b8kl+b0rdiHZF1+gN6NYIyeB7zDHTxX7wqHBsbdj7DPY3uk31Y
	 P6e8jAHMrIzmqUq2Q/Jh4eAeNwlkokmANkkmzfrBeR1POLTAOx6geAaFLTKR4BLJnimCx
	 /9X13vKqWi9QhCYNkjylydRg4d7lMMvgt4JUw34P99vGK81G7g8aKoXKjf6M0EWesgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795249735;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vA0VgrN/AJbvlL7DFILZtRf61HlqOG1LXfr01uh4umc=;
	b=WlUPtz99PDnXxL9yp9Skgp74gH5YqnVPvdBkurWBcLKd2KZtySc+hrjLhpfUaVoMyJaG
	 boeA+Dl8rr/ryQY7KaeO+TiLtmKH0Q7KqpKxT645ECkYVMhVJDSYkKPKt0u+qdk40neCq
	 3elPfjZdWNXp5HXPQyzM+ufD99UJx9fzzJQmBkR7YCwKxtGu3ZqqAbePd3dVDr+TtrOdt
	 srt44aEPNguv6yJpHQukduidoUcQIvjh9S6hGZdEdWbPJiP/uKdGOvdnyo+OvUKSaF4lN
	 RfdTnVvbfChoskJOtIvsSgAZ1noNK3oox4zwLPxq4iO4lrxNk8jIcIStm2EruUMw4Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JWTvHv2M;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86562606A325
	for <cgroups@vger.kernel.org>; Sat, 21 Nov 2026 08:28:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86562606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JWTvHv2M
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-491846221ffso1310746f8f.3
        for <cgroups@vger.kernel.org>; Sat, 21 Nov 2026 00:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795249733; x=1795854533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vA0VgrN/AJbvlL7DFILZtRf61HlqOG1LXfr01uh4umc=;
        b=JWTvHv2MoSyG38P2ut6CGuOo+RMs6DecQiq+J9y9TQm+XNetpG7gWzCduF+1Dq+EcA
         Y3FOLIeetVe7r6I7AkfF3FK/laIIZPksmjpIosdGBa3KNHqZUb+OZKE+yM+md43V29w2
         sovrWZbaKaw9XEZHUAgcsp3KxNw5lz/6bbZZEGeXpRPcTr8OJMWGps9G3UBVpq/fZnXf
         Els2ob3iY6686NjEuUwxO4w+d3OEy5z9s2KtJHmHa57HDi3rGQggnI0NaEjh365jLsnZ
         V1namk7Gmdj0DXYajWjOCesPRxk5t7JckHbva5Y3AzE/T0AJmDsb7dApwqBH9cY66ciZ
         rdzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795249733; x=1795854533;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vA0VgrN/AJbvlL7DFILZtRf61HlqOG1LXfr01uh4umc=;
        b=hWSo3A3mN3gW48MQh40yU0TM4KJUITPOWyc1M+1Txo0BVnWxf63CgmN41c8ngmJGpv
         pmOlnSMApsuy34CaM9MgrSL6HlroAxb5FH5F3Xz43ZfuRUOdfDTJ0mMaHbFQVVlKI6Np
         hdCMuLdiE2BPfDMHeghUQ4hWb1BDiik8iN01nLijdwk/Z0CJO9Pcj+TrNL8JMpaBpt4C
         DkoLjufYcKaebBBCRc/vkszEMKKzo7TWsbR9yBTmxk+Wk1st5ywXAZEqZAK4cQljBhGs
         bNHxOTv8YkMOpESFbc4g75OU7GjSndLGx3kIAKeuAGAqW5IAPI0LnKpmwrFYepqlMDrk
         GZqQ==
X-Forwarded-Encrypted: i=1; AL+hErEV5Ly3a7kuhZ0DS/+pMuubID4jbxRrDX8nd2Bksvsj9LdQ5iUuR07pgM39T/cJTLdWBOd6iBf4@vger.kernel.org
X-Gm-Message-State: APuU4Z86DPsYbA4AoWPXAZiTaP4de4z5qLi/Q/AtRcYWxf2tgyoCRyRr
	vk4GfcNssveEHPpRofSMpCZ+O0Lr+SRl3b/74WIV5lUo4/hrHSElaA9B
X-Gm-Gg: AZFdTZdMoH1YQPPIASac3v+8kZTBmRnbcpOWPF8iTRg0W49qWOd0pepLL14ygJZe5aw
	qm5lrHfTiXm75QK4LZjqBTrk1eBnYVTfg4eT/sCtVbAcFgMdVBogo6uwN+qDW+f3suvpB5bNpUP
	afy0GzH+hyXFQKXWlZFE+heHiC5sL7lH48+bzCsEB75fEo8yr8H1bvlUotv8hJfLVKPDAOLtMbM
	vncSJCHC+3K/1f0z9gwT1r1Y6UidMmsXKARRklNlJozUTJQyp06tANydFPVWvzf9KNS+NyHWvgi
	OytQHryJ7Xjs3pQoPgm+yhGzKqmKHLZW9uwIUf7+9s3lE6lsGGiFr5XTVMBlN6foHPuBr9V5mgJ
	HygaSsHq+pIyUpOH9+S9/n90hvV0aK8dclnCAvySamHp0yah0VeaWUlm1jz/u1MUt7THSfZgv8g
	T4MBbtY/Tvnpki47VwhFgpXf1Fw4JaUJabTav4RrjCcoN2TCnWi6A0lykhKbYJiVA/i0KwieCrr
	AqMlu+CRbL8Wy4bTc6BGcEXzWO2Ti2cyNAfRxJTvXr5Aja1Pc+e7WGI/4CQ1qQKXiUXT9LVzzPq
	4D/cmoUZww8zyX5WnitdabOLh1sLjQwc5KAt5C7WXwAR6kiYtRy0GuGsgt+ti2rzfc0XjQmmlvA
	2NJlYYpqdRCo0+uFx3Qx/v2PrFznIgMYeQUwj6fripQgC38+Vr+ZFqXDjtEmR7czELRGVgOxomi
	jBnBa/04wAFBDWUknHKPWHK2loBgtgm8yn
X-Received: by 2002:a5d:59c9:0:b0:4ab:f5b0:a7fa with SMTP id ffacd0b85a97d-4abf5b0a975mr10806542f8f.33.1795249732684;
        Sat, 21 Nov 2026 00:28:52 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a02-3100-aeb0-6801-ad74-bca0-dc5f-7242.310.pool.telefonica.de. [2a02:3100:aeb0:6801:ad74:bca0:dc5f:7242])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb4341sm10892378f8f.4.2026.11.21.00.28.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 21 Nov 2026 00:28:52 -0800 (PST)
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
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Puranjay Mohan <puranjay@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH bpf-next] selftests/bpf: Disable preemption around css_rstat_updated()
Date: Sat, 21 Nov 2026 09:28:43 +0100
Message-Id: <20261121082843.44614-1-kmehltretter@gmail.com>
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
Content-Transfer-Encoding: 8bit

cgroup_hierarchical_stats triggers a lockdep warning in
__css_rstat_updated() on PREEMPT_RT. The counter runs at the
cgroup_attach_task tracepoint under spin_lock_irqsave() on
trace_cgroup_path_lock. On PREEMPT_RT this leaves preemption and
interrupts enabled. On non-RT it masks interrupts, satisfying the
assertion.

Disable preemption around css_rstat_updated() so the updater can queue
the update without being preempted.

Fixes: 36df6e3dbd7e ("cgroup: make css_rstat_updated nmi safe")
Reported-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Closes: https://lore.kernel.org/r/20251119111402.153727-1-jiayuan.chen@linux.dev/
Link: https://lore.kernel.org/r/fmey2ektwdk7l5aktjz3xb24x3pk3lxy3gfld7reazal6xa6u2@tmryedehqhql/
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Assisted by an LLM.

Ran test_progs -t cgroup_hierarchical_stats on bpf-next 9867c61abbd4 in
x86-64 KVM guests with lockdep. The test passed on all eight boots.

  Boots with an rstat warning   Before   After
  PREEMPT_RT                       2/2     0/2
  PREEMPT (!RT)                    0/2     0/2

 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
index 8fc38592a..d4babda81 100644
--- a/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
+++ b/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
@@ -6,6 +6,7 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_core_read.h>
+#include "bpf_experimental.h"
 
 char _license[] SEC("license") = "GPL";
 
@@ -76,7 +77,9 @@ int BPF_PROG(counter, struct cgroup *dst_cgrp, const char *path,
 	else if (create_percpu_attach_counter(cg_id, 1))
 		return 0;
 
+	bpf_preempt_disable();
 	css_rstat_updated(&dst_cgrp->self, bpf_get_smp_processor_id());
+	bpf_preempt_enable();
 	return 0;
 }
 

base-commit: 9867c61abbd44f7053a871566b3d982f62c6d8dc
-- 
2.43.0

