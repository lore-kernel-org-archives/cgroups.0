From: Hugh Dickins <hughd@google.com>
Subject: [PATCH 3/3] memcg: let css_get_next() rely upon rcu_read_lock()
Date: Thu, 19 Jan 2012 12:51:47 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1201191250210.29542@eggly.anvils>
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils> <1326958401.1113.22.camel@edumazet-laptop> <CAOS58YO585NYMLtmJv3f9vVdadFqoWF+Y5vZ6Va=2qHELuePJA@mail.gmail.com> <1326979818.2249.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <alpine.LSU.2.00.1201191235330.29542@eggly.anvils>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=XvtKgpsVjtfSIkRWF2ReQzbrWGRNJg+cY8uPt4392ug=;
        b=yMoho8yKTmL51D7sHd8pFwGnyR8A2kBi6n/b35CK1lkyF2HgSiYXJSgk8+FOUT/+R5
         n+JB6U1SxtoOUP8MqpnlwDx2PbFqc5TCO0RzZtMw8apeZ6ki9zpXv3akzrRL1ikstFo6
         71cSaC6vRf0nTn7Oyeb83DfAzInCFSs07VjYI=
In-Reply-To: <alpine.LSU.2.00.1201191235330.29542@eggly.anvils>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, Manfred Spraul <manfred@colorfullife.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>, Greg Thelen <gthelen@google.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Remove lock and unlock around css_get_next()'s call to idr_get_next().
memcg iterators (only users of css_get_next) already did rcu_read_lock(),
and its comment demands that; but add a WARN_ON_ONCE to make sure of it.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- 3.2.0+.orig/kernel/cgroup.c	2012-01-19 12:16:04.000000000 -0800
+++ 3.2.0+/kernel/cgroup.c	2012-01-19 12:22:55.188244820 -0800
@@ -5087,6 +5087,8 @@ css_get_next(struct cgroup_subsys *ss, i
 		return NULL;
 
 	BUG_ON(!ss->use_id);
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
 	/* fill start point for scan */
 	tmpid = id;
 	while (1) {
@@ -5094,10 +5096,7 @@ css_get_next(struct cgroup_subsys *ss, i
 		 * scan next entry from bitmap(tree), tmpid is updated after
 		 * idr_get_next().
 		 */
-		spin_lock(&ss->id_lock);
 		tmp = idr_get_next(&ss->idr, &tmpid);
-		spin_unlock(&ss->id_lock);
-
 		if (!tmp)
 			break;
 		if (tmp->depth >= depth && tmp->stack[depth] == rootid) {

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
