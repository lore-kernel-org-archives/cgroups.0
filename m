Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC6135957
	for <cgroups@vger.kernel.org>; Sat,  1 Aug 2026 04:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785557592; cv=none; b=Ykzff8yH+GpxO/Zx+6z5AqQmrU8xkUmemmU3cTWDCexRFSnQri6A/rmCXn3L/lxNodxMLRSGNiWx8MZdtWcoKXQgogOGnZ7AyOuEEkeO5sRGi8J4hsu91p65ya/n0hsc5M2Bt7Ve0FcB7p7ZnMMvFIsrN+6ggq58EJCbJqvLCtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785557592; c=relaxed/simple;
	bh=tE4aHWnPmx88w/MUAY0jqP8Q0YG2GlCJjM4idzsJ7dc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jDKK+REhF+xY0WpYPyb00ZC+F/XfKmmv6xkTTEg+B7ldizxYFF1YYOGNxQbTocxDQqhZyKYcPOEiNZ6GL16M7nFTz317O+U+KxHgUsM4QEiz8RrPs1vfEH6BRY9PFW/Fkj0qMWOke1CelGb+MwmjhBPBrDFeGcJJFdkkhoZVZ04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S5XtltjR; arc=none smtp.client-ip=209.85.216.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S5XtltjR"
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e4758ab46so2000799a91.0
        for <cgroups@vger.kernel.org>; Fri, 31 Jul 2026 21:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785557590; x=1786162390; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5XpdFy8Z6PUfDqbqo17LIsT1Kc72p948s1zae/y2clQ=;
        b=S5XtltjRBhus4DoWBW/FIqp3+OfWKNA99ujo1x4jcIENDJltrIm0XgIO0xx8oMbVmS
         dgZkDtS7wg4cwiGd5plXIskh39Le1co7AJpubBvOovVjyvVV4MNfLucbQcj6Gpi+Obq3
         Zre0dqNegcaipBZbH9n62KUeJkXRkOXsWZtyn4+SvLnfg7V6hxUczQ3JrIIt1WklkEVX
         equysbgaBOdLih3NJKDwDtpXemBOkDYQCAbdXoD+SjOy7zbTIX7PXJsc8l6NVlmWN6uF
         lAKjrAxxBk88g/CdA6neMgI8CTIYzZ8gIvf9MIm7U0PYZ7ajdSnMaAeGO+sakEPyqT+1
         DSMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785557590; x=1786162390;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5XpdFy8Z6PUfDqbqo17LIsT1Kc72p948s1zae/y2clQ=;
        b=MRs+r82v/VN63F6H6LZSdxAUy9VLaZBwBEvY5KzJ7LiDgjnEkMzjXGROD7ScHvu8PL
         QbIgvlW23CbdO6VIHSdhBhS17lDCUrLigtsSlqLL6XKPZ4CjTQRBo+qF/QjdrWKEldB+
         KmOZAjcPu241SOk7XMeRH6jzoyVjqDVnI4pI9VIDgHtp4GoReQVaG5r6a+0JJjuNkhon
         VGFjmr6S9lASk7EaHUM9MQLZbeZ02HV0lxk5PgSxV/dvoqSsjBQf+fCoMlGiSfARPSVV
         SYOOy9QE5BLqHiY6UZ4sULbVuZf30fLHy9RkHuU1TGZS8sXsIA896ScMVQ4/nZXNBCvL
         3L+w==
X-Forwarded-Encrypted: i=1; AHgh+RqcVXqYp4f7mXnn0jvqcBK2X7Ly8/a4cAinBHBRrhvfXN34DQaGjS8z1vG5tuE4tb1Mhy9Ohqis@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+VZQb02Bu8zgCaDYgNGbkjmoYiJ9hnxL15ePIG2eMhDQAJS1i
	eAdj5x/S6oblRPoAq8mkVo4DYm43XljocF6eu/FGo/QpDq+cQmfry8TuNHaXYoKKcv9hFmjTvGU
	NYdglBguAkg==
X-Received: from pjgg7.prod.google.com ([2002:a17:90b:57c7:b0:37c:c540:67c4])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c91:b0:387:e0db:bc26
 with SMTP id 98e67ed59e1d1-38fbc538106mr1983898a91.38.1785557590236; Fri, 31
 Jul 2026 21:13:10 -0700 (PDT)
Date: Sat,  1 Aug 2026 04:12:46 +0000
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260801041255.752039-1-wfelipe@google.com>
Subject: [PATCH] selftests/cgroup: test_zswap: skip test_no_kmem_bypass if
 debugfs is unavailable
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, "=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"

test_no_kmem_bypass() needs to read
/sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
verify that compressed pages are charged to the memcg.

When running in an environment where debugfs is not mounted or
CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
loop to terminate early and report a false negative (KSFT_FAIL).

Selftests should not fail when if debugfs is unavailable, and it
should print a message when it is skipped.

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 49b36ee791606..c4f7b66f1b206 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -566,12 +566,19 @@ static int test_no_kmem_bypass(const char *root)
 	int child_status;
 	char *test_group = NULL;
 	pid_t child_pid;
+	size_t stored_pages;
 
 	/* Read sys info and compute test values accordingly */
 	if (sysinfo(&sys_info) != 0)
 		return KSFT_FAIL;
-	if (sys_info.totalram > 5000000000)
+	if (sys_info.totalram > 5000000000) {
+		ksft_print_msg("requires less than 5000000000 total ram\n");
 		return KSFT_SKIP;
+	}
+	if (get_zswap_stored_pages(&stored_pages)) {
+		ksft_print_msg("debugfs at /sys/kernel/debug is required\n");
+		return KSFT_SKIP;
+	}
 	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
 			PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	if (values == MAP_FAILED)
@@ -604,7 +611,6 @@ static int test_no_kmem_bypass(const char *root)
 	/* Try to wakeup kswapd and let it push child memory to zswap */
 	set_min_free_kb(min_free_kb_high);
 	for (int i = 0; i < 20; i++) {
-		size_t stored_pages;
 		char *trigger_allocation = malloc(trigger_allocation_size);
 
 		if (!trigger_allocation)
-- 
2.55.0.508.g3f0d502094-goog

