From: Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH 2/4] memcg: check for proper lock held in mem_cgroup_update_page_stat
Date: Thu, 22 Aug 2013 17:52:11 +0800
Message-ID: <1377165131-24052-1-git-send-email-handai.szj@taobao.com>
References: <CAFj3OHXy5XkwhxKk=WNywp2pq__FD7BrSQwFkp+NZj15_k6BEQ@mail.gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cJmV8LHHS6UDRSrqz+7lVarDyvolh1lis2AaAjd9txg=;
        b=IDADedow3ADWsc8AcjF1cESGJyUFbjoUGGFN+idpdj/odV01+bbXICwJfQD6pd2cJF
         Lzalov1SF3LvNp0JjnCUuwUbh5X10golGUuUtvborSUHhQ6xDkJwUqV7YGwzGXiiQ2Cz
         Jj5dpLd944MmxpKX2cXytxpEBNvpmYttzuSL7FgXQuELYEAZSNDZGOqENJzm4l/HllL6
         yYTAjWSHVowz8g1EhGmysOZYOxG8B3/Mx/V9wRQPiggxTwnEXJfyG/BJKmOuJoc7/MYf
         no0DvN98rhi7l6/caRpXE7fx9sGplC2PfujDMsn+kSOAcuKLSP0/unB2FocCqEfYDu8p
         16dA==
In-Reply-To: <CAFj3OHXy5XkwhxKk=WNywp2pq__FD7BrSQwFkp+NZj15_k6BEQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>

From: Sha Zhengju <handai.szj@taobao.com>

We should call mem_cgroup_begin_update_page_stat() before
mem_cgroup_update_page_stat() to get proper locks, however the
latter doesn't do any checking that we use proper locking, which
would be hard. Suggested by Michal Hock we could at least test for
rcu_read_lock_held() because RCU is held if !mem_cgroup_disabled().

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Greg Thelen <gthelen@google.com>
---
 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 24d6d02..0a50871 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2249,6 +2249,7 @@ void mem_cgroup_update_page_stat(struct page *page,
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
