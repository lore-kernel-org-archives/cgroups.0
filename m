From: David Rientjes <rientjes@google.com>
Subject: [patch 6/8] res_counter: add interface for maximum nofail charge
Date: Tue, 3 Dec 2013 21:20:13 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1312032118390.29733@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz> <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz> <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=nIlh2O/NtNbZ1zllJmRq+a/MQhI/s5MSgH2G8sBQ8uU=;
        b=cZJMMbsApOsLEvOqwraYDZmRUDEAcEHGZn+aqIidgJ1+CWKC5zmTJaapmBvfHTEA54
         am8SKeV1rRwDzUlQbN56RU4qkmOnFMcIuqE5JmRfNvZNMHgjRzz6Jt0OOCRkgS62biXW
         kvvr8iSrnCR13q+gy2e4CUTBX2LQo5ghftjmYWP3WOGQPXTv9FryrI47eS2I2nonMcNx
         XuT6Tk+9LBv6iQihpOKS1x8kHE/WndNn3+N1c37mqAtdk1o3AvcR8i7B5bEf9xSC/ZmX
         Q08jCHnNXFB28DPMSyha32ZVJpL16ATS7nhl2Y5LocIvJXaE77i4MLOLMilgENK8ZDwG
         czXg==
In-Reply-To: <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

For memcg oom reserves, we'll need a resource counter interface that will
not fail when exceeding the memcg limit like res_counter_charge_nofail,
but only to a ceiling.

This patch adds res_counter_charge_nofail_max() that will exceed the
resource counter but only to a maximum defined value.  If it fails to
charge the resource, it returns -ENOMEM.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/res_counter.h | 10 +++++++++-
 kernel/res_counter.c        | 27 +++++++++++++++++++++------
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -107,14 +107,22 @@ void res_counter_init(struct res_counter *counter, struct res_counter *parent);
  * counter->limit
  *
  * charge_nofail works the same, except that it charges the resource
- * counter unconditionally, and returns < 0 if the after the current
+ * counter unconditionally, and returns < 0 if after the current
  * charge we are over limit.
+ *
+ * charge_nofail_max is the same as charge_nofail, except that the
+ * resource counter usage can only exceed the limit by the max
+ * difference.  Unlike charge_nofail, charge_nofail_max returns < 0
+ * only if the current charge fails because of the max difference.
  */
 
 int __must_check res_counter_charge(struct res_counter *counter,
 		unsigned long val, struct res_counter **limit_fail_at);
 int res_counter_charge_nofail(struct res_counter *counter,
 		unsigned long val, struct res_counter **limit_fail_at);
+int res_counter_charge_nofail_max(struct res_counter *counter,
+		unsigned long val, struct res_counter **limit_fail_at,
+		unsigned long max);
 
 /*
  * uncharge - tell that some portion of the resource is released
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -33,15 +33,19 @@ static u64 res_counter_uncharge_locked(struct res_counter *counter,
 }
 
 static int res_counter_charge_locked(struct res_counter *counter,
-				     unsigned long val, bool force)
+				     unsigned long val, bool force,
+				     unsigned long max)
 {
 	int ret = 0;
 
 	if (counter->usage + val > counter->limit) {
 		counter->failcnt++;
-		ret = -ENOMEM;
+		if (max == ULONG_MAX)
+			ret = -ENOMEM;
 		if (!force)
 			return ret;
+		if (counter->usage + val - counter->limit > max)
+			return -ENOMEM;
 	}
 
 	counter->usage += val;
@@ -51,7 +55,8 @@ static int res_counter_charge_locked(struct res_counter *counter,
 }
 
 static int __res_counter_charge(struct res_counter *counter, unsigned long val,
-				struct res_counter **limit_fail_at, bool force)
+				struct res_counter **limit_fail_at, bool force,
+				unsigned long max)
 {
 	int ret, r;
 	unsigned long flags;
@@ -62,7 +67,7 @@ static int __res_counter_charge(struct res_counter *counter, unsigned long val,
 	local_irq_save(flags);
 	for (c = counter; c != NULL; c = c->parent) {
 		spin_lock(&c->lock);
-		r = res_counter_charge_locked(c, val, force);
+		r = res_counter_charge_locked(c, val, force, max);
 		spin_unlock(&c->lock);
 		if (r < 0 && !ret) {
 			ret = r;
@@ -87,13 +92,23 @@ static int __res_counter_charge(struct res_counter *counter, unsigned long val,
 int res_counter_charge(struct res_counter *counter, unsigned long val,
 			struct res_counter **limit_fail_at)
 {
-	return __res_counter_charge(counter, val, limit_fail_at, false);
+	return __res_counter_charge(counter, val, limit_fail_at, false,
+				    ULONG_MAX);
 }
 
 int res_counter_charge_nofail(struct res_counter *counter, unsigned long val,
 			      struct res_counter **limit_fail_at)
 {
-	return __res_counter_charge(counter, val, limit_fail_at, true);
+	return __res_counter_charge(counter, val, limit_fail_at, true,
+				    ULONG_MAX);
+}
+
+int res_counter_charge_nofail_max(struct res_counter *counter,
+				  unsigned long val,
+				  struct res_counter **limit_fail_at,
+				  unsigned long max)
+{
+	return __res_counter_charge(counter, val, limit_fail_at, true, max);
 }
 
 u64 res_counter_uncharge_until(struct res_counter *counter,

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
