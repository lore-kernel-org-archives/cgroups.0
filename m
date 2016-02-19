From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Fri, 19 Feb 2016 22:26:09 +0000
Message-ID: <20160219222609.GC17997@ZenIV.linux.org.uk>
References: <20160217210744.GA6479@mtj.duckdns.org>
 <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
 <20160217230231.GC6479@mtj.duckdns.org>
 <20160218095538.GA4338@quack.suse.cz>
 <20160218130033.GE6479@mtj.duckdns.org>
 <20160219201805.GZ17997@ZenIV.linux.org.uk>
 <20160219205147.GN13177@mtj.duckdns.org>
 <20160219215811.GA17997@ZenIV.linux.org.uk>
 <20160219221512.GO13177@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160219221512.GO13177@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Tahsin Erdogan <tahsin@google.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Nauman Rafique <nauman@google.com>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>

On Fri, Feb 19, 2016 at 05:15:12PM -0500, Tejun Heo wrote:

> > IOW, while fs shutdown may be async, making it *always* async would be a bad
> > bug.  And bumping ->s_active does just that.
> > 
> > I'd go for trylock inside that work + making generic_shutdown_super()
> > kill all such works.  I assume that it *can* be abandoned in situation
> > when we know that sync_filesystem() is about to be called and that
> > said sync_filesystem() won't, in turn, schedule any such works, of course...
> 
> I'll make generic_shutdown_super() to kill all such work items.  I
> don't think the work item itself would need further locking tho.  Can
> you please elaborate why you thought adding trylock to the work would
> be necessary?

Umm...  Not much, except that it would make the life cycle rules a bit
more regular.

Is that code OK with e.g. running in parallel with remounting filesystem r/o?
