From: Chris Down <chris@chrisdown.name>
Subject: [PATCH] docs: cgroup: mm: Fix spelling of "list"
Date: Mon, 11 Nov 2019 14:44:38 +0000
Message-ID: <20191111144438.GA11327@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=jpUzAZEpApOMVMIW0Fqf4/xrL7Q7nYI9jKjTWCa/2z8=;
        b=OS76QWxrRsPKqu6mUeCbMb9Joyk0TTB7Vdtx082xBJahs8lh9PNXAOwoS8XFicAgnI
         S/inQqa37xoc1IvkPXcEYEx81Bda9cHzMfpc6CFPjL+XDAaptyTPwCVnrscdIIwD1Bcc
         L8WJGGl/hHN28w0gmLwzm7pWVT5CtEgO2zfj0=
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: kernel-team@fb.com
---
 Documentation/admin-guide/cgroup-v2.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index ed9123155e03..0704552ed94f 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1335,7 +1335,7 @@ PAGE_SIZE multiple when read back.
 
 	  pgdeactivate
 
-		Amount of pages moved to the inactive LRU lis
+		Amount of pages moved to the inactive LRU list
 
 	  pglazyfree
 
-- 
2.24.0

