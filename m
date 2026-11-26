Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.60
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795672359;
	b=A6RY5S0WzAoOnpjv37fz7OCtBrzs8IgJUHaDkzZJhV7Vj/WhWQIJgHfSspWsce2gzexG
	 7dFMMrTudc6E9u4gHbS/ehaMtwRR1syAKINqIF5zNzES1XczqJlGUU8pf1mYZCZv2OTq9
	 T7EmoCNTK8NWfJbvOqrh6A2sxJBL1DWATvuMbC3DvCWhD5JYl67s7r+MCKvdkn7+Csrdp
	 xPCKeYdi5mhTC0PBMx6jCXgMFgFUuVJIeXdGCCEOzJgVE+/hfn1BbdFyCLL+V3yQhUFg6
	 n3RDuagKhlybufKT0Ex3zMbsuPgQVBGqYiASIps1TwEdbeYZPHjJaxyhrvbEAiWSR5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795672359;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Rp87fFVo66z0bNjr/QAS94X3yd/Vue0JZ5sGVAATgmM=;
	b=fAUhNQNJeQddXC7dZRmvjlTrCct/sGfZdMXE7Ff4QJ0ItajlThuadbvovVQ9dm3H+akP
	 WMJqahAh2aodSJuXAwf1cSEsKOKAb1V98VMLTspHroAwnGvpwO93q5YzSgtqD3F/LVJ6g
	 RJrPqYeXnycV5cAZlNOVtJbqnZU9e8bmKe0COTkyL7btevzItiI63RtriPIqG1yxnsIOX
	 C3fN+F49BdigOdH/KbWJnLES2v3iOCGjhirq3ESk6BYp6jgJLLA/De3DL6i/pTwsRf2N1
	 GQx2q600eP2Nn/nsow99KEYbSvRjBc50aafbhQdpTN9fYyfGuIunvn1rP/Joun9O/xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QG573tJa;
	arc=none smtp.remote-ip=91.218.175.60
Received: from mta0.migadu.com (out-60.mta0.migadu.com [91.218.175.60])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9751606A323
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 05:52:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9751606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QG573tJa
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PDJSASvlt9xJZen0jV2WM8AUZCLu70P+kYtSbovdDvs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795672356; v=1; x=1796277156;
 b=QG573tJaV654Sq6KseiWH+511Ij/DlsFvITfxRTQIVkHzfaXrNe3TpmmvmTK6hGzBqrZQkjV
 XGmgtLZfpdM/Pwa98GdUK9Meljq8EYzvB1PbtddLDt6iJNh6FRUeAXWb5OZW2kl/Rm23XEWB/bp
 hHZVVvsh76S1r+FAPLevpEN4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bb5f8296b098adfa;
	Thu, 26 Nov 2026 05:52:36 +0000
X-Mizu-Trace-ID: bb5f8296b098adfa
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com,
	tj@kernel.org,
	corbet@lwn.net
Cc: ridong.chen@linux.dev,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 2/2] docs: cgroup-v2: Document the housekeeping CPU requirement
Date: Thu, 26 Nov 2026 13:52:06 +0800
Message-ID: <20261126055206.251724-3-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261126055206.251724-1-guopeng.zhang@linux.dev>
References: <20261126055206.251724-1-guopeng.zhang@linux.dev>
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

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

The cpuset.cpus.partition documentation does not describe the
housekeeping CPU requirement for isolated partitions.

When full dynticks is enabled, changes to the isolated partition
configuration must leave at least one active CPU available for
housekeeping.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 2f792ff29425..36199da5c842 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2838,6 +2838,13 @@ Cpuset Interface Files
 	kernel boot command line option.  If those CPUs are to be put
 	into a partition, they have to be used in an isolated partition.
 
+	In addition to the CPU 0 restriction above, when full dynticks is
+	enabled with "nohz_full=" or the "nohz" flag of "isolcpus=", the
+	isolated partition configuration must leave at least one active CPU
+	available for housekeeping. This CPU must be outside the full-dynticks
+	CPU set, the CPUs isolated at boot using the "domain" flag of
+	"isolcpus=", and the CPUs in all isolated partitions.
+
 
 Device controller
 -----------------
-- 
2.43.0

