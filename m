From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET RFC block/for-next] writeback: cgroup writeback support
Date: Fri, 9 Jan 2015 16:36:13 -0500
Message-ID: <20150109213613.GC2785@htj.dyndns.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
 <20150108093057.GD14705@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=53tuEtfZLVu0zUxfwPD2ukqOB/y49LZqjyrJ/61/Yfg=;
        b=Ij6vz6iC9b/J/TVQ3onZjvEEMBAjojiQxttl2qntTYr2paqy9elk5e4KRaLGNnBee4
         jS3aPu1puS6ULmo/r1JYWuxyZ7MNsYtkoh2RNXHljfeTlJw2d09d9OVj3/XPRC0aEnkb
         zuyf7yqRMSu7WgG7BEE5o9QP3TQ1TOpfAFJwaczuszP067RpCTAKpKSUA5YNczlmrf+k
         xKkxT0i4NW1vf/mIOzRjxJH7cqhcUZMNWkWqlSr9Wff2kOVtSC1lrnduNizoHJJ6aV9J
         ur+mh1UJAMl2/CcJw1uEuTB4adS09AfsceMHASoX0Aue3DR0qBaMlcYSxoL1dq4Lvy9f
         9kYQ==
Content-Disposition: inline
In-Reply-To: <20150108093057.GD14705@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com

Hello, Jan.

On Thu, Jan 08, 2015 at 10:30:57AM +0100, Jan Kara wrote:
> > * An inode may have pages dirtied by different memcgs, which naturally
> >   means that it should be able to be dirtied against multiple wb's.
> >   To support linking an inode against multiple wb's, iwbl
> >   (inode_wb_link) is introduced.  An inode has multiple iwbl's
> >   associated with it if it's dirty against multiple wb's.
>
>   Is the ability for inode to belong to multiple memcgs really worth the
> effort? It brings significant complications (see also Dave's email) and
> the last time we were discussing cgroup writeback support the demand from
> users for this was small... How hard would it be to just start with an
> implementation which attaches the inode to the first memcg that dirties it
> (and detaches it when inode gets clean)? And implement sharing of inodes
> among mecgs only if there's a real demand for it?

This was something I spent quite some time debating back and forth.
IMO, the complexity added from having to handle dirtying against
multiple cgroups isn't that high in the scheme of things.  It enables
use cases where different regions of an inode are actively shared by
multiple cgroups and more importantly makes unexpected behaviors a lot
less likely by aligning what writeback and blkcg sees with memcg's
perception.  As mentioned in the head message, this gives us the
ability to hook up dirty ratio handling correctly for each memcg.
That working properly strongly hinges on everybody involved seeing the
same picture.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
