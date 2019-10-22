From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 0/8]: mm: vmscan: cgroup-related cleanups
Date: Tue, 22 Oct 2019 10:47:55 -0400
Message-ID: <20191022144803.302233-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UutYteqTWkPmD48f0jNhpK+dvRJrMgtVJxTJWvlNPEM=;
        b=vlBYE+fWCY++BNYbapfKjvbzLNzuEMvv1UXCfI27y9wdHR3b89oXrVKLA8ud68Zs6J
         LqUbEsGJanuyERO6T1Dr7kUcpK/YSTQME+H9oYcAKQK8vlmOLbgPDHBVeq26VXQ5aBSV
         PLA0dfTYtghWw83ibT/hu+u8uuDVMlHbIetO16tszI+oUcbVZebbbpEmbKXBydiHkwhh
         SpNoB7b3+RMat88O1vqGmMpg8SHgx/hJBUHzbR1h4NcFWBtScqVSQK29G5nTaq5xJENX
         iE9rdbBtv3zaV6M4uLKi7GapV5UGPecdZrvbJlyMr47HQqY5Z6EgsWs3ROMRTwlkHnVY
         HQaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Here are 8 patches that clean up the reclaim code's interaction with
cgroups a bit. They're not supposed to change any behavior, just make
the implementation easier to understand and work with.

My apologies in advance for 5/8, which changes the indentation of
shrink_node() and so results in a terrible diff. The rest of the
series should be straight-forward.

 include/linux/memcontrol.h |  32 ++--
 include/linux/mmzone.h     |  26 +--
 mm/memcontrol.c            |  12 +-
 mm/page_alloc.c            |   2 +-
 mm/slab.h                  |   4 +-
 mm/vmscan.c                | 386 +++++++++++++++++++------------------------
 mm/workingset.c            |   8 +-
 7 files changed, 216 insertions(+), 254 deletions(-)


