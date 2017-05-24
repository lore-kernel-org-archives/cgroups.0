From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.12-fixes] cpuset: consider dying css as offline
Date: Wed, 24 May 2017 12:03:48 -0400
Message-ID: <20170524160348.GE24798@htj.duckdns.org>
References: <327ca1f5-7957-fbb9-9e5f-9ba149d40ba2@oracle.com>
 <20170523200645.GG13222@htj.duckdns.org>
 <b7cb070c-c6df-9bf7-fd88-a1b07da28dd0@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ujYl2dCLUaCoSGwn9srWA3oITe5wBXUKfgu4rwigJzk=;
        b=TfIqJeXKbgJhzVK3LffD7v/y+CopCgCHQI1MqKyUGAa7GZCTZHRPsuazXDi0gIYXic
         IQzu/dfndTGOGiUQnBAB2fCFHEvfr1BNOCTqylbvjaCgn54zquuTawNWrgeTe5eAgiNy
         dxlBxVsfOJUrkrHo+KKNM23twX44F+r77sozUvRHrhBQ9Qmqjg8HADaMifKJIoz5AI/u
         RZMm9K1eGEtOILFhnxY7pY7j4tDlrib9FdNyOMlREKNbyKWCFkXCdR0Ai9jZ9SgBJ8du
         LyiaNHXEUkkt8GMldlfPNgS7CLVUZJeVpR5L4P67S0YFsVySAKEdYzf46AyhaAJgGR6N
         q0jA==
Content-Disposition: inline
In-Reply-To: <b7cb070c-c6df-9bf7-fd88-a1b07da28dd0-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

In most cases, a cgroup controller don't care about the liftimes of
cgroups.  For the controller, a css becomes online when ->css_online()
is called on it and offline when ->css_offline() is called.

However, cpuset is special in that the user interface it exposes cares
whether certain cgroups exist or not.  Combined with the RCU delay
between cgroup removal and css offlining, this can lead to user
visible behavior oddities where operations which should succeed after
cgroup removals fail for some time period.  The effects of cgroup
removals are delayed when seen from userland.

This patch adds css_is_dying() which tests whether offline is pending
and updates is_cpuset_online() so that the function returns false also
while offline is pending.  This gets rid of the userland visible
delays.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Link: http://lkml.kernel.org/r/327ca1f5-7957-fbb9-9e5f-9ba149d40ba2-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
Hello,

Applying to cgroup/for-4.12-fixes.  Li, I think this is the right fix,
but I'd appreciate if you can take a look.

Thanks.

 include/linux/cgroup.h |   20 ++++++++++++++++++++
 kernel/cgroup/cpuset.c |    4 ++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ed2573e149fa..710a005c6b7a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -344,6 +344,26 @@ static inline bool css_tryget_online(struct cgroup_subsys_state *css)
 }
 
 /**
+ * css_is_dying - test whether the specified css is dying
+ * @css: target css
+ *
+ * Test whether @css is in the process of offlining or already offline.  In
+ * most cases, ->css_online() and ->css_offline() callbacks should be
+ * enough; however, the actual offline operations are RCU delayed and this
+ * test returns %true also when @css is scheduled to be offlined.
+ *
+ * This is useful, for example, when the use case requires synchronous
+ * behavior with respect to cgroup removal.  cgroup removal schedules css
+ * offlining but the css can seem alive while the operation is being
+ * delayed.  If the delay affects user visible semantics, this test can be
+ * used to resolve the situation.
+ */
+static inline bool css_is_dying(struct cgroup_subsys_state *css)
+{
+	return !(css->flags & CSS_NO_REF) && percpu_ref_is_dying(&css->refcnt);
+}
+
+/**
  * css_put - put a css reference
  * @css: target css
  *
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f6501f4f6040..ae643412948a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -176,9 +176,9 @@ typedef enum {
 } cpuset_flagbits_t;
 
 /* convenient tests for these bits */
-static inline bool is_cpuset_online(const struct cpuset *cs)
+static inline bool is_cpuset_online(struct cpuset *cs)
 {
-	return test_bit(CS_ONLINE, &cs->flags);
+	return test_bit(CS_ONLINE, &cs->flags) && !css_is_dying(&cs->css);
 }
 
 static inline int is_cpu_exclusive(const struct cpuset *cs)
