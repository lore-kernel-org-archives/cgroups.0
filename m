From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rename MEM_CGROUP_STAT_SWAPOUT as
 MEM_CGROUP_STAT_NR_SWAP
Date: Fri, 1 Jun 2012 10:54:27 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1206011047430.9814@eggly.anvils>
References: <4FC89BC4.9030604@jp.fujitsu.com> <20120601165320.GA1761@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=6x6ZaSWJRGIEXsBxZxsY1biHdyV50bDKcqP9Uha7Z6s=;
        b=KfvQdfFwR2cYMMPKsLY/PY5mzFqAHeUSMgcAFqlkd15skcgClQZBPwjVfiOEiR8FT5
         RL39RZYdQSpNpJD42C4GVt2/FYUpg5AUGPN0fBBT93BcdZUy8DZw6qlOJZgUDvYshmNF
         aa8cZSWAFO6eK8Hpp+cGQgCJ5cfLUT7EN5TuP4jmhA3tLdSGxq25CUseqy7pn8iILAxh
         1Caem141jciy8rwiu9C6G4VSRlxV8PXphs/DTb9aItIvbvlLIG3Qyv9qFmK9ITejRYV+
         C7maZRjDaInSJSvX6Ufg0QQogug2uk7aFG53Uc0/A4VQt5+ivYef6XF230HOT/QyTBIs
         CICA==
In-Reply-To: <20120601165320.GA1761-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Fri, 1 Jun 2012, Johannes Weiner wrote:
> On Fri, Jun 01, 2012 at 07:39:00PM +0900, Kamezawa Hiroyuki wrote:
> > MEM_CGROUP_STAT_SWAPOUT represents the usage of swap rather than
> > the number of swap-out events. Rename it to be MEM_CGROUP_STAT_NR_SWAP.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> 
> Wouldn't MEM_CGROUP_STAT_SWAP be better?  It's equally descriptive but
> matches the string.  And we also don't have NR_ for cache, rss, mapped
> file etc.

That's just what I thought too.

You can attach Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
to MEM_CGROUP_STAT_SWAP and MEM_CGROUP_CHARGE_TYPE_ANON.

Oh, and to a patch deleting MEM_CGROUP_CHARGE_TYPE_FORCE!

Hugh
