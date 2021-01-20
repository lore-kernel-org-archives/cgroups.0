From: Kir Kolyshkin <kolyshkin@gmail.com>
Subject: [PATCH 07/10] docs/admin-guide: cgroup-v2: fix cgroup.type rendering
Date: Tue, 19 Jan 2021 16:18:21 -0800
Message-ID: <20210120001824.385168-8-kolyshkin@gmail.com>
References: <20210120001824.385168-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sl4zutZNTqwn4UHJVbcHFIYb+Z0yDoOK+cSVT1ECB74=;
        b=FAHyInT2erztCE+Frd0/kZorfgt3mSLYhqmxotJ/K3i2LDdZRBYoJgcn7tUSgWTfzw
         BM26+JwBeo60N8US3bSpEdk0HWvme3LbqCwswE8pgfQVNmFp0K/f+0uPeGFMA1YtbhRr
         gPtTX0LU8yrS0yBRpSmlqo6gkoqnWv0tZUZSxJAVz1cDeRJLTnAzjMFKQk7ach94mZTv
         IhwMzPZaTfj6atx/BgF2GVQxKZ0ffcHSdL3n2qTskwNnfmnwRR6vjNP5nlcBQ7rgOYAc
         nlk8SUUZW7YU3fxXVhMeCpRj8vUniTNjl6SvKeuslH/OMGYmnKi0irIsPyh6Kfu0ZnOD
         2OaA==
In-Reply-To: <20210120001824.385168-1-kolyshkin@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: corbet@lwn.net
Cc: linux-doc@vger.kernel.org, cgroups@vger.kernel.org, Kir Kolyshkin <kolyshkin@gmail.com>

Due to an extra vertical whitespace, this was not recognised
as a definition list entry, and thus was not rendered like
the rest of cgroupfs files.

Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 073f976d44ea..c1b6ffc286cf 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -788,7 +788,6 @@ Core Interface Files
 All cgroup core files are prefixed with "cgroup."
 
   cgroup.type
-
 	A read-write single value file which exists on non-root
 	cgroups.
 
-- 
2.29.2

