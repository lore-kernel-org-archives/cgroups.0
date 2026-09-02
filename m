Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B15B372661;
	Wed,  2 Sep 2026 18:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788375581; cv=none; b=mjtrlBTUTi/0iG7eYvtxCKU7h+pF62sKOAnBcsYHEPoR4OTR/J5mnS4dNFQMiCXVJbMZxFwWllMmIethdGwdDvDomEx1h343tTxtKG9JdHSfPKHHMeTyZqqCpatak9+ZU49Ml0+FnW8sbs9XkRz9w5t1kiR3ROiiSRv3HnKp0Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788375581; c=relaxed/simple;
	bh=ahMvYNRMR+81ZB+9Smlwfo84jiKsizICoHjmawUddFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q1eOIufka4gqS9t8ghnCb+opaQXwf4qIAOCQkBVzychNW4At1ld6pHwemrWsOZZO+e4uzCJllReMcKjosGQI39p/T5UgdS9RHkOPAmsYAzox1cLq/oQaWbBRjHsCRUmXp4oHokvlJvlCsODhe5TqpsAIlMQCgpM/muVjmoR43Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mBXSmTCc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBXSmTCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD211F000E9;
	Wed,  2 Sep 2026 18:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788375580;
	bh=7MVxmAb+8/292y9Afv7Rly1SIVSBIQzWkxZPHvi4uus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mBXSmTCc90dfNq2DolrYZwSts+5YG+tf7H0DrypJ/XuUO//lxUMl7R01AxmlL89Im
	 W2aCg3k2q+xzegZOShPet2A1fT0n54NsOQJ6d4RnCyVfGVtLo7n7NGD3vCPwYK5j8O
	 P1JNcxyQfb+sHw26tZg19PPEgaDAbDdYQPIK+EM/Z06UZfBbkrssWCTmAYcaumr8UF
	 a+kYvL3e2UX+6+7QwV2Ol4r57VopmAsEMbd0/Hd82x3YQh4kFCqicpdmRbM7GjH31W
	 bM/+eXJFjkPMx6EYQlvcXa76w3DJAGUDaYWr7BiJ0Vqv4GELYFnphw6RD4W/DmagnB
	 dBy21AMRueuIQ==
Date: Wed, 2 Sep 2026 08:59:39 -1000
From: Tejun Heo <tj@kernel.org>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Schatzberg <dschatzberg@meta.com>,
	Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
	Noah Elias Feldt <N.Feldt@mittwald.de>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] cgroup: Avoid iteration of dying tasks with zero refcount
Message-ID: <aphyG4kapy2MBcnH@slm.duckdns.org>
References: <20260902161653.1051794-1-mkoutny@suse.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902161653.1051794-1-mkoutny@suse.com>

How about something like the following? It's more in line with other skips
and the resulting behavior should remain the same as before:

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5215,6 +5215,7 @@
  */
 struct task_struct *css_task_iter_next(struct css_task_iter *it)
 {
+	struct task_struct *task;
 	unsigned long irqflags;
 
 	if (it->cur_task) {
@@ -5228,6 +5229,21 @@
 	if (it->flags & CSS_TASK_ITER_SKIPPED)
 		css_task_iter_advance(it);
 
+	/*
+	 * @it->task_pos was picked on an earlier call. A dying leader stays on
+	 * dying_tasks until cgroup_task_free(), past its last usage ref drop,
+	 * so it may have been reaped since and get_task_struct() on it would
+	 * resurrect a task about to be freed. That last ref is dropped by an
+	 * RCU callback queued from release_task(), after signal->live hit zero,
+	 * so a leader still showing live threads in this irq-disabled section
+	 * can't lose its ref before the section ends.
+	 */
+	if (it->task_pos && it->cur_tasks_head == &it->cur_cset->dying_tasks) {
+		task = list_entry(it->task_pos, struct task_struct, cg_list);
+		if (!atomic_read(&task->signal->live))
+			css_task_iter_advance(it);
+	}
+
 	if (it->task_pos) {
 		it->cur_task = list_entry(it->task_pos, struct task_struct,
 					  cg_list);
