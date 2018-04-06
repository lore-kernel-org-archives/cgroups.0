From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 3/4] mm: treat memory.low value inclusive
Date: Fri, 6 Apr 2018 12:38:02 -0400
Message-ID: <20180406163802.GA16383@cmpxchg.org>
References: <20180405185921.4942-1-guro@fb.com>
 <20180405185921.4942-3-guro@fb.com>
 <20180405194526.GC27918@cmpxchg.org>
 <20180406122132.GA7185@castle>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uRVB9Uovmd3OXzYs3nRkXSuERcfqGWHo66jmqocx+D8=; b=snuwDoGuE7phhJKZUf1g/j0oij
        NcL11QjtEmnCy9ADn65uuBIeRMNOpRVAibaRn2ZNyPFyrIFt7sztsK7YM3ier11mAN6tFKwg0nqOO
        AkclOe/ESmJ122jGyiq4G/cSYJD99OiHlhR8c48zVKNcS8BhprwGzGvP2GiTcHHFX5IA=;
Content-Disposition: inline
In-Reply-To: <20180406122132.GA7185@castle>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Apr 06, 2018 at 01:21:38PM +0100, Roman Gushchin wrote:
> Updated version below.
> 
> --
> 
> From 466c35c36cae392cfee5e54a2884792972e789ee Mon Sep 17 00:00:00 2001
> From: Roman Gushchin <guro@fb.com>
> Date: Thu, 5 Apr 2018 19:31:35 +0100
> Subject: [PATCH v4 3/4] mm: treat memory.low value inclusive
> 
> If memcg's usage is equal to the memory.low value, avoid reclaiming
> from this cgroup while there is a surplus of reclaimable memory.
> 
> This sounds more logical and also matches memory.high and memory.max
> behavior: both are inclusive.
> 
> Empty cgroups are not considered protected, so MEMCG_LOW events
> are not emitted for empty cgroups, if there is no more reclaimable
> memory in the system.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: kernel-team@fb.com
> Cc: linux-mm@kvack.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Looks good, thanks!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
