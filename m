Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60DF33B966
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 04:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785817287; cv=none; b=YdnHY+8/c/1JtWt3lmVWC5lceIYidbQBfc40JDeyWzObQNH1w9M3u+z9BAuwvb9JkjykvVuHDPK26QDbC3WvIu8tcaQxVGGjdGbM9K2JYHySo8cukUfAZXQZhSwc+Bu41ZsuPiqRBxRkhw72G0D4OB7YAOj/sN3fWpliUYlmtQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785817287; c=relaxed/simple;
	bh=YvF04B1W/yLH1bakOmkI1fH/05ZqviVjuotOMDsX+Zw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qHT1krp/MuYMtyf8b55eRHagiGRvkO7xeRzE6+7Hc68VUgVH18TcCiY/Rx4RBjYHg4LvBV3V2KmQoKs3hYzoGWFDw1TzDtH70WlLp1YBy1r7MWqAnCrh5PS4Xfk2UQfm+p8vP+R+qIbdiLRQmpE/DWiIue3vaRbxJMUFOstjgho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L70Oq84N; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L70Oq84N"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84f0d3ab2f4so1455269b3a.1
        for <cgroups@vger.kernel.org>; Mon, 03 Aug 2026 21:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785817285; x=1786422085; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c05RDdz6OIqKa9ddqGc6Vs3UmFH3RFQyxs0qMB66mW8=;
        b=L70Oq84NLq+cOFJm9x+43xDUoba/JNUNhbTdRCTQvim84nMraEghiTz8Hfk9erHatA
         flVAVNmmeIpLPfbnz0EKsxqYf7Dz7SgTXPRr8zsWVJhS9FyS8qVnvs6wV4lAy7NI90pL
         NyfolDh2GNTRogS7MMPeRSWZSMaO18buCeTHAIUOi08vcnETpYBWOb6BJn7fnzoWlrtq
         YN79GrdT1bT88BsCfxG9NJSVKiGTYma5cdrM5sPJqg+hFzhAfCppbaU4Jzkkn+Y5i/UT
         ujxyvdK1rhAn+9c2xaRmsPAOewVWoOvXxHOeSLWF1FHAsuFLGSqla+TOy1FHhA02QdJT
         O5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817285; x=1786422085;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c05RDdz6OIqKa9ddqGc6Vs3UmFH3RFQyxs0qMB66mW8=;
        b=GKJB8GBqeBIkmx0E6WfxbHh+5DM4cCjQUoao1z7sMUnBiUBuL4pSEYYQNGpoQKLFmD
         0Smw3RNQbdi6W2w3Fn1Zx0XtQbYrvQ6QSdssHCrCm2zIlMOYdMdeYAHDv3fXIhaC+a1X
         pHkCQVw7Q0CvvGphkVn4TYE4Ec5L6dWgzvB3cEGQrO/qCVyXj/Kw4c3VqviYrj+iZgeL
         V3A2jFU7o1n3XuN4yLo1Ky3SodQt6hrWYk8+lNso224Gg8pZfOLHd2czK+TaDDnfsJmL
         c2ARZq6VX/1CDMOT7vXF26UzFxOguD+R70+T2JT51T2wGOjfdydmyn5iF1uQXq3rHyJP
         aYww==
X-Forwarded-Encrypted: i=1; AHgh+RpbZK4p54ohmXd0FmEvJRwuOYqeVSMuz9ZkHIi3/Sicgj+ErYALQJ6rNn1CGAUMaV8UnOWoJWe9@vger.kernel.org
X-Gm-Message-State: AOJu0YwtX9ILD7q9Oi6db2jltq0Lq33kVmzElkci9cDFyJRDqPLtkKqa
	F+cNm3EfNkW8G7wNmAJ5aYriQDuiyEOdDvivivsCG8KAwqnOLczi4q/xLFajdnydIsbNnJEST0x
	b7CyLU5bXRA==
X-Received: from pgay6.prod.google.com ([2002:a05:6a02:4966:b0:c9b:c3d4:2a18])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1791:b0:848:2f71:b65b
 with SMTP id d2e1a72fcca58-84ee49ac7d9mr11925666b3a.70.1785817284851; Mon, 03
 Aug 2026 21:21:24 -0700 (PDT)
Date: Tue,  4 Aug 2026 04:20:44 +0000
In-Reply-To: <20260804042053.56940-1-wfelipe@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260804042053.56940-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
Message-ID: <20260804042053.56940-2-wfelipe@google.com>
Subject: [PATCH 1/2] selftests/cgroup: test_zswap: retry subtree_control write
 on EBUSY in test_zswap_writeback
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"

When running test_zswap on a single-core VM (-smp 1) with 4GB of RAM,
test_zswap_writeback reliably fails on the initial run after boot.

In test_zswap_writeback(), after waitpid() reaps the child process created
by test_zswap_writeback_one(), writing "+memory" to cgroup.subtree_control
can fail with -EBUSY. Under Cgroup v2, enabling domain subtree controllers
is forbidden while any tasks remain in cgroup.procs.

When a child process exits, waitpid() reaps the zombie PID immediately,
but the removal of struct task_struct from the cgroup task list is
performed asynchronously via an RCU callback (release_task). On
single-core systems, this RCU callback is delayed behind CPU softirqs,
causing "+memory" to fail if written immediately after waitpid() returns.

Fix this by adding an EBUSY retry loop with usleep(1000) around cg_write(),
matching the existing cgroup cleanup pattern in cg_destroy().

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 49b36ee791606..312d51887a1d8 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -407,8 +407,11 @@ static int test_zswap_writeback(const char *root, bool wb)
 	 * Thus, the parent's setting shall be what's in effect. */
 	if (cg_write(test_group, "memory.zswap.max", "max"))
 		goto out;
-	if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
-		goto out;
+	while (cg_write(test_group, "cgroup.subtree_control", "+memory")) {
+		if (errno != EBUSY)
+			goto out;
+		usleep(1000);
+	}
 
 	test_group_child = cg_name(test_group, "zswap_writeback_test_child");
 	if (!test_group_child)
-- 
2.55.0.571.g244d577d93-goog

