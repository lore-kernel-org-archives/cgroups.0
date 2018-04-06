From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 2/4] mm/vmscan: remove redundant
 current_may_throttle() check
Date: Fri, 6 Apr 2018 12:10:19 -0400
Message-ID: <20180406161019.GC20806@cmpxchg.org>
References: <20180323152029.11084-1-aryabinin@virtuozzo.com>
 <20180323152029.11084-3-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4qjaBhIBDkkHKyANJ7eTRrwgTBAaywsdFCnLQzNydTQ=; b=Bec/55qWAvc6/kYJS+968A2Fcr
        JsIpog2ohGmiW3koTB7DwyI1fZFUchW9fmzQFY4OYxF63Vzs0Xb7hQ/jSCivXwp3CoeMSu9Swa0Gl
        xtRX/6J+5NmIjGC7lcMTPaDGoUkKLDhUCDg8oqt86RBb56Rmk5VXNz9vTkAlKdiYwl2E=;
Content-Disposition: inline
In-Reply-To: <20180323152029.11084-3-aryabinin@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Fri, Mar 23, 2018 at 06:20:27PM +0300, Andrey Ryabinin wrote:
> Only kswapd can have non-zero nr_immediate, and current_may_throttle() is
> always true for kswapd (PF_LESS_THROTTLE bit is never set) thus it's
> enough to check stat.nr_immediate only.
> 
> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Acked-by: Michal Hocko <mhocko@suse.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
