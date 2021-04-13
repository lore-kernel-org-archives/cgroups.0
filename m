From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: [PATCH 1/2] cgroup2: cpuset: Disable subset validation on set
Date: Tue, 13 Apr 2021 11:02:34 +0200
Message-ID: <20210413090235.1903026-2-odin@uged.al>
References: <20210413090235.1903026-1-odin@uged.al>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4iJUYo21aTslz6Z8Ta9PIHGPXdm8gkXi8+0HPXoSBsQ=;
        b=VD1IkuKhEvpeeF08omMrTP4Zn1dGCpJFSkgyvFwfXaYHJ7c/DULWvIUG3ZDl1jhk5N
         SrJ/virX6o+L0WmJVF9o57v9OGLLJCUI+2M4H4NXnrW1UINI6LOr1fBFjFDPp7+SOfkH
         EbC+WgNXCK0PFEllFpyKjnunx9Chn7otj8uCsnlim9/NlCmap6FTOU/p18miIowlpBND
         HJJIAw7oVmTxLguV2vEsWwH4D2iwYTt7shERHYNrJT+/7kr+sWxK5C8pYlNLYCzfafbZ
         Dqa7J1ho/Y8msY+HCLR0mmCF0Om9SVM7kw+bt3amoVS+wfzNfBRdIVjcXJ+i1bRcoJd4
         25dw==
In-Reply-To: <20210413090235.1903026-1-odin-RObV4cXtwVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>

Due to how cpuset works in v2, there is no need to check if direct
children are subsets of the new cpuset. In v2, the effective cpuset
of a cgroup is the intersection between the effective value of the parent
and the cpuset.cpus value of the cgroup, with a fallback to the effective
parent value in case the intersection is an empty set.

Therefore, in v2, it is allowed to set cpuset.cpus to a a value that is
not a subset of the parents effective value, resulting in inheriting the
effective cpuset from the parent. Therefore the validation when updating
the parent cpuset (in this case) is not necessary, and can be disabled.

Example:

  /sys/fs/cgroup/A     (cpus=1-2,cpus.effective=1-2)
  /sys/fs/cgroup/A/B   (cpus="", cpus.effective=1-2)

  Setting cpus to 3-4 is possible for A/B

  /sys/fs/cgroup/A     (cpus=1-2,cpus.effective=1-2)
  /sys/fs/cgroup/A/B   (cpus=3-4,cpus.effective=1-2)

  Setting cpus to 1 for A would result in an -EBUSY error, but
  with this patch it will work as expected:

  /sys/fs/cgroup/A     (cpus=1,  cpus.effective=1)
  /sys/fs/cgroup/A/B   (cpus=3-4,cpus.effective=1)

This also applies in a similar manner on cpuset.mems.

Signed-off-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5258b68153e0..f543c4c6084a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -572,11 +572,13 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	rcu_read_lock();
 
-	/* Each of our child cpusets must be a subset of us */
+	/* On legacy hierarchy, each of our child cpusets must be a subset of us */
 	ret = -EBUSY;
-	cpuset_for_each_child(c, css, cur)
-		if (!is_cpuset_subset(c, trial))
-			goto out;
+	if (!is_in_v2_mode()) {
+		cpuset_for_each_child(c, css, cur)
+			if (!is_cpuset_subset(c, trial))
+				goto out;
+	}
 
 	/* Remaining checks don't apply to root cpuset */
 	ret = 0;
-- 
2.31.0

