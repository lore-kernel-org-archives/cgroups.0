From: ufo19890607 <ufo19890607@gmail.com>
Subject: Some questions about cgroup aware OOM killer.
Date: Thu, 19 Apr 2018 08:17:04 +0100
Message-ID: <1524122224-26670-1-git-send-email-ufo19890607@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gC5HfWu9MN4rgGEJvSrBc0tHAVh75vqqzP9R2ktQxOU=;
        b=jlZoW3JreFMlYIdNYeRFJ+CFj79iuit5JUhtYKna1DQSA6xzG/a/oifiOzZsvd0wSD
         Edx4mJtY7Kd34GABA0zLnx6yKDf7X+/xOlRi819Mmgh3/w/y0+S6+E0wPABxym04ZB6K
         rdnIRbwRJ/KjfXabCTpj7CZKjK/DSlmZyOExKj7BlM89PKLfCQul7ssKMQYSBCLcQNXD
         0GieE8tPSlqcpDIQ2oBV75rUYQXC5cVHiPnecS4oSEWsPPG3eQ0I5VYpmNQGCcdPOTDj
         n4nu+JlL/2GXVAJg1iCbKriMinVwaL6KcAh30y/lM2ObZvdj/V0N/4PtFZ30Zyl4ybFk
         3NzA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: guro@fb.com, mhocko@suse.com, vdavydov.dev@gmail.com, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, akpm@linux-foundation.org, tj@kernel.org
Cc: kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, yuzhoujian <yuzhoujian@didichuxing.com>

From: yuzhoujian <yuzhoujian@didichuxing.com>

Hi Roman
I've read your patchset about cgroup aware OOM killer, and try
to merge your patchset to the upstream kernel(v4.17-rc1). But
I found some functions which in your patch([PATCH v13 3/7] 
mm, oom: cgroup-aware OOM killer) does not exist in the upstream
kernel. Which version of the kernel do you patch on? And, do you
have the latest patchset?

The faults in PATCH v13 3/7:
1. mm/oom_kill.o: In function `out_of_memory':
   /linux/mm/oom_kill.c:1125: undefined reference to `alloc_pages_before_oomkill'
2. mm/oom_kill.c: In function ‘out_of_memory’:
   mm/oom_kill.c:1125:5: error: ‘struct oom_control’ has no member named ‘page’
   oc->page = alloc_pages_before_oomkill(oc);
     ^

Best wishes
