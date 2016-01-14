From: Martijn Coenen <maco@google.com>
Subject: [PATCH] memcg: Only free spare array when readers are done
Date: Thu, 14 Jan 2016 14:33:52 +0100
Message-ID: <001a113abaa499606605294b5b17@google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=F045+Kud0Qdy41oKGEv5jGz4PK0qEbBOdZdLblbc5KY=;
        b=BTIgWi5/vdRrRWysDx9GaRH75wRcVHyXmLjS3gTJf6Xy5kQ1WRchjYGB1d2M49M2do
         tsNCgqW+E7K89XTqDjoZzJAoGrzGj1TeJF674aM626sCdOi4BOSIVn1SPBxTph5REJwa
         DHudJL+BpuF6XYQGW3a9F0XxVAtgVtdv1i0Ta181w0q8gk8Y6T2/gSuXlh6TiTUS+c18
         AqelxqnpL0kle0XXFNEyQ5//EF3YBRRmR2UGAovyToXtvlfooLNa4U5KGd+kdqdqugFu
         zLIoIjMch5dkoIkIAVSeNyZIZRCRdOaMTAROoSeBRYwSFBg6kfsfWFDAOON3R6C/ntVI
         Eolg==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

A spare array holding mem cgroup threshold events is kept around
to make sure we can always safely deregister an event and have an
array to store the new set of events in.

In the scenario where we're going from 1 to 0 registered events, the
pointer to the primary array containing 1 event is copied to the spare
slot, and then the spare slot is freed because no events are left.
However, it is freed before calling synchronize_rcu(), which means
readers may still be accessing threshold->primary after it is freed.

Fixed by only freeing after synchronize_rcu().

Signed-off-by: Martijn Coenen <maco@google.com>
---
  mm/memcontrol.c | 11 ++++++-----
  1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 14cb1db..73228b6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3522,16 +3522,17 @@ static void  
__mem_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
  swap_buffers:
  	/* Swap primary and spare array */
  	thresholds->spare = thresholds->primary;
-	/* If all events are unregistered, free the spare array */
-	if (!new) {
-		kfree(thresholds->spare);
-		thresholds->spare = NULL;
-	}

  	rcu_assign_pointer(thresholds->primary, new);

  	/* To be sure that nobody uses thresholds */
  	synchronize_rcu();
+
+	/* If all events are unregistered, free the spare array */
+	if (!new) {
+		kfree(thresholds->spare);
+		thresholds->spare = NULL;
+	}
  unlock:
  	mutex_unlock(&memcg->thresholds_lock);
  }
-- 
2.6.0.rc2.230.g3dd15c0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
