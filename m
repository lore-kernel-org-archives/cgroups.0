From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Documentation: Clarify usage of memory limits
Date: Thu,  1 Jun 2023 11:38:19 -0700
Message-ID: <20230601183820.3839891-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685644703; x=1688236703;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SzJSGye10y66Z1Cc9RFPHp9tWIbjNHpbJLhF+8yAFeo=;
        b=Cbq9QM48Z6LYiuI0eqBqMNi7B0znBZKapVJt0GVsuDyMvxSqOoOaZQwp2T7lMVU3Zx
         6vyB5naOztqPiso2+220gnQtd5JjVJaDbxaSttSMzTcSWj7SkAmBNaK0txhjVmruGo+/
         +3t+dYZtvMALXnh2JgVqXPKP8guWh5uH9XCkoiW/N5iJCZ6PGIXJJwiRHdmdG3AHwoBp
         qqhA5WQUBLDTM1vLp6buhENr6YcISGoSQ3IIOvGhEYBUDgs4Fl0Ff3uXdG3CNyiYJ8lW
         kRbvXZro2PrOnkACkh0cd0Dlgbld8n02Cm03eJWGZukFomSV8qEO+7S2BoCbecgv/4a0
         SXLA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "open list:CONTROL GROUP CGROUP" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

The existing documentation refers to memory.high as the "main mechanism
to control memory usage." This seems incorrect to me - memory.high can
result in reclaim pressure which simply leads to stalls unless some
external component observes and actions on it (e.g. systemd-oomd can be
used for this purpose). While this is feasible, users are unaware of
this interaction and are led to believe that memory.high alone is an
effective mechanism for limiting memory.

The documentation should recommend the use of memory.max as the
effective way to enforce memory limits - it triggers reclaim and results
in OOM kills by itself.

Signed-off-by: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index f67c0829350b..e592a9364473 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1213,23 +1213,25 @@ PAGE_SIZE multiple when read back.
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "max".
 
-	Memory usage throttle limit.  This is the main mechanism to
-	control memory usage of a cgroup.  If a cgroup's usage goes
+	Memory usage throttle limit.  If a cgroup's usage goes
 	over the high boundary, the processes of the cgroup are
 	throttled and put under heavy reclaim pressure.
 
 	Going over the high limit never invokes the OOM killer and
-	under extreme conditions the limit may be breached.
+	under extreme conditions the limit may be breached. The high
+	limit should be used in scenarios where an external process
+	monitors the limited cgroup to alleviate heavy reclaim
+	pressure.
 
   memory.max
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "max".
 
-	Memory usage hard limit.  This is the final protection
-	mechanism.  If a cgroup's memory usage reaches this limit and
-	can't be reduced, the OOM killer is invoked in the cgroup.
-	Under certain circumstances, the usage may go over the limit
-	temporarily.
+	Memory usage hard limit.  This is the main mechanism to limit
+	memory usage of a cgroup.  If a cgroup's memory usage reaches
+	this limit and can't be reduced, the OOM killer is invoked in
+	the cgroup. Under certain circumstances, the usage may go
+	over the limit temporarily.
 
 	In default configuration regular 0-order allocations always
 	succeed unless OOM killer chooses current task as a victim.
@@ -1238,10 +1240,6 @@ PAGE_SIZE multiple when read back.
 	Caller could retry them differently, return into userspace
 	as -ENOMEM or silently ignore in cases like disk readahead.
 
-	This is the ultimate protection mechanism.  As long as the
-	high limit is used and monitored properly, this limit's
-	utility is limited to providing the final safety net.
-
   memory.reclaim
 	A write-only nested-keyed file which exists for all cgroups.
 
-- 
2.34.1

