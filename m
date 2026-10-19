Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536EC2F2619
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 01:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372495; cv=none; b=aEScePUhTxrX36cojy5oBlwsexYj2UaS0Gyve8tNZ02aDHVejDMtmi6Hjog+kPLhIuzlBtgA3NUvIfC13UO5I9s8q2jqoVuH0NFtAwJAGWgM3WXx0YnQehTfFKfpc/DcVzDlKS5D5BfxW9a3qexPZ8c2f7UYUuTS1S+aL4ht1hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372495; c=relaxed/simple;
	bh=MjziIp9HYumm33wp7eGvStS8U10QD8NX473m/jxckec=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dusC6hKZD64GWHyLZvOiUB+U/MG8iZ6VhKsqlDjiAbmA1041X4zZSIBW0tKRZZcWaCKF6MmN4BMq4ubs2CInGbIKwxKfhgvtFdPZMsr4EnvVSbTdBaE4u8FecYyp+F3JuNEllE+wPqywFz7BF7k3+utORjSGQ9CK/NhDvCjOx6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=H6winlpS; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="H6winlpS"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-988bb309c2bso866493241.1
        for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 18:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372493; x=1792977293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Cpnp3yMFelG0fvds3XdN1g7x4e9nS7OKWWPDPS530n8=;
        b=H6winlpSr+2NMDzblkRqAPbFFGaxkpvMQru8EVdwnlni9Ct740dXHTBe5BCI+jn34K
         4nFhwkDbkxTM+5u1ZkWvv8vqDU6D9S43ucJsDQmTlKI0Smi1fH6PIBPrir6EIw3ljOiQ
         22Zqy+GKv5HdYHmiMZKKn8SU78KZRCdwJB3BztHsRla/RCzel+N0FTngglln+sjrsKAX
         EMi8ISBmgjp40o04mJhM5Qwis8CyS0zKn2sG959OUqujQE7Qt/w8u3M6XB+0tqaz4xOd
         Sht0TS72FN41F5Eoilo2iBLLTTonr8js2/X6V1hEsl9SKMqFr/jc1jFGgiqfoswbg2zZ
         viEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372493; x=1792977293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Cpnp3yMFelG0fvds3XdN1g7x4e9nS7OKWWPDPS530n8=;
        b=D6dyTiaQlQBDa9zPKaXD64LDBD7OOptimGKXyX1B3J60hNibE3aK1CZDBEwARLWOk9
         q0wPK4spqw1ob76YOJ9ncdYdtulEAISrl1l/wrhib2T63D3yof2MEZz05a2leTTftK0N
         sKako72BhFlYLovo7YnYQhwpKL1nVt9DiXlcg7bOgkD+mLxD4KKTAFYvBPh+Y/l4UzV9
         NIsyGLWde9IlH8qb5szwdKq7Q8F7S64LMcuJKefU/D2BZw5wxbo8nk4WcQ049z0DyUVg
         V5UbJ/1PLLVAbmeUEiyUVhoDUsi/hyyevm0YR2xkct9cClOpwq5NuaujJN9k6J2ntG/2
         AhKQ==
X-Forwarded-Encrypted: i=1; AKwUvBzLCgO7mnUr3fQ82gMgUtc/5pdVInxp+wVzaA7126wxjZ2Vw8B+7GjcmIriSrUcWN8OiK98JKB1@vger.kernel.org
X-Gm-Message-State: AFq9FYLfk4rTLh2cOp7XI8k/J7721hSDMAJSWo0WwVhH9fOfaKARwSpC
	AhUSVrPJeqLfDfhlgdKUFD/e2untN9EzigbZf2bXkMJ3DXb6yVUSu4Ganw3O4FSo5qk=
X-Gm-Gg: AYBFou2f51nfcRC1F6FuUUUwB49RUBV0jVeoxglF0Lz1qx6424al656DyeGXA0vZ5kR
	hx5mVPyCI+p1UJo4ZulDqIkZHqnuKDvZwjLKauRL7S/rQly/IBYdkIE0+EXq8LgzZddbUjIT34r
	9P7hulFgdeA9TU/B+B+MhN8PlD6Oa125K5Vqon6VpCHwaZPPyeyCpiA/Pu2cQTY11pLaCEQ+bwf
	NfHn8b0N5NbgRFKXGw442dtemz7hHqB0s+dPQOU5qnTaYGhmyZt7z75iOHSUhJFfjrNxfWhq9IL
	tZksBo0F81kHFm5H/Z0/qMfauQa4MNr8vbKS8UZYLkAiPGoq09/AHrGm5H8ZbakPHn2Zxu8IdQy
	c552q6DVmd7G6fJpg3T0ws846tGG0hZ5HJSAgMChQRQQrdaKxt1SIKSejx06A1lLlqcSsNW3GfJ
	vHWA95Ifva2eOHfl7BM+IxWoQc16cKj1BseEn0GDQda2h5ndEDikAajoUa0JzicAm+5wlFhNQGL
	Qs4FdKnz7zlAT6EfLW1SzyqnpindP/FsuO5YmpD0P6QpGsC98X6rlsHvGQlhygSz+2NrypdjJxI
	qgkHNs8rNFwSzH/lAdI=
