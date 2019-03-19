From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v6 2/7] psi: make psi_enable static
Date: Tue, 19 Mar 2019 16:56:14 -0700
Message-ID: <20190319235619.260832-3-surenb@google.com>
References: <20190319235619.260832-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Hcsw4jWN1hMUQas5fk8qH4/pHraV7uLJWBMnp4emY1w=;
        b=kkRScrd31+enlreI5z0oUEdvclr3JCffoxWlBxgdfvsiHG+l1qdm7rpPzTM74AffEB
         LfPQCYRFRkk5MVQ3Sswlo00GL73nAMZLv5CUblp9iwglJ0iHORdkEQbjcmg+RAyhtDSK
         O9SwD0WRSCDe+dqmFFjegvme5136ckLAkDUHKL6mVSMZP0sNbLYuvx8Ezdf706E/KfDY
         9fBeMjXuR3YFS9h86rSzKNERDrjqmseba0FXjHr885Gzr4DFfIZy5quXrHuTBM0lthvA
         9RXHgsNWSfaXr1nwN76MY2akaLAzeMLaPr9LrKq+sgEJNGwUCyr6TQwEqhNFsTdPpUau
         OdXQ==
In-Reply-To: <20190319235619.260832-1-surenb@google.com>
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
2.21.0.225.g810b269d1ac-goog

