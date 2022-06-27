From: Vasily Averin <vvs@openvz.org>
Subject: [PATCH mm v2] memcg: notify about global mem_cgroup_id space
 depletion
Date: Mon, 27 Jun 2022 05:11:26 +0300
Message-ID: <97bed1fd-f230-c2ea-1cb6-8230825a9a64@openvz.org>
References: <Yre8tNUY8vBrO0yl@castle>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=l3AbRcb3euHIPSR9NMXHx/86nFq6XgvCj4Y708407TI=;
        b=o0XCv7KUDJSIdcVmSBhxbsYa0J3ql98Deo9ytYEOPzqH2Urm67Hxxy/ZP677pKTbHk
         82l3qp7hq5PQ1I8LcLBh8+vZ8vDsJC8q8JLAe2NBc20Uthc2x6PcfJhlWyV3DxTcVnmc
         64k1BjpS8AJUbQwqwUyYI4fxkEHSVynTciRK8xJPzQ9VdIK39/QBsTdVys7zbzA2LK0f
         CQYF2r0f7qDjBNvbsmCDdcsSZ6WoBh/wO7A1IpCtgz0kABXJ7sDvre6cV8caASu1Vt0+
         gq0Q7T8+9emWYjCddt6d4CynBSRyRqh4ANhQwOux3JrZy6nwA02R6X568g4eF/B/sT6E
         igtQ==
Content-Language: en-US
In-Reply-To: <Yre8tNUY8vBrO0yl@castle>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>
Cc: kernel@openvz.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, Muchun Song <songmuchun@bytedance.com>, cgroups@vger.kernel.org

Currently, the host owner is not informed about the exhaustion of the
global mem_cgroup_id space. When this happens, systemd cannot start a
new service and receives a unique -ENOSPC error code.
However, this can happen inside this container, persist in the log file
of the local container, and may not be noticed by the host owner if he
did not try to start any new services.

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
v2: Roman Gushchin pointed that idr_alloc() should return unique -ENOSPC
    if no free IDs could be found, but can also return -ENOMEM.
    Therefore error code check was added before message output and
    patch descriprion was adopted.
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d4c606a06bcd..ffc6b5d6b95e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5317,6 +5317,8 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 				 1, MEM_CGROUP_ID_MAX + 1, GFP_KERNEL);
 	if (memcg->id.id < 0) {
 		error = memcg->id.id;
+		if (error == -ENOSPC)
+			pr_notice_ratelimited("mem_cgroup_id space is exhausted\n");
 		goto fail;
 	}
 
-- 
2.36.1

