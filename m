From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv3 1/3] rdmacg: Added rdma cgroup controller.
Date: Sun, 31 Jan 2016 06:04:20 -0500
Message-ID: <20160131110420.GV32380@htj.duckdns.org>
References: <1454167387-31260-1-git-send-email-pandit.parav@gmail.com>
 <1454167387-31260-2-git-send-email-pandit.parav@gmail.com>
 <20160130183015.GP32380@htj.duckdns.org>
 <CAG53R5XrnYY1AVBnu1b6BVfWwiUgyq+EsXay=CianRXnsUDviQ@mail.gmail.com>
 <20160131100237.GS32380@htj.duckdns.org>
 <CAG53R5WOLA_=gD9qVnsVk_oPs0iyacL3M+1qD+RAbrnciVXEOA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+8fLTohiE4dNRsq1op7CtTfadA09TNbMKW4+uTuCzMA=;
        b=gmobLuhwwNqVLOG9Ifc7/13fz6+uGPskOu+zJwxiFDqcZslV8swRf+ZGjLP+BwTY+N
         rRCGZfgfqY56dMHLiaTHgVDWtUxwYF8t7UCX4YucW4iIRX3IkEBZXe5/gQJaOXOkYy9W
         eEDLaWEnG58iSbYtl9mQV0MY/UhxiEgfhvEb0B9pEs9Y6+D2wLlvjv8C/Gj8CdkCVEJZ
         h/zyYeOSlav6COe8scfCzJgSVhZG31FmZp3qvWEwfF+4GrEGlkYHXO6j1X+0hWaaOLRl
         ukIrgkS+iTU0CFxhJYOGgsMalzXYEvggLE9GG3VD5tW595WR367dDGz7CD5hpGp5q71a
         19tA==
Content-Disposition: inline
In-Reply-To: <CAG53R5WOLA_=gD9qVnsVk_oPs0iyacL3M+1qD+RAbrnciVXEOA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hello, Parav.

On Sun, Jan 31, 2016 at 04:11:54PM +0530, Parav Pandit wrote:
> No. We agreed that let IB stack define in the header file that rdmacg
> can include.
> However when I started with that I realized that, such design has
> basic flaw that IB stack is compiled as loadable modules.
> cgroup which is compiled along with kernel, cannot rely on the header
> file of the loadable module, as it will lead to incompatibly and
> possible crash.

Yes, it can.  It just becomes a part of kernel ABI that the IB stack
module depends on.

> > Keep the resource types in an array in minimal way and match with the
> > information from core side.  It doesn't make any sense to use match
> > tokens in defining resources when the resource type is always fixed.
> >
> Match token is being used in other places also typically where user
> configuration is involved.
> so Match token infrastructure APIs help to avoid rewriting parser.
> What exactly is the issue in using match token?
> Resource type is fixed - sure it is with given version of loadable
> module. But if new feature/resource is added in IB stack, at that
> point new token will be added in the array.

Sure, use parser for parsing but you end up stripping =%d in other
places anyway.  Do it the other way.  Let the definitions contain
what's essential and do the extra stuff in code handling it, not the
other way around.

> Now coming to remove command's need.
> If user has previously configured limit of say mr=15. Now if wants to
> remove that configuration and don't want to bother for the limit.
> So the way, its done is by issuing "remove" command.
> Should I name is "reset".

How is this different from setting the limits to max?

> When user issues "remove" command it could still happen that there are
> active rdma resources. So we cannot really free the rpool object.
> That is freed when last resource is uncharged.
> Make sense?

Not really.

> > You're re-stating the same thing without explaining the reasoning
> > behind it.  Why is this different from other controllers?  What's the
> > justification?
> 
> As in above example of 15-85, if we keep it or create is we will end
> up allocating rpool objects for all the 100 cgroups, which might not
> be necessary. If it happens to be multi level hierarchy, it will end
> up having in each level.
> So therefore its allocated and freed dynamically.

Just keeping them around till device destruction would work just fine.
If you wanna insist on freeing them dynamically, free them when both
their usages and configs are nil.  How the object is created shouldn't
be a factor.

> If its created by user configuration, and if we free the rpool object
> when last resource is freed which is holding the configuration,
> user configuration is lost.
> Also it doesn't make much sense to have two different allocation for
> limit and usage configuration. Pointer storing overhead is more than
> the actual content.

See above.  If you want to free dynamically, free when the thing
doesn't contain any information.  Better, just don't worry about it.
It's unlikely to matter.

> > No, the locking scheme doesn't make any sense.  Except for some
> > special cases, sequence like the following indicates that the code is
> > buggy or at least silly.
> >
> Help me to understand, silly means - unacceptable?

Yes, it's a clear anti-pattern for a refcnted object.  Again, just
push the locking to the users and drop the atomics.

> Why you don't want them to be freed when there are no requester
> allocating the resource?
> Device usually stays for longer time, but applications go way and come
> back more often, so freeing them makes more sense when not in use.
> What exactly is the problem in freeing when uncharing occurs, due to
> which I should defer it to device unregistration stage?

Two things.  Freeing dynamically doesn't require creator type or
refcnting here, so the code makes no sense to me.  It's complicated
without any purpose.  Second, it's not that big a struct.  Just leave
them around till it's clear that this is problematic.  For the Nth
time in this whole thing, keep things simple.  Stop overengineering.

-- 
tejun
