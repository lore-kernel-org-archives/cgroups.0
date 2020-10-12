From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: localize mem_cgroup_sockets_enabled()
 check
Date: Mon, 12 Oct 2020 09:58:23 -0400
Message-ID: <20201012135823.GA188876@cmpxchg.org>
References: <20201010104521.67262-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LiRTK1pn0r+YX72HhN94UTqVGuwvK727gErKq+9p5co=;
        b=kdD+EQ/dal5vV717URB/8INdiZStUkziLF+UP1/oTSbkc1xgOTizbXO5c7UxoZEPEW
         ciXRZScy5HT82Nv+OD2jUtLvQ9ZQUcBf5lQFSVG840aSBl/RscDr0IFlx4mq7nv7MQ35
         qKKeS7bNKo7We6dmI+xlw49U9Yldi1thKV+okEC746kq4DMa7X461pF8ef+CffG9QZHZ
         P4KVdg4bG0zObRLP2mgNLOg61igdJOJIBA0f9nLPUnjww4ZBDnQ2ZQq2sYhk6myWpyxs
         kMjev9XtTo/GbPHtFljwhoUpLw1Rj5mPbkW6NIMYdXRlfoGwcEQJYFL0k3Ft/+QUy2a5
         zMxQ==
Content-Disposition: inline
In-Reply-To: <20201010104521.67262-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: davem@davemloft.net, kuba@kernel.org, edumazet@google.com, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, shakeelb@google.com, guro@fb.com, iamjoonsoo.kim@lge.com, laoar.shao@gmail.com, chris@chrisdown.name, daniel@iogearbox.net, kafai@fb.com, ast@kernel.org, jakub@cloudflare.com, linmiaohe@huawei.com, keescook@chromium.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Sat, Oct 10, 2020 at 06:45:21PM +0800, Muchun Song wrote:
> Move the mem_cgroup_sockets_enabled() checks into memcg socket charge
> or uncharge functions, so the users don't have to explicitly check that
> condition.
> 
> This is purely code cleanup patch without any functional change. But
> move the sk_memcg member of the sock structure to the CONFIG_MEMCG
> scope.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  include/linux/memcontrol.h      | 78 ++++++++++++++++++++++++++-------
>  include/net/sock.h              |  5 ++-
>  include/net/tcp.h               |  3 +-
>  mm/memcontrol.c                 | 43 +++++++++++++-----
>  net/core/sock.c                 | 15 +++----
>  net/ipv4/inet_connection_sock.c |  6 +--
>  net/ipv4/tcp_output.c           |  3 +-
>  7 files changed, 111 insertions(+), 42 deletions(-)

Hm, this is almost 3 times as much code.

The sk_memcg saving on !CONFIG_MEMCG is somewhat nice, but it's not
clear how many users would benefit here. And it adds ifdefs in code.

Also memcg code now has to know about struct sock.

I'm not quite sure that this is an overall improvement.
