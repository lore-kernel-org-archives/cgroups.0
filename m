From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm/memcontrol: update lruvec counters in
 mem_cgroup_move_account
Date: Tue, 15 Oct 2019 09:53:48 -0400
Message-ID: <20191015135348.GA139269@cmpxchg.org>
References: <157112699975.7360.1062614888388489788.stgit@buzz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rdFD1ySM7snbTlYVusRsUK5w8tupUNVkhhCAYZ7l2Pc=;
        b=y5eyFIzUZPf7JNQjTnetQoWn3BAyiwEjxA5Z4qE2NKrnEC5SXIMN2+3NTw9lnNtQpl
         8jXl1nYoG97Myed+YXA4VidWTzzkb728WjXDdyiTxMAnQnJCgfOxgYm+hXr813ku/ApS
         D/V/R44Njsqn3oEV6/kJ7kxFhqWh4qQzvA/G0IpIq0MYI9ymag/1KcZjH4FecF15gYer
         FWTe0oBPGVvjex692yOemBosnoB8ax+5iL9DTQF+3g1QQvhV+wm+0euRJZqpsxIc5fHh
         t7R60n9eCfBoflqA7J0pr4mOMAlD6cCJW5kjSZJkYio+WNor05cV2ad46SLhRD6o/TXk
         48kw==
Content-Disposition: inline
In-Reply-To: <157112699975.7360.1062614888388489788.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>

On Tue, Oct 15, 2019 at 11:09:59AM +0300, Konstantin Khlebnikov wrote:
> Mapped, dirty and writeback pages are also counted in per-lruvec stats.
> These counters needs update when page is moved between cgroups.
> 
> Fixes: 00f3ca2c2d66 ("mm: memcontrol: per-lruvec stats infrastructure")
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Please mention in the changelog that currently is nobody *consuming*
the lruvec versions of these counters and that there is no
user-visible effect. Thanks
