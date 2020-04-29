From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 0/4] Charge loop device i/o to issuing cgroup
Date: Wed, 29 Apr 2020 10:03:57 -0400
Message-ID: <20200429140357.GB18499@dschatzberg-fedora-PC0Y6AEN>
References: <20200428161355.6377-1-schatzberg.dan@gmail.com>
 <20200428214653.GD2005@dread.disaster.area>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OPeUScr2vL9/Zkz5n3yjWKmeXq3NwFtTvKkYOvdwcJg=;
        b=LTCggxC9MXNyozRB6RCYBO8Lbp0lLeLTySbNpJQhtIFbSYraYm25VdWaDJlMpN3BN2
         CqzhR0a16L40HQr0KYxb4JN+MGOqhjvgX63E5A4tba8gwwlnFCg1squLu7pJJkT81JWG
         qy65myRgm6O+M918NRgjLhXBFp1/UCw1HGPZkkr3KG+mo3ph1CaD3QlOXne8wjvvQ/9k
         puyVBe991Mmpaa/0UmjaPTufO8PNOhVyp9hX8hEcwcLb8O//uXvqVh5LSgNgfYdLViA1
         c8eWv1keMyVgk8dLGVIKDN4EvyeFnOZ+2lsrAMpgrO4Pq6AVuf7TOPbrfaPrSXJyPgOw
         gkXw==
Content-Disposition: inline
In-Reply-To: <20200428214653.GD2005-pA1nmv6sEBkOM8BvhN4Z8vybgvtCy99p@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas

On Wed, Apr 29, 2020 at 07:47:34AM +1000, Dave Chinner wrote:
> On Tue, Apr 28, 2020 at 12:13:46PM -0400, Dan Schatzberg wrote:
> > The loop device runs all i/o to the backing file on a separate kworker
> > thread which results in all i/o being charged to the root cgroup. This
> > allows a loop device to be used to trivially bypass resource limits
> > and other policy. This patch series fixes this gap in accounting.
> 
> How is this specific to the loop device? Isn't every block device
> that offloads work to a kthread or single worker thread susceptible
> to the same "exploit"?

I believe this is fairly loop device specific. The issue is that the
loop driver issues I/O by re-entering the VFS layer (resulting in
tmpfs like in my example or entering the block layer). Normally, I/O
through the VFS layer is accounted for and controlled (e.g. you can
OOM if writing to tmpfs, or get throttled by the I/O controller) but
the loop device completely side-steps the accounting.

> 
> Or is the problem simply that the loop worker thread is simply not
> taking the IO's associated cgroup and submitting the IO with that
> cgroup associated with it? That seems kinda simple to fix....
> 
> > Naively charging cgroups could result in priority inversions through
> > the single kworker thread in the case where multiple cgroups are
> > reading/writing to the same loop device.
> 
> And that's where all the complexity and serialisation comes from,
> right?
> 
> So, again: how is this unique to the loop device? Other block
> devices also offload IO to kthreads to do blocking work and IO
> submission to lower layers. Hence this seems to me like a generic
> "block device does IO submission from different task" issue that
> should be handled by generic infrastructure and not need to be
> reimplemented multiple times in every block device driver that
> offloads work to other threads...

I'm not familiar with other block device drivers that behave like
this. Could you point me at a few?

> 
> > This patch series does some
> > minor modification to the loop driver so that each cgroup can make
> > forward progress independently to avoid this inversion.
> > 
> > With this patch series applied, the above script triggers OOM kills
> > when writing through the loop device as expected.
> 
> NACK!
> 
> The IO that is disallowed should fail with ENOMEM or some similar
> error, not trigger an OOM kill that shoots some innocent bystander
> in the head. That's worse than using BUG() to report errors...

The OOM behavior is due to cgroup limit. It mirrors the behavior one
sees when writing to a too-large tmpfs.
