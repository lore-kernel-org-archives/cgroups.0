From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v2 0/5] Minor cleanups and performance optimizations for
 LRU rework
Date: Tue, 18 Aug 2020 21:26:57 -0700
Message-ID: <20200819041852.23414.95939.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=6h612JI2s0g5y4Ra24/kFs/yiArKTc1sB1o5qgaZ/yA=;
        b=LNxAKNkPYb4d+9N1/y9oUHLhX61kCIDjUBthQJ7A+5jMmKKB0C+Lv50He4t5SJQZTy
         L2JVj53G4ItXbzZAJpmXd2RUU4bNLcRG7dT4aMeHwMd/LhrckJ4LxNKRoNAYQNchSUrd
         ngQlflwv1GSSfQiAmYTIwGlUiHdbt1Y9eyam0cCfh5xO756GrdchR4hinz2jWLBHHwMy
         UPZCJp2C9hGe5uxoIyI39NAt1X8qOQu7qibpJ+lfUO4DsinFdI3vOgjN0pBE1U8ZYXAS
         tD7jnvOY6pm6XVJFFrpNdi28Jgihb4pRUESe4xonX7brqf6enMEk4Xy5GJgPavb/eEZT
         8G6Q==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org
Cc: yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org

So this patch set addresses a few minor issues I have found and is based on
the lrunext branch of the tree at:
https://github.com/alexshi/linux.git

The first three patches address various issues if ound with the patch set
such as the fact that we were skipping non-LRU compound pages one 4K page
at a time, the fact that test_and_set_skip had been made redundant by the
fact that the LRU bit made the setting of the bit exclusive per pageblock,
and the fact that we were using put_page while holding the LRU lock.

The last two patches are some patches I have been experimenting with.
Basically trying to reduce the number of times the LRU lock has to be
released and reacquired by batching LRU work together, or deferring the
freeing/returning of pages to LRU in the case of move_pages_to_lru. I am
still working on generating data but for the fourth patch I have seen an
improvement of about 5% on the will-it-scale/page_fault2 test with THP
enabled by default, however that is just some preliminary data and I still
have a number of tests left to run.

---

Alexander Duyck (5):
      mm: Identify compound pages sooner in isolate_migratepages_block
      mm: Drop use of test_and_set_skip in favor of just setting skip
      mm: Add explicit page decrement in exception path for isolate_lru_pages
      mm: Split release_pages work into 3 passes
      mm: Split move_pages_to_lru into 3 separate passes


 mm/compaction.c |   84 +++++++++++++++---------------------------
 mm/swap.c       |  109 ++++++++++++++++++++++++++++++++++---------------------
 mm/vmscan.c     |   77 +++++++++++++++++++++++----------------
 3 files changed, 142 insertions(+), 128 deletions(-)
