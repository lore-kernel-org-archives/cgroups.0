From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Mon, 28 Jan 2019 06:30:33 -0800
Message-ID: <20190128143033.GN50184@devbig004.ftw2.facebook.com>
References: <20190123223144.GA10798@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1ogb3hFMHB8WCDDPWWGm6OYJJs0L4GkVd3fDg6sKROY=;
        b=L1ydZxq2pUdx41QvZPNxpibVmlWNSwIjOand8ivfRjISmfa1LIaEOSgbFYxaCSfydA
         9JKxXq9itIXeevyyuBGJLlFvvNMbaCxOhfKS7sqFVcq9o2ImHgRNS2PQ7u2P7OE/8Ld1
         vnN1CBwoZeu0o42j/hO7OJiH4yjm2hm6aM07+9zdXFS+ZBMBhS9pEW5fDqUbGYEn+Lir
         D5NhFy92Kzkr0o4YoBq/SMH3e2HXhOOzRhaJ0INHmUPkPVYoNe1eXw+pLHT94+qlDtsR
         eNw8P/PcwD5FAWBJTBDnl4nJZaCanVN663vg1JgF1tds/39xysXE1CSWq+en5qvrzmRl
         zWeg==
Content-Disposition: inline
In-Reply-To: <20190123223144.GA10798@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Wed, Jan 23, 2019 at 05:31:44PM -0500, Chris Down wrote:
> memory.stat and other files already consider subtrees in their output,
> and we should too in order to not present an inconsistent interface.
> 
> The current situation is fairly confusing, because people interacting
> with cgroups expect hierarchical behaviour in the vein of memory.stat,
> cgroup.events, and other files. For example, this causes confusion when
> debugging reclaim events under low, as currently these always read "0"
> at non-leaf memcg nodes, which frequently causes people to misdiagnose
> breach behaviour. The same confusion applies to other counters in this
> file when debugging issues.
> 
> Aggregation is done at write time instead of at read-time since these
> counters aren't hot (unlike memory.stat which is per-page, so it does it
> at read time), and it makes sense to bundle this with the file
> notifications.
...
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Tejun Heo <tj@kernel.org>

Michal has a valid counterpoint that this is a change in userland
visible behavior but to me this patch seems to be more of a bug fix
than anything else in that it's addressing an obvious inconsistency in
the interface.

Thanks.

-- 
tejun
