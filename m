From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm: vmscan: memcg: Add global shrink priority
Date: Sun, 29 Dec 2019 14:02:40 +0000
Message-ID: <20191229140240.GB612003@chrisdown.name>
References: <1576662179-16861-1-git-send-email-teawaterz@linux.alibaba.com>
 <20191218140952.GA255739@chrisdown.name>
 <25AA9500-B249-42C2-B162-2B8D4EE83BB0@linux.alibaba.com>
 <20191219112618.GA72828@chrisdown.name>
 <1E6A7BC4-A983-4C65-9DA9-4D3A26D4D31D@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tVdSh5eigGfpfZbcGPOwFmTu1bT8ccSTdspsY1KsgDw=;
        b=QYExPAlecIZL1gnZxQC2xAYNOQMYgcCITRyrl9YRy7vqXB90bkcdXQ0PNNPKj+EfIY
         XbxHnw6z/MYyt8nlFYs49bKYSGMGMdpvYQ4QZkCFEDPLndQdvuyJElvqaxMHi909zBA1
         Yn5uZ2Ws6avDpxFA76+O6cfBw5jIPVmBer4XQ=
Content-Disposition: inline
In-Reply-To: <1E6A7BC4-A983-4C65-9DA9-4D3A26D4D31D@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: teawater <teawaterz@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Yang Shi <yang.shi@linux.alibaba.com>, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

Hi Hui,

teawater writes:
>In the memory-constrained and complex multitasking environment such as an Android system may require more complex performance priority.
>For example, the tasks of app in the font, they need high priority because low priority will affect the user experience at once.
>The tasks of app in background should have lower priority than the first one.  And sometime, each app should have different priority.  Because some apps are frequently used.  They should have high priority than other background apps.
>The daemons should have lower priority than background apps.  Because most of them will not affect the user experience.

In general I don't think it's meaningful to speculate about whether it would 
help or not without data and evidence gathering. It would really depend on how 
the system is composed overall. Is this a real problem you're seeing, or just 
something hypothetical?

If there is a real case to discuss, we can certainly discuss it. That said, at 
the very least I think the API needs to be easier to reason about rather than 
just exposing mm internals, and there needs to be a demonstration that it 
solves a real problem and existing controls are insufficient :-)

Thanks,

Chris
