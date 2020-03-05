From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: Make mem_cgroup_id_get_many dependent on MMU and
 MEMCG_SWAP
Date: Thu, 5 Mar 2020 11:09:29 -0500
Message-ID: <20200305160929.GA1166@cmpxchg.org>
References: <20200304142348.48167-1-vincenzo.frascino@arm.com>
 <20200304165336.GO16139@dhcp22.suse.cz>
 <8c489836-b824-184e-7cfe-25e55ab73000@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YFJQskCNWVXuMbTVUr/PuWgn4wVuFnn3nZZ9fMSzuBk=;
        b=O+9wu3BfAMHUjSBZqShEq7hMfSVcLTfHQH3cPXWeDLhMdWns+lMT2fjlIuVY1xcidZ
         r4aOTQjLqDmz1oGNL0DlWKypSa0m3yZsnU98baSb735BbZLpwMdBa8ezdluL9EQhAfjQ
         WrqEGLIjEEzTA76rzJUhPVQYxwdyqC/HlQ5i15gGol/dcdcCgy5ZTMSn9xCotqoHeL/z
         LVSdPNoJnFMfy2TqYVXGDzx2e2K2xAWeZ4P34/1bZNcK28XlUjpfu0FAZ5QWJBKKgIRG
         8xBuG8dS2XEPA3p/3jNDBn8jVaTwqUBnDUKjRsG9drVZQl30An7O+5aTkA+ooVkatlL1
         ceLg==
Content-Disposition: inline
In-Reply-To: <8c489836-b824-184e-7cfe-25e55ab73000@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Mar 05, 2020 at 09:49:23AM +0000, Vincenzo Frascino wrote:
> Hi Michal,
> 
> On 3/4/20 4:53 PM, Michal Hocko wrote:
> > On Wed 04-03-20 14:23:48, Vincenzo Frascino wrote:
> >> mem_cgroup_id_get_many() is currently used only when MMU or MEMCG_SWAP
> >> configuration options are enabled. Having them disabled triggers the
> >> following warning at compile time:
> >>
> >> linux/mm/memcontrol.c:4797:13: warning: ‘mem_cgroup_id_get_many’ defined
> >> but not used [-Wunused-function]
> >>  static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned
> >>  int n)
> >>
> >> Make mem_cgroup_id_get_many() dependent on MMU and MEMCG_SWAP to address
> >> the issue.
> > 
> > A similar patch has been proposed recently
> > http://lkml.kernel.org/r/87fthjh2ib.wl-kuninori.morimoto.gx@renesas.com.
> > The conclusion was that the warning is not really worth adding code.
> > 
> 
> Thank you for pointing this out, I was not aware of it. I understand that you
> are against "#ifdeffery" in this case, but isn't it the case of adding at least
> __maybe_unused? This would prevent people from reporting it over and over again
> and you to have to push them back :) Let me know what do you think, in case I am
> happy to change my patch accordingly.

I would ack a patch that adds __maybe_unused.

This is a tiny function. If we keep it around a few releases after
removing the last user, it costs us absolutely nothing. Eventually
somebody will notice and send a patch to remove it. No big deal.

There is, however, real cost in keeping bogus warnings around and
telling people to ignore them. It's actively lowering the
signal-to-noise ratio and normalizing warnings to developers. That's
the kind of thing that will actually hide problems in the kernel.

We know that the function can be unused in certain scenarios. It's
silly to let the compiler continue to warn about it. That's exactly
what __maybe_unused is for, so let's use it here.
