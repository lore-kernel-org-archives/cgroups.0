From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH] memcg: Remove memcg_cgroup::id from IDR on
 mem_cgroup_css_alloc() failure
Date: Sun, 29 Jul 2018 22:26:21 +0300
Message-ID: <20180729192621.py4znecoinw5mqcp@esperanza>
References: <20180413112036.GH17484@dhcp22.suse.cz>
 <6dbc33bb-f3d5-1a46-b454-13c6f5865fcd@virtuozzo.com>
 <20180413113855.GI17484@dhcp22.suse.cz>
 <8a81c801-35c8-767d-54b0-df9f1ca0abc0@virtuozzo.com>
 <20180413115454.GL17484@dhcp22.suse.cz>
 <abfd4903-c455-fac2-7ed6-73707cda64d1@virtuozzo.com>
 <20180413121433.GM17484@dhcp22.suse.cz>
 <20180413125101.GO17484@dhcp22.suse.cz>
 <20180726162512.6056b5d7c1d2a5fbff6ce214@linux-foundation.org>
 <20180727193134.GA10996@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g120l+1kg1FvM93625X2HLCbuZ/cj28KpMCzCv6H4kk=;
        b=bhfO7xvSEvOjtMVR0cbM4dUCpJF3zsiWH/xeAfEICI0dpMBdNpxrJdjLI9hbU3pFf8
         r4v8H8Nm6DXVyDyqyifWqksTds3nY9GxXdnEfUPEm/gOGbTxb6FGY+qZaiOqg0XPVJ7f
         D1rFOaqEHXAhkPs1cfR5N92DVcyuv22FBPyG+jPKO8pfPWWKLtCo+ipG2wD64YZZc45a
         Y3QODYd0A0jHKrVyo8UdZyIw3HY7eLQmpKaLwtLrGUDIVv7/ggMBUf2LJc9f09q90x4w
         uugweW+4szHy1FsMBR8pKcBTB8hVMNZU5O6Qey3qmbUS7GuTcxRtWfCAflS+ObyDiWd9
         WMBw==
Content-Disposition: inline
In-Reply-To: <20180727193134.GA10996@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Kirill Tkhai <ktkhai@virtuozzo.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri, Jul 27, 2018 at 03:31:34PM -0400, Johannes Weiner wrote:
> That said, the lifetime of the root reference on the ID is the online
> state, we put that in css_offline. Is there a reason we need to have
> the ID ready and the memcg in the IDR before onlining it?

I fail to see any reason for this in the code.

> Can we do something like this and not mess with the alloc/free
> sequence at all?

I guess so, and this definitely looks better to me.
