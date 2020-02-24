From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/3] mm: Charge active memcg when no mm is set
Date: Mon, 24 Feb 2020 16:37:50 -0500
Message-ID: <20200224213750.GA3773@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
References: <cover.1582216294.git.schatzberg.dan@gmail.com>
 <0a27b6fcbd1f7af104d7f4cf0adc6a31e0e7dd19.1582216294.git.schatzberg.dan@gmail.com>
 <alpine.LSU.2.11.2002231058520.5735@eggly.anvils>
 <alpine.LSU.2.11.2002231710420.7354@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/oLy8oVuts+NDR86rWT12f1DfuTi/T+KFkIcevjcIVk=;
        b=G/dqJBKUaChhHiklV5Lw+49KVuJF9AbPOpkfS+2n6Qk8wkhPUVDGGMJD5uvSfRAwOx
         xzJfG8b8FMlMdMb4KndOLEFwTqa8kpbf1gnvD3wJ7DmQ3+a0myrZMyoZ7gQm/CiO1t8Y
         AQ2niiTydeDa2Tm4yZZQAzuwao4ut8S7wQoFQU7h30tlwtv05ivIKuBQl9CAbTmUQykG
         vhhobIrRrVhM0SrntztkE7e08WvFc+q24oNp6mNiqulz617fl7f3YoSmNWXPrsOexSXk
         /3UsPWtixv84JHg6mkf5BwIRJHok/gkKO/3aAOD4Hc4Tpta4BGbVr3rVA37at/r8be18
         XmfA==
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2002231710420.7354-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Sun, Feb 23, 2020 at 05:11:12PM -0800, Hugh Dickins wrote:
> On Sun, 23 Feb 2020, Hugh Dickins wrote:
> > On Thu, 20 Feb 2020, Dan Schatzberg wrote:
> > 
> > > memalloc_use_memcg() worked for kernel allocations but was silently
> > > ignored for user pages.
> > > 
> > > This patch establishes a precedence order for who gets charged:
> > > 
> > > 1. If there is a memcg associated with the page already, that memcg is
> > >    charged. This happens during swapin.
> > > 
> > > 2. If an explicit mm is passed, mm->memcg is charged. This happens
> > >    during page faults, which can be triggered in remote VMs (eg gup).
> > > 
> > > 3. Otherwise consult the current process context. If it has configured
> > >    a current->active_memcg, use that. Otherwise, current->mm->memcg.
> > > 
> > > Previously, if a NULL mm was passed to mem_cgroup_try_charge (case 3) it
> > > would always charge the root cgroup. Now it looks up the current
> > > active_memcg first (falling back to charging the root cgroup if not
> > > set).
> > > 
> > > Signed-off-by: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > > Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > 
> > Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > 
> > Yes, internally we have some further not-yet-upstreamed complications
> > here (mainly, the "memcg=" mount option for all charges on a tmpfs to
> > be charged to that memcg); but what you're doing here does not obstruct
> > adding that later, they fit in well with the hierarchy that you (and
> > Johannes) mapped out above, and it's really an improvement for shmem
> > not to be referring to current there - thanks.
> 
> I acked slightly too soon. There are two other uses of "try_charge" in
> mm/shmem.c: we can be confident that the userfaultfd one knows what mm
> it's dealing with, but the shmem_swapin_page() instance has a similar
> use of current->mm, that you also want to adjust to NULL, don't you?
> 
> Hugh

Yes, you're right. I'll change shmem_swapin_page as well
