From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: [PATCH v8 2/8] writeback, cgroup: add smp_mb() to cgroup_writeback_umount()
Date: Mon, 7 Jun 2021 18:31:17 -0700
Message-ID: <20210608013123.1088882-3-guro@fb.com>
References: <20210608013123.1088882-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=5HrHHih5juBqYKEEslPOvXicus6WWgPH+iRjEl6TblE=;
 b=amxgprEku9rCQRvdWBmXu/0dZv4ziiDbMNJ1H+AzjZDyEK4MCtAofsB8BWqiwnlGlCV9
 o+B9DsMRcSyLKfce86LYlR5S/ijO3IKbacOzZzKQS6pN5fgSUruVQ1CbruTOxl2VYpSn
 iwWuHMNyDlaII8Zrs4IKhdjvpmJnmWPwVlk= 
In-Reply-To: <20210608013123.1088882-1-guro-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

A full memory barrier is required between clearing SB_ACTIVE flag
in generic_shutdown_super() and checking isw_nr_in_flight in
cgroup_writeback_umount(), otherwise a new switch operation might
be scheduled after atomic_read(&isw_nr_in_flight) returned 0.
This would result in a non-flushed isw_wq, and a potential crash.

The problem hasn't yet been seen in the real life and was discovered
by Jan Kara by looking into the code.

Suggested-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
---
 fs/fs-writeback.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index bd99890599e0..3564efcc4b78 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1000,6 +1000,12 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_i=
d, unsigned long nr,
  */
 void cgroup_writeback_umount(void)
 {
+	/*
+	 * SB_ACTIVE should be reliably cleared before checking
+	 * isw_nr_in_flight, see generic_shutdown_super().
+	 */
+	smp_mb();
+
 	if (atomic_read(&isw_nr_in_flight)) {
 		/*
 		 * Use rcu_barrier() to wait for all pending callbacks to
--=20
2.31.1

