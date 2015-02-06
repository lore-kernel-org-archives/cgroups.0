From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Fri, 6 Feb 2015 09:17:46 -0500
Message-ID: <20150206141746.GB10580@htj.dyndns.org>
References: <20150130160722.GA26111@htj.dyndns.org>
 <54CFCF74.6090400@yandex-team.ru>
 <20150202194608.GA8169@htj.dyndns.org>
 <CAHH2K0aSPjNgt30uJQa_6r=AXZso3SitjWOm96dtJF32CumZjQ@mail.gmail.com>
 <20150204170656.GA18858@htj.dyndns.org>
 <xr93zj8ti6ca.fsf@gthelen.mtv.corp.google.com>
 <20150205131514.GD25736@htj.dyndns.org>
 <xr93siekt3p3.fsf@gthelen.mtv.corp.google.com>
 <20150205222522.GA10580@htj.dyndns.org>
 <xr93pp9nucrt.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=b+Lfzs96esdWg9eitbMgQ/BNdNZkEdyFvshdT5GdzBM=;
        b=cDXkGVQ9SP0Nv6rE05YBEBxSpB8hG2p7epCAtOOEef4HiuiVWaN8WqInFBgmwYziRF
         o8+/Ib7g7Tw02ImCpmtmGsfVKLKPV0XQS5cbFR2iSGJLF3u0OW8dnr6m9zNJfl0EJJcM
         ArgQuaDQh3+OQHo/UUr/RXlYvl9FPsh1N9kaYdchV7o7ogrGn+xc6Jg5kOQIOlB5EjNo
         xvDszhvDPZOioDN0wRsRlNT5sBeJinNKLILzZRghAUBb9IbFGRG+JNLYjFQSTVTKcYp6
         tcNedr98qVnxSzrXAkAAhsC+vCvgij7CTUKerNGnyhZt2aT3I3+o1H54bJxtt7UoTScn
         Xpwg==
Content-Disposition: inline
In-Reply-To: <xr93pp9nucrt.fsf@gthelen.mtv.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>

Hello, Greg.

On Thu, Feb 05, 2015 at 04:03:34PM -0800, Greg Thelen wrote:
> So  this is  a system  which charges  all cgroups  using a  shared inode
> (recharge on read) for all resident pages of that shared inode.  There's
> only one copy of the page in memory on just one LRU, but the page may be
> charged to multiple container's (shared_)usage.

Yeap.

> Perhaps I missed it, but what happens when a child's limit is
> insufficient to accept all pages shared by its siblings?  Example
> starting with 2M cached of a shared file:
> 
> 	A
> 	+-B    (usage=2M lim=3M hosted_usage=2M)
> 	  +-C  (usage=0  lim=2M shared_usage=2M)
> 	  +-D  (usage=0  lim=2M shared_usage=2M)
> 	  \-E  (usage=0  lim=1M shared_usage=0)
> 
> If E faults in a new 4K page within the shared file, then E is a sharing
> participant so it'd be charged the 2M+4K, which pushes E over it's
> limit.

OOM?  It shouldn't be participating in sharing of an inode if it can't
match others' protection on the inode, I think.  What we're doing now
w/ page based charging is kinda unfair because in the situations like
above the one under pressure can end up siphoning off of the larger
cgroups' protection if they actually use overlapping areas; however,
for disjoint areas, per-page charging would behave correctly.

So, this part comes down to the same question - whether multiple
cgroups accessing disjoint areas of a single inode is an important
enough use case.  If we say yes to that, we better make writeback
support that too.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
