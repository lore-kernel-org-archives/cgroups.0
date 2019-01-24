From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm: Move maxable seq_file logic into a single place
Date: Thu, 24 Jan 2019 11:56:34 -0500
Message-ID: <20190124165634.GA13549@chrisdown.name>
References: <20190124061718.GA15486@chrisdown.name>
 <20190124160935.GB12436@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/n5RO3ynJj5/bNE9tmIzk4EgTVnmQBOVPbiCNZWucCY=;
        b=YKWa4jgiYZ79VkYeO8kCZgz1L1IMeQnAHkMW+GVd2NfaNUXvRA6B7g/3RPcFoQVc6O
         0tvrfJrA8IDHOdaGmgsDJ8trxGoio6EUvlkDrQBuR0wQIpBM/6QhLqHCdRbvUJlt9tTd
         PZ7QeIDKBV9N5XPgf+MVl1Ix8wDc2uxHANCMk=
Content-Disposition: inline
In-Reply-To: <20190124160935.GB12436@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Johannes Weiner writes:
>I think this increases complexity more than it saves LOC,
>unfortunately.
>
>The current situation is a bit repetitive, but much more obviously
>correct. And we're not planning on adding many more of those memcg
>interface files, so I this doesn't seem to be an improvement re:
>maintainability and future extensibility of the code.

Hmm, my main goal in the patch was not really reduction of LOC, but more around 
centralising logic so that it's clear where these functions are unique and 
where they are completely the same. My initial reaction upon reading these was 
mostly to feel like I'm missing something due to the large amount of similarity 
between them, wondering if the change in mem_cgroup/page_counter access is 
really the only thing to look at, so my goal was primarily to reduce confusion 
(although of course this is subjective, I can also see your point about how 
having "memory.low" and the like without context can also be confusing).

I think using a macro is not ideal, but unfortunately without it a lot of the 
complexity can't really be abstracted easily.

If not this, what would you think about a patch that adds two new functions:

1. mem_cgroup_from_seq
2. mem_cgroup_write_max_or_val

This won't be able to reduce as much of the overlap as the macro, but it still 
will centralise a lot of the logic.
