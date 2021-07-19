From: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 6/6] cpuset: Add cpuset.isolation_mask file
Date: Mon, 19 Jul 2021 12:41:28 -0300
Message-ID: <20210719154128.GB27911@fuller.cnet>
References: <20210714135420.69624-1-frederic@kernel.org>
 <20210714135420.69624-7-frederic@kernel.org>
 <20210714163157.GA140679@fuller.cnet>
 <20210719132649.GB116346@lothringen>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626718205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WvxmU6C3e5BEm26OJjFVoh44JOCamNiazeqRDjQ7ySA=;
        b=KXaz6IxWPikrtLzLSJvSLDwGoYKEUNg0InLZe3KuoNsGNlq4pOV2ucdDs29f6pHibLpg+D
        utsN1CKi0hfOQAUMvCIeuQVudRQq50qt2t4eLTHZrRWTwR1kdLmR/dbVruzFPABXK+LNyy
        JGITRI203G6JnZWQPY/DfSbQTlaOYDU=
Content-Disposition: inline
In-Reply-To: <20210719132649.GB116346@lothringen>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Belits <abelits-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>, Nitesh Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Nicolas Saenz <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-LoxgEY9JZOazQB+pC5nmwQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jul 19, 2021 at 03:26:49PM +0200, Frederic Weisbecker wrote:
> On Wed, Jul 14, 2021 at 01:31:57PM -0300, Marcelo Tosatti wrote:
> > On Wed, Jul 14, 2021 at 03:54:20PM +0200, Frederic Weisbecker wrote:
> > > Add a new cpuset.isolation_mask file in order to be able to modify the
> > > housekeeping cpumask for each individual isolation feature on runtime.
> > > In the future this will include nohz_full, unbound timers,
> > > unbound workqueues, unbound kthreads, managed irqs, etc...
> > > 
> > > Start with supporting domain exclusion and CPUs passed through
> > > "isolcpus=".
> > 
> > It is possible to just add return -ENOTSUPPORTED for the features 
> > whose support is not present?
> 
> Maybe, although that looks like a specialized error for corner cases.

Well, are you going to implement runtime enablement for all features,
including nohz_full, in the first patch set?

From my POV returning -ENOTSUPPORTED would allow for a gradual 
implementation of the features.

> > > CHECKME: Should we have individual cpuset.isolation.$feature files for
> > >          each isolation feature instead of a single mask file?
> > 
> > Yes, guess that is useful, for example due to the -ENOTSUPPORTED
> > comment above.
> > 
> > 
> > Guarantees on updates
> > =====================
> > 
> > Perhaps start with a document with:
> > 
> > On return to the write to the cpumask file, what are the guarantees?
> > 
> > For example, for kthread it is that any kernel threads from that point
> > on should start with the new mask. Therefore userspace should 
> > respect the order:
> > 
> > 1) Change kthread mask.
> > 2) Move threads.
> > 
> 
> Yep.
> 
> > Updates to interface
> > ====================
> > 
> > Also, thinking about updates to the interface (which today are one
> > cpumask per isolation feature) might be useful. What can happen:
> > 
> > 1) New isolation feature is added, feature name added to the interface.
> > 
> > Userspace must support new filename. If not there, then thats an 
> > old kernel without support for it.
> > 
> > 2) If an isolation feature is removed, a file will be gone. What should
> > be the behaviour there? Remove the file? (userspace should probably 
> > ignore the failure in that case?) (then features names should not be
> > reused, as that can confuse #1 above).
> 
> Heh, yeah that's complicated. I guess we should use one flag per file as that
> fits well within the current cpuset design. But we must carefully choose the new
> files to make sure they have the least chances to be useless in the long term.
> 
> > Or maybe have a versioned scheme?
> 
> I suspect we should avoid that at all costs :-)
> 
> Thanks!

Makes sense.

