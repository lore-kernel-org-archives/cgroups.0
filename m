Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794913934;
	b=P7ff1MejGMkcHkOXPe3NSq39ubWtckxDxaxKEV89lvmd6ImpGUMMoN5UKsWS4/oKMX1t
	 yeGah3oDuqv1Juvj7sz4vXQupsAOydLeQba9EE0obP0TjXhs0RisyuIdy5VxMtvxNRl9c
	 JYW30SBWPrQpv07GQm1wN9taBTyob6v20gqmoNorYQ4bDYFnsIyaiYpDEpl0yRL/vhQuG
	 yY1T5BccAQEc9GL7j1gpZDb5JT5HZNqgQXpDYvPcnh+ftCvtFwdEKaO3N9epi+2qxDDsv
	 q/jJdyfWj1xKJlivZw2GWRH0MeM6EUn2HLNGTs25r2uOmjy+KaeS0d6iQ8NpaCtgP1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794913934;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YpT6onB1YW1VQSPE7BNmbI9BqwBaWK5/0IYsluHOeG0=;
	b=u8THSavhBFQWwP76Y/mM/NdRda6NF7pBPMwtnjRf3x1Dx+NRDcKEwQRf9GoDN/DwYlME
	 qmZRQ0f3qFKWkcOxjEoAC8jFAavxiezQEZdVhURxVZAattfbUAlvSB/2GeV6taVWzY+ZI
	 Jr74tJIdbuwNcTv+qu0ZOVNq2KRFuncZGl/HJcJL4Tvj+EN5Wc9wu7pb4yRmTTjrz++fr
	 4HfWOL7KqbVayex5TMZyFqFC+gLeoFNfIWQPQ7rsQEEQJAcSrnGf9pfuELh5z1vyuh4fO
	 lUAg5rhdd8jM+1L/OALpb/4n/C3ucUB+cDhy9b7ikF99jvvLfB6wVLbQs+9s6tZBPMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g4LDFMlr;
	arc=none smtp.remote-ip=74.125.227.130
Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB7B606A32A
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 11:12:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7AB7B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g4LDFMlr
Received: by mail-pj2-f2.google.com with SMTP id 98e67ed59e1d1-3b1478f06e3so1205446a91.0
        for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 03:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794913934; x=1795518734; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YpT6onB1YW1VQSPE7BNmbI9BqwBaWK5/0IYsluHOeG0=;
        b=g4LDFMlrT5xVMlwDAzPW6YO9fwosGC32nZ8FGPwgQ929gmyDlQJBvF7cdWdtE5cxbq
         AA6oag+4HbkPqb5A/aS7cQ4Bypozy14dRYwQxivHjjckNYbKALh6Ybs1Z7iDxwNl/Dyj
         3bNGFHApW4Gms7Rlml3EwnhUunTz07O8k7AdJCwqgbdkhFFsGB/mBlvAAuaBXhQp5F5B
         yP9ah/qyo7/dBzUkKidSA7HDL2e4UIAXIOEctXKSFChg7Nvlmj4R7zRQChhww6K0a8v4
         CcWf9ImLVQjogHY99Igr9wpp0wJo0BAmtRM0xDYMWq5PSOmIaoOWCfzdrtwx+F869Rw0
         qcGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794913934; x=1795518734;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YpT6onB1YW1VQSPE7BNmbI9BqwBaWK5/0IYsluHOeG0=;
        b=srqz8yKSucwI7BeUEFZ3+k/fQIjWbvzWv5v7pnxDqGubuuDTVA3/qZh3RsDGnC5qmQ
         P1hAOEqXskTska/Bd7+oVAJFhSplWddHS6/03NIRF2L2O73ghDXKdp5ghpKTmlTI4Mzp
         v40V88cOAseZTXo2zAB75LMhKC2rAI4skyR+0aQgJXpGuxpALoLSCi6ilnWh3pUvKVlQ
         X77R41kxWoegONRuhFXHtM6GMbLtE1xQu1EoRB6hIWgOberkekhHSusuGj/tTKC3mhQw
         7FFIHLAE3ON+wUnrndhO7/6Yamw633xDp9if8ji0Whaqg7Gjw2Ta7hYy6ps/JKyqReaz
         ll0Q==
X-Forwarded-Encrypted: i=1; AL+hErFpt+fiEqR6tm3vco8y4SG2Imeoz0jSzO5jiLxrJL5QmYph1g6YD3QFyYmDvamurm6gaO2i2GSp@vger.kernel.org
X-Gm-Message-State: APuU4Z8U85PqBpV6+J963kjXrAkSoIQSuYrxbMGrdbQct9E6DE2TnROZ
	gALOFeka5sWP6iUuSi8T9GvPGqxsFyc3Tw3BBZiMYYeIB3xdj/F0/k9s
