From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] cgroups: censor kernel pointer in debug files
Date: Sat, 25 Feb 2017 01:56:48 -0800
Message-ID: <20170225095648.GA4917@beast>
Mime-Version: 1.0
Return-path: <kernel-hardening-return-6830-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <cgroups.vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=sX3MmK7O6cUMTVJT73Qiak8s5tz1UcjABuRtH6eLWEM=;
        b=Kfjjf7ZyvH1iU6NVXtZBuw23KoH6rJC68IVVALKwxoSspM6upW3zTHIRTPCb9aNJYE
         qb6AfbzBVMbhZpx5nGTJr+Tm3Gzz18RQns+Rh7lO+zvpLHHekWjgEzXahCUdpq7BhKKl
         LSP8pUOE0AptUlOM0T5KhuxWEKWWHEaJZ2hJM=
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com

As found in grsecurity, this avoids exposing a kernel pointer through
the cgroup debug entries.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 53bbca7c4859..b794bcadefa4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -6589,7 +6589,7 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 		struct task_struct *task;
 		int count = 0;
 
-		seq_printf(seq, "css_set %p\n", cset);
+		seq_printf(seq, "css_set %pK\n", cset);
 
 		list_for_each_entry(task, &cset->tasks, cg_list) {
 			if (count++ > MAX_TASKS_SHOWN_PER_CSS)
-- 
2.7.4


-- 
Kees Cook
Pixel Security
