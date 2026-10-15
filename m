Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D61387361
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 15:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792078433; cv=none; b=tRVTUx193TPH7wiS+X4zdY6Nq5RB9xGHlun4KH60rZxBj0vgoVeBj7iLPC38NGLH4M4gbz853kYqN0/JCi75CL3ngQ2kPRAr0aQjhiR6yWxKZN6JlFB5lOr+IXZi5kq0ok5iyZucpYVgnaxoLLKIuCmM9ABr/LXZ81cX8XuVGds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792078433; c=relaxed/simple;
	bh=O55RAvz0if8G1Ax5zhoCLemnqpQwrXQ3r6eLnjofQiI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=du6IW747Mpi0lrBDg5TUEnZ0OsFUYH1815eH9I8Yfbug2YJOW7yiDt4w77oQYhcQ2cwYVT8GhcX/Eqv7NpkLNyxITnR/a4W8Zr+wN4hKGOi4g4RwJPN9/3eEQgmx6LSz0MaYOpy7QvlIAMDj7UW2Mqrk+xkMnNQgqfFL/f2MZFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=J0S3hBOf; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="J0S3hBOf"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-98febe968deso2469001241.0
        for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 08:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792078419; x=1792683219; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j4tKjkoRHQBs/0qfSCONCIuiBtr3cfqRy92h/STkCYg=;
        b=J0S3hBOf6/D7ATcQ3+g/Aj8W6MDz7BdqdKU64XruqvNuTliWwisSpQTkZDLHcX/4H7
         N/x7wdxl8l3MRaffLuGAQwOPov3jHUQVqEeAgb8E9XSX600Ov0Y3Sv1N5+HQXCy+PsBG
         d2R/PEmfwOXlaQ64msnT2V1qWn+f22SG6iaKkl/faXGRWLjs0EDyunJAwH+fgbsjn8fL
         xTRh0Cu0N9ihBL1WeDfKI7SEkc14fhF3d26Dw9S4YBKrsb7OH50SN1KzJGa5KeCpojXu
         E7zzgzRPqffb2uagL/RTMqVhWLsRawcyltFpkr0SWqcLKSmj0BrBxUeTRmQn4Wd6a1g/
         ix3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792078419; x=1792683219;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j4tKjkoRHQBs/0qfSCONCIuiBtr3cfqRy92h/STkCYg=;
        b=dOf1ZD/SnzWrdxd6WsM5CRJ1kpz4kDZUqWROSPSPyO43HZP+ePNA68UVknqiHh416x
         X8fsw8o7uCma3sTX7d48jOX3RqgNr3vz+Df0Ck47cg7YByXsrbH2PoU5FrT1arJ0VEn1
         9X8XTPmciswWlPNxkT0WFah16adbX8MMv73ey6eUIkRMRkqRDbA0RAmTOgvw8T1BCV4m
         n/GPv4RXZPqH2S7Wygr0QshDzb7CKYo/M82wKqJQItnu8jtRrmuci2zTIMWrWyO1PmEo
         RlbD1jQv+OACj9g4TYJsaeyHqtLPmpXoExI2W9MLpyoEllj8Z2J6jmfPkUf8aoQ5eWK+
         ekFA==
X-Forwarded-Encrypted: i=1; AKwUvBwBn9jb70je0mGcZLlPYvpXlyQrzsTNpRP30SpXHw9Yyn2eaqp2fEMNijqsx2KudjgQDsld74kh@vger.kernel.org
X-Gm-Message-State: AFq9FYL/D2u37UBGlXqe+QN4gTklx1Evsn1HDiyDgKCRnjtUeJwJA8py
	WTm96MlfbodcKn0lFVXvoiynPcO3s8nWFyJ5uIKPV192LnBjXQlSBlKUf2GT6S/xjds=
