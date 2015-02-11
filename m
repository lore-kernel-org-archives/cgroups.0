From: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Thu, 12 Feb 2015 01:57:04 +0400
Message-ID: <CALYGNiPX89HsgUS8BrJvL_jW-EU95xezc7uPf=0Pm72qiUwp7A@mail.gmail.com>
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
	<20150211214650.GA11920@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=bjMupn/RSy2E8eOhLMBx8Brvgtw5knB1TfwZqAsoXJ4=;
        b=y/P5ZDupPrgBOyJjX9R+bSMhYGpdKUGH3lCP755ZnREj6INElF26xcsobEzKT0MT7o
         fPU7joj41gD4feQuE2vgMm+ItAvCx9ho2VXeXFuCh78a+bZf8XEK03b0iw5p6Lk6vv+g
         jsV/IvBvbM9KXJu4yP2xwvwguhM7DIyfKDvyMFSe2pJTqKJQgyjn5vJ38mzD6V9LMiTu
         7vHUhDooHtD14YgBlGZDkzRkAca1DhFIGPNJsRgsiZl8pIgrSwO7DAbQd0Wx2+9bo9kA
         3WuQHdYO+/SdA9xLiAj2bL85Wo2KIMbKr8HFe4KMDx6EVFP/aiqhZTd/FGSVplIU7XAk
         vmKg==
In-Reply-To: <20150211214650.GA11920-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Feb 12, 2015 at 12:46 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Thu, Feb 12, 2015 at 12:22:34AM +0300, Konstantin Khlebnikov wrote:
>> > Yeah, available memory to the matching memcg and the number of dirty
>> > pages in it.  It's gonna work the same way as the global case just
>> > scoped to the cgroup.
>>
>> That might be a problem: all dirty pages accounted to cgroup must be
>> reachable for its own personal writeback or balanace-drity-pages will be
>> unable to satisfy memcg dirty memory thresholds. I've done accounting
>
> Yeah, it would.  Why wouldn't it?

How do you plan to do per-memcg/blkcg writeback for balance-dirty-pages?
Or you're thinking only about separating writeback flow into blkio cgroups
without actual inode filtering? I mean delaying inode writeback and keeping
dirty pages as long as possible if their cgroups are far from threshold.

>
>> for per-inode owner, but there is another option: shared inodes might be
>> handled differently and will be available for all (or related) cgroup
>> writebacks.
>
> I'm not following you at all.  The only reason this scheme can work is
> because we exclude persistent shared write cases.  As the whole thing
> is based on that assumption, special casing shared inodes doesn't make
> any sense.  Doing things like allowing all cgroups to write shared
> inodes without getting memcg on-board almost immediately breaks
> pressure propagation while making shared writes a lot more attractive
> and increasing implementation complexity substantially.  Am I missing
> something?
>
>> Another side is that reclaimer now (mosly?) never trigger pageout.
>> Memcg reclaimer should do something if it finds shared dirty page:
>> either move it into right cgroup or make that inode reachable for
>> memcg writeback. I've send patch which marks shared dirty inodes
>> with flag I_DIRTY_SHARED or so.
>
> It *might* make sense for memcg to drop pages being dirtied which
> don't match the currently associated blkcg of the inode; however,
> again, as we're basically declaring that shared writes aren't
> supported, I'm skeptical about the usefulness.
>
> Thanks.
>
> --
> tejun
