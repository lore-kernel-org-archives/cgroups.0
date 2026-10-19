Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3486F314B8C
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 01:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372508; cv=none; b=hrwd/Yoy2v8eSRSpeM7fswpKX0NLSTmlkMrcBmbpKesN/YwDzoKCJEn/vDWGCN0uTppiuXR1H0/EGcZmp/cZ8yDMoMHasFY5XwBbs2x/Z7ZWnV7PNsoHv5u54eEOHL0rFoGoajZUDSYqQGWqsyFkp87qm6Q90vbCf3ue7uZqpjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372508; c=relaxed/simple;
	bh=1dTkByrcgDmsfb6ZwowQ9ilpEPQjcySb7S7SITSyFjg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVDNbSh0wG1ErwUfjWxIJmzsG0MIJ97rWkhLdwO8hKVVxtUBDlEkdrX4gKEN80vFUdqwq+i6+jetHAZVS5cThvyXZJKenAdHXv04/UCJg2mymMGo70+SdWx/m/SVM/hObqzlgKTrw51nE+BgbmsEOy2sjM1sSv2qXSeWM1GTu6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=Yy1UjT5m; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="Yy1UjT5m"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-7cc013095d4so467860137.2
        for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 18:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372500; x=1792977300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=z5LyhpH+32vicnnX5+Nfrq1TH+85hwwraSFoho5291M=;
        b=Yy1UjT5mYqOt+a/p+XRFqAoHKcRWRNnnJ+GpIGz+6SBZqGRFKReI2GuBRalEevraNH
         UINSDEJGXy2ctXEsx1pcDajhOq6zgkwtu+jW3lhjgpnAfsyvpEOoeNhU8Pjo280A9y43
         iDm2MyeIsWlnmOk7Lg4HVrQI/ul3QlUwO2dSDLIfYZ0J7mM0zSNJ6JuAWjO1hPtY47qi
         fmdKE72EF11q5im90PmqJbAAJPfodnXyCj+vamfKSF97wPkHtC1vTrljYQKY9bogTA6A
         PGs2HfxgPAC43iEflq7gKqIcNMa8i3Js/WmhiU2a7FnPpPRo60Sj4LR5MKLco0HZmaJT
         D6BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372500; x=1792977300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=z5LyhpH+32vicnnX5+Nfrq1TH+85hwwraSFoho5291M=;
        b=IczWaiD5YYPHFUl1quzEAewGF//OjksDm5H4/2YUDjK4DsKmG1r+EAzViRx0KyfIfn
         GhjVXziJLabKO6t538yWqFABMASrBX2OEq1+oTwG/uZfGekzL9Bglz68VSUpYmPpCfox
         VkxoUo7UucFUUdTvT4iwVborS4auh0BxEyipCgyrjdSPcRnIRwAx9mmoKuhvIC4Dvs2q
         vvAf64rnhACLe96b7byLNVWVMe5pFGvFrD8WO61be61OkRy739Z3lsK+sxO/4/XVP76M
         1vbZfrZ8XC7GwH+cmZVNdb4pbLOZ//NqOV6Uwerogo4wpBN3USNuFzXcwn5RfqN0UFXA
         hdNQ==
X-Forwarded-Encrypted: i=1; AKwUvBxE9vGUJiU+DIU7IHjW7sD4AWjIXUpVz2MepFWXnhpF3kLYgvuf2lErjDdf/X6xRzDhf094DuB/@vger.kernel.org
X-Gm-Message-State: AFq9FYIxLK1/HzECeXWerl6GXWvAdk+KbRgyXiMf+ftu+JUhOn+cRA0B
	aKh4rQLaKzoTlooFtQ9Hv69qUf3ZsstZB9dPovZT6r9bctbp/L1kFuma4nfI3LSMVIc=
