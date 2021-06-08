From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v9 2/8] writeback, cgroup: add smp_mb() to cgroup_writeback_umount()
Date: Tue, 8 Jun 2021 16:02:19 -0700
Message-ID: <20210608230225.2078447-3-guro@fb.com>
References: <20210608230225.2078447-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=mfav6jzNKGWoxXgqLsimDL5+HxKJWmRmET2uHflSm9w=;
 b=OjqfaN2Os6DxSL7HmOn4jDtij1QwyZYPxFDhWgbljrVVB85ZPP7F2i1BRuaLZ7Rrp80u
 F9+mfkNCMARlB+MSC3rh4vz7UjDseYvOEtUZKn8LwPjakhCg/wlUY8oB9jdWmd3tnEb2
 i0qc72fz4JnRtBJRCP8a4Pp2Nog77WtweDM= 
In-Reply-To: <20210608230225.2078447-1-guro@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Dennis Zhou <dennis@kernel.org>, Dave Chinner <dchinner@redhat.com>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

A full memory barrier is required between clearing SB_ACTIVE flag
in generic_shutdown_super() and checking isw_nr_in_flight in
cgroup_writeback_umount(), otherwise a new switch operation might
be scheduled after atomic_read(&isw_nr_in_flight) returned 0.
This would result in a non-flushed isw_wq, and a potential crash.

The problem hasn't yet been seen in the real life and was discovered
by Jan Kara by looking into the code.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 7d2891d7ac12..b6fc13a4962d 100644
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

