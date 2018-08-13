From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH RFC 1/3] cgroup: list all subsystem states in debugfs
 files
Date: Mon, 13 Aug 2018 13:11:19 -0400
Message-ID: <20180813171119.GA24658@cmpxchg.org>
References: <153414348591.737150.14229960913953276515.stgit@buzz>
 <20180813134842.GF3978217@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=d7YjYfmhzgSP6FwYdHeRdy7ygate4wqD0+xYgcOY848=;
        b=h3ii49DkXCYBxMWjDOjLkNUHcRkxvzX7g8v8B1vR5ncGMn4rx39oY5UI1yGt7q643L
         KqrAyfgs1dFJpyzwdax15D/unLLJs3CiFfQRXJmYa3c93oAkM1JrPOK2yoLNDlINuKGU
         na86chzgMKukDlUPQs29PdIE7HcJY5k4cZlyz1MEeTf8TsqnTciOP5kWNdTY0iljAFPd
         o3BT2Da4lCFEkcdaQyshsf3VTLuVoydqNwQomrnqm3lPjB3PYcIHz53huWekqXDoNwvd
         328P9w/zlMpiLumwUZfvsk/Nuqpbeyp9maJj+W4nOTrq8BH27QiUOv8TgdWrwmQCvBk3
         HIAQ==
Content-Disposition: inline
In-Reply-To: <20180813134842.GF3978217@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>

On Mon, Aug 13, 2018 at 06:48:42AM -0700, Tejun Heo wrote:
> Hello, Konstantin.
> 
> On Mon, Aug 13, 2018 at 09:58:05AM +0300, Konstantin Khlebnikov wrote:
> > After removing cgroup subsystem state could leak or live in background
> > forever because it is pinned by some reference. For example memory cgroup
> > could be pinned by pages in cache or tmpfs.
> > 
> > This patch adds common debugfs interface for listing basic state for each
> > controller. Controller could define callback for dumping own attributes.
> > 
> > In file /sys/kernel/debug/cgroup/<controller> each line shows state in
> > format: <common_attr>=<value>... [-- <controller_attr>=<value>... ]
> 
> Seems pretty useful to me.  Roman, Johannes, what do you guys think?

Generally I like the idea of having more introspection into offlined
cgroups, but I wonder if having only memory= and swap= could be a
little too terse to track down what exactly is pinning the groups.

Roman has more experience debugging these pileups, but it seems to me
that unless we add a breakdown off memory, and maybe make slabinfo
available for these groups, that in practice this might not provide
that much more insight than per-cgroup stat counters of dead children.
