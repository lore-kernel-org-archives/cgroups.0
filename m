From: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/10] docs/admin-guide/cgroup-v2: fix mount opt rendering
Date: Tue, 19 Jan 2021 16:18:24 -0800
Message-ID: <20210120001824.385168-11-kolyshkin@gmail.com>
References: <20210120001824.385168-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AdWaVN+/y4nB7k2Y/h5vFo2XQMYLD7PwO6KnTXo1gOs=;
        b=tc1iJDBzwbPdk+USFLGiRAiPsr6L571rZa3SCif6sTOwoQRJRXez/OTOLccvPK3pkU
         5ab1xxV1QurDk1JxI7Yv4IxskuIOSIzpdB8otapSda/VCvcU454FGalL9pPXpv0izXPD
         +HDMlU0j0o0hZNSHAih7DYTeaxiNhRtinyid5QBhYcHuflDF2gECapHYNPkdzmlW/aUq
         +LnQINaUPaw/Li6mThzwPrSUBSV6lZLcsAbu831MVkoRkutl/D6prMiTRVYlY0ySDwDb
         CVTVD+kFdzfOjkdu3DCRgshK+p2MXJCRU428sXP2CXbbVy5CVrRJUAv2feqRw2qdDKJ5
         uQJg==
In-Reply-To: <20210120001824.385168-1-kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: corbet-T1hC0tSOHrs@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Due to an extra empty line between the option and its description
it is rendered not like in other places.

Remove the empty lines to fix.

Signed-off-by: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 136902cd0e98..14a7523c46a4 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -174,7 +174,6 @@ disabling controllers in v1 and make them always available in v2.
 cgroup v2 currently supports the following mount options.
 
   nsdelegate
-
 	Consider cgroup namespaces as delegation boundaries.  This
 	option is system wide and can only be set on mount or modified
 	through remount from the init namespace.  The mount option is
@@ -182,7 +181,6 @@ cgroup v2 currently supports the following mount options.
 	Delegation section for details.
 
   memory_localevents
-
         Only populate memory.events with data for the current cgroup,
         and not any subtrees. This is legacy behaviour, the default
         behaviour without this option is to include subtree counts.
@@ -191,7 +189,6 @@ cgroup v2 currently supports the following mount options.
         option is ignored on non-init namespace mounts.
 
   memory_recursiveprot
-
         Recursively apply memory.min and memory.low protection to
         entire subtrees, without requiring explicit downward
         propagation into leaf cgroups.  This allows protecting entire
-- 
2.29.2

