From: Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH 3/7][TRIVIAL][resend] drivers/pci: cleanup kernel-doc warning
Date: Fri, 15 Jun 2012 21:15:49 +0800
Message-ID: <1339766154-7470-1-git-send-email-liwp.linux@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=XK9D+Ei2gJEDYJ6qctnQ9roL/WMiGoUs6OPnMH918TM=;
        b=iQtFLo2zURu6ISm0HQ1NFOvh0prJ+sXrmvimnE01zowM1osJ9k77j1HjwGxM75JAmI
         tbPWGLJlNaaB0jOZkzqmue73axQG+Sr83GhrsMobmrTC+Vh4DH+TxdlcKecX0QjsEd+c
         dj8s5Lb9YSP1N10vtfzax0K8Yu8D+kGzAd4Rz+XMNehsAC0XXaRXwQOAb7zgeGi4J9fR
         4QSM+EjHcDRAX5QVNCZsDmS6HMsB8X8TRUUU6PvWQp61Ex8xd66t+rKRkqrqGZUSGDft
         bAoGrYPQCOXqNrpNlIrR6Hlvg0Y27DX/EVyqKacj0rTAwsG/ZrwwpqXHVy6h/3Vq/76k
         pnnA==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Christoph Lameter <cl@linux-foundation.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Milton Miller <miltonm@bga.com>, Nishanth Aravamudan <nacc@us.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Jason Wessel <jason.wessel@windriver.com>, Jan Kiszka <jan.kiszka@siemens.com>, David Howells <dhowells@redhat.com>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Warning(drivers/pci/setup-bus.c:277): No description found for parameter 'fail_head'
Warning(drivers/pci/setup-bus.c:277): Excess function parameter 'failed_list' description in 'assign_requested_resources_sorted'

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 drivers/pci/setup-bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 8fa2d4b..9165d25 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -265,7 +265,7 @@ out:
  * assign_requested_resources_sorted() - satisfy resource requests
  *
  * @head : head of the list tracking requests for resources
- * @failed_list : head of the list tracking requests that could
+ * @fail_head : head of the list tracking requests that could
  *		not be allocated
  *
  * Satisfy resource requests of each element in the list. Add
-- 
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
