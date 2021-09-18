From: Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v7 10/12] test_sysfs: enable deadlock tests by default
Date: Fri, 17 Sep 2021 22:04:28 -0700
Message-ID: <20210918050430.3671227-11-mcgrof@kernel.org>
References: <20210918050430.3671227-1-mcgrof@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=REleVeJdVPAjpr9HeQ2cRfmfpLS6DlhRbk/XlbxpQOE=; b=QzR7NY5Fd+cQRWfTaqtKiaRDUV
        7qaA68e8dCYZLdZDm52bd5Qv5sR8TTBOZtQE2sCzurKg7c4TAWpBZDfN8TPQFeQSNO0NNCAtRXKjd
        +eW3WMTgmid5sptLhXA8FJEmBlDDVf/KtTSKj+aW7kly6s9LnI/NMzthxasKWR5NSQLkhSLVM1N5u
        q1Adv1Z46q6/pEFTCp7nSmls2dmWNOgw+lx+r5+0oX0xV2Kao7Y0j7mDWXvE6bcj7F8AJvIRQqINN
        tMgQ1XPNN3YpvzDsgq5TLOS7BYsXE3otLzEfvuOIUw3CP1bbCUEEiwC/PHluEyP631IqjSvAFSbeM
        f3vzE3og==;
In-Reply-To: <20210918050430.3671227-1-mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: Luis Chamberlain <mcgrof-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jeyu-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ndesaulniers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ojeda-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org, vitor-HdruG0TBZYlAfugRpC6u6w@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rf-yzvPICuk2AA4QjBA90+/kJqQE7yCjDx5@public.gmane.org, stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org, David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, trishalfonso-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mbenes-IBi9RG/b67k@public.gmane.org, ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org, sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, daniel.vetter-/w4YWyX8dFk@public.gmane.org, bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kw-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, dan.j.williams@intel.c

Now that sysfs has the deadlock race fixed with module removal,
enable the deadlock tests module removal tests. They were left
disabled by default as otherwise you would deadlock your system

./tools/testing/selftests/sysfs/sysfs.sh -t 0027
Running test: sysfs_test_0027 - run #0
Test for possible rmmod deadlock while writing x ... ok

./tools/testing/selftests/sysfs/sysfs.sh -t 0028
Running test: sysfs_test_0028 - run #0
Test for possible rmmod deadlock using rtnl_lock while writing x ... ok

Signed-off-by: Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 tools/testing/selftests/sysfs/sysfs.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/sysfs/sysfs.sh b/tools/testing/selftests/sysfs/sysfs.sh
index f928635d0e35..4047ac48e764 100755
--- a/tools/testing/selftests/sysfs/sysfs.sh
+++ b/tools/testing/selftests/sysfs/sysfs.sh
@@ -60,8 +60,8 @@ ALL_TESTS="$ALL_TESTS 0023:1:1:test_dev_y:block"
 ALL_TESTS="$ALL_TESTS 0024:1:1:test_dev_x:block"
 ALL_TESTS="$ALL_TESTS 0025:1:1:test_dev_y:block"
 ALL_TESTS="$ALL_TESTS 0026:1:1:test_dev_y:block"
-ALL_TESTS="$ALL_TESTS 0027:1:0:test_dev_x:block" # deadlock test
-ALL_TESTS="$ALL_TESTS 0028:1:0:test_dev_x:block" # deadlock test with rntl_lock
+ALL_TESTS="$ALL_TESTS 0027:1:1:test_dev_x:block" # deadlock test
+ALL_TESTS="$ALL_TESTS 0028:1:1:test_dev_x:block" # deadlock test with rntl_lock
 ALL_TESTS="$ALL_TESTS 0029:1:1:test_dev_x:block" # kernfs race removal of store
 ALL_TESTS="$ALL_TESTS 0030:1:1:test_dev_x:block" # kernfs race removal before mutex
 ALL_TESTS="$ALL_TESTS 0031:1:1:test_dev_x:block" # kernfs race removal after mutex
-- 
2.30.2

