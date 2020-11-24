From: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Date: Tue, 24 Nov 2020 21:27:25 +0000
Message-ID: <20201124212725.GB246319@google.com>
References: <alpine.DEB.2.23.453.2011131615510.333518@chino.kir.corp.google.com>
 <20201124191629.GB235281@google.com>
 <20201124194904.GA45519@google.com>
 <alpine.DEB.2.23.453.2011241215400.3594395@chino.kir.corp.google.com>
 <20201124210817.GA65542@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ycdBeKfDdnxlj2we2eatzJcCu25NkZg7utasfa+QCJs=;
        b=j1YEcpcRCjolfYVSNLeLmzuHRNxnhlKz+wYLfNMVpoq2ZqI2DBBuBRO0ixD0qzD3tC
         KeLaMHOuTm71wOBGHwodtG43JGmQ/uDnbRrbK1FFWk5Td49DkkdETpql2oh34ccq4SD6
         7G+zsmZKba/biKWGiFY/xlEkWH+nziDRuGaRqaa/xUKKo84H0mY/qaLWRRw7SC2e96ny
         QTFOq6vk7UcEem8/3SuMSoV/N97Ernjs6ts18XyYnVsAVpygnI7frPOeqHNMhVmknuqb
         Wsc7mJroPtrz8tH6x7VyOyhgV2x6Wt3ToRvDfOKxm+pe4OgSAcD0mTj2Z6oCko7hQMkF
         BKRw==
Content-Disposition: inline
In-Reply-To: <20201124210817.GA65542-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Janosch Frank <frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Thomas <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, Brijesh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Jon <jon.grimm-5C7GfCeVMHo@public.gmane.org>, Eric <eric.vantassell-5C7GfCeVMHo@public.gmane.org>, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 24, 2020, Vipin Sharma wrote:
> On Tue, Nov 24, 2020 at 12:18:45PM -0800, David Rientjes wrote:
> > On Tue, 24 Nov 2020, Vipin Sharma wrote:
> > 
> > > > > Looping Janosch and Christian back into the thread.                           
> > > > >                                                                               
> > > > > I interpret this suggestion as                                                
> > > > > encryption.{sev,sev_es,keyids}.{max,current,events} for AMD and Intel         
> > > > 
> > > > I think it makes sense to use encryption_ids instead of simply encryption, that
> > > > way it's clear the cgroup is accounting ids as opposed to restricting what
> > > > techs can be used on yes/no basis.
> > > > 
> > 
> > Agreed.
> > 
> > > > > offerings, which was my thought on this as well.                              
> > > > >                                                                               
> > > > > Certainly the kernel could provide a single interface for all of these and    
> > > > > key value pairs depending on the underlying encryption technology but it      
> > > > > seems to only introduce additional complexity in the kernel in string         
> > > > > parsing that can otherwise be avoided.  I think we all agree that a single    
> > > > > interface for all encryption keys or one-value-per-file could be done in      
> > > > > the kernel and handled by any userspace agent that is configuring these       
> > > > > values.                                                                       
> > > > >                                                                               
> > > > > I think Vipin is adding a root level file that describes how many keys we     
> > > > > have available on the platform for each technology.  So I think this comes    
> > > > > down to, for example, a single encryption.max file vs                         
> > > > > encryption.{sev,sev_es,keyid}.max.  SEV and SEV-ES ASIDs are provisioned      
> > > > 
> > > > Are you suggesting that the cgroup omit "current" and "events"?  I agree there's
> > > > no need to enumerate platform total, but not knowing how many of the allowed IDs
> > > > have been allocated seems problematic.
> > > > 
> > > 
> > > We will be showing encryption_ids.{sev,sev_es}.{max,current}
> > > I am inclined to not provide "events" as I am not using it, let me know
> > > if this file is required, I can provide it then.

I've no objection to omitting current until it's needed.

> > > I will provide an encryption_ids.{sev,sev_es}.stat file, which shows
> > > total available ids on the platform. This one will be useful for
> > > scheduling jobs in the cloud infrastructure based on total supported
> > > capacity.
> > > 
> > 
> > Makes sense.  I assume the stat file is only at the cgroup root level 
> > since it would otherwise be duplicating its contents in every cgroup under 
> > it.  Probably not very helpful for child cgroup to see stat = 509 ASIDs 
> > but max = 100 :)
> 
> Yes, only at root.

Is a root level stat file needed?  Can't the infrastructure do .max - .current
on the root cgroup to calculate the number of available ids in the system?
