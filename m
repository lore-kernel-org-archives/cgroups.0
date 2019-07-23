From: Chris Down <chris@chrisdown.name>
Subject: [PATCH] cgroup: kselftest: Relax fs_spec checks
Date: Tue, 23 Jul 2019 17:07:37 -0400
Message-ID: <20190723210737.GA487@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=eXdJyX/5y1/FGa+5JWyiUL+IHdXyD6YsS6A0RC/riP0=;
        b=krorYgFC8c4EEHktVPMM8Uc7p10JFe0m3Uh5Z7ygeHlBHaZoO9KsDsqrGfKaOQ5n45
         Uu4t0n4z/SGQkouCaz5dv002xNN8r2wM56rDbp6+ZTVvamypB6MVSsqNBUzlCunbD8JI
         DmdBacuJcpJxjt2ybAFvHIpYgMHnUYIG12DWQ=
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On my laptop most memcg kselftests were being skipped because it claimed
cgroup v2 hierarchy wasn't mounted, but this isn't correct. Instead, it
seems current systemd HEAD mounts it with the name "cgroup2" instead of
"cgroup":

    % grep cgroup /proc/mounts
    cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate 0 0

I can't think of a reason to need to check fs_spec explicitly
since it's arbitrary, so we can just rely on fs_vfstype.

After these changes, `make TARGETS=cgroup kselftest` actually runs the
cgroup v2 tests in more cases.

Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: kernel-team@fb.com
---
 tools/testing/selftests/cgroup/cgroup_util.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 4c223266299a..bdb69599c4bd 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -191,8 +191,7 @@ int cg_find_unified_root(char *root, size_t len)
 		strtok(NULL, delim);
 		strtok(NULL, delim);
 
-		if (strcmp(fs, "cgroup") == 0 &&
-		    strcmp(type, "cgroup2") == 0) {
+		if (strcmp(type, "cgroup2") == 0) {
 			strncpy(root, mount, len);
 			return 0;
 		}
-- 
2.22.0

