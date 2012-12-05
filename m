From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] memcg: replace cgroup_lock with memcg specific
 memcg_lock
Date: Wed, 5 Dec 2012 06:41:36 -0800
Message-ID: <20121205144136.GK3885@mtj.dyndns.org>
References: <1354282286-32278-5-git-send-email-glommer@parallels.com>
 <20121203171532.GG17093@dhcp22.suse.cz>
 <50BDAD38.6030200@parallels.com>
 <20121204082316.GB31319@dhcp22.suse.cz>
 <50BDB4E3.4040107@parallels.com>
 <20121204084544.GC31319@dhcp22.suse.cz>
 <20121204145221.GA3885@mtj.dyndns.org>
 <20121204151420.GL31319@dhcp22.suse.cz>
 <20121204152225.GC3885@mtj.dyndns.org>
 <20121205143537.GC9714@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5vP1eh6/8f6VFVx3q7prdyZ4gKGBMNIBM80cihSdyAY=;
        b=azkOVi+QLgY6bDG5fhe0RzdtJ+1EzhXsp4rzTB8KKQH3jiP4FvIcVC5P1eAShQCB7j
         dzN4AoF+qt7X4Hd64gIG3f+yXhGOxXiv7/jMVi2C5os4C03JgoV0S8k9FkM1qiY7yxno
         RO1gQj0JxYIS7tQV/8PIaCOWXv9RMFlkdnJ807a/Ascj0Pdbis5GtqrT0F1Z17at+0Bh
         WWcQHMeSLegyqfzYzvOBfp2G/4xSpLVKPXmVtnQEMHuveF3M93kYH6leOdFo1b1cmXlz
         xdzsmY3ORxM7I1PrmPXhROFliM1SIqzERDSBlRWgKn8qpAipuQGN+TKci68rlu7dt6a5
         MrJw==
Content-Disposition: inline
In-Reply-To: <20121205143537.GC9714-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Michal.

On Wed, Dec 05, 2012 at 03:35:37PM +0100, Michal Hocko wrote:
> On Tue 04-12-12 07:22:25, Tejun Heo wrote:
> > Hello, Michal.
> > 
> > On Tue, Dec 04, 2012 at 04:14:20PM +0100, Michal Hocko wrote:
> > > OK, I read this as "generic helper doesn't make much sense". Then I
> > > would just ask. Does cgroup core really care whether we do
> > > list_empty test? Is this something that we have to care about in memcg
> > > and should fix? If yes then just try to do it as simple as possible.
> > 
> > The thing is, what does the test mean when it doesn't have proper
> > synchronization?  list_empty(&cgroup->children) doesn't really have a
> > precise meaning if you're not synchronized. 
> 
> For the cases memcg use this test it is perfectly valid because the only
> important information is whether there is a child group. We do not care
> about its current state. The test is rather strict because we could set
> use_hierarchy to 1 even if there is child which is not online yet (after
> the value is copied in css_online of course). But do we care about this
> race? If yes, patches with the use case are welcome.

Please just implement properly synchronized onlineness.  There is
absoluately *NO* reason not to do it.  It's gonna be error/race-prone
like hell if memcg keeps trying to dance around it.

> > There could be cases where such correct-most-of-the-time results are
> > okay but depending on stuff like that is a sure-fire way to subtle
> > bugs.
> > 
> > So, my recommendation would be to bite the bullet and implement
> > properly synchronized on/offline state and teach the memcg iterator
> > about it so that memcg can definitively tell what's online and what's
> > not while holding memcg_mutex, and use such knowledge consistently.
> 
> I would rather not complicate the iterators with even more logic but if
> it turns out being useful then why not.

It's gonna be as simple as the following.  I doubt it's gonna add much
to the complexity.

	if (!memcg_online(pos))
		continue; // or goto next; whatever

Thanks.

-- 
tejun
