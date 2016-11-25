From: Kirtika Ruchandani <kirtika@chromium.org>
Subject: [PATCH] cpuset: Remove unused 'struct cpuset*' variable
Date: Thu, 24 Nov 2016 20:55:12 -0800
Message-ID: <1480049712-17224-1-git-send-email-kirtika@chromium.org>
References: <kirtika@chromium.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eGNT3+lfvU17e7AEMg99Gi5xIjXyDOkTRtKKlMcmtZk=;
        b=adFXRjuGmDti8ssYPihkq0jyTAZQu39gQW8ag25PhFWcNAby7dGuZvsrsFQ6EU64mT
         aJdTENgjqPJTzQnLmVkVcAIPVpsjjyi80zySfSujfVQG2TpD0IDcJeJW1v//EZmo3AWZ
         vUNQ7gMgHpa50NmU2fimgiousGL8mLAI+Yv7g=
In-Reply-To: <kirtika@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: tj@kernel.org, Li Zefan <lizefan@huawei.com>
Cc: Kirtika Ruchandani <kirtika@chromium.org>, arnd@arndb.de, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

'struct cpuset* cs' that is set but not used, was introduced in commit
1f7dd3e5a6e4 ("cgroup: fix handling of multi-destination migration from subtree_control enabling").
cpuset_cancel_attach() uses css_cs(css) instead. Compiling with W=1
gives the folllowing harmless warning, which we'd like to fix to
reduce the noise with W=1 in the kernel.

kernel/cpuset.c: In function ‘cpuset_cancel_attach’:
kernel/cpuset.c:1502:17: warning: variable ‘cs’ set but not used [-Wunused-but-set-variable]
  struct cpuset *cs;
                 ^

Fixes: 1f7dd3e5a6e4 ("cgroup: fix handling of multi-destination migration from subtree_control enabling").
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Kirtika Ruchandani <kirtika@chromium.org>
---
 kernel/cpuset.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 29f815d..af51460 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1499,10 +1499,8 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
-	struct cpuset *cs;
 
 	cgroup_taskset_first(tset, &css);
-	cs = css_cs(css);
 
 	mutex_lock(&cpuset_mutex);
 	css_cs(css)->attach_in_progress--;
-- 
2.8.0.rc3.226.g39d4020

