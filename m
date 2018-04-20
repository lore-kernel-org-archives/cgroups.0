From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] mm: move the high field from struct mem_cgroup to
 page_counter
Date: Fri, 20 Apr 2018 16:54:50 -0400
Message-ID: <20180420205450.GB24563@cmpxchg.org>
References: <20180420163632.3978-1-guro@fb.com>
 <20180420163632.3978-2-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fEY29b6hQBUF2+tDn5H04jzf/O5xYpFOxubFo8tD0zw=; b=yinF7UxtIFrVYggXl3QuBT1i2U
        RUiSG47VWYLtkjFdtWkbMQe+X7PCWUBtRHw5NJ2PcHYP+54t8cnS9mI/F8zUGB1NgD6Th3TRsvb6i
        jVx8xb+TnjCDO4LCCacuRbd6yU4vwF9tYu1gWGWbu4AMnKYNOvyA+dcVXxgufMby5eH8=;
Content-Disposition: inline
In-Reply-To: <20180420163632.3978-2-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>

On Fri, Apr 20, 2018 at 05:36:32PM +0100, Roman Gushchin wrote:
> We do store memory.min, memory.low and memory.max actual values
> in struct page_counter fields, while memory.high value is located
> in the struct mem_cgroup directly, which is not very consistent.
> 
> This patch moves the high field from struct mem_cgroup to
> struct page_counter to simplify the code and make handling
> of all limits/boundaries clearer.

I would prefer not doing this.

Yes, it looks a bit neater if all these things are next to each other
in the struct, but on the other hand it separates the high variable
from high_work, and it adds an unnecessary setter function as well.

Plus, nothing in the page_counter code actually uses the value, it
really isn't part of that abstraction layer.
