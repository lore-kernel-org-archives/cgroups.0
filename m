From: Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH V2 0/2] Provide more precise dump info for memcg-oom
Date: Wed,  7 Nov 2012 16:40:02 +0800
Message-ID: <1352277602-21687-1-git-send-email-handai.szj@taobao.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=cD4tm8bBNy7Z/ZWzHQ2XWLhQJhP9wtPHv7Rvp7ZRFZc=;
        b=hJP8LTlbEmHcmMwDsw1AoNFvyRfCLWZePtHixpRHQ1+5rIWfF0LStfQ5SguHUmZpi2
         laybpwjbe3rJ0LY7wL1ZRPeVZ6Re33muHP3Q1Dt7/Ow3QqyFXlnWu1RILJkMUsSs44Dv
         uxG/ja6HC1I22S/b/b0jFIRQrrH5k5up9VJnQbQeFLYwcJzWN7HbA8tguL1p9TVAWFRA
         Y6eDmAM9IQtYz3KwGC0pCSyrRhJ2LBxJkujGk5aW51QZfmm6Ld5tWLTcw23AGyMS9drm
         KMkOhcrnrrPl+z/z0Q3FhB77BCBE2UfcFrt8/ttNM6IzFvoaKpwtdgd5vPxKWVPfu65E
         UmSw==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, cgroups@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, rientjes@google.com
Cc: linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>

From: Sha Zhengju <handai.szj@taobao.com>


When memcg oom is happening the current memcg related dump information
is limited for debugging. The patches provide more detailed memcg page statistics
and also take hierarchy into consideration.
The previous primitive version can be reached here: https://lkml.org/lkml/2012/7/30/179.

Change log:
	1. some modification towards hierarchy
	2. rework dump_tasks
	3. rebased on Michal's mm tree since-3.6  

Any comments are welcomed. : )


Sha Zhengju (2):
	memcg-oom-provide-more-precise-dump-info-while-memcg.patch
	oom-rework-dump_tasks-to-optimize-memcg-oom-situatio.patch

 include/linux/memcontrol.h |    7 ++++
 include/linux/oom.h        |    2 +
 mm/memcontrol.c            |   85 +++++++++++++++++++++++++++++++++++++++-----
 mm/oom_kill.c              |   61 +++++++++++++++++++------------
 4 files changed, 122 insertions(+), 33 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
