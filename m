From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 0/4] Charge loop device i/o to issuing cgroup
Date: Tue, 5 May 2020 11:38:34 -0400
Message-ID: <20200505153834.GA12217@mtj.thefacebook.com>
References: <20200428161355.6377-1-schatzberg.dan@gmail.com>
 <20200428214653.GD2005@dread.disaster.area>
 <20200429102540.GA12716@quack2.suse.cz>
 <20200505064114.GI2005@dread.disaster.area>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BXdArichtJxJSpMdJATI60C/n/3lvsy1fL/KOG1aR0o=;
        b=Qgxse7dVakSkufrx/Jt+udb+ymexH65VUMnEUWLtLKEfqRpwkmZlz5vI4O25vYATuy
         VVaC5aOnEDpNMe0z4vb1MBK8RuTdKfE1z+9MXMsUa8Z7ppPI9jeLSH+Y8Hs6hSeLIt7Z
         XdQeFLLxaDYlVJjnLRQT2fRAPqAx2+GxrlAFS5lYDNwWv5TZOo8aje30hyhqww7q5VgE
         hFxkjqHOBiRON9nOAlxbQxTz+54tsN16QGn69GNDWSv9wEK3DmoNTZSaJqVrx9A7Mk8y
         00VmVkyFxFDtx76koAUjHf4CeJ1KqeHm5lGGRIjrmR90TSFZ8z6JZKNkLs+fowxAlB76
         0AAg==
Content-Disposition: inline
In-Reply-To: <20200505064114.GI2005-pA1nmv6sEBkOM8BvhN4Z8vybgvtCy99p@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrea Arcangeli <aarcange@redha>

Hello, Dave.

On Tue, May 05, 2020 at 04:41:14PM +1000, Dave Chinner wrote:
> > OTOH I don't have a great idea how the generic infrastructure should look
> > like...
> 
> I haven't given it any thought - it's not something I have any
> bandwidth to spend time on.  I'll happily review a unified
> generic cgroup-aware kthread-based IO dispatch mechanism, but I
> don't have the time to design and implement that myself....
> 
> OTOH, I will make time to stop people screwing up filesystems and
> block devices with questionable complexity and unique, storage
> device dependent userspace visible error behaviour. This sort of
> change is objectively worse for users than not supporting the
> functionality in the first place.

That probably is too strong a position to hold without spending at least
some thoughts on a subject, whatever the subject may be, and it doesn't seem
like your understanding of userspace implications is accurate.

I don't necessarily disagree that it'd be nice to have a common
infrastructure and there may be some part which can actually be factored
out. However, there isn't gonna be a magic bullet which magically makes
every IO thing in the kernel cgroup aware automatically. Please consider the
followings.

* Avoding IO priority inversions requires splitting IO channels according to
  cgroups and working around (e.g. with backcharging) when they can't be.
  It's a substantial feature which may require substantial changes. Each IO
  subsystem has different constraints and existing structures and many of
  them would require their own solutions. It's not different from different
  filesystems needing their own solutions for similar problems.

* Because different filesystems and IO stacking layers already have their
  own internal infrastructure, the right way to add cgroup support is
  adapting to and modifying the existing infrastructure rather than trying
  to restructure them to use the same cgroup mechanism, which I don't think
  would be possible in many cases.

* Among the three IO stacking / redirecting mechanisms - md/dm, loop and
  fuse - the requirements and what's possible vary quite a bit. md/dm
  definitely need to support full-on IO channel splitting cgroup support.
  loop can go either way, but given existing uses, full splitting makes a
  sense. fuse, as it currently stands, can't support that because the
  priority inversions extend all the way to userspace and the kernel API
  isn't built for that. If it wants to support cgroup containment, each
  instance would have to be assigned to a cgroup.

Between dm/md and loop, it's maybe possible that some of the sub-threading
code can be reused, but I don't see a point in blocking loop updates given
that it clearly fixes userspace visible malfunctions, is not that much code
and how the shared code should look is unclear yet. We'll be able to answer
the sharing question when we actually get to dm/md conversion.

Thanks.

-- 
tejun
