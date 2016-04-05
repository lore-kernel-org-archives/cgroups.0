From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Tue, 5 Apr 2016 10:01:07 -0400
Message-ID: <20160405140107.GB7822@mtj.duckdns.org>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
 <1458850962-16057-2-git-send-email-pandit.parav@gmail.com>
 <20160404193640.GA7822@mtj.duckdns.org>
 <CAG53R5UgDeFxqvOOJb=r1DH2yFmboQZPM=-_atGrOCvK=XYU=A@mail.gmail.com>
 <20160405012504.GG24661@htj.duckdns.org>
 <CAG53R5Xs9nB_g7pDu6G260EY+iu6hi=fs6eV1ggyk=NwO32oRg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8enkJY6SWZAIs8/LPofC8tBmqb9juz+6L8u62qtfd7E=;
        b=LUMcK399daz9RLy7Xa5stmFu1h2LESID7WUsVd5kQrltctVP/5FVBJV1rcbbqOBZBt
         vjwealZOhqv1hS5E2TY0c1YhCs9GZ4K7SCF74vzDRtk1Ys5s/FvXOpQ5IixY7Hshuaek
         TlNS0g4PApENOGCFTydyyQu4rkiZbDt+wFyt1Ji8Wrz9VV/qcnuk9Z+ptThH/1Gg9NEi
         FMmqzLIXV+G6/OkgRnpCyYwykSVDrk8crKr1K7BIC+xzn+dIVlvPBBDQgBq63WNU/2Nu
         buXHfdZlpMp9OR4G8M9F74Ypm+3thiSOItsg69T72OHSIXD8I9k6T8LocmiL5IKOQobg
         wnmA==
Content-Disposition: inline
In-Reply-To: <CAG53R5Xs9nB_g7pDu6G260EY+iu6hi=fs6eV1ggyk=NwO32oRg@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hello, Parav.

On Mon, Apr 04, 2016 at 07:22:38PM -0700, Parav Pandit wrote:
> > Is it actually customary to have rdma core module updated more
> > frequently separate from the kernel?  Out-of-tree modules being
> > updated separately happens quite a bit but this is an in-kernel
> > module, which usually is tightly coupled with the rest of the kernel.
> >
> Yes.
> rdma core module is compiled as kernel module.
> Its often updated for new features, fixes.
> So kernel version can be one but RDMA core module(s) get updated more
> frequently than kernel.

As it is a fairly isolated domain, to certain extent, it could be okay
to let it go.  At the same time, I know that these enterprise things
tend to go completely wayward and am worried about individual drivers
going crazy with custom attributes in a non-sensical way.  The
interface this patch is proposing easily allows that and that at the
cost of internal engineering flexibility.  I don't really want to be
caught up in a situation where we're forced to include broken usages
because that's what's already out in the wild.  I personally would
much prefer the resources to be defined rigidly.  Let's see how the
discussion with Christoph evolves.

> > I don't remember the details well but the code was vastly more complex
> > back then and the object lifetime management was muddy at best.  If I
> > reviewed in a contradicting way, my apologies, but given the current
> > code, it'd be better to have objects creation upfront.
> 
> Do you mean,
> try_charge() should
> lock()
> run loop to allocate in hierarchy, if not allocated.
> run loop again to charge.
> unlock()
> 
> If so, I prefer to run the loop once.

In the original review message, I mentioned creating an interface
which creates the hierarchy of objects as necessary and returns the
target pool with lock held, can you please give it a shot?  Something
like the following.

pool *get_pool(...)
{
	lock;
	if (target pool exists)
		return pool w/ lock held;

	create the pool hierarchically (might involve unlock);
	if (succeeded)
		return pool w/ lock held;
	return NULL w/o lock;
}

> > It isn't necessarily about speed.  It makes clear that the parent
> > always should exist and makes the code easier to read and update.
> 
> It doesn't have to exist. It can get allocated when charging occurs.
> Otherwise even if rdma resources are not used, it ends up allocating
> rpool in hierarchy. (We talked this before)

Sure, create pools only for the used combinations but do that
hierarchically so that a child pool always has a parent.  I can
promise you that the code will read a lot better with that.

> > I don't know why you end up missing basic patterns so badly.  It's
> > making the review and iteration process pretty painful.  Please don't
> > be confrontational and try to read the review comments assuming good
> > will.
> >
> My understanding of seq_printf() being blocking call and accessing

seq_printf() can be called from any context; otherwise, it would be a
horrible interface to use, wouldn't it?

> pool_info in spin lock context, made me allocate memory to get all
> values upfront through allocation.
> Now that the lock is going away, I can do what you have described above.

Thanks.

-- 
tejun
