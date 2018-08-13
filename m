From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH RFC 1/3] cgroup: list all subsystem states in debugfs
 files
Date: Mon, 13 Aug 2018 10:53:52 -0700
Message-ID: <20180813175348.GA31962@castle.DHCP.thefacebook.com>
References: <153414348591.737150.14229960913953276515.stgit@buzz>
 <20180813134842.GF3978217@devbig004.ftw2.facebook.com>
 <20180813171119.GA24658@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=mkLvR07c0bI3mkTQ33poWU4P0Ee5dwtb9G6VxjlMce8=;
 b=Hcq7a99oZslzJfemRBnVbi06lVIfT6iz8sZrzcyXrlOB9QQwbg/YOSVJtZqXOwcXTWVC
 EA2Mw/kKAi6XSp1XeqG5gvmmOQaa6+IPA+t9z7xX+SIumCF8wj64i1u9rbsdTHNz2DGI
 WoOi1Q8+mZwSWm3jDF1ciuDCTLuP/FLO2sY= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkLvR07c0bI3mkTQ33poWU4P0Ee5dwtb9G6VxjlMce8=;
 b=XmaTdU97LUl6IpzFoa01WuEWSGfAbNDUQ+VHMdja5lSoVzp5DUqpZm9xXWzY4iHjT41wOb/aEqNZEiaugmg/9bBClz6SNqN7eYKG5UUxX4yDXY9Fv/XC4V/YuJSAhHKkMIcSXK+9JNuTE4dlEo3K+n4tcRrclLH1AOIhhBj8bFs=
Content-Disposition: inline
In-Reply-To: <20180813171119.GA24658@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>

On Mon, Aug 13, 2018 at 01:11:19PM -0400, Johannes Weiner wrote:
> On Mon, Aug 13, 2018 at 06:48:42AM -0700, Tejun Heo wrote:
> > Hello, Konstantin.
> > 
> > On Mon, Aug 13, 2018 at 09:58:05AM +0300, Konstantin Khlebnikov wrote:
> > > After removing cgroup subsystem state could leak or live in background
> > > forever because it is pinned by some reference. For example memory cgroup
> > > could be pinned by pages in cache or tmpfs.
> > > 
> > > This patch adds common debugfs interface for listing basic state for each
> > > controller. Controller could define callback for dumping own attributes.
> > > 
> > > In file /sys/kernel/debug/cgroup/<controller> each line shows state in
> > > format: <common_attr>=<value>... [-- <controller_attr>=<value>... ]
> > 
> > Seems pretty useful to me.  Roman, Johannes, what do you guys think?

Totally agree with the idea and was about to suggest something similar.

> Generally I like the idea of having more introspection into offlined
> cgroups, but I wonder if having only memory= and swap= could be a
> little too terse to track down what exactly is pinning the groups.
> 
> Roman has more experience debugging these pileups, but it seems to me
> that unless we add a breakdown off memory, and maybe make slabinfo
> available for these groups, that in practice this might not provide
> that much more insight than per-cgroup stat counters of dead children.

I agree here.

It's hard to say in advance what numbers are useful, so let's export
these numbers, but also make the format more extendable, so we can
easily add new information later. Maybe, something like:

cgroup {
  path = ...
  ino = ...
  main css {
    refcnt = ...
    key = value
    ...
  }
  memcg css {
    refcnt = ...
    ...
  }
  some other controller css {
  }
  ...
}

Also, because we do batch charges, printing numbers without draining stocks
is not that useful. All stats are also per-cpu cached, what adds some
inaccuracy.

Thanks!
