From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: vmscan: memcontrol: remove
 mem_cgroup_select_victim_node()
Date: Tue, 29 Oct 2019 17:47:23 -0700
Message-ID: <20191029174723.ceb916ec850e7c88ed00e091@linux-foundation.org>
References: <20191029234753.224143-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572396444;
        bh=rC4DTyV2zuA+J7bw7dlMjJDABthKcuPGgzmZ5hyLjuk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DqNmB7cmPEMslfCggeao0xz1kdv2tQhIkyD7Hc8ovAHyXPu3xJlmo9hCCB4yuZF2C
         Yqf39GHojD759SooL74JvoLuYT7M8J0q4zOVJ8XoFBP4Q/DrCA+/i6JM6+iJH4KCx8
         s/OLz4DGT94C0Dhpc+xlz1YOg3OoodQ3lsuWTBl0=
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

The sysbot report
(http://lkml.kernel.org/r/00000000000055aba7058af4d378@google.com) was
for a null pointer deref.  So won't we be needing a Fixes: and cc:stable?
