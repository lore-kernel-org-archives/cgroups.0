From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v6 0/3] Directed kmem charging
Date: Tue, 19 Jun 2018 12:11:49 -0400
Message-ID: <20180619161149.GA27423@cmpxchg.org>
References: <20180619051327.149716-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+IqX0uvqzAWjSDuvjz2ayMip+Gsi1TKGyqUNwCy3Wgk=; b=TH3jD+yHYEgEQsWkWsf9xNCyDy
        iH2seAn+hK6YDoD1ezwik4ADymd9SAaBXf+pvSjCCMLc166wBLk+4qbTG8OGxSt/A/MNrTvotc0zJ
        RXnNPjSWUbXSEluxLTcL4wcLqQ1ZQjBRUTD49J8SDMSJHb+zGzwCjTFIYFg+eksO29bM=;
Content-Disposition: inline
In-Reply-To: <20180619051327.149716-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

Hi Shakeel,

this looks generally reasonable to me.

However, patch 1 introduces API that isn't used until patch 2 and 3,
which makes reviewing harder since you have to jump back and forth
between emails. Please fold patch 1 and introduce API along with the
users.

On Mon, Jun 18, 2018 at 10:13:24PM -0700, Shakeel Butt wrote:
> This patchset introduces memcg variant memory allocation functions.  The
> caller can explicitly pass the memcg to charge for kmem allocations.
> Currently the kernel, for __GFP_ACCOUNT memory allocation requests,
> extract the memcg of the current task to charge for the kmem allocation.
> This patch series introduces kmem allocation functions where the caller
> can pass the pointer to the remote memcg.  The remote memcg will be
> charged for the allocation instead of the memcg of the caller.  However
> the caller must have a reference to the remote memcg.  This patch series
> also introduces scope API for targeted memcg charging. So, all the
> __GFP_ACCOUNT alloctions within the specified scope will be charged to
> the given target memcg.

Can you open with the rationale for the series, i.e. the problem
statement (fsnotify and bh memory footprint), *then* follow with the
proposed solution?

Thanks!
