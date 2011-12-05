From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH] resource cgroups: remove bogus cast
Date: Mon, 05 Dec 2011 22:13:41 +0100
Message-ID: <1323119621.3244.1.camel@offbook>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Pavel Emelianov <xemul@openvz.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, cgroups@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

The memparse() function already accepts const char * as the parsing string.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 kernel/res_counter.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 34683ef..6d269cc 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -159,8 +159,7 @@ int res_counter_memparse_write_strategy(const char *buf,
 		return 0;
 	}
 
-	/* FIXME - make memparse() take const char* args */
-	*res = memparse((char *)buf, &end);
+	*res = memparse(buf, &end);
 	if (*end != '\0')
 		return -EINVAL;
 
-- 
1.7.4.1


