From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Patch v2 0/3] mm/memcg: some cleanup for mem_cgroup_iter()
Date: Wed, 30 Mar 2022 23:47:16 +0000
Message-ID: <20220330234719.18340-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=9LsSC7UA/+paobOapmA1UTtO12gXoTTx/WztGKAK+nc=;
        b=fe8eEAxqUkCZXNGaq3RHJrZtPAa7wyQzIypVPUh9xnoN6xe8QrIvlcinUSoQ6IUwhD
         MsAIu87gT2JCNO2a5tAm6RP/syCmhSmtdFYMrW5HEfNhzGlRxUChrw8BMQWKR289xWnS
         WjapK7MM2ND4tNqj5/C9UmPFZ+uMsaguZKFcYNppJSJZCtDU+3EnT96GQnXANK0oY0hd
         8Z2Wo2LpiGv/0Y4JEKbKMSQdv5CyDm2YYqX6xqZfwtesHHXVylMZBzm6t32Z+B9mp4D8
         OA3Qu4yzBCYSpwB24NguEODDVRhh6T5/BFUncycCXkxxqhcmTKHb7PeJ+gZ2nDyTUfxH
         gAew==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

No functional change, try to make it more readable.

v2: some adjustment as suggested by Johannes 

Wei Yang (3):
  mm/memcg: set memcg after css verified and got reference
  mm/memcg: set pos explicitly for reclaim and !reclaim
  mm/memcg: move generation assignment and comparison together

 mm/memcontrol.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

-- 
2.33.1

