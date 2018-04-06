From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 1/4] mm/vmscan: Update stale comments
Date: Fri, 6 Apr 2018 12:08:57 -0400
Message-ID: <20180406160857.GB20806@cmpxchg.org>
References: <20180323152029.11084-1-aryabinin@virtuozzo.com>
 <20180323152029.11084-2-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Yk0mF2PrAHc7DG2gjfAJ1w4G5cqbkvwVkotHvpR9H8s=; b=GOugoxbIBMrA1S1zO+8vFzpqRm
        Wj+PZljXZrtZn6RcOWXhoApTNp9K2Juv9DU+aozxcpp/agQ7urVBRPsy53x8Ln5W/ZlsnBVgARexc
        IwwR9W7Uu8/Y4+ziSFvj/pYeDOA9N3fCszCD4By85UyMf9zybD27GICVSBem4uLw+Ai8=;
Content-Disposition: inline
In-Reply-To: <20180323152029.11084-2-aryabinin@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Fri, Mar 23, 2018 at 06:20:26PM +0300, Andrey Ryabinin wrote:
> Update some comments that become stale since transiton from per-zone
> to per-node reclaim.
> 
> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Acked-by: Michal Hocko <mhocko@suse.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
