From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] Documentation: memcg: use 'CONFIG_MEMCG_SWAP'
Date: Wed, 25 Jun 2014 09:20:51 +0200
Message-ID: <1403680851.1960.28.camel@x220>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Commit c255a458055e ("memcg: rename config variables") renamed
CONFIG_CGROUP_MEM_RES_CTLR_SWAP to CONFIG_MEMCG_SWAP. It missed this use
of that macro due to two typos. Rename it too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
The second typo is bit subtle!

 Documentation/cgroups/memcg_test.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
index 8870b0212150..3759237f8b2c 100644
--- a/Documentation/cgroups/memcg_test.txt
+++ b/Documentation/cgroups/memcg_test.txt
@@ -48,7 +48,7 @@ Please note that implementation details can be changed.
 
 	At cancel(), simply usage -= PAGE_SIZE.
 
-Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
+Under below explanation, we assume CONFIG_MEMCG_SWAP=y.
 
 4. Anonymous
 	Anonymous page is newly allocated at
-- 
1.9.3

