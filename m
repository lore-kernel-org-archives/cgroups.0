From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/11] protect architectures where THREAD_SIZE >= PAGE_SIZE
 against fork bombs
Date: Tue, 26 Jun 2012 01:45:30 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206260143450.16020@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-12-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252157000.30072@chino.kir.corp.google.com> <4FE96358.6080601@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=NREYyb62ivcqhDZclYoOeOczftIO9dYo27X1Jgosx1s=;
        b=Py+3V9Zb16DPcnPaIQ58D0Pi7pRgt2UBBu6TR1FoyWToVYAv2dY0Shs2H8DEbmeWJy
         uKiepcd5jlFeKxJLDtfgt1+GBZc2W4jbJ99jkneO+uptup/ap5jS0asAQ4Gu1Xhzr/uE
         6apIrMyTNAMR98T1kv6Es7C7M/Z27jkR054LEMGzSiuaL49hdxHcr284pSu3qSpWUtOQ
         pnhki6vV6+SE5QN66bx8sH+TSW8UV16+GXPFJ76WohoFKF7jLZllVbXLHBNYma/HCR+G
         joP37cWC45gIWTH7WPGttJrFxZqYpCiGzq3MXLShOAk7fEp8EqsYq3L3mHt8I9ROmXkB
         oaCQ==
In-Reply-To: <4FE96358.6080601-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, 26 Jun 2012, Glauber Costa wrote:

> > > diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
> > > index ccc1899..914ec07 100644
> > > --- a/include/linux/thread_info.h
> > > +++ b/include/linux/thread_info.h
> > > @@ -61,6 +61,12 @@ extern long do_no_restart_syscall(struct restart_block
> > > *parm);
> > >   # define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACK)
> > >   #endif
> > > 
> > > +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> > > +# define THREADINFO_GFP_ACCOUNTED (THREADINFO_GFP | __GFP_KMEMCG)
> > > +#else
> > > +# define THREADINFO_GFP_ACCOUNTED (THREADINFO_GFP)
> > > +#endif
> > > +
> > 
> > This type of requirement is going to become nasty very quickly if nobody
> > can use __GFP_KMEMCG without testing for CONFIG_CGROUP_MEM_RES_CTLR_KMEM.
> > Perhaps define __GFP_KMEMCG to be 0x0 if it's not enabled, similar to how
> > kmemcheck does?
> > 
> That is what I've done in my first version of this patch. At that time,
> Christoph wanted it to be this way so we would make sure it would never be
> used with #CONFIG_CGROUP_MEM_RES_CTLR_KMEM defined. A value of zero will
> generate no errors. Undefined value will.
> 
> Now, if you ask me, I personally prefer following what kmemcheck does here...
> 

Right, because I'm sure that __GFP_KMEMCG will be used in additional 
places outside of this patchset and it will be a shame if we have to 
always add #ifdef's.  I see no reason why we would care if __GFP_KMEMCG 
was used when CONFIG_CGROUP_MEM_RES_CTLR_KMEM=n with the semantics that it 
as in this patchset.  It's much cleaner by making it 0x0 when disabled.
