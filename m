From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v5 2/7] psi: make psi_enable static
Date: Fri,  8 Mar 2019 10:43:06 -0800
Message-ID: <20190308184311.144521-3-surenb@google.com>
References: <20190308184311.144521-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bO9Ut6bvYRKsfb9hG438t2Q8GfNMLAbUhphxvMlnr+Y=;
        b=Ddj5LQyjlIjwrHP5ehK+oJ/v9fKavvSearbFSnK49AD0M0Ijda7ZsanGy74D80pufg
         Lgkcv8juSAkThYZJjtNfyaTS7N2zDclYu45eWjgibFFwaNK8ylyh0oB7kmipClxsLsWG
         cxV5JRBPuMfAr5RQ52u+RYzzNTQvS3pNMIth63F6imHd2Ft3RZ8Yp5NVHeLn/kPYvo0M
         fkk9E5iqllL6RJSI9Lsi+bUnPFigtvVlPOKMb7S0PbnrLOFx3egU9xt6UxWQIFUF+QJc
         InrzrowbvnHoW34yZXO0BbCSWS+Yn2NAKH9O/c9a5tz3tcc/HyTAjgeMNowOQwuAJCBJ
         tlUQ==
In-Reply-To: <20190308184311.144521-1-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com, Suren Baghdasaryan <surenb@google.com>

psi_enable is not used outside of psi.c, make it static.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 kernel/sched/psi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 22c1505ad290..281702de9772 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -140,9 +140,9 @@ static int psi_bug __read_mostly;
 DEFINE_STATIC_KEY_FALSE(psi_disabled);
 
 #ifdef CONFIG_PSI_DEFAULT_DISABLED
-bool psi_enable;
+static bool psi_enable;
 #else
-bool psi_enable = true;
+static bool psi_enable = true;
 #endif
 static int __init setup_psi(char *str)
 {
-- 
2.21.0.360.g471c308f928-goog

