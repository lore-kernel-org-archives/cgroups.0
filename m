From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-4.2] MAINTAINERS: add a cgroup core co-maintainer
Date: Fri, 12 Jun 2015 17:15:23 -0500
Message-ID: <20150612221523.GA26854@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=1l8F4ta3YotkkuiaL/burq5D9W7onKTaLyIkRGLPsuE=;
        b=bI+bZ8ujFXyMKGwqPL4PESkkP02kmV6mSyqUWwneOboufLxeO0Tp6Kb9cvgx8ea3Ww
         PFsDph7cCPdKacqUllSGwxhO/yi9BExExZ7P5zUnA5brqHweCgohicvHeX7YVl8F+oYm
         /mLy8uVYA72xwX3pA78I+CeT+WkJrIFGDdFZCnbAkapWdSLn6hULC1BAne/7Gjka4bfq
         iU9lGBlhO5bioTBD1QkyPkKhDKEstkyqf3wd4RutzMK9hq5N77ArdaO2RYrqaic1/ta1
         QkcJqfqbRwTZrPcN3PHiXjovfH+3G3POyCGcO/zkUgcIJUYLcB6sDq96H+7x0fqQbdUt
         aUvw==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Add Johannes Weiner as a co-maintainer of cgroup core.  Johannes has
been heavily involved with the design of the v2 interface and is
familiar with design and implementation of cgroup core.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ea00017..1d39599 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2695,6 +2695,7 @@ F:	drivers/connector/
 CONTROL GROUP (CGROUP)
 M:	Tejun Heo <tj@kernel.org>
 M:	Li Zefan <lizefan@huawei.com>
+M:	Johannes Weiner <hannes@cmpxchg.org>
 L:	cgroups@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
