From: Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH V5 3/8] memcg: check for proper lock held in mem_cgroup_update_page_stat
Date: Thu,  1 Aug 2013 19:52:26 +0800
Message-ID: <1375357946-10228-1-git-send-email-handai.szj@taobao.com>
References: <1375357402-9811-1-git-send-email-handai.szj@taobao.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=rLxXA7yvae1d6uFeNhupHu2Bhr7j9tltsSvUF/+NSMA=;
        b=SI9yngn611X8Et0SHBOkQsfe+27FQytNIy29O9EyMzedeqmX250M49vqyySkA2GgPl
         yP99jackWFsHFxGf5k3zxp8DdNLX9zuoD0gt4wzJwqCOQNeUPd10quDNE4DBzd9EWGTc
         2ZjUE8/f+FAk9cnvA39EJAhAOV+vaL+UWwMQuAwVblgmIJFw4alCz8rb9g2snWcAxRry
         2S7eSvaof1tFlgGp5y+qu6XItd0Jf6hQMPW5l2U/G7iqoaY59sCo8Xf+Gp85NK5vdRNL
         QpY+tL63ZmGIK0E/cJIAjn1A7UeNICPuzwCTpdaIzxyPXS+M77FsqHKnKGPN2I0XZ/RS
         eGJA==
In-Reply-To: <1375357402-9811-1-git-send-email-handai.szj@taobao.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, glommer@gmail.com, gthelen@google.com, fengguang.wu@intel.com, akpm@linux-foundation.org, Sha Zhengju <handai.szj@taobao.com>

From: Sha Zhengju <handai.szj@taobao.com>

We should call mem_cgroup_begin_update_page_stat() before
mem_cgroup_update_page_stat() to get proper locks, however the
latter doesn't do any checking that we use proper locking, which
would be hard. Suggested by Michal Hock we could at least test for
rcu_read_lock_held() because RCU is held if !mem_cgroup_disabled().

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7691cef..4a55d46 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2301,6 +2301,7 @@ void mem_cgroup_update_page_stat(struct page *page,
 	if (mem_cgroup_disabled())
 		return;
 
+	VM_BUG_ON(!rcu_read_lock_held());
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
 		return;
-- 
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
