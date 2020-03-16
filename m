From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 3/3] MAINTAINERS: add maintenance information for psi
Date: Mon, 16 Mar 2020 15:13:33 -0400
Message-ID: <20200316191333.115523-4-hannes@cmpxchg.org>
References: <20200316191333.115523-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NyO1rZabDWL4zYr5NEoM7UySObvndH4J9mOHghZ7eWU=;
        b=YzwA/EftTv+ZfSdrE1t15eyNk3OiF3B+bzstIn3J58vjROhIoqEAmMkiaehM3MArOW
         P+ofXL7CDQqMZVvIN8il489zO3B4hMcw5jVoW6wxyNAwmba1KNuJf8o9eDsTVVyVQ8/c
         1yETge5Z0N+vxayHMn91EBPGQNgtjKnQ7PUeQDa1E/YGhSjDwUouWfJWeZk8L1jdT3ot
         KpsfifLZ4VPAqXDDtXs72NyQh9/SxHH9fT0Uo4sCMNGmnnZWIavUt1nfKCIjliYsrXTC
         nzXvgse2a1GB7qCaQoJ3uByubc6wRrTDO8EQZE/D/KOoSfkX535+V+K1BTewv42dmN29
         r4uA==
In-Reply-To: <20200316191333.115523-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Add a maintainer section for psi, as it's a user-visible, configurable
kernel feature.

The patches are still routed through the scheduler tree due to the
close integration with that code, but get_maintainers.pl does the
right thing and makes sure everybody gets CCd:

$ ./scripts/get_maintainer.pl -f kernel/sched/psi.c
Johannes Weiner <hannes@cmpxchg.org> (maintainer:PRESSURE STALL INFORMATION (PSI))
Ingo Molnar <mingo@redhat.com> (maintainer:SCHEDULER)
Peter Zijlstra <peterz@infradead.org> (maintainer:SCHEDULER)
...

Reported-by: Ivan Babrou <ivan@cloudflare.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cc1d18cb5d18..6d9684b931cc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13515,6 +13515,12 @@ F:	net/psample
 F:	include/net/psample.h
 F:	include/uapi/linux/psample.h
 
+PRESSURE STALL INFORMATION (PSI)
+M:	Johannes Weiner <hannes@cmpxchg.org>
+S:	Maintained
+F:	kernel/sched/psi.c
+F:	include/linux/psi*
+
 PSTORE FILESYSTEM
 M:	Kees Cook <keescook@chromium.org>
 M:	Anton Vorontsov <anton@enomsg.org>
-- 
2.25.1