X-Received: by 2002:a05:6102:290d:b0:7c7:f976:ea9c with SMTP id ada2fe7eead31-7cc369118cfmr2079452137.13.1792372493221;
        Sun, 18 Oct 2026 18:14:53 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:14:52 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kees@kernel.org,
	rppt@kernel.org,
	juri.lelli@redhat.com,
	nik.borisov@suse.com,
	tglx@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	vincent.guittot@linaro.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	cgroups@vger.kernel.org,
	tony.luck@intel.com,
	david@kernel.org,
	mingo@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	ljs@kernel.org,
	zhangguopeng@kylinos.cn,
	dietmar.eggemann@arm.com,
	mhocko@suse.com,
	vinicius.gomes@intel.com,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	surenb@google.com,
	hpa@zytor.com,
	x86@kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rostedt@goodmis.org,
	gmonaco@redhat.com,
	jgross@suse.com,
	mgorman@suse.de,
	graf@amazon.com,
	linux-edac@vger.kernel.org,
	liam@infradead.org,
	ridong.chen@linux.dev,
	blum@kernel.org,
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v2 1/8] x86/realmode: Remove unnecessary WBINVD from AP startup trampoline
Date: Sun, 18 Oct 2026 21:14:39 -0400
Message-ID: <20261019011446.834487-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

trampoline_start executes WBINVD in 16-bit real mode before switching to
protected mode. This WBINVD was originally added in the 1990s for
Sequent NUMA-Q hardware (as noted by the comment in trampoline_32.S:
"Needed for NUMA-Q should be harmless for others"), whose cross-quad
caches came up non-coherent prior to OS initialization. Sequent NUMA-Q
support (CONFIG_X86_NUMAQ) was removed in commit b5660ba76b41
("x86, platforms: Remove NUMAQ").

Per the Intel SDM (Vol. 3A, Table 10-1, note 2) and AMD APM, the INIT
IPI used to wake secondary CPUs preserves cache contents and leaves
CR0.CD and CR0.NW unchanged (0, as already enabled by firmware or the
kernel). Neither sev_es_trampoline_start nor trampoline_start64
executes WBINVD.

On modern multi-core processors with large shared last-level caches
(such as 504 MB shared L3 per socket on Intel Xeon 6985P-C), WBINVD is
not harmless: each execution flushes and invalidates the entire
coherence domain's caches and takes ~85-115 ms per CPU while disturbing
active workloads on online CPUs.

Remove the obsolete WBINVD from trampoline_start.

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:  40.40 s -> 40.46 s
  Online:   65.83 s -> 11.14 s (-83.1%)
  Total:   106.23 s -> 51.60 s (-51.4%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/realmode/rm/trampoline_32.S | 2 --
 arch/x86/realmode/rm/trampoline_64.S | 1 -
 2 files changed, 3 deletions(-)

diff --git a/arch/x86/realmode/rm/trampoline_32.S b/arch/x86/realmode/rm/trampoline_32.S
index 3fad907a179f..14e56ea95416 100644
--- a/arch/x86/realmode/rm/trampoline_32.S
+++ b/arch/x86/realmode/rm/trampoline_32.S
@@ -30,8 +30,6 @@
 
 	.balign	PAGE_SIZE
 SYM_CODE_START(trampoline_start)
-	wbinvd			# Needed for NUMA-Q should be harmless for others
-
 	LJMPW_RM(1f)
 1:
 	mov	%cs, %ax	# Code and data in the same place
diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index 14d9c7daf90f..e5a3f03d6221 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -60,7 +60,6 @@
 	.balign	PAGE_SIZE
 SYM_CODE_START(trampoline_start)
 	cli			# We should be safe anyway
-	wbinvd
 
 	LJMPW_RM(1f)
 1:
-- 
2.56.0.176.g3575e65682-goog

