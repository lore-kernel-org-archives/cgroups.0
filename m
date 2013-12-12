From: Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH v13 11/16] mm: list_lru: add per-memcg lists
Date: Fri, 13 Dec 2013 00:48:03 +0400
Message-ID: <CAA6-i6rukbiu+_pnS1nkD45ViA0fnn9fQjhk74LWXOA+S=+7Tg@mail.gmail.com>
References: <cover.1386571280.git.vdavydov@parallels.com>
	<0ca62dbfbf545edb22b86bd11c50e9017a3dc4db.1386571280.git.vdavydov@parallels.com>
	<20131210050005.GC31386@dastard>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=XFm0pVcy22Y2kyLajDHa1Z5iuLO3AH+kOxMMsjyylYI=;
        b=BFlc/dlV+Wyvyzbi4k5jYznNyzVKuPmmEfys1MZVS4hdwnAE5nQJCwy2/8YbLrA9KT
         l5kZqR5uuAwQTX2EAGUzeU+SvDaRKXZhNVP5HYFzX6LV3ZMykJJGhmi4cWxNI0jDWkvu
         OkoLgthIPXWVUBFGmw8SX/DQkfZ/D7AyTG9wguwMTMKYP2hpTXtHn2eNnImquuHCEo/D
         Idc7BvXTETCNmDtt3l9KBMmSGszQCMvbUpP6yu35nJDcLCQfG+UnF7770rNeHNojIv5p
         zpots2oUCVeIqcMpm0K4zZzyiUB7cuUQij7RcRXftDSsGQFB1T95AWkLeupD5xl8NRTz
         sw8g==
In-Reply-To: <20131210050005.GC31386@dastard>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, dchinner@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Glauber Costa <glommer@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> OK, as far as I can tell, this is introducing a per-node, per-memcg
> LRU lists. Is that correct?
>
> If so, then that is not what Glauber and I originally intended for
> memcg LRUs. per-node LRUs are expensive in terms of memory and cross
> multiplying them by the number of memcgs in a system was not a good
> use of memory.
>
> According to Glauber, most memcgs are small and typically confined
> to a single node or two by external means and therefore don't need the
> scalability numa aware LRUs provide. Hence the idea was that the
> memcg LRUs would just be a single LRU list, just like a non-numa
> aware list_lru instantiation. IOWs, this is the structure that we
> had decided on as the best compromise between memory usage,
> complexity and memcg awareness:
>
Sorry for jumping late into this particular e-mail.

I just wanted to point out that the reason I adopted such matrix in my
design was that
it actually uses less memory this way. My reasoning for this was
explained in the original
patch that I posted that contained that implementation.

This is because whenever an object would go on a memcg list, it *would
not* go on
the global list. Therefore, to keep information about nodes for global
reclaim, you
have to put them in node-lists.

memcg reclaim, however, would reclaim regardless of node information.

In global reclaim, the memcg lists would be scanned obeying the node structure
in the lists.

Because that has a fixed cost, it ends up using less memory that having a second
list pointer in the objects, which is something that scale with the
number of objects.
Not to mention, that cost would be incurred even with memcg not being in use,
which is something that we would like to avoid.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
