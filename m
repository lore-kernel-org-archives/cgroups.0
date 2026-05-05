Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1767319848;
	Tue,  5 May 2026 00:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777942287; cv=none; b=UEhYf7GvLxcSOAERF6UPoXuzQKI9m3xMjEocP9XdRQXLYEpYBhN4W3/s1IW/RseWqApq2m9He+3e8gSAiogmUeX+I+KLLMxLhvXUPTNTZ0ZNr4y0Op1ax0ojwKP9mVxPpEbJ5fxZWJGnltl6nJRSCxYTsARIFwfUZ9hUP+J2zJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777942287; c=relaxed/simple;
	bh=gD+2MRbZ01t9uwzNNUk1LO/HmAUyFae4CG2AISagNWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYyoLsxk/KreVEc9Cw6bq6P0hbKYCtUDqurkB27+iBcHFi316zNefvLjNcOIh7ky1T2wZD8BkCoXzacWxoCXQvqzQyWdYP+Lxw2ft2SRgQlv+USlIZn7iZRts9FZos9xsb4X7J6xBqTKoSuvBs+n/EbDeK+fnRnARXVELKG7+hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QoHtbb8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QoHtbb8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAE0C2BCC4;
	Tue,  5 May 2026 00:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777942287;
	bh=gD+2MRbZ01t9uwzNNUk1LO/HmAUyFae4CG2AISagNWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QoHtbb8IOxcyJhZi0TQrVWzPF/c3jqq1QWYMp83b5skLuzc2MuorW3epAPcV1mE1i
	 IRpCuplRVFupKHHszA/doxMBMMOMk9eSWuSlgwOjhE0tUt+7efcQnOWm01yjTIUZGD
	 CZB6rgBRftHEICuxL+MXp54GMC0UtZu5iyMBnTS+nANOHl+xkn+1BpNF0qjdZPeDCv
	 SwdsAivVkr8DbA//QL02X28ykLCSbvpzOvnUNL0g6yIRXWKMJL08BE1actEr05JEPi
	 9rJLOF/87HVPKSa4cPbD/dFGtWOO3hGPE1i3kXvxQ43Lvjmhc3EkleZOSUCEYqI5tB
	 JL48aF48C/tMg==
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Petr Malat <oss@malat.biz>,
	Bert Karwatzki <spasswolf@web.de>,
	kernel test robot <oliver.sang@intel.com>,
	Martin Pitt <martin@piware.de>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] cgroup: Defer kill_css_finish() in cgroup_apply_control_disable()
Date: Mon,  4 May 2026 14:51:21 -1000
Message-ID: <20260505005121.1230198-6-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260505005121.1230198-1-tj@kernel.org>
References: <20260505005121.1230198-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Same race shape as the rmdir path that 93618edf7538 ("cgroup: Defer css
percpu_ref kill on rmdir until cgroup is depopulated") fixed: a task past
exit_signals() whose cset subsys[ssid] still pins the disabled controller's
css can be touching subsys state while ->css_offline() runs. The earlier
patches in this series built up the per-subsys-css deferral machinery and
routed cgroup_destroy_locked() through it. Apply the same shape to
cgroup_apply_control_disable():

	kill_css_sync(css);
	if (!css_is_populated(css))
		kill_css_finish(css);

When the dying css is still populated, kill_css_finish() is deferred. The
walker in css_update_populated() fires kill_finish_work once the css's
hierarchical populated count drops to zero.

cgroup_lock_and_drain_offline()'s wait predicate switches from
percpu_ref_is_dying() to css_is_dying(). CSS_DYING is set by kill_css_sync()
and is a strict superset of percpu_ref_is_dying. Without this change, a +cpu
re-enable after a deferred -cpu disable would skip the drain (percpu_ref
isn't killed yet) and observe the still-CSS_DYING css through cgroup_css(),
treating it as live.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index fa24102535d9..bdc8deedb4f7 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3237,7 +3237,7 @@ void cgroup_lock_and_drain_offline(struct cgroup *cgrp)
 			struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
 			DEFINE_WAIT(wait);
 
-			if (!css || !percpu_ref_is_dying(&css->refcnt))
+			if (!css || !css_is_dying(css))
 				continue;
 
 			cgroup_get_live(dsct);
@@ -3405,7 +3405,8 @@ static void cgroup_apply_control_disable(struct cgroup *cgrp)
 			if (css->parent &&
 			    !(cgroup_ss_mask(dsct) & (1 << ss->id))) {
 				kill_css_sync(css);
-				kill_css_finish(css);
+				if (!css_is_populated(css))
+					kill_css_finish(css);
 			} else if (!css_visible(css)) {
 				css_clear_dir(css);
 				if (ss->css_reset)
-- 
2.54.0

