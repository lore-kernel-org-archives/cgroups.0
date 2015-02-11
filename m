From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Wed, 11 Feb 2015 17:30:30 -0500
Message-ID: <20150211223030.GB12728@htj.duckdns.org>
References: <CAHH2K0bxvc34u1PugVQsSfxXhmN8qU6KRpiCWwOVBa6BPqMDOg@mail.gmail.com>
 <20150207143839.GA9926@htj.dyndns.org>
 <20150211021906.GA21356@htj.duckdns.org>
 <CAHH2K0aHM=jmzbgkSCdFX0NxWbHBcVXqi3EAr0MS-gE3Txk93w@mail.gmail.com>
 <20150211203359.GF21356@htj.duckdns.org>
 <CALYGNiMm2VajBx0Y+XtLJ8860JS-GHfuSXQrBt32Wt0K7QpH0A@mail.gmail.com>
 <20150211214650.GA11920@htj.duckdns.org>
 <CALYGNiPX89HsgUS8BrJvL_jW-EU95xezc7uPf=0Pm72qiUwp7A@mail.gmail.com>
 <20150211220530.GA12728@htj.duckdns.org>
 <CALYGNiMgpU51vNr186x6h-uh_9NqaTqZ_a2L60XG0STozy=30g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ZN8k+5eb38B6zfXDxf5+A24nhopFVyP5jBFDupM/JMQ=;
        b=CUwKe10ihzTrSGkcWov+2hbXCKfScRTT8YsozctgvN5PAcTfmFXSIogLpejSPLfI1Z
         nbjeV9OAC5ASy5QfPAzXmFyrzxBx55M7Ya/qiI6+aPErZStLb8PvVRo71dIw8NmIXlPy
         4iwQICmHJZ95v//9mj+oN+WodqFl8pIjtJypZoCev1sxrRu6VpT+aFDxYIGDKbCvs3nF
         t07xTyok43X8MBuUGnPO6zRQ+dIrtovG+QYHul8zA1V57dGzedsCxsPzvp6CrCVgcPaK
         7XjX50GK2S/KvbJ+t155sSJ+M1ZU3cIBIERkyBQTCu6EeUJhBVdOW4r6cuYMLxXtTFRz
         S1tQ==
Content-Disposition: inline
In-Reply-To: <CALYGNiMgpU51vNr186x6h-uh_9NqaTqZ_a2L60XG0STozy=30g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Greg Thelen <gthelen@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>

Hello,

On Thu, Feb 12, 2015 at 02:15:29AM +0400, Konstantin Khlebnikov wrote:
> Well, ok. Even if shared writes are rare whey should be handled somehow
> without relying on kupdate-like writeback. If memcg has a lot of dirty pages

This only works iff we consider those cases to be marginal enough to
be handle them in a pretty ghetto way.

> but their inodes are accidentially belong to wrong wb queues when tasks in
> that memcg shouldn't stuck in balance-dirty-pages until somebody outside
> acidentially writes this data. That's all what I wanted to say.

But, right, yeah, corner cases around this could be nasty if writeout
interval is set really high.  I don't think it matters for the default
5s interval at all.  Maybe what we need is queueing a delayed per-wb
work w/ the default writeout interval when dirtying a foreign inode.
I'll think more about it.

Thanks.

-- 
tejun
