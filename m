From: Antonio Murdaca <amurdaca@redhat.com>
Subject: [PATCH v2] security: selinux: allow changing labels for cgroupfs
Date: Thu,  2 Feb 2017 16:22:57 +0100
Message-ID: <20170202152257.30220-1-runcom@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: selinux@tycho.nsa.gov
Cc: gary.tierney@gmx.com, linux-kernel@vger.kernel.org, dwalsh@redhat.com, pmoore@redhat.com, vgoyal@redhat.com, cgroups@vger.kernel.org

This patch allows changing labels for cgroup mounts. Previously, running
chcon on cgroupfs would throw an "Operation not supported". This patch
specifically whitelist cgroupfs.

The patch could also allow containers to write only to the systemd cgroup
for instance, while the other cgroups are kept with cgroup_t label.

Signed-off-by: Antonio Murdaca <runcom@redhat.com>
---
Changes in v2:
  - whitelist cgroup2 fs type

 security/selinux/hooks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3b955c6..2789f0a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -480,6 +480,8 @@ static int selinux_is_sblabel_mnt(struct super_block *sb)
 		sbsec->behavior == SECURITY_FS_USE_NATIVE ||
 		/* Special handling. Genfs but also in-core setxattr handler */
 		!strcmp(sb->s_type->name, "sysfs") ||
+		!strcmp(sb->s_type->name, "cgroup") ||
+		!strcmp(sb->s_type->name, "cgroup2") ||
 		!strcmp(sb->s_type->name, "pstore") ||
 		!strcmp(sb->s_type->name, "debugfs") ||
 		!strcmp(sb->s_type->name, "tracefs") ||
-- 
2.9.3

