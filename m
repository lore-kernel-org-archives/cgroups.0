From: Jacob Pan <jacob.jun.pan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
Date: Wed, 24 Mar 2021 09:17:01 -0700
Message-ID: <20210324091701.63c9ce8e@jacob-builder>
References: <20210304231946.2766648-1-vipinsh@google.com>
        <20210304231946.2766648-2-vipinsh@google.com>
        <20210319142801.7dcce403@jacob-builder>
        <YFjn7wv/iMO4Isgz@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YFjn7wv/iMO4Isgz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jacob.jun.pan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

Hi Vipin,

On Mon, 22 Mar 2021 11:54:39 -0700, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Fri, Mar 19, 2021 at 02:28:01PM -0700, Jacob Pan wrote:
> > On Thu,  4 Mar 2021 15:19:45 -0800, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > wrote:  
> > > +#ifndef _MISC_CGROUP_H_
> > > +#define _MISC_CGROUP_H_
> > > +  
> > nit: should you do #include <linux/cgroup.h>?
> > Otherwise, css may be undefined.  
> 
> User of this controller will use get_curernt_misc_cg() API which returns
> a pointer. Ideally the user should use this pointer and they shouldn't
> have any need to access "css" in their code. They also don't need to
> create a object of 'struct misc_cg{}', because that won't be correct misc
> cgroup object. They should just declare a pointer like we are doing here
> in 'struct kvm_sev_info {}'.
> 
> If they do need to use "css" then they can include cgroup header in their
> code.
> 
I didn't mean the users of misc_cgroup will use css directly. I meant if I
want to use misc cgruop in ioasid.c, I have to do the following to avoid
undefined css:
#include <linux/cgroup.h>
#include <linux/misc_cgroup.h>

So it might be simpler if you do #include <linux/cgroup.h> inside
misc_cgroup.h. Then in ioasid.c, I only need to do
#include <linux/misc_cgroup.h>.

> Let me know if I am overlooking something here.
> 
> Thanks
> Vipin Sharma


Thanks,

Jacob
