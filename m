From: Krzysztof Pawlaczyk <krzpaw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] docs: cgroup-v1: replace dead CONFIG_MEM_RES_CTRL_SWAP symbol
Date: Fri, 28 Jul 2023 12:57:23 +0200
Message-ID: <20230728105723.251892-1-krzpaw@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690541945; x=1691146745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bFsY8/ZjjU7LwHHb+uRNiN1oriLKCvMdQRblo9hKtwI=;
        b=mSoO2RBLZ3V69g4yjzRKp6C+BjpK019a/acfMnMuGovyLL1pQbGVJeXQMhQ8MK5b89
         EBnWdmtyjiVgXpCFGzCbLJBX0nY5tinBn6y3jmpLj+yxOMwyvZ6GdGektEy3TePpvRqi
         AwxwXp0F7JBLTV+MGi0EvXeaNmMoJxRT2DhsHcs8fJAjpwUprUw5Z2ZywuTJ2rA7KxbR
         AOGIgsmD5iG5UpKJ1N7e8LhBpHEsZ7WorTdnJu0rXy5NWO7TEadJjXSz3vCGtwGSn2lu
         n47SgkW3FM3cWrQfZ+c8YlHLS7DRSlBTC3CczS0xm7RM9C6HRNA5/Cpk52kA97cxSIAf
         LflQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lukas.bulwahn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Krzysztof Pawlaczyk <krzpaw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Commit e55b9f96860f ("mm: memcontrol: drop dead CONFIG_MEMCG_SWAP
config symbol") removed MEMCG_SWAP as it was just a shorthand for
CONFIG_MEMCG && CONFIG_SWAP.

The commit also adjusted the documentation but missed reference to
CONFIG_MEM_RES_CTRL_SWAP, which was the previous name of
CONFIG_MEMCG_SWAP before renaming in commit c255a458055e ("memcg: rename
config variables").

Update the reference to the current state.

Signed-off-by: Krzysztof Pawlaczyk <krzpaw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v1/memcg_test.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memcg_test.rst b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
index a402359abb99..1f128458ddea 100644
--- a/Documentation/admin-guide/cgroup-v1/memcg_test.rst
+++ b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
@@ -62,7 +62,7 @@ Please note that implementation details can be changed.
 
 	At cancel(), simply usage -= PAGE_SIZE.
 
-Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
+Under below explanation, we assume CONFIG_SWAP=y.
 
 4. Anonymous
 ============
-- 
2.25.1

