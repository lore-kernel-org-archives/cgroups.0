From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] cgroup: pids: show number of failed forks since
 limit reset
Date: Sun, 26 Jun 2016 19:42:58 -0400
Message-ID: <20160626234258.GJ9219@stj.duckdns.org>
References: <20160624030049.13341-1-asarai@suse.de>
 <20160624030049.13341-2-asarai@suse.de>
 <20160624153151.GQ3262@mtj.duckdns.org>
 <78d17b23-d712-7d9c-3655-34c646bc4897@suse.de>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j5Oj2Z1CTipeli5S6qBY/28iXVuTZ6xFcLTwALqGT/4=;
        b=P/ZUaGjq+9TQ3y6hMKoLF0V5g05RdfGOw0ZBO1oH+f3XKROWYy6mGqH54l4FcCG80+
         8nOQeYh+ahQIVBRCPbSnib7+8Ypjy83p7WIXUoo2440cUki5KVXc3TyV+MvBsVTwCNKE
         QyWTz+v7c43gJtBvLOelkjhiR9Y8KoR9m9W/jkD36sw2KVXXwmCLg4pLzUKVTnl2C/iV
         R+AXpDi5fTP50KGrZCJEeYm04AqSMuNQf/xcERHLiDvhh5x0PIwmgxE0s6DXdskPHIDc
         RrNggQgdpIwrNP/q0D3u1iKPcxSTf+sCq9S9bkUufuz56LwC2r/2pe1Ucm3iYx5BpGP+
         h9fw==
Content-Disposition: inline
In-Reply-To: <78d17b23-d712-7d9c-3655-34c646bc4897@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Kenny Yu <kennyyu@fb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello,

On Sun, Jun 26, 2016 at 09:34:41PM +1000, Aleksa Sarai wrote:
> If a user has a setup where they wait for notifications on changes to
> pids.event, and then auto-adjust the cgroup limits based on the number of
> failures you have a race condition between reading the pids.event file and
> then setting the new limit. Then, upon getting notified again there may have
> been many failed forks with the old limit set, so you might decide to bump
> up the limit again.
> 
> It's not a huge deal, I just though it could be useful to alleviate problems
> like the above.

This is something which can easily be avoided from userland.  I don't
think we need to add extra facilities for this.

Thanks.

-- 
tejun
