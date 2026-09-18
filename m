Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7204D486E
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 10:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789728539; cv=none; b=CszKIgLvrrP2R9szM4A5d6AT1XIeLhM00UKPGI4JYPYcMCxTHN17qiRgUHlBmv5nxlyXoMULQh4+1MFvLtOOi12J57uPxhbLLQURGyD5gidGDf4KBVVVa5Cem0hC5fpqkqjD/93Xsn2MURlZWF0+ZuWhe/pKIC9OBGYNCS9fUwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789728539; c=relaxed/simple;
	bh=UuV51DzSFj/9U7jcVJ3onzYGdjdKog7uhfDHtGUgXQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=A1M+OT4BCdLZkMLYL8CliPT/fL8OpCxIn7RgdEiAiM8bFCWVe363gr8fHuR3/odGuyoAkD9vIRWviHACPzTWOEohJYW6bEQeF5Bq5F5iJVjLCfP2GMesaAmNvwfQyik/+9A0ifUGx/evNIbQ1Mi7KYjtW+TY+hf973cAFk9dWv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=uImVmxm9; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=SlTNvz1F; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="uImVmxm9";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="SlTNvz1F"
Date: Fri, 18 Sep 2026 12:48:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1789728533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=BWLFcfNkrmv6EMBkXvhceeJPXtB+sECuVVHb+v5vDFs=;
	b=uImVmxm9wBKGpg9HfQhHCmbsisn9RGHzFJ+7L7whjeKwBeTpZurUSJqR6gwR/K8/Me3w7V
	yUUHBrjRH+K3CJ1XSR5OXFXPBWqyDyKbw+gQY7htdxINUalSd3WnCQYlHW7iP7JmuPXgG+
	zBhwSunaClIrHlocjZQwdU+rwvZX0yMdqGc5YYHJRHu3JZlnWYoGbCPZwxKp3LGBJaXjwF
	6957AQ0H7GP644VdBRtEH2C1uDfS+pOFZkg18lYrzwqA7R1nyiR+6xpoziNdQFDvZiM9aJ
	oTZ8gTwD0q+KpB/kiQkvpCfuYMsMqARkpKYgpxcy3MsXVTpCVD3IBjenkN/xbw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1789728533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=BWLFcfNkrmv6EMBkXvhceeJPXtB+sECuVVHb+v5vDFs=;
	b=SlTNvz1FJ+Xzdvw17eZ4l+tKbFcQvAG/8U37gHhQobsjohDsx4QZUqE7lI2tui57HX2MGp
	VWZVukXz+kZZg9AA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: cgroups@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: [PATCH] cgroup: Use %p for pointer formatting
Message-ID: <20260918104852.1p2fz_-_@linutronix.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Since commit ad67b74d2469d ("printk: hash addresses printed with
%p") pointers are hashed by default and the behaviour can be controller
by `hash_pointers' boot argument.
Removing %pK makes it possible to remove its handling from the library.
The policy on %p is to not introduce new ones.

Since this looks vital to the debugging of cgroups, keep the pointer
output.

Use %p instead %pK.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/cgroup/debug.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index 883347b87842d..7cb862db07206 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -51,7 +51,7 @@ static int current_css_set_read(struct seq_file *seq, void *v)
 	spin_lock_irq(&css_set_lock);
 	cset = task_css_set(current);
 	refcnt = refcount_read(&cset->refcount);
-	seq_printf(seq, "css_set %pK %d", cset, refcnt);
+	seq_printf(seq, "css_set %p %d", cset, refcnt);
 	if (refcnt > cset->nr_tasks)
 		seq_printf(seq, " +%d", refcnt - cset->nr_tasks);
 	seq_puts(seq, "\n");
@@ -125,10 +125,10 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 		 * Print out the proc_cset and threaded_cset relationship
 		 * and highlight difference between refcount and task_count.
 		 */
-		seq_printf(seq, "css_set %pK", cset);
+		seq_printf(seq, "css_set %p", cset);
 		if (rcu_dereference_protected(cset->dom_cset, 1) != cset) {
 			threaded_csets++;
-			seq_printf(seq, "=>%pK", cset->dom_cset);
+			seq_printf(seq, "=>%p", cset->dom_cset);
 		}
 		if (!list_empty(&cset->threaded_csets)) {
 			struct css_set *tcset;
@@ -137,7 +137,7 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 			list_for_each_entry(tcset, &cset->threaded_csets,
 					    threaded_csets_node) {
 				seq_puts(seq, idx ? "," : "<=");
-				seq_printf(seq, "%pK", tcset);
+				seq_printf(seq, "%p", tcset);
 				idx++;
 			}
 		} else {
-- 
2.55.0

