From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: vmscan: fix IO/refault regression in cache
 workingset transition
Date: Tue, 4 Apr 2017 18:29:52 -0400
Message-ID: <20170404222952.GA28930@cmpxchg.org>
References: <20170404220052.27593-1-hannes@cmpxchg.org>
 <20170404150703.742c49d73921df6369ed3dbd@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZgTmYVQ5yGsluxvbsFSFKVnQPGMTI0oR5LNHITjszLI=; b=0rIjDRzh/5Mze7RFlm75Gui96/
        3TNz4IddVjE/OgpCsrwOs5uw5MdJPPQE2OUXvSHMNYSPv+d1b7c0ufzurUaf8nvGUs5ZS8ZIPFeQM
        GvhMQpSWFJd6U+8u8gvrLhepuYjL/0Adv9dbN/+t0HF9fA2GUu98LbkjZXNNeyL0XZLM=;
Content-Disposition: inline
In-Reply-To: <20170404150703.742c49d73921df6369ed3dbd-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Apr 04, 2017 at 03:07:03PM -0700, Andrew Morton wrote:
> On Tue,  4 Apr 2017 18:00:52 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> 
> > Since 59dc76b0d4df ("mm: vmscan: reduce size of inactive file list")
> > we noticed bigger IO spikes during changes in cache access patterns.
> > 
> > The patch in question shrunk the inactive list size to leave more room
> > for the current workingset in the presence of streaming IO. However,
> > workingset transitions that previously happened on the inactive list
> > are now pushed out of memory and incur more refaults to complete.
> > 
> > This patch disables active list protection when refaults are being
> > observed. This accelerates workingset transitions, and allows more of
> > the new set to establish itself from memory, without eating into the
> > ability to protect the established workingset during stable periods.
> > 
> > Fixes: 59dc76b0d4df ("mm: vmscan: reduce size of inactive file list")
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.7+
> 
> That's a pretty large patch and the problem has been there for a year. 
> I'm not sure that it's 4.11 material, let alone -stable.  Care to
> explain further?

The problem statement is a little terse, my apologies.

The workloads that were measurably affected for us were hit pretty bad
by it, with refault/majfault rates doubling and tripling during cache
transitions, and the machines sustaining half-hour periods of 100% IO
utilization, where they'd previously have sub-minute peaks at 60-90%.

Stateful services that handle user data tend to be more conservative
with kernel upgrades. As a result we hit most page cache issues with
some delay, as was the case here.

The severity seemed to warrant a stable tag, but I agree that holding
out until 4.11.1 is probably better, given the invasiveness of this.
