From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH -mm -v6 2/9] mm, memcg: Support to charge/uncharge
 multiple swap entries
Date: Wed, 08 Mar 2017 22:37:56 +1100
Message-ID: <1488973076.13674.5.camel@gmail.com>
References: <20170308072613.17634-1-ying.huang@intel.com>
	 <20170308072613.17634-3-ying.huang@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7a9xFlCgiwbvXAEdN3gdDJqWvjSPPrn3CSYL5tF+mNU=;
        b=ItLl79uuM4/q9fy6a3kwB58W05dJAer9s+jaYfmfsRoIXP944J2Mstz+RcRYlyTFNT
         SrgV+HKvzFzmYORgLB9rECK1Z65I3Wh9KzNGZGSiPj16bjX/quq5aFgSU0GCJJFiKSJ2
         30t/PB+C9CZzrA7ITqCQcplXw4Yk0vTNSLGb7Tpyg4zPPpRXS0KpGALjYy/wl4o3V4us
         z4cylyY7FINIR5jFnWsQXxbSqfJhrVRkuZL1GCTVsrfV0Lgq4TWkpAyBL/oN36kNMRwW
         rTvVYEVblD8kR7U8AXL2e+xC61iuEno7cUSE+uJCZbxKWm8eCQT4LGCV3UvVdU157b+3
         1IXg==
In-Reply-To: <20170308072613.17634-3-ying.huang@intel.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Huang, Ying" <ying.huang@intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Vladimir Davydov <vdavydov@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

On Wed, 2017-03-08 at 15:26 +0800, Huang, Ying wrote:
> From: Huang Ying <ying.huang@intel.com>
> 
> This patch make it possible to charge or uncharge a set of continuous
> swap entries in the swap cgroup.  The number of swap entries is
> specified via an added parameter.
> 
> This will be used for the THP (Transparent Huge Page) swap support.
> Where a swap cluster backing a THP may be allocated and freed as a
> whole.  So a set of (HPAGE_PMD_NR) continuous swap entries backing one
> THP need to be charged or uncharged together.  This will batch the
> cgroup operations for the THP swap too.

A quick look at the patches makes it look sane. I wonder if we would
make sense to track THP swapout separately as well
(from a memory.stat perspective)

Balbir Singh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
