From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup
 is above protection
Date: Thu, 30 Apr 2020 02:16:26 +0100
Message-ID: <20200430011626.GA2754277@chrisdown.name>
References: <cover.1588092152.git.chris@chrisdown.name>
 <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
 <CALOAHbCotD1-+o_XZPU_4_i8Nn98r5F_5NpGVd=z6UG=rUcCmA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l64V23ovWLJzXgRwUJUSoRHmFCYvD/C61lUFlvHuAM8=;
        b=NEm5AmoTD2jKzz4hSccJVFQ1FPjZ6Bxkvy9pbF1n13au2XvE7BgLVefCXG75LJARlN
         vnoy8WuPgSjgJpXQR+RcXTzwoRRtfu4SDZm+Yc+p6DSFyw0qj5XWcrtNba7s9fwH42iU
         Dmrs/6XTu4+ArHUN5ftQeDPkUfs2GVxihVugU=
Content-Disposition: inline
In-Reply-To: <CALOAHbCotD1-+o_XZPU_4_i8Nn98r5F_5NpGVd=z6UG=rUcCmA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Yafang,

Yafang Shao writes:
>Would you pls. add some comments above these newly added WRITE_ONCE() ?
>E.g.
>What does them mean to fix ?
>Why do we must add WRITE_ONCE() and READ_ONCE here and there all over
>the memcg protection ?
>Otherwise, it may be harder to understand by the others.

There is already discussion in the changelogs for previous store tear 
improvements. For example, b3a7822e5e75 ("mm, memcg: prevent 
mem_cgroup_protected store tearing").

WRITE_ONCE and READ_ONCE are standard compiler barriers, in this case, to avoid 
store tears from writes in another thread (effective protection caching is 
designed by its very nature to permit racing, but tearing is non-ideal).

You can find out more about them in the "COMPILER BARRIER" section in 
Documentation/memory-barriers.txt. I'm not really seeing the value of adding an 
extra comment about this specific use of them, unless you have some more 
explicit concern.
