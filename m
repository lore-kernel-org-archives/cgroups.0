From: Mina Almasry <almasrymina@google.com>
Subject: [PATCH v6 3/9] hugetlb_cgroup: add cgroup-v2 support
Date: Sat, 12 Oct 2019 17:30:18 -0700
Message-ID: <20191013003024.215429-3-almasrymina@google.com>
References: <20191013003024.215429-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bBrSpk5/lkb8AYsfeF62BNq9VWemrH+WCBAgVGWPGII=;
        b=hJsydjotiPKAHadLUhsMYb1DIvUHI/kTS4eMu9je11cjpNhoSeutvUQtrx/wKtlpnw
         KQ9qbPdjYSO8qTEwOaAYp1y+a9mT3vEPpNW/symkNk0FLP6a2K4IcbLuP/QgYmh8BbEr
         sJoWnep9Jx+LO8ugGxfDMv/HuEqGs785Fuc5e9crs1hhJPomjPhsIe2Dazo2zleIiBvT
         jUP+k489gBqIWZi1aR8iLR4OBNa0WGPAAWPJkMr7llHnVGZNphvewvTDllm3rB0rsRWp
         YLAq6vZwAdjwh8zxFMfiIL6O1Sh/wIOpnsMNoOHXEePop0Tqm3EoHuhpP+n1rH1sHCGk
         IwDw==
In-Reply-To: <20191013003024.215429-1-almasrymina@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mike.kravetz@oracle.com
Cc: shuah@kernel.org, almasrymina@google.com, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, khalid.aziz@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com, mkoutny@suse.com

---
 mm/hugetlb_cgroup.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 854117513979b..ac1500205faf7 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -503,8 +503,13 @@ static void __init __hugetlb_cgroup_file_init(int idx)
 	cft = &h->cgroup_files[HUGETLB_RES_NULL];
 	memset(cft, 0, sizeof(*cft));

-	WARN_ON(cgroup_add_legacy_cftypes(&hugetlb_cgrp_subsys,
-					  h->cgroup_files));
+	if (cgroup_subsys_on_dfl(hugetlb_cgrp_subsys)) {
+		WARN_ON(cgroup_add_dfl_cftypes(&hugetlb_cgrp_subsys,
+					       h->cgroup_files));
+	} else {
+		WARN_ON(cgroup_add_legacy_cftypes(&hugetlb_cgrp_subsys,
+						  h->cgroup_files));
+	}
 }

 void __init hugetlb_cgroup_file_init(void)
@@ -548,8 +553,14 @@ void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
 	return;
 }

+static struct cftype hugetlb_files[] = {
+	{} /* terminate */
+};
+
 struct cgroup_subsys hugetlb_cgrp_subsys = {
 	.css_alloc	= hugetlb_cgroup_css_alloc,
 	.css_offline	= hugetlb_cgroup_css_offline,
 	.css_free	= hugetlb_cgroup_css_free,
+	.dfl_cftypes = hugetlb_files,
+	.legacy_cftypes = hugetlb_files,
 };
--
2.23.0.700.g56cf767bdb-goog
