From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 0/3] Re: [PATCH v17 14/21] mm/compaction: do page
 isolation first in compaction
Date: Wed, 12 Aug 2020 21:02:15 -0700
Message-ID: <20200813035100.13054.25671.stgit@localhost.localdomain>
References: <3828d045-17e4-16aa-f0e6-d5dda7ad6b1b@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=P1KdIUWFxYzw82EVvLFYFt+MNwT3Xk5xYJFfFDC3pI4=;
        b=pbMlVToUVOgIRz7b6T0Cmo4L05tlQHpSEVkoGFYVI4InDZqz4mjEonJrT9TjtNOg8b
         H1zOIK5DzV6MtTsxmV9fSHEIQLgp/HpHSogVOWCoFPhXQ6fJFFwWEdNL+N2CnZ5Lq9Eh
         KLznw3j1mF7Yruy5bR7H1RwKK4cjJgFtfOyvX0pzuvUqmYwxNC3KQCf7LAfK6G+6ZOar
         rpdpM45wwqdiH4P8c7aHDPC4mw11hvtSvQcNXzQFAvg25sg0+z3INGyrQmgjMM1H3qEa
         VyH0kukxWyHrDUZoZ6LRTGeYFuS4MGUaeC8vuTJIpa+DGhF0afM/3v0dej2rrOgFilDF
         iYRA==
In-Reply-To: <3828d045-17e4-16aa-f0e6-d5dda7ad6b1b-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org
Cc: yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org

Here are the patches I had discussed earlier to address the issues in
isolate_migratepages_block.

They are based on the tree at:
 https://github.com/alexshi/linux.git lrunext 

The first patch is mostly cleanup to address the RCU locking in the
function. The second addresses the test_and_set_skip issue, and the third
relocates PageCompound.

I did some digging into the history of the skip bits and since they are
only supposed to be a hint I thought we could probably just drop the
testing portion of the call since the LRU flag is preventing more than one
thread from accessing the function anyway so it would make sense to just
switch it to a set operation similar to what happens when low_pfn ==
end_pfn at the end of the call.

I have only had a chance to build test these since rebasing on the tree. In
addition I am not 100% certain the PageCompound changes are correct as they
operate on the assumption that get_page_unless_zero is enough to keep a
compound page from being split up. I plan on doing some testing tomorrow,
but thought I would push these out now so that we could discuss them.

---

Alexander Duyck (3):
      mm: Drop locked from isolate_migratepages_block
      mm: Drop use of test_and_set_skip in favor of just setting skip
      mm: Identify compound pages sooner in isolate_migratepages_block


 mm/compaction.c |  126 +++++++++++++++++++------------------------------------
 1 file changed, 44 insertions(+), 82 deletions(-)
