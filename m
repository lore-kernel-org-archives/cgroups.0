From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Thu, 30 Apr 2020 15:29:07 -0400
Message-ID: <20200430192907.GA2436@cmpxchg.org>
References: <20200430182712.237526-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/eq6aHDyq4eplML2a4cRLGlwq126IAji+Fvgv3MjJ3w=;
        b=b4OU7wwbA3wxPurcG9pIX2GntI2Xn9noV/RldtqK/ry2Aih34RZFyG37mvEUhqPgUJ
         FZuolZ4rblAdaMTfLS/iPurKZ2F/6LgIKXT/SPaEjMRd+QYwp0iY0BM+tlLBA7fvDX0b
         PoKDmL7E0sHYEdt3HL88joyXkVl1giGBlW/wGc0A4Z+11ui4tXTZR9v+/zrk6N9GA6vQ
         haEP1z4FLxKtLHf0Jh1JXqAuHFmIlunGDsdbG4opwBuPEkRLvy8YZ6HWRP9GmVpISVqB
         FH581z7KqQk9BGUSOLm3k9zUxr+9oN1hYP+uY2Iia++2Azdeu1TiYpS2K1o6nZxcsaMj
         dT1A==
Content-Disposition: inline
In-Reply-To: <20200430182712.237526-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Apr 30, 2020 at 11:27:12AM -0700, Shakeel Butt wrote:
> Lowering memory.max can trigger an oom-kill if the reclaim does not
> succeed. However if oom-killer does not find a process for killing, it
> dumps a lot of warnings.
> 
> Deleting a memcg does not reclaim memory from it and the memory can
> linger till there is a memory pressure. One normal way to proactively
> reclaim such memory is to set memory.max to 0 just before deleting the
> memcg. However if some of the memcg's memory is pinned by others, this
> operation can trigger an oom-kill without any process and thus can log a
> lot un-needed warnings. So, ignore all such warnings from memory.max.

Can't you set memory.high=0 instead? It does the reclaim portion of
memory.max, without the actual OOM killing that causes you problems.
