From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] swap: cond_resched in swap_cgroup_prepare()
Date: Sun,  4 Jun 2017 13:01:09 -0700
Message-ID: <20170604200109.17606-1-yuzhao@google.com>
References: <20170601195635.20744-1-yuzhao@google.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F7UGowaKd+2aEVprlXN8K6Slr1kIpEWjg210EoPAWHc=;
        b=sXTicSVjyHCR++5MjbDTLttRXpA/MG0XyIqzrmC/uuWk14Pdfc/xB7QMZ4VgwilUyN
         HY77Gnfj71Pdki07CRCEstXFbROOZ5DQrR/V1rys70+a6pe4FaTLCv/1MuqXIL1sO1/J
         R7eH0aXP7+BeqzXsmLCRnxRtQe9S9r/O/Z4APtQYOAJEFHHKTfsBKZkaH9Y03R/p8VSs
         MR6UTRgOxINsUJDs9H7b6s90bA19kvOxg6KXUIGZG4PP0w1ayvAS6x23xMvxw8aXzF0W
         XO5CUpJU45gBaKHpVM5+SopX9xlMOXzfqBmPc1OBLeSuM7QfEaxyqqr9jYwljvpsih56
         FriQ==
In-Reply-To: <20170601195635.20744-1-yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Saw need_resched() warnings when swapping on large swapfile (TBs)
because continuously allocating many pages in swap_cgroup_prepare()
took too long.

We already cond_resched when freeing page in swap_cgroup_swapoff().
Do the same for the page allocation.

Signed-off-by: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Acked-by: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changelog since v1:
* clarify the problem in the commit message

 mm/swap_cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
index ac6318a064d3..3405b4ee1757 100644
--- a/mm/swap_cgroup.c
+++ b/mm/swap_cgroup.c
@@ -48,6 +48,9 @@ static int swap_cgroup_prepare(int type)
 		if (!page)
 			goto not_enough_page;
 		ctrl->map[idx] = page;
+
+		if (!(idx % SWAP_CLUSTER_MAX))
+			cond_resched();
 	}
 	return 0;
 not_enough_page:
-- 
2.13.0.506.g27d5fe0cd-goog
