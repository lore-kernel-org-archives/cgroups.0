From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/1] psi: remove 500ms min window size limitation for triggers
Date: Thu,  2 Mar 2023 17:13:46 -0800
Message-ID: <20230303011346.3342233-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677806030;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pk7Od9lx1FvwXfe2+jCyuETO6j4UmvCkXNRwPfsPdX8=;
        b=eawrTzCH33CbOpQRrdHF07gcS0h9D1fZAptzT+SJUwp8eltvWzEvvp9uSp3iqVbkls
         cqD96AeE8qiN73slqQ81HuGUu6xBeCHlD/QwFmF4SWXenGr98sEL5df8aqUJgveG2cZA
         MIRo5Gf6PS8V7+p93ejwhwPx/Zzm8icHjBpOJpQ5mT/DzAHhN1Ua/6fBWtLOS3kr55VC
         3GEyDVbXsOkpLx5aJClCUXvSUnC7JOuxd2OR/Zbimj6cGtSwn7Ad4+TroPZDrDw3oBbW
         2cUbgCSfRfZTug//WxNgmYlh8jp6snpqjyp3oQIgg1RyVqOYyxrglI95cfpAy3GN3cnZ
         CAJw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Current 500ms min window size for psi triggers limits polling interval
to 50ms to prevent polling threads from using too much cpu bandwidth by
polling too frequently. However the number of cgroups with triggers is
unlimited, so this protection can be defeated by creating multiple
cgroups with psi triggers (triggers in each cgroup are served by a single
"psimon" kernel thread).
Instead of limiting min polling period, which also limits the latency of
psi events, it's better to limit psi trigger creation to authorized users
only, like we do for system-wide psi triggers (/proc/pressure/* files can
be written only by processes with CAP_SYS_RESOURCE capability). This also
makes access rules for cgroup psi files consistent with system-wide ones.
Add a CAP_SYS_RESOURCE capability check for cgroup psi file writers and
remove the psi window min size limitation.

Suggested-by: Sudarshan Rajagopalan <quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Link: https://lore.kernel.org/all/cover.1676067791.git.quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org/
Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 10 ++++++++++
 kernel/sched/psi.c     |  4 +---
 2 files changed, 11 insertions(+), 3 deletions(-)

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
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 02e011cabe91..0945f956bf80 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -160,7 +160,6 @@ __setup("psi=", setup_psi);
 #define EXP_300s	2034		/* 1/exp(2s/300s) */
 
 /* PSI trigger definitions */
-#define WINDOW_MIN_US 500000	/* Min window size is 500ms */
 #define WINDOW_MAX_US 10000000	/* Max window size is 10s */
 #define UPDATES_PER_WINDOW 10	/* 10 updates per window */
 
@@ -1278,8 +1277,7 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 	if (state >= PSI_NONIDLE)
 		return ERR_PTR(-EINVAL);
 
-	if (window_us < WINDOW_MIN_US ||
-		window_us > WINDOW_MAX_US)
+	if (window_us == 0 || window_us > WINDOW_MAX_US)
 		return ERR_PTR(-EINVAL);
 
 	/* Check threshold */
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

