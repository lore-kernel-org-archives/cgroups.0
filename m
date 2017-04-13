From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC 0/1] add support for reclaiming priorities per mem cgroup
Date: Thu, 13 Apr 2017 12:03:43 -0400
Message-ID: <20170413160343.GC29727@cmpxchg.org>
References: <20170317231636.142311-1-timmurray@google.com>
 <20170330155123.GA3929@cmpxchg.org>
 <CALvZod7Dr+YaYcSpUYCMAjotnU4hH=TnZWaL6mbBzLq=O3GJTA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PS84jzWCNn9FPLdQhi3XKAnbZjqo6inTk7aIHbeOlss=; b=nA8RUwp/d56Hipza0+0WZA4A5U
	AZ8HfWF7tsGKWcZE7JwSus3NnnUfxj3jW+3ZzcOyUWBJZwGCuDO9ZYIcAbU7A0Ah8nZ9A5bHKXalI
	3r7DSB+5cRsLTxCxNMFRyY5qoNN0H+GOjp3k5KRQmYIs7tQQlDBtIjGVpKtLSwjAzp5k=;
Content-Disposition: inline
In-Reply-To: <CALvZod7Dr+YaYcSpUYCMAjotnU4hH=TnZWaL6mbBzLq=O3GJTA@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Tim Murray <timmurray@google.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Linux MM <linux-mm@kvack.org>, surenb@google.com, totte@google.com, kernel-team@android.com

On Thu, Mar 30, 2017 at 09:48:55AM -0700, Shakeel Butt wrote:
> > A more useful metric for memory pressure at this point is quantifying
> > that time you spend thrashing: time the job spends in direct reclaim
> > and on the flipside time the job waits for recently evicted pages to
> > come back. Combined, that gives you a good measure of overhead from
> > memory pressure; putting that in relation to a useful baseline of
> > meaningful work done gives you a portable scale of how effictively
> > your job is running.
> >
> > I'm working on that right now, hopefully I'll have something useful
> > soon.
> 
> Johannes, is the work you are doing only about file pages or will it
> equally apply to anon pages as well?

It will work on both, with the caveat that *any* swapin is counted as
memory delay, whereas only cache misses of recently evicted entries
count toward it (we don't have timestamped shadow entries for anon).

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
