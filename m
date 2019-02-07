From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] Documentation: cgroup-v2: eliminate markup warnings
Date: Wed, 6 Feb 2019 16:59:00 -0800
Message-ID: <7ba0d6eb-8f45-7f4d-4e84-53dab1158da4@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SVWcuUz5gH1sGpGdo0QIT9ocAF9t5jKjZESXWQYppus=; b=NNpfCnGMNbAu6DOm9fKstuGN0
        xkwYK7CJqYi6hL44/NpSs/RkK7kJorFt4eu5iqYWr1iD2yFjGRy9gZf/P4MzEY/0sX/PHkEROli4p
        UMG2jnRspSbsUW0TRYoKL6iGJd3mSUZW1AJqs9uEY45m5cRkwoWeO4hLkrps4JsHY0jjfiDRnghsq
        0EjrOWzi0KWEFcH5OA8Q9hDmgRQDkrsURyFpAp0GpafMlVsC2x1pp/py6Eq8QUw2bUOx1FzGG3TwP
        Kr7Fi0Ha/FWXrDVPhrbP0W5zRqM8MkU8qfYanOLs+dsj8LkSXxfFUAWuhT0w4d9kIfOiWwyJsz/WB
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix markup warnings in cgroup-v2.rst:

Documentation/admin-guide/cgroup-v2.rst:1509: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/admin-guide/cgroup-v2.rst:1511: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/admin-guide/cgroup-v2.rst:1512: WARNING: Block quote ends without a blank line; unexpected unindent.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/admin-guide/cgroup-v2.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-50-rc5.orig/Documentation/admin-guide/cgroup-v2.rst
+++ lnx-50-rc5/Documentation/admin-guide/cgroup-v2.rst
@@ -1503,7 +1503,7 @@ protected workload.
 
 The limits are only applied at the peer level in the hierarchy.  This means that
 in the diagram below, only groups A, B, and C will influence each other, and
-groups D and F will influence each other.  Group G will influence nobody.
+groups D and F will influence each other.  Group G will influence nobody::
 
 			[root]
 		/	   |		\