X-Gm-Gg: AYBFou2KRNjUFbkt66CmWbT1PrzuEcpCab4H8sjoQ6TeJODiZbe8tTDBsSkBhdFSEQn
	3aHnB6BuUyibIVLkh+RLCzf+OQuKm3bVJAzNrtAnz3HVdjTtIEOJZrfrviXXFJrfHXLG6Yq9gO4
	6TXvn40sD7oTmHa0/lMaQWwxGHuPtTCzRL7TGH95QBXJP8u9fHBF1cH6FCsfDovF3PUcODY7CrP
	dmIrRiS8CPQ4pFAI8SgLzBGH89mtaNVFvF9hpXCjwhqWF8oDHtvR5cavsb4vSH9kyalOfw4srlP
	ZBrvSIdB0cOCt12ChguZ5NPDHgQWNIDzPYu5ZIxFzQtOTaUimijd4d1ZGbpXVGAlvCyfBBuDU+6
	rYGuWprSPcn57+9kioaIDPFOyRG5IATwQ9p6maOa4g0v7o5JrtP5/0gxQDr212OBnXoGCV4elcL
	xhWweycZebKrAVIbbPdI44i5GTq4D7VOc97SMSPvaR6/Ipf3MBV3wc6ZyV3Au2DMLmbjBV+OZog
	9wiecGghpcGim6+OHEQVKH1J42wddL7esfeWxJJ+FIq0qj+pLrtWPFwmgSMH04hqiCuKm2RUc/A
	3B41Jg6nIh3uHN6LgVsNefs54RD7SQ==
X-Received: by 2002:a05:6102:5110:b0:7c8:448:5237 with SMTP id ada2fe7eead31-7cb3a0e2580mr5832272137.24.1792078418833;
        Thu, 15 Oct 2026 08:33:38 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003f66ad9sm12986347241.10.2026.10.15.08.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 08:33:38 -0700 (PDT)
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
	thorsten.blum@linux.dev,
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
	tj@kernel.org,
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
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v1 2/8] x86/smp: Remove unnecessary WBINVD from mwait_play_dead()
Date: Thu, 15 Oct 2026 11:33:25 -0400
Message-ID: <20261015153331.1872641-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When a logical CPU goes offline via mwait_play_dead(), it executes
WBINVD before entering the MWAIT loop. On processors with large shared
last-level caches (such as Intel Xeon 6985P-C with 504 MB L3 per
socket), each WBINVD takes ~85-115 ms, flushes and invalidates the
entire socket's shared caches, and stalls the physical core (including
any online SMT sibling on that core) for the duration of the flush.

mwait_play_dead() places the logical processor into an architectural
MWAIT C-state—the same hardware C-states entered by intel_idle during
normal idle without executing WBINVD—where hardware maintains cache
coherency while the package remains powered and automatically flushes
core-private L1/L2 caches to the coherent LLC on C-state entry.

During system sleep (cpuhp_tasks_frozen), however, power may be removed
from a non-boot package's caches after all of its CPUs are offlined,
and the sleep-entry cache flush on the boot CPU only covers the boot
CPU's own package. Skip WBINVD in mwait_play_dead() during runtime CPU
offline and only execute it when cpuhp_tasks_frozen is set. Note that
wbinvd_on_all_cpus() callers (such as cpu_cache_invalidate_memregion())
only reach online CPUs, so a package whose CPUs are all offlined at
runtime retains its cached lines while powered.

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:  40.46 s -> 11.42 s (-71.8%)
  Online:   11.14 s -> 11.08 s (-0.5%)
  Total:    51.60 s -> 22.50 s (-56.4%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kernel/smpboot.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ba01a9e919b78..60a781dac9991 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1414,10 +1414,6 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
-/*
- * We need to flush the caches before going to sleep, lest we have
- * dirty data in our caches when we come back up.
- */
 void __noreturn mwait_play_dead(unsigned int eax_hint)
 {
 	struct mwait_cpu_dead *md = this_cpu_ptr(&mwait_cpu_dead);
@@ -1426,15 +1422,21 @@ void __noreturn mwait_play_dead(unsigned int eax_hint)
 	md->status = CPUDEAD_MWAIT_WAIT;
 	md->control = CPUDEAD_MWAIT_WAIT;
 
-	wbinvd();
+	/*
+	 * MWAIT C-states keep the caches coherent, so runtime CPU offline
+	 * does not need to flush them. System sleep, however, may remove
+	 * power from this package's caches while all of its CPUs are
+	 * offline, and the flush done by the boot CPU before entering the
+	 * sleep state only covers the boot CPU's own package.
+	 */
+	if (cpuhp_tasks_frozen)
+		wbinvd();
 
 	while (1) {
 		/*
 		 * The CLFLUSH is a workaround for erratum AAI65 for
 		 * the Xeon 7400 series.  It's not clear it is actually
 		 * needed, but it should be harmless in either case.
-		 * The WBINVD is insufficient due to the spurious-wakeup
-		 * case where we return around the loop.
 		 */
 		mb();
 		clflush(md);
-- 
2.56.0.385.gd3acb90ef8-goog

