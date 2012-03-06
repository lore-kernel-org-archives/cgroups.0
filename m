From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] memcg: revise the position of threshold index while unregistering event
Date: Tue,  6 Mar 2012 20:12:23 +0800
Message-ID: <1331035943-7456-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=3vOYW1U86eTLroKBBzVUuCBAwR7KlrTZcs1kHw/fFVs=;
        b=fzFYKQRntDE7CF91WPoOuSWhbV4QkSAYV67taxPg7UFPQy+cWI86w477zIuXGlt5Eb
         lZiC2mluHfOKllAyK26YRY/UWHiH2fbGJfANB7t04Vdw515E0KaTGKq0XK1BFN+ZKm8y
         YZ1XWmesZJDZCY8y00MkTzu7yDV3qMgDVIVOs8VI85iquPJtHk0CJtDmaDBZEnnn4bCv
         lXaX7GIdciqm5Tfb8bh2fCf3mSjUktsksCo0iGLC42xIGIIjRqeI4A77XBaxb0rKvM+u
         +pRo6zQ9XTu3s0//uQcx1Gt9CeDLQ4ACIMl15wlexAuWO28kRPvTQA8YP0AoSQbo5fIa
         5MYQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Index current_threshold should point to threshold just below or equal to usage.
See below:
http://www.spinics.net/lists/cgroups/msg00844.html


Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 22d94f5..cd40d67 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4398,7 +4398,7 @@ static void mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
 			continue;
 
 		new->entries[j] = thresholds->primary->entries[i];
-		if (new->entries[j].threshold < usage) {
+		if (new->entries[j].threshold <= usage) {
 			/*
 			 * new->current_threshold will not be used
 			 * until rcu_assign_pointer(), so it's safe to increment
-- 
1.7.4.1