X-Gm-Gg: AZFdTZcadyGvLUxPV7SWE3lWals6/97KvN1rGmKhav/Sbx624sR3U69GQ1TGuJPtgNT
	4nFhB27F3DkG1wFJGq+C9Z59ByyEh+iH20nKtiS3vWTXM2maGoM5pKjZgZgd3LZHglc6GwS72cb
	Uxco9s52nJVc6dWts16d5dGv7+9oew6/mxNwfOL1dZCvnfY2AwicO3DnVx129cFN9tbhhxSOMxw
	ZU877kZGln02gWeT+8Dkm0Uznl2oJwParTVOC76Zoz8K7dFv+sdeMPgDAf4WzWFmMqybY9GQGyF
	umT667evCIzHeU+ebifGJkXzCkDBiS0pbgtuDQYd1yKecRx0MZhrVdCYgblxJ4yu8pcshj2ZLAE
	0QjMno5mw8463TXkLWSRPhWVQm4YIx+weK9m8SVKGtAcfADzdVNBlQQ9ECJtv+kV0PJ2knhxEx+
	hYyGr7dmE9e8qbDLm6vGJTo4w/ZeCFuplMIUDBK2AmCpEs8CnNtdkeUXQcaYFidxJE+vkGr+F7z
	cgzntmdKfLAZRdXwjXQ2uWLaG04+vpVbDrmN9ZhcJCYfgs7CKRqv3uvmfjxK8Y+juU9SCHaQp9B
	+/43kYX5UBLHDyc1kA8SpBJIBcGSo5sdPXiQi9QrGMLjIQr0qIKWLYlIoP9/CyKUx+aPPo1vxML
	15PTy4xWbiJoSAw3hCZTpK3SK9bPr52hLNw1FkA==
X-Received: by 2002:a17:90b:3b8a:b0:3b0:9f53:e8a8 with SMTP id 98e67ed59e1d1-3b1b0b5f2c1mr13037200a91.52.1794913933750;
        Tue, 17 Nov 2026 03:12:13 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3b6da0fa8sm2752958a91.9.2026.11.17.03.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 03:12:13 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: axboe@kernel.dk
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	josef@toxicpanda.com,
	bvanassche@acm.org,
	cuitao@kylinos.cn,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH v2] blk-ioprio: check capabilities before promoting a cgroup to RT
Date: Tue, 17 Nov 2026 11:11:57 +0000
Message-ID: <20261117111157.2968-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
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

ioprio_set() and the per-request I/O priority of aio and io_uring only
hand out IOPRIO_CLASS_RT to tasks that have CAP_SYS_ADMIN or
CAP_SYS_NICE. The io.prio.class cgroup attribute has no such check.
Writing "promote-to-rt", or its alias "none-to-rt", to it changes the
requests of the cgroup to the RT class.

The attribute exists in every cgroup that has the io controller enabled
and it is not hierarchical. A user that got a cgroup delegated owns the
files of the child cgroups it creates there, so it can create a child
cgroup, move into it and write "promote-to-rt" to its io.prio.class.
Its requests are then issued with IOPRIO_CLASS_RT although ioprio_set()
fails with -EPERM for the same task, and mq-deadline dispatches them
before the best-effort requests of everybody else.

The delegation model in Documentation/admin-guide/cgroup-v2.rst expects
the settings of all resource controllers to be hierarchical, so that a
delegatee can only distribute further what it received from its parent.
This attribute lets it raise the priority class of its own requests
instead.

Require CAP_SYS_ADMIN or CAP_SYS_NICE for the two policies that raise
the priority class, like ioprio_check_cap() does. Check the credentials
of the task that opened the file, like cgroup_release_agent_write()
does, so that the check cannot be bypassed by passing the file
descriptor to a privileged program. The other policies are left alone.

Fixes: 556910e39249 ("block: Introduce the ioprio rq-qos policy")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
Changes in v2:
- Check the credentials of the task that opened the file with
  file_ns_capable() instead of the credentials of the writer (Bart).
- Document the requirement in cgroup-v2.rst (Bart).

v1: https://lore.kernel.org/all/20261116090529.69650-1-dennylin0707@gmail.com/

 Documentation/admin-guide/cgroup-v2.rst | 3 +++
 block/blk-ioprio.c                      | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..4424f9cf583e 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2409,6 +2409,9 @@ that attribute:
   none-to-rt
 	Deprecated. Just an alias for promote-to-rt.
 
+Selecting promote-to-rt or none-to-rt requires CAP_SYS_ADMIN or CAP_SYS_NICE
+in the initial user namespace.
+
 The following numerical values are associated with the I/O priority policies:
 
 +----------------+---+
diff --git a/block/blk-ioprio.c b/block/blk-ioprio.c
index 8fa8bca35062..acec62ee94bd 100644
--- a/block/blk-ioprio.c
+++ b/block/blk-ioprio.c
@@ -14,6 +14,8 @@
 
 #include <linux/blk-mq.h>
 #include <linux/blk_types.h>
+#include <linux/capability.h>
+#include <linux/cred.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include "blk-cgroup.h"
@@ -91,6 +93,10 @@ static ssize_t ioprio_set_prio_policy(struct kernfs_open_file *of, char *buf,
 	ret = sysfs_match_string(policy_name, buf);
 	if (ret < 0)
 		return ret;
+	if ((ret == POLICY_PROMOTE_TO_RT || ret == POLICY_NONE_TO_RT) &&
+	    !file_ns_capable(of->file, &init_user_ns, CAP_SYS_ADMIN) &&
+	    !file_ns_capable(of->file, &init_user_ns, CAP_SYS_NICE))
+		return -EPERM;
 	blkcg->prio_policy = ret;
 	return nbytes;
 }
-- 
2.43.0

