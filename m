From: Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH 4/4] memcg: Document cgroup dirty/writeback memory statistics
Date: Thu, 22 Aug 2013 17:53:42 +0800
Message-ID: <1377165222-24235-1-git-send-email-handai.szj@taobao.com>
References: <CAFj3OHXy5XkwhxKk=WNywp2pq__FD7BrSQwFkp+NZj15_k6BEQ@mail.gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ea37Wixbzj65vp5cjuDTKqg6xduLu3rUJMgDPvapM2g=;
        b=gXxTcT+NHXSC0GmI/UsYwQnFAvQalR32JqOwK3otprmc/f+TTQFNdti6WfBN+BQRFf
         w6e0pjFglskVDIqdw4EY9cKgh40TvmKijJ6gQpdVGhSA6QrBGRkUwNj+XH7dUL1U2BS+
         ERjDtC6wQ6PsNOX30pJu6n+Z1ICqzsz4C03jZB0GSnoog033Ivz9jEus/enhtqEHXpcn
         e8tDRH3eBSARNphIUX6BWO6HRRlhZR+rHy8z+J6KQBx5IBhl6EAxph6OKXLUCUeHK8O9
         rNmHRwiz9bWe8td8JEjLG2CUrixWv06VfU6zwwS1r8XtdF+iVdxxJBIVv7JKxpvecfu1
         c7yg==
In-Reply-To: <CAFj3OHXy5XkwhxKk=WNywp2pq__FD7BrSQwFkp+NZj15_k6BEQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>

From: Sha Zhengju <handai.szj@taobao.com>

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 Documentation/cgroups/memory.txt |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 327acec..c9ea502 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -490,6 +490,7 @@ pgpgin		- # of charging events to the memory cgroup. The charging
 pgpgout		- # of uncharging events to the memory cgroup. The uncharging
 		event happens each time a page is unaccounted from the cgroup.
 swap		- # of bytes of swap usage
+writeback      - # of bytes of file/anon cache that are queued for syncing to disk.
 inactive_anon	- # of bytes of anonymous memory and swap cache memory on
 		LRU list.
 active_anon	- # of bytes of anonymous and swap cache memory on active
-- 
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
