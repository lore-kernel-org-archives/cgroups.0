Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59AD40315F;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784602389; cv=none; b=qfD0Watwizf/f03yMUGUi+Zw4dPa+NgiZ/NzUBtITm70ZL1ey8CyT4168T5YpD9EFAzbyVkRygdE1gPHjVlG+UoUhWBeZbPX8PzoouSNQ/xa5jjAKuQkCXPc42p+UBco7/Jf/WLkskVnSkiTGjDAoK9WzFTF0AD882jygWulRFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784602389; c=relaxed/simple;
	bh=JpV22Go91sm1l5ZmXhWEkSXKUuaRnYmpd8p8KT1aw60=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UxnQRSxvQFNehE9AOwnQFxlQ+is77jcHeOslqSs9oSm77h4uZK5fKpaFcnlmc/Xz1+npNedAreuQ712GxrSzLzYkYR0tyx0H9rEUPzBn7pLOJDywMK6uJAfhW+aDYQUXyxM70woRW/L807fu1d0t+qpGcO5qiBMCjCd873FzVlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OpCXHLn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OpCXHLn0"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A882CC2BCFF;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784602389;
	bh=JpV22Go91sm1l5ZmXhWEkSXKUuaRnYmpd8p8KT1aw60=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OpCXHLn0A3bJ+aa4MSCA7kUV7uxqiXXIHvcVUPlhOaV6rW/hWTJmuZBsf+xrNpnNu
	 CiQAOCxPsCbbbBEJd54KRvYlI82kTX3/oZD5SyI520eoBfneSQTM5mN4NcNz5USZmp
	 NkwxBsEvZ0D0aWlbRrJAshs+wikoaIIhHYL8noEKlxlMjD1B+qtXAWitnr5YFbaI2g
	 S/PaJKCoiQcPaQeJiREfIzTmpuB7udzRgNo5QAK1Yq9sxcoF4uwBrEWnyQiqWvrjgv
	 6nL2NjUI6QVS3PRr5SGYteQRaCi74yLa8C1srWFbpu718vcNmPwf8bR8sQ9G+2NCz/
	 3+JfTzZLQVWMA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A4CC44532;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 20 Jul 2026 17:25:16 -0700
Subject: [PATCH v3 13/13] WIP: Reproducer for out_put_pages subpool reserve
 leakage
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hugetlb-alloc-failure-fixes-v3-13-7d2a169aa9ee@google.com>
References: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
In-Reply-To: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784602387; l=9148;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=C8+RXWPxhEZ0iEc4milJz3Gk4NI1eHcFg/eirCB7vkk=;
 b=q6N14FCm455WC6E/wtqOt21WQ9EGTtEaTl7luRiBu/0vYOPvnC8ObL8G6bHnPziiAVISRL15X
 x6XxCY8nTsCCLmEJMu1UapNUs92xUAIHuzRe/7jowOLIze6pP5/0MsE
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com

From: Ackerley Tng <ackerleytng@google.com>

Add a highly precise C reproducer and accompanying bash execution script
to exercise, validate, and stress-test the `out_put_pages` error path
rollback semantics in `hugetlb_reserve_pages()`.

How it works:
1. The bash script sets the system-wide HugeTLB pool to a highly constrained
   baseline of exactly `nr_hugepages = 1` and `nr_overcommit_hugepages = 0`.
2. It mounts a `hugetlbfs` instance with `-o pagesize=2M,min_size=2M,size=4M`,
   which causes the kernel to immediately consume the 1 available global page
   as the subpool's mount-time minimum size reserve (`rsv_hugepages` becomes 1).
3. The C reproducer then attempts a shared `mmap()` for `4M` (2 pages).
   - `hugepage_subpool_get_pages()` requests 2 pages, sees 1 reserved, and
     requests 1 additional global page.
   - `hugetlb_acct_memory()` attempts to secure that global page but immediately
     fails with `-ENOMEM` because the pool is exhausted.
   - The kernel jumps to the `out_put_pages` error path, calling
     `hugepage_subpool_put_pages()` to symmetrically roll back the reservation.
4. The script verifies that the subpool successfully retains its 1reserved page
   during the failure and returns it cleanly to the global pool upon unmount,
   proving that no underflow, double-free, or reserve leakage occurs in the
   `out_put_pages` boundary path.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 hugetlb_reserve_pages_out_put_pages.c  |  49 +++++++++++
 hugetlb_reserve_pages_out_put_pages.sh | 153 +++++++++++++++++++++++++++++++++
 2 files changed, 202 insertions(+)

