From: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/10] docs/admin-guide/cgroup-v2: nit
Date: Tue, 19 Jan 2021 16:18:23 -0800
Message-ID: <20210120001824.385168-10-kolyshkin@gmail.com>
References: <20210120001824.385168-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WwtSrnSYMVvS4qlas+fFjqkRS4JIs0P9IHv9gWu1OEM=;
        b=bDJtoahsaS1KxAdHsDXc1idqxnR6tE0o47LbSzTp5jc1sm8Dbu9Zn88FjPxjLoEvWM
         1qN0QLKZwCvHsXdEShRVOjCFy/2pXIwMv6nFYQ/sEq4T6ZRG6xEIC1RWOkKe957cldIn
         eos1TEWZPNMgNRQM8EgBbwgtGKZwvHS0GBeLCGadWosrirRlllo/XFqTC2o+4O8SwqwG
         1KoMdZW+gH5NyJT+OymTG8hq0NfCO4qJlS73XmSBDPEQalWJCmCH/8vJ/GauRTwTMmDA
         J3a2SkdW+dUTZKiTwe8v3kkd+wWUPUhpyjIoyy07LovKWE15RTYWSPU8hO1lrx6rbV5Y
         +lkg==
In-Reply-To: <20210120001824.385168-1-kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: corbet-T1hC0tSOHrs@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Improper Capitalization.

Signed-off-by: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6f59f13f28d0..136902cd0e98 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2226,7 +2226,7 @@ Without cgroup namespace, the "/proc/$PID/cgroup" file shows the
 complete path of the cgroup of a process.  In a container setup where
 a set of cgroups and namespaces are intended to isolate processes the
 "/proc/$PID/cgroup" file may leak potential system level information
-to the isolated processes.  For Example::
+to the isolated processes.  For example::
 
   # cat /proc/self/cgroup
   0::/batchjobs/container_id1
-- 
2.29.2

