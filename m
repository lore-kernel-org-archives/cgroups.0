From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: vmscan: memcontrol: remove
 mem_cgroup_select_victim_node()
Date: Tue, 29 Oct 2019 17:54:59 -0700
Message-ID: <20191029175459.b3bfed9326559e69acdd2e35@linux-foundation.org>
References: <20191029234753.224143-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572396900;
        bh=tFF8Zjgmu+WIIlTlxCMd0FFO5WyZqnXX4sv24/2yUUc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=z6JxpYIAXwYaitOroIOgVkFFJ+fD7w974Y/gOcL+K9o7d1P1lWTu08tW16aKNpUvw
         y+t/MUhPzHfbuARnFWHe6PZgDfV3SiJMRkW2/CE4taPh37lj9lpTCJutLLoo1fzGnY
         M/E0EaPON/9wkaV7L85UXF+LEpMHvI7mmNWumlTY=
In-Reply-To: <20191029234753.224143-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>
Cc: Greg Thelen <gthelen@google.com>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+13f93c99c06988391efe@syzkaller.appspotmail.com

On Tue, 29 Oct 2019 16:47:53 -0700 Shakeel Butt <shakeelb@google.com> wrote:

> Since commit 1ba6fc9af35b ("mm: vmscan: do not share cgroup iteration
> between reclaimers"), the memcg reclaim does not bail out earlier based
> on sc->nr_reclaimed and will traverse all the nodes. All the reclaimable
> pages of the memcg on all the nodes will be scanned relative to the
> reclaim priority. So, there is no need to maintain state regarding which
> node to start the memcg reclaim from. Also KCSAN complains data races in
> the code maintaining the state.
> 
> This patch effectively reverts the commit 889976dbcb12 ("memcg: reclaim
> memory from nodes in round-robin order") and the commit 453a9bf347f1
> ("memcg: fix numa scan information update to be triggered by memory
> event").
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: <syzbot+13f93c99c06988391efe@syzkaller.appspotmail.com>

I can't find the original sysbot email.  Help?

iirc the incidentally-fixed issue is a rather theoretical data race and
the patch isn't a high priority thing?