X-Gm-Gg: AYBFou2MSlOMACo85wvcRhFg3wwHtFqlUemXt1UB5tc/ZGZ8hRU9i5Ns56M8uMTMNuy
	52jBd9lElK8aTMlSi1PP74SJ0Pc19ZxtvTDOuCQzdDtPbWk0F3nbsEYjJFUm0I6N2DKer7BKMzT
	W+VCFNN8w35VysNCPt9c9yoLBu/MufKTcHWEoTj2HGg7/+4v3omwgnnbqX5ApgnwcV8CYemsq5b
	aDQumJZZl9SKzL/k8IVeJXrpNFCCDteFecQA8mu9s8Vy9NRRtUhhy3wS9nuJB15a+zXifGGCQH8
	WCUhW2JXzlQ0NvGdkqHrOuv16af8FWFl0/sgZq9MtG24yDlugRh8TjuqE9WozPQnUxUmlo+KwFv
	XtAM++/KvrXTuOFkKyjNoJwedEt3TIJ/j4MNCauqthdS5m6hM/Tydh8mAV07xsSK6Ab8IOXDzyX
	RNcFJUUdnf0LzkngjRjhz2Htnq1wYEkbL8vNz9IbdyFCf4RsuLHKZWJ3YoK6J5kq9wVw0Ep5o2V
	BHQww4f7rRmpZLMzxswDVxFzQWgsO59srdRc8ZJWOGaVu+AzFhZHee1qsxlgZ+EiSNRDXwLK5Kp
	CGdIUclks6ZBjxrxb61rUDb3mSPi7g==
X-Received: by 2002:a05:6102:419e:b0:7c3:6466:3155 with SMTP id ada2fe7eead31-7cc36aa4af1mr1518608137.33.1792372499968;
        Sun, 18 Oct 2026 18:14:59 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:14:58 -0700 (PDT)
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
Subject: [PATCH v2 4/8] x86/cacheinfo, mtrr: Skip stop_machine rendezvous in cache_ap_online() when MTRRs match
Date: Sun, 18 Oct 2026 21:14:42 -0400
Message-ID: <20261019011446.834487-5-pasha.tatashin@soleen.com>
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

When a single CPU is brought online at runtime
(cache_aps_delayed_init == false), cache_ap_online() unconditionally
calls stop_machine_from_inactive_cpu() to rendezvous all online CPUs
while the incoming AP runs cache_cpu_init() to disable caches
(CR0.CD = 1, plus wbinvd() when X86_FEATURE_SELFSNOOP is not set),
reprogram MTRRs via mtrr_generic_set_state(), and re-enable caches.

During initial boot (cache_aps_init()) and across warm CPU offline/online
cycles, the AP's hardware MTRR MSRs have already been programmed to match
the saved mtrr_state. Stopping all online CPUs in stop_machine (and
flushing caches on the AP) when the AP's MTRRs already match mtrr_state
is unnecessary.

Add mtrr_generic_state_matches() to compare the local CPU's
MSR_MTRRdefType, variable MTRR ranges, and fixed MTRR ranges against
mtrr_state (including k8_check_syscfg_dram_mod_en() on AMD), and check it
on the AP in cache_ap_online() before invoking
stop_machine_from_inactive_cpu(). If the hardware MTRRs already match
mtrr_state, initialize PAT locally on the AP and return.

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:   9.63 s ->  9.85 s
  Online:   11.11 s ->  8.69 s (-21.8%)
  Total:    20.74 s -> 18.54 s (-10.6%)
  cache_ap_online() (cpu479 online):
    7,704.0 us -> 4.7 us (-99.94%)

