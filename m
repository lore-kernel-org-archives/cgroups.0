From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 0/2] cgroup: allow management of subtrees by new
 cgroup namespaces
Date: Fri, 20 May 2016 12:09:10 -0400
Message-ID: <1463760550.8091.13.camel@HansenPartnership.com>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
	 <573F23D0.2030500@suse.de> <20160520152244.GB5632@htj.duckdns.org>
	 <1463758258.8091.3.camel@HansenPartnership.com>
	 <20160520160352.GC5632@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
	s=20151216; t=1463760552;
	bh=S/8CXanUCGP9d87xBuYzwbzy96RYvTYhMXF2TJyEKRE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=CQ8kYlWHrYhEJWXkQHbA8S7kd9CleM1lCUWEeP8+SgNllAXWVgCFRRCfWdi5qAQrF
	 8lAydpgMIXdA7xV6tHPVqKXfV6HUVrte54cpwT7SVhxTnkbXdjLNv/DjmhKHmzSypQ
	 vO8jnhlEN+H8OdQjEqpHeob9i6Q7su8rLm6oEUnk=
In-Reply-To: <20160520160352.GC5632@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Aleksa Sarai <asarai@suse.de>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Aleksa Sarai <cyphar@cyphar.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, dev@opencontainers.org

On Fri, 2016-05-20 at 09:03 -0700, Tejun Heo wrote:
> Hello, James.
> 
> On Fri, May 20, 2016 at 11:30:58AM -0400, James Bottomley wrote:
> > Given it's merge window time, I haven't yet had time to look at the
> > patch, but I can tell you why it (or something like it) is
> > necessary:
> > unprivileged containers need to be able to set up cgroups as well
> > as
> > namespaces, so we do need a way for the user ns owner to modify
> > cgroups
> > in their default configuration otherwise cgroups just won't fit
> > into
> > the unprivileged model.  Whether this should be through the cgroup
> > ns
> 
> That can be allowed by delegating a cgroup sub-hierarchy to the
> unpriviledged user.  Sub-cgroups created by that user will be owned 
> by that user.  IOW, if the owner of the cgroup hierarchy doesn't
> explicitly delegate the subtree, the unpriv user can't have the
> subtree.  This is true for regular use cases and shouldn't be
> different for namespaces.

The use case for unprivileged containers is that the end user should be
able to use them from the default configuration without and
administrator intervention (although there may be ways the admin can
prevent this if desired).  Your "deletage a cgroup sub-hierarchy"
requires admin intervention, so it's not yet a workflow that
unprivileged containers can use.

> 
> > is up for debate, as is how we should actually allow this to happen 
> > and what we should present to the user ns owner, but we do need a 
> > way to do this.
> > 
> > Delegation can't be through chmodding in this case because the user 
> > ns owner can't chmod something owned by init_user_ns root.
> 
> I still don't see why the existing mechanisms (including userns if
> delegation from inside a ns is necessary) aren't enough.  And even if
> we need something, I'd much prefer not to add a behavior which wildly
> deviates from the usual rules.

I think it's just different definitions.  If you take on our definition
of being able to set up a container without any admin intervention, do
you see our problem: we can't get the initial delegation of the
hierarchy.

James

