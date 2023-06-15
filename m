From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Wed, 14 Jun 2023 19:18:22 -0600
Message-ID: <ZIpm3pcs3iCP9UaR@work>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686791845;
        bh=jC/V/5wTuDMjSNiSOnA5excD/Pg4jzWuQwRXLi7lZ5Q=;
        h=Date:From:To:Cc:Subject:From;
        b=LNn3r6SsDlIceMsugdzXzyHk9WrMjwzuxupyyplrVHyioNpMJdpql/gLeE+cky74M
         7/gIN433a9Az+BryjDhdebV9l6Mnw4rB9+iqI6K5ce3PdjuOyjyiwgS3o4L1jcdmQY
         t9PY3TpynCOtMjyn4mXp6Wga7IIu/2AZoBsp29aMD6JYTeKrrQppEc0MFMTKtgNwMF
         krwRXUZxh2Vchb79SSKMEvvLrj7xm3Q1Tb5PktEXXLDaadwmoVq5AWvQv4qwKOV4hQ
         Rs0JFIB02Mjw2n30gUblEh4OxBCw19+eCBmlKcuJ9iIvOLsYjFdW3V8a5voebM/9Ed
         mRzHWmC4lfCxA==
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-hardening@vger.kernel.org

Address the following -Wstringop-overflow warnings seen when
built with ARM architecture and aspeed_g4_defconfig configuration
(notice that under this configuration CGROUP_SUBSYS_COUNT == 0):
kernel/cgroup/cgroup.c:1208:16: warning: 'find_existing_css_set' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
kernel/cgroup/cgroup.c:1258:15: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
kernel/cgroup/cgroup.c:6089:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
kernel/cgroup/cgroup.c:6153:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]

These changes are based on commit d20d30ebb199 ("cgroup: Avoid compiler
warnings with no subsystems").

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 kernel/cgroup/cgroup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index cd497b90e11a..1ee76e62eb98 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1200,6 +1200,9 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	unsigned long key;
 	int ssid;
 
+	if (!CGROUP_HAS_SUBSYS_CONFIG)
+		return NULL;
+
 	lockdep_assert_held(&cgroup_mutex);
 
 	/* First see if we already have a cgroup group that matches
@@ -6045,6 +6048,9 @@ int __init cgroup_init(void)
 	struct cgroup_subsys *ss;
 	int ssid;
 
+	if (!CGROUP_HAS_SUBSYS_CONFIG)
+		return -EINVAL;
+
 	BUILD_BUG_ON(CGROUP_SUBSYS_COUNT > 16);
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_base_files));
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_psi_files));
-- 
2.34.1

