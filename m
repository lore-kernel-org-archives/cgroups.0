From: Mina Almasry <almasrymina@google.com>
Subject: [PATCH v8 3/9] hugetlb_cgroup: add cgroup-v2 support
Date: Tue, 29 Oct 2019 18:36:55 -0700
Message-ID: <20191030013701.39647-3-almasrymina@google.com>
References: <20191030013701.39647-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1GwmRjPs7u0T+r1yllJwr/PMM5pTo/W+dyBkrzs0XUw=;
        b=jd1r6Jia7s590891AgR3YYy9CElt7HWAUKHltf6wi81ngafwOYcF4N8Uwe/4zvW4MC
         IMk4k0LW1lf0/UGSclUObeuq/p3apoMtj4dOo8LZ3krCjiaET5tiZ+YTnO+UGNjAvSOU
         3uPmacYgwbx/u60ZQlS4vRPN7KP3sK5/3zhAaRK4S6ZiIGEaO386M6CIjj7hD/z+xln8
         HF2EafhhgD6PSHLKNb79leD5RoJeH0xD4HAkHOC0Jqf/o5pz89syAuvF2WHT8Rl719BR
         FB8AjMvuGbVf+5f9/Il7sZ4FoNHE4N3M8imjilODvpfBX+iUx1KthnL6nANbputXXdpz
         jDcg==
In-Reply-To: <20191030013701.39647-1-almasrymina@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mike.kravetz@oracle.com
Cc: shuah@kernel.org, almasrymina@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com

Signed-off-by: Mina Almasry <almasrymina@google.com>

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
2.24.0.rc1.363.gb1bccd3e3d-goog
