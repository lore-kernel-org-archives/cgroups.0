Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17D445D5FB;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784763681; cv=none; b=EYJ2fz3SfPTq4CFVF63T0Burs2pvFVyNjvENgrNJV3o+L9XWph9wEpnGf5xLyM8sgLTsXd6VlJM/eYtwmfMDMTwdNaqYUqQYcw9roZAMG3TGneN7vAJc6Ins4tLJ1OJ4E04lcRV/kqbZVrSljX2/9PsUhva3VRyEErTDYc1w6k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784763681; c=relaxed/simple;
	bh=IaSkp3fdmtv7NRhfe3SroO5xQIMOPLdrrRcj/2IEtlE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=J1cMrIk41ufCYI3lT4/73H//eb+bo5twIlz2rVrqUFQI0MnlbPbthw+SkrjlD5dEt2Si9KT0VQ91FQkyrLjNYFvE3Ksdnb6lDf4YayMZorIUuE8Y4PrE7r+FCoGPcZinNXCiAUMYVVD6vyWPfXSql0dYToLJ6XkyjhDiGn3mBRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XlQib/ow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XlQib/ow"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF269C2BCF7;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=IaSkp3fdmtv7NRhfe3SroO5xQIMOPLdrrRcj/2IEtlE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XlQib/owPAVh3H7KfaNS4PyZkmlCbiHxJjSJbi29AcA2PUhaNCMdYbn3nFoRKC9xf
	 9z7uj6VoT2q8h7zOKugYJorEvmpU3Ogas/oag/J0kR4AO2H+LU63b7FxgJ4Gr1HRvm
	 XgUXx2mabgUEG1SbqIrZybG/YFb+q/b8g/7wgFb08ytsJltdsj4feTnw9aEAejYHuR
	 E9YKl0Fbd/Wm5TdI5yiu0eV1JkPbKkcLxscGACQJPCWJW1kfX8kMWHjTV0SZP4ji1m
	 zTuPDeKmBWVqyzfVfxxz5YIWSu284D3KT0zYL+zxGSRlK87q7wKxeFgXEQCE/u3/cC
	 j7G2h1Adnf0Mw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA00C4453F;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:22 -0700
Subject: [PATCH v4 14/16] WIP: Reproducer for subpool usage leak
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-14-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=4644;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=E4drmq1mZkjUTuE98aQslvvt9cikJbWZghcgFkli30k=;
 b=HiSFLR0mil6K38uaer8wl9Fy+05WtiROHkCptxCr9umgO7pDRf//LRN/q++nLpLWmSKUyE1xs
 3Zjk/paa3R0Cx5A8PWmokVRUBC6lXEwTZfCv4jw5HxO6WGQpOvLFmfx
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com

From: Ackerley Tng <ackerleytng@google.com>

(This reproducer was hacked up and not meant to be merged.)

The kernel leaks subpool usage and the subpool structure itself if a HugeTLBfs
mount specifying size (which sets max_hpages on the subpool) is created.

subpool_leak_max_size.sh reproduces this with the following steps:

1. Create mount, specifying size=2M (1 page). This sets max_hpages = 1 on the
   subpool, but does not reserve any pages.
2. Set nr_hugepages = 0 and nr_overcommit_hugepages = 0 so that physical
   allocations will fail.
3. Run fallocate -l 2M on a file in the mount.
     + This calls hugetlbfs_fallocate, which attempts to allocate a page by
       calling alloc_hugetlb_folio.
     + alloc_hugetlb_folio calls hugepage_subpool_get_pages to track the
       allocation against the subpool limit. This increments used_hpages to 1.
     + Physical allocation fails because nr_hugepages is 0.
     + Before patch (Buggy):
         + The error path in alloc_hugetlb_folio sees gbl_chg is 1 (indicating
           we tried to allocate a global page) and incorrectly skips calling
           hugepage_subpool_put_pages.
         + fallocate fails and returns to userspace, but the subpool used_hpages
           counter remains leaked at 1.
     + After patch:
         + The error path always calls hugepage_subpool_put_pages if map_chg is
           true, restoring used_hpages to 0.

4. Unmount the filesystem.
     + During unmount, the kernel calls unlock_or_release_subpool to clean up
       the subpool.
     + It checks if the subpool is free using subpool_is_free, which returns
       whether used_hpages is 0.
     + Before patch (Buggy):
         + Since used_hpages leaked and is 1, subpool_is_free returns false.
         + The kernel skips freeing the subpool structure, leaking the
           hugepage_subpool structure in kernel memory.
     + After patch:
         + Since used_hpages is 0, subpool_is_free returns true, and the subpool
           structure is correctly freed.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 subpool_leak_max_size.sh | 72 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/subpool_leak_max_size.sh b/subpool_leak_max_size.sh
new file mode 100755
index 0000000000000..226fd2766c4d0
--- /dev/null
+++ b/subpool_leak_max_size.sh
@@ -0,0 +1,72 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+if [ "$EUID" -ne 0 ]; then
+    echo "Please run as root"
+    exit 1
+fi
+
+MNT_PATH="/tmp/mnt_hugetlb"
+FILE_PATH="$MNT_PATH/test_file"
+
+# Save original values
+orig_nr=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
+orig_overcommit=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_overcommit_hugepages)
+
+cleanup() {
+    echo "Cleaning up..."
+    rm -f "$FILE_PATH"
+    umount "$MNT_PATH" 2>/dev/null
+    rmdir "$MNT_PATH" 2>/dev/null
+    echo "$orig_nr" > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+    echo "$orig_overcommit" > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_overcommit_hugepages
+    echo "Cleanup done."
+}
+trap cleanup EXIT
+
+# 1. Mount hugetlbfs with size=2M (1 page)
+mkdir -p "$MNT_PATH"
+if ! mount -t hugetlbfs -o size=2M none "$MNT_PATH"; then
+    echo "Failed to mount hugetlbfs"
+    exit 1
+fi
+
+# 2. Set nr_hugepages to 0, overcommit to 0
+echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_overcommit_hugepages
+
+# Check subpool usage before running
+read total free < <(stat -f -c "%b %f" "$MNT_PATH")
+used_before=$((total - free))
+echo "Before test - Subpool total blocks: $total"
+echo "Before test - Subpool free blocks:  $free"
+echo "Before test - Subpool used blocks:  $used_before"
+if [ "$used_before" -ne 0 ]; then
+    echo "ERROR: Subpool is not clean before test starts!"
+    exit 1
+fi
+
+# Run fallocate (expecting failure)
+echo "Running fallocate (expecting failure)..."
+if fallocate -l 2M "$FILE_PATH" 2>/dev/null; then
+    echo "ERROR: fallocate succeeded but should have failed (nr_hugepages is 0)"
+    exit 1
+fi
+
+# Check subpool usage via statfs
+# %b: Total blocks
+# %f: Free blocks
+read total free < <(stat -f -c "%b %f" "$MNT_PATH")
+used=$((total - free))
+
+echo "Subpool total blocks: $total"
+echo "Subpool free blocks:  $free"
+echo "Subpool used blocks (leaked if > 0): $used"
+
+if [ "$used" -gt 0 ]; then
+    echo "RESULT: LEAK DETECTED (FAIL)"
+    exit 1
+else
+    echo "RESULT: NO LEAK (PASS)"
+    exit 0
+fi

-- 
2.55.0.229.g6434b31f56-goog


