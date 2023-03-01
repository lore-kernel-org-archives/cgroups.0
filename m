From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/1] cgroup: limit cgroup psi file writes to processes with CAP_SYS_RESOURCE
Date: Tue, 28 Feb 2023 17:46:51 -0800
Message-ID: <20230301014651.1370939-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677635215;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Hkk07sQi4ewYkgcLI5Vv3w/Ohqk2oO/iYGZZBdhoujI=;
        b=SPZCLaYSWsFrDoFUe+8BNKpQBvdrTpQWNkS+pSnYsNjidK6DiG6uxbfe7ZnXEF5NJn
         mA4kKgoYr+T01aH7H9Odwr+okLsltXjxhHH8k/FBiPg0KQ05aWI6MnXcOTSBQBtmnZti
         59IM9MtiQSlS5IIx5lpMwTlsQFBBfJKjga+S5NGw+aXNoPb6PpM92R+dqa3tXtO45j57
         RPny4gtbyLIvSMGpWUYZEn0P66MLNtWF7zQh7PNLL89KppUZcj5yxU6XLU8oU7IJw3NG
         V5S++Dy9Z/OJgLN7yPmibRr23zDQlcIIqNOKl+MKw+gsadanJtye+mwY96YZ1yXoFkyH
         FAww==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Currently /proc/pressure/* files can be written only by processes with
CAP_SYS_RESOURCE capability to prevent any unauthorized user from
creating psi triggers. However no such limitation is required for
per-cgroup pressure files. Fix this inconsistency by requiring the same
capability for writing per-cgroup psi files.

Fixes: 6db12ee0456d ("psi: allow unprivileged users with CAP_SYS_RESOURCE to write psi files")
Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 935e8121b21e..b600a6baaeca 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3867,6 +3867,12 @@ static __poll_t cgroup_pressure_poll(struct kernfs_open_file *of,
 	return psi_trigger_poll(&ctx->psi.trigger, of->file, pt);
 }
 
+static int cgroup_pressure_open(struct kernfs_open_file *of)
+{
+	return (of->file->f_mode & FMODE_WRITE && !capable(CAP_SYS_RESOURCE)) ?
+		-EPERM : 0;
+}
+
 static void cgroup_pressure_release(struct kernfs_open_file *of)
 {
 	struct cgroup_file_ctx *ctx = of->priv;
@@ -5266,6 +5272,7 @@ static struct cftype cgroup_psi_files[] = {
 	{
 		.name = "io.pressure",
 		.file_offset = offsetof(struct cgroup, psi_files[PSI_IO]),
+		.open = cgroup_pressure_open,
 		.seq_show = cgroup_io_pressure_show,
 		.write = cgroup_io_pressure_write,
 		.poll = cgroup_pressure_poll,
@@ -5274,6 +5281,7 @@ static struct cftype cgroup_psi_files[] = {
 	{
 		.name = "memory.pressure",
 		.file_offset = offsetof(struct cgroup, psi_files[PSI_MEM]),
+		.open = cgroup_pressure_open,
 		.seq_show = cgroup_memory_pressure_show,
 		.write = cgroup_memory_pressure_write,
 		.poll = cgroup_pressure_poll,
@@ -5282,6 +5290,7 @@ static struct cftype cgroup_psi_files[] = {
 	{
 		.name = "cpu.pressure",
 		.file_offset = offsetof(struct cgroup, psi_files[PSI_CPU]),
+		.open = cgroup_pressure_open,
 		.seq_show = cgroup_cpu_pressure_show,
 		.write = cgroup_cpu_pressure_write,
 		.poll = cgroup_pressure_poll,
@@ -5291,6 +5300,7 @@ static struct cftype cgroup_psi_files[] = {
 	{
 		.name = "irq.pressure",
 		.file_offset = offsetof(struct cgroup, psi_files[PSI_IRQ]),
+		.open = cgroup_pressure_open,
 		.seq_show = cgroup_irq_pressure_show,
 		.write = cgroup_irq_pressure_write,
 		.poll = cgroup_pressure_poll,
-- 
2.39.2.722.g9855ee24e9-goog

