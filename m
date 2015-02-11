From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Wed, 11 Feb 2015 17:05:30 -0500
Message-ID: <20150211220530.GA12728@htj.duckdns.org>
References: <xr93pp9nucrt.fsf@gthelen.mtv.corp.google.com>
 <20150206141746.GB10580@htj.dyndns.org>
 <CAHH2K0bxvc34u1PugVQsSfxXhmN8qU6KRpiCWwOVBa6BPqMDOg@mail.gmail.com>
 <20150207143839.GA9926@htj.dyndns.org>
 <20150211021906.GA21356@htj.duckdns.org>
 <CAHH2K0aHM=jmzbgkSCdFX0NxWbHBcVXqi3EAr0MS-gE3Txk93w@mail.gmail.com>
 <20150211203359.GF21356@htj.duckdns.org>
 <CALYGNiMm2VajBx0Y+XtLJ8860JS-GHfuSXQrBt32Wt0K7QpH0A@mail.gmail.com>
 <20150211214650.GA11920@htj.duckdns.org>
 <CALYGNiPX89HsgUS8BrJvL_jW-EU95xezc7uPf=0Pm72qiUwp7A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ZWH46ZitBdElJ6G4UUnD2Gn58kpL/c6HGfqSv21Ysyk=;
        b=ec3CaWFO0JSpIENE3hglBRWaTGYTuIkZklrD76hCn45IFCUfGLB8nyPyQaT9DNa6BN
         LTjEssddaySZ67nwdTgn5fsc1rC4Zf0hpQ9TBmiWWnSQe8QMK5Pla2F35P+zcdX2n02n
         lDxO5yOBGkItUU8y/GjKXxx+gnVbNgpJDG1kvZcl5Hk934gwHkn992yTXnJG4S2SwMmd
         syAIzMnJalpze9jEJGFN/jTUgV7gzSSyDfZqxir8QGsWdz77beRoyAgPmO0izsiZHN+k
         RDv64eleeJ7146QD1xkXuaBWrCcFl9xMBKyjXrSzh1XZCfOt3s/n+/+rfHPHp5Z6KwZa
         yFMA==
Content-Disposition: inline
In-Reply-To: <CALYGNiPX89HsgUS8BrJvL_jW-EU95xezc7uPf=0Pm72qiUwp7A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Feb 12, 2015 at 01:57:04AM +0400, Konstantin Khlebnikov wrote:
> On Thu, Feb 12, 2015 at 12:46 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > Hello,
> >
> > On Thu, Feb 12, 2015 at 12:22:34AM +0300, Konstantin Khlebnikov wrote:
> >> > Yeah, available memory to the matching memcg and the number of dirty
> >> > pages in it.  It's gonna work the same way as the global case just
> >> > scoped to the cgroup.
> >>
> >> That might be a problem: all dirty pages accounted to cgroup must be
> >> reachable for its own personal writeback or balanace-drity-pages will be
> >> unable to satisfy memcg dirty memory thresholds. I've done accounting
> >
> > Yeah, it would.  Why wouldn't it?
> 
> How do you plan to do per-memcg/blkcg writeback for balance-dirty-pages?
> Or you're thinking only about separating writeback flow into blkio cgroups
> without actual inode filtering? I mean delaying inode writeback and keeping
> dirty pages as long as possible if their cgroups are far from threshold.

What?  The code was already in the previous patchset.  I'm just gonna
rip out the code to handle inode being dirtied on multiple wb's.

-- 
tejun