2-socket, 512-CPU AMD EPYC 9B45 (N=511, mean of 10 runs):
  Offline:   4.53 s ->  4.51 s (-0.4%)
  Online:    3.92 s ->  3.15 s (-19.6%)
  Total:     8.45 s ->  7.66 s (-9.3%)
  cache_ap_online() (cpu511 online):
    1,354.6 us -> 6.4 us (-99.53%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/include/asm/mtrr.h        |  2 ++
 arch/x86/kernel/cpu/cacheinfo.c    |  7 +++++
 arch/x86/kernel/cpu/mtrr/generic.c | 49 ++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 76b95bd1a405..0527e216808c 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -61,6 +61,7 @@ extern int amd_special_default_mtrr(void);
 void mtrr_disable(void);
 void mtrr_enable(void);
 void mtrr_generic_set_state(void);
+bool mtrr_generic_state_matches(void);
 #  else
 static inline void guest_force_mtrr_state(struct mtrr_var_range *var,
 					  unsigned int num_var,
@@ -106,6 +107,7 @@ static inline int mtrr_trim_uncached_memory(unsigned long end_pfn)
 #define mtrr_disable() do {} while (0)
 #define mtrr_enable() do {} while (0)
 #define mtrr_generic_set_state() do {} while (0)
+static inline bool mtrr_generic_state_matches(void) { return true; }
 #  endif
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/x86/kernel/cpu/cacheinfo.c b/arch/x86/kernel/cpu/cacheinfo.c
index 13ed16527905..64796d5b34fd 100644
--- a/arch/x86/kernel/cpu/cacheinfo.c
+++ b/arch/x86/kernel/cpu/cacheinfo.c
@@ -770,6 +770,13 @@ static int cache_ap_online(unsigned int cpu)
 	if (!memory_caching_control || get_cache_aps_delayed_init())
 		return 0;
 
+	if (!(memory_caching_control & CACHE_MTRR) ||
+	    mtrr_generic_state_matches()) {
+		if (memory_caching_control & CACHE_PAT)
+			pat_cpu_init();
+		return 0;
+	}
+
 	/*
 	 * Ideally we should hold mtrr_mutex here to avoid MTRR entries
 	 * changed, but this routine will be called in CPU boot time,
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 67cf69f24b00..8760a7b4dc38 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -981,6 +981,55 @@ void mtrr_generic_set_state(void)
 	}
 }
 
+bool mtrr_generic_state_matches(void)
+{
+	struct msr val;
+	unsigned int i;
+
+	if (!cpu_feature_enabled(X86_FEATURE_MTRR))
+		return true;
+
+	rdmsrq(MSR_MTRRdefType, val.q);
+	if ((val.l & MTRR_DEF_TYPE_TYPE) != mtrr_state.def_type ||
+	    ((val.l & MTRR_DEF_TYPE_ENABLE) >> MTRR_STATE_SHIFT) != mtrr_state.enabled)
+		return false;
+
+	for (i = 0; i < num_var_ranges; i++) {
+		struct mtrr_var_range *vr = &mtrr_state.var_ranges[i];
+
+		rdmsrq(MTRRphysBase_MSR(i), val.q);
+		if ((vr->base_lo & ~MTRR_PHYSBASE_RSVD) != (val.l & ~MTRR_PHYSBASE_RSVD) ||
+		    (vr->base_hi & ~phys_hi_rsvd) != (val.h & ~phys_hi_rsvd))
+			return false;
+
+		rdmsrq(MTRRphysMask_MSR(i), val.q);
+		if ((vr->mask_lo & ~MTRR_PHYSMASK_RSVD) != (val.l & ~MTRR_PHYSMASK_RSVD) ||
+		    (vr->mask_hi & ~phys_hi_rsvd) != (val.h & ~phys_hi_rsvd))
+			return false;
+	}
+
+	if (mtrr_state.have_fixed) {
+		u64 *saved = (u64 *)mtrr_state.fixed_ranges;
+		int block = -1, range;
+
+		/*
+		 * Ensure MtrrFixDramModEn is clear so fixed MTRR reads do not
+		 * expose K8 RdMem/WrMem bits and cause false mismatches.
+		 */
+		k8_check_syscfg_dram_mod_en();
+
+		while (fixed_range_blocks[++block].ranges) {
+			for (range = 0; range < fixed_range_blocks[block].ranges; range++) {
+				rdmsrq(fixed_range_blocks[block].base_msr + range, val.q);
+				if (val.q != *saved++)
+					return false;
+			}
+		}
+	}
+
+	return true;
+}
+
 /**
  * generic_set_mtrr - set variable MTRR register on the local CPU.
  *
-- 
2.56.0.176.g3575e65682-goog

