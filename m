From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Wed, 11 Feb 2015 16:46:50 -0500
Message-ID: <20150211214650.GA11920@htj.duckdns.org>
References: <xr93siekt3p3.fsf@gthelen.mtv.corp.google.com>
 <20150205222522.GA10580@htj.dyndns.org>
 <xr93pp9nucrt.fsf@gthelen.mtv.corp.google.com>
 <20150206141746.GB10580@htj.dyndns.org>
 <CAHH2K0bxvc34u1PugVQsSfxXhmN8qU6KRpiCWwOVBa6BPqMDOg@mail.gmail.com>
 <20150207143839.GA9926@htj.dyndns.org>
 <20150211021906.GA21356@htj.duckdns.org>
 <CAHH2K0aHM=jmzbgkSCdFX0NxWbHBcVXqi3EAr0MS-gE3Txk93w@mail.gmail.com>
 <20150211203359.GF21356@htj.duckdns.org>
 <CALYGNiMm2VajBx0Y+XtLJ8860JS-GHfuSXQrBt32Wt0K7QpH0A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=aL+3SM/8Ktj+7QpIwygmC5QMm1BoQoB7/bkcDD/stos=;
        b=inA+wlh71ZqtWGBt+iFmMFfDYw9iIr+iGL4Z/IMsfXJe+lb0RXivVrH+jhJG+Aebh+
         dirfdDprdBQnYTketUsiUNvSRvKywxuSdo2pBNv+s1CBjHoTRnansn8v6gMdRbDzSmiz
         lqoP3T1Qi5VRwzt3fkvayc8cCJA9SmTtjtiGJlKiI41YE4s8L3F/HuZZZrP7D5Yk14QX
         bP0c/mV8IM8wadVaVyXXCQXVDMSBKdN5C+ebvNRs2vsBZ9Za3ohtqIa0clUlOAIiQ8Qp
         f9NcP/ekLL6dupNYE8IGfX+k+6EeN0nkqnQjOiAGZZtcCgkAAf1TPKfVD/pE245lsha1
         +Ckw==
Content-Disposition: inline
In-Reply-To: <CALYGNiMm2VajBx0Y+XtLJ8860JS-GHfuSXQrBt32Wt0K7QpH0A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Greg Thelen <gthelen@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>

Hello,

On Thu, Feb 12, 2015 at 12:22:34AM +0300, Konstantin Khlebnikov wrote:
> > Yeah, available memory to the matching memcg and the number of dirty
> > pages in it.  It's gonna work the same way as the global case just
> > scoped to the cgroup.
> 
> That might be a problem: all dirty pages accounted to cgroup must be
> reachable for its own personal writeback or balanace-drity-pages will be
> unable to satisfy memcg dirty memory thresholds. I've done accounting

Yeah, it would.  Why wouldn't it?

> for per-inode owner, but there is another option: shared inodes might be
> handled differently and will be available for all (or related) cgroup
> writebacks.

I'm not following you at all.  The only reason this scheme can work is
because we exclude persistent shared write cases.  As the whole thing
is based on that assumption, special casing shared inodes doesn't make
any sense.  Doing things like allowing all cgroups to write shared
inodes without getting memcg on-board almost immediately breaks
pressure propagation while making shared writes a lot more attractive
and increasing implementation complexity substantially.  Am I missing
something?

> Another side is that reclaimer now (mosly?) never trigger pageout.
> Memcg reclaimer should do something if it finds shared dirty page:
> either move it into right cgroup or make that inode reachable for
> memcg writeback. I've send patch which marks shared dirty inodes
> with flag I_DIRTY_SHARED or so.

It *might* make sense for memcg to drop pages being dirtied which
don't match the currently associated blkcg of the inode; however,
again, as we're basically declaring that shared writes aren't
supported, I'm skeptical about the usefulness.

Thanks.

-- 
tejun