diff --git a/hugetlb_reserve_pages_out_put_pages.c b/hugetlb_reserve_pages_out_put_pages.c
new file mode 100644
index 0000000000000..9e63fc8997d57
--- /dev/null
+++ b/hugetlb_reserve_pages_out_put_pages.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <fcntl.h>
+#include <err.h>
+#include <errno.h>
+
+int main(int argc, char **argv)
+{
+	const char *file_path;
+	size_t size;
+	int fd;
+	void *addr;
+
+	if (argc < 3) {
+		fprintf(stderr, "Usage: %s <hugetlbfs_file> <size_in_bytes>\n",
+			argv[0]);
+		return 1;
+	}
+
+	file_path = argv[1];
+	size = strtoull(argv[2], NULL, 0);
+
+	fd = open(file_path, O_CREAT | O_RDWR, 0666);
+	if (fd < 0)
+		err(1, "open");
+
+	printf("Attempting to mmap %zu bytes shared on %s...\n", size,
+	       file_path);
+	addr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		if (errno == ENOMEM) {
+			printf("mmap failed with ENOMEM as expected.\n");
+			close(fd);
+			return 0;
+		}
+		perror("mmap failed with unexpected error");
+		close(fd);
+		return 1;
+	}
+
+	printf("ERROR: mmap SUCCEEDED unexpectedly at %p\n", addr);
+	munmap(addr, size);
+	close(fd);
+	return 1;
+}
diff --git a/hugetlb_reserve_pages_out_put_pages.sh b/hugetlb_reserve_pages_out_put_pages.sh
new file mode 100755
index 0000000000000..030e1915539b4
--- /dev/null
+++ b/hugetlb_reserve_pages_out_put_pages.sh
@@ -0,0 +1,153 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+set -e
+
+if [ "$EUID" -ne 0 ]; then
+    echo "Please run as root"
+    exit 1
+fi
+
+SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
+cd "$SCRIPT_DIR"
+
+# Detect default hugepage size to support both 2MB and 1GB pages robustly
+hpz=$(grep -i hugepagesize /proc/meminfo | awk '{print $2}')
+kb=$hpz
+mb=$((kb / 1024))
+hpage_size_bytes=$((kb * 1024))
+
+hpage_dir="hugepages-${kb}kB"
+SYSFS_PATH="/sys/kernel/mm/hugepages/$hpage_dir"
+
+MNT_PATH="/tmp/mnt_hugetlb_repro"
+FILE_PATH="$MNT_PATH/test_file"
+
+# Save original values for safe restoration
+orig_nr=$(cat "$SYSFS_PATH/nr_hugepages")
+orig_overcommit=$(cat "$SYSFS_PATH/nr_overcommit_hugepages")
+
+cleanup() {
+    echo "Cleaning up..."
+    rm -f "$FILE_PATH"
+    umount "$MNT_PATH" 2>/dev/null
+    rmdir "$MNT_PATH" 2>/dev/null
+    echo "$orig_nr" > "$SYSFS_PATH/nr_hugepages"
+    echo "$orig_overcommit" > "$SYSFS_PATH/nr_overcommit_hugepages"
+    echo "Cleanup done."
+}
+trap cleanup EXIT
+
+# Verify reproducer binary exists
+if [ ! -x ./hugetlb_reserve_pages_out_put_pages ]; then
+    echo "reproducer binary './hugetlb_reserve_pages_out_put_pages' not found or not executable."
+    echo "Please compile it first: gcc -static -o hugetlb_reserve_pages_out_put_pages hugetlb_reserve_pages_out_put_pages.c"
+    exit 1
+fi
+
+# 1. Set global pool such that only the mount-time reservation can succeed
+echo 1 > "$SYSFS_PATH/nr_hugepages"
+echo 0 > "$SYSFS_PATH/nr_overcommit_hugepages"
+
+initial_resv=$(cat "$SYSFS_PATH/resv_hugepages")
+echo "Initial resv_hugepages (before mount): $initial_resv"
+
+# 2. Mount with min_size = 1 page, max size = 2 pages
+min_size_str="${mb}M"
+max_size_str="$((mb * 2))M"
+mmap_size_bytes=$((hpage_size_bytes * 2))
+
+mkdir -p "$MNT_PATH"
+echo "Mounting hugetlbfs with pagesize=${mb}M, min_size=$min_size_str, size=$max_size_str..."
+if ! mount -t hugetlbfs -o "pagesize=${mb}M,min_size=$min_size_str,size=$max_size_str" none "$MNT_PATH"; then
+    echo "Failed to mount hugetlbfs"
+    exit 1
+fi
+
+resv_after_mount=$(cat "$SYSFS_PATH/resv_hugepages")
+echo "resv_hugepages after mount: $resv_after_mount"
+expected_after_mount=$((initial_resv + 1))
+if [ "$resv_after_mount" != "$expected_after_mount" ]; then
+    echo "ERROR: resv_hugepages is not $expected_after_mount after mount (actual: $resv_after_mount)!"
+    exit 1
+fi
+
+# Check mount stats after mount
+expected_bsize=$hpage_size_bytes
+bsize_S=$(stat -f -c "%S" "$MNT_PATH")
+bsize_s=$(stat -f -c "%s" "$MNT_PATH")
+echo "Mount block size after mount: $bsize_S / $bsize_s (expected: $expected_bsize)"
+if [ "$bsize_S" != "$expected_bsize" ] && [ "$bsize_s" != "$expected_bsize" ]; then
+    echo "ERROR: Unexpected mount block size after mount (actual S:$bsize_S s:$bsize_s, expected: $expected_bsize)"
+    exit 1
+fi
+
+actual_stats_mount=$(stat -f -c "%b %f %a" "$MNT_PATH")
+expected_stats_mount="2 2 2"
+echo "Mount stats after mount (total free avail): $actual_stats_mount (expected: $expected_stats_mount)"
+if [ "$actual_stats_mount" != "$expected_stats_mount" ]; then
+    echo "ERROR: Unexpected mount stats after mount: $actual_stats_mount (expected: $expected_stats_mount)"
+    exit 1
+fi
+
+# 3. Run the reproducer to trigger the out_put_pages failure path
+echo "Running reproducer (expecting mmap failure with ENOMEM)..."
+if ./hugetlb_reserve_pages_out_put_pages "$FILE_PATH" "$mmap_size_bytes"; then
+    echo "Reproducer finished successfully."
+    resv_after_mmap=$(cat "$SYSFS_PATH/resv_hugepages")
+    echo "resv_hugepages after failed mmap: $resv_after_mmap"
+    expected_after_mmap=$expected_after_mount
+    if [ "$resv_after_mmap" = "$expected_after_mmap" ]; then
+        echo "RESULT: out_put_pages EXERCISED (resv_hugepages preserved at $expected_after_mmap as expected)"
+
+        # Check mount stats
+        expected_bsize=$hpage_size_bytes
+        bsize_S=$(stat -f -c "%S" "$MNT_PATH")
+        bsize_s=$(stat -f -c "%s" "$MNT_PATH")
+        echo "Mount block size: $bsize_S / $bsize_s (expected: $expected_bsize)"
+        if [ "$bsize_S" != "$expected_bsize" ] && [ "$bsize_s" != "$expected_bsize" ]; then
+            echo "ERROR: Unexpected mount block size (actual S:$bsize_S s:$bsize_s, expected: $expected_bsize)"
+            exit 1
+        fi
+
+        actual_stats=$(stat -f -c "%b %f %a" "$MNT_PATH")
+        expected_stats="2 2 2"
+        echo "Mount stats (total free avail): $actual_stats (expected: $expected_stats)"
+        if [ "$actual_stats" != "$expected_stats" ]; then
+            echo "RESULT: Unexpected mount stats after failed mmap (FAIL)"
+            exit 1
+        else
+            echo "RESULT: Mount stats restored to $expected_stats as expected (PASS)"
+        fi
+    else
+        echo "RESULT: Unexpected resv_hugepages value: $resv_after_mmap (expected: $expected_after_mmap)"
+        exit 1
+    fi
+else
+    echo "FAIL: Reproducer returned non-zero (mmap didn't fail with ENOMEM)"
+    exit 1
+fi
+
+# 4. Disable trap and do manual cleanup to check for final unmount underflow
+trap - EXIT
+
+echo "Unmounting..."
+umount "$MNT_PATH"
+rmdir "$MNT_PATH"
+
+final_resv=$(cat "$SYSFS_PATH/resv_hugepages")
+echo "Final resv_hugepages (after unmount): $final_resv"
+
+# Restore original values
+echo "Restoring original hugepage settings..."
+echo "$orig_nr" > "$SYSFS_PATH/nr_hugepages"
+echo "$orig_overcommit" > "$SYSFS_PATH/nr_overcommit_hugepages"
+
+if [ "$final_resv" = "$initial_resv" ]; then
+    echo "RESULT: State restored to $initial_resv (or cleaned up if fixed)"
+    echo "ALL DONE."
+    exit 0
+else
+    echo "RESULT: Underflow/Leak/Incorrect state detected! (final_resv = $final_resv, expected = $initial_resv)"
+    echo "ALL DONE."
+    exit 1
+fi

-- 
2.55.0.229.g6434b31f56-goog


