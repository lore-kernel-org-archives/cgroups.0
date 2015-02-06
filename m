From: Greg Thelen <gthelen@google.com>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Fri, 6 Feb 2015 15:43:11 -0800
Message-ID: <CAHH2K0bxvc34u1PugVQsSfxXhmN8qU6KRpiCWwOVBa6BPqMDOg@mail.gmail.com>
References: <20150130160722.GA26111@htj.dyndns.org> <54CFCF74.6090400@yandex-team.ru>
 <20150202194608.GA8169@htj.dyndns.org> <CAHH2K0aSPjNgt30uJQa_6r=AXZso3SitjWOm96dtJF32CumZjQ@mail.gmail.com>
 <20150204170656.GA18858@htj.dyndns.org> <xr93zj8ti6ca.fsf@gthelen.mtv.corp.google.com>
 <20150205131514.GD25736@htj.dyndns.org> <xr93siekt3p3.fsf@gthelen.mtv.corp.google.com>
 <20150205222522.GA10580@htj.dyndns.org> <xr93pp9nucrt.fsf@gthelen.mtv.corp.google.com>
 <20150206141746.GB10580@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=I/z1u7mmFoHlhyzTSsyd+GenenMXBLBlQHIMDdMoMO8=;
        b=Fwwu1+j7bFbcmpYVN9SB0J1qRNvJytJIlk2FsLTMV/kkDxbA+b2bMnVK1H1nUTEr6V
         i9YjyFGVTfWhXIGPsMUUinAyba+eu0RI9lTTPXKWMxYm3+JA01p8zUub6nEQpaRz6Y3h
         3wepHkEFc+pY1Y1fB+Dat6W9osTMdXuiQFL89X+1I2JI/G7eVeOiFWeeRgoem0N8/HUV
         FX3vt8TI+H/VRV9npKnupudLVc9yI6lLezWi1lHYec40ZG95Mfd8amiGenMc9+eBgvk8
         j2oH7vcNH58Sm58aDEIJfRPSl6ri1p70+3mDNxY9PP7qULuwsRmsjm2N7731hhaPqvYb
         7/TQ==
In-Reply-To: <20150206141746.GB10580@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>

On Fri, Feb 6, 2015 at 6:17 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Greg.
>
> On Thu, Feb 05, 2015 at 04:03:34PM -0800, Greg Thelen wrote:
>> So  this is  a system  which charges  all cgroups  using a  shared inode
>> (recharge on read) for all resident pages of that shared inode.  There's
>> only one copy of the page in memory on just one LRU, but the page may be
>> charged to multiple container's (shared_)usage.
>
> Yeap.
>
>> Perhaps I missed it, but what happens when a child's limit is
>> insufficient to accept all pages shared by its siblings?  Example
>> starting with 2M cached of a shared file:
>>
>>       A
>>       +-B    (usage=2M lim=3M hosted_usage=2M)
>>         +-C  (usage=0  lim=2M shared_usage=2M)
>>         +-D  (usage=0  lim=2M shared_usage=2M)
>>         \-E  (usage=0  lim=1M shared_usage=0)
>>
>> If E faults in a new 4K page within the shared file, then E is a sharing
>> participant so it'd be charged the 2M+4K, which pushes E over it's
>> limit.
>
> OOM?  It shouldn't be participating in sharing of an inode if it can't
> match others' protection on the inode, I think.  What we're doing now
> w/ page based charging is kinda unfair because in the situations like
> above the one under pressure can end up siphoning off of the larger
> cgroups' protection if they actually use overlapping areas; however,
> for disjoint areas, per-page charging would behave correctly.
>
> So, this part comes down to the same question - whether multiple
> cgroups accessing disjoint areas of a single inode is an important
> enough use case.  If we say yes to that, we better make writeback
> support that too.

If cgroups are about isolation then writing to shared files should be
rare, so I'm willing to say that we don't need to handle shared
writers well.  Shared readers seem like a more valuable use cases
(thin provisioning).  I'm getting overwhelmed with the thought
exercise of automatically moving inodes to common ancestors and back
charging the sharers for shared_usage.  I haven't wrapped my head
around how these shared data pages will get protected.  It seems like
they'd no longer be protected by child min watermarks.

So I know this thread opened with the claim "both memcg and blkcg must
be looking at the same picture.  Deviating them is highly likely to
lead to long-term issues forcing us to look at this again anyway, only
with far more baggage."  But I'm still wondering if the following is
simpler:
(1) leave memcg as a per page controller.
(2) maintain a per inode i_memcg which is set to the common dirtying
ancestor.  If not shared then it'll point to the memcg that the page
was charged to.
(3) when memcg dirtying page pressure is seen, walk up the cgroup tree
writing dirty inodes, this will write shared inodes using blkcg
priority of the respective levels.
(4) background limit wb_check_background_flush() and time based
wb_check_old_data_flush() can feel free to attack shared inodes to
hopefully restore them to non-shared state.
For non-shared inodes, this should behave the same.  For shared inodes
it should only affect those in the hierarchy which is sharing.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
