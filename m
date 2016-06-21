From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-4.8] cgroup: allow NULL return from ss->css_alloc()
Date: Tue, 21 Jun 2016 13:06:24 -0400
Message-ID: <20160621170624.GK3262@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=jqhMWOCMdrqD9+QvTEVOFM3gcanW2dvjBDFQWaaPuIE=;
        b=qbIyvU9JP5SWG+oXK97WJAxpY7H3daKpl1Ru//hqbluzD7CXzoErNzB+N3IFmpeFSx
         q0+AOIMIx2CX+b7iusW2uhs4O+IvPu/3uhPD+fsnbDB+x+UKMzt0Adfwuzg7Wut64P6n
         ilYfEomg+yMm2M2YSWnQM6tVkmNZS73Ww9X1taGfzVXhege4twfd4MvFL5QNSCPS7x4y
         2IEOsaEpAwrsOusrlDbtZT4PQ5On7kJqXyqbfZ7b122K+cO4j3tUV9vRECb1rbVuhXX9
         1azxEgY8LC/kf4nMYrQYFemBDAFtGG9fEFMLreHxCCJSMu5VHGS57CeQQvBx7FH+bjXT
         BRDA==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

cgroup core expected css_alloc to return an ERR_PTR value on failure
and caused NULL deref if it returned NULL.  It's an easy mistake to
make from an alloc function and there's no ambiguity in what's being
indicated.  Update css_create() so that it interprets NULL return from
css_alloc as -ENOMEM.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Hello,

I'm applying this patch to cgroup/for-4.8.

Thanks.

 kernel/cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 86cb5c6..8e5470d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5139,6 +5139,8 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 	lockdep_assert_held(&cgroup_mutex);
 
 	css = ss->css_alloc(parent_css);
+	if (!css)
+		css = ERR_PTR(-ENOMEM);
 	if (IS_ERR(css))
 		return css;
 
