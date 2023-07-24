From: "Haitao Huang" <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 03/28] x86/sgx: Add 'struct sgx_epc_lru_lists' to
 encapsulate lru list(s)
Date: Mon, 24 Jul 2023 09:55:37 -0500
Message-ID: <op.18lc2zw6wjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-4-haitao.huang@linux.intel.com>
 <CU4GHCJTRKLZ.1RK23NWPHJGNI@seitikki>
 <op.17794m01wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <4f5496d2e0ea8edba430e7de7304bdd840616146.camel@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690210540; x=1721746540;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=0nQmreZIIFL5rEUPYPNOo7mftuofidoQGo9palwNguw=;
  b=Pb9+CNagUg5PRfUxXh8qCaZXRgU/7qe0oG2ZZzQ/4ho3mPLPO0ICuP1/
   00ouNESRfd2QaQJxfwjXTV/6HA2/ley2CVb7jEFfB4vkTOh6EU6cSax9P
   cZ0QFCGWZiWVyDoPX9liuS3Cv0JoOwFlNXPL8tw+0y6FLbPevLP1/OC23
   o4PaCpFImeNkULTymvDcVouCn49vbcjFegCU8sTzd031rRMAPwEu2nTRO
   1XYrZ/2kmxqlWhN5LafhukewA6rpYkmOiI7wId6OZNvLDGs4BJH38ST4g
   eL6dUtAebx1G6aEuklNkhrN/dBgXGIp9h7eG1zGIgacN0AC6WZN4Ulcfy
   g==;
In-Reply-To: <4f5496d2e0ea8edba430e7de7304bdd840616146.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huang, Kai" <kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Chatre, Reinette" <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Li, Zhiquan1" <zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Christopherson,, Sean" <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Kai
On Mon, 24 Jul 2023 05:04:48 -0500, Huang, Kai <kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, 2023-07-17 at 08:23 -0500, Haitao Huang wrote:
>> On Mon, 17 Jul 2023 07:45:36 -0500, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> wrote:
>>
>> > On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
>> > > From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> > >
>> > > Introduce a data structure to wrap the existing reclaimable list
>> > > and its spinlock in a struct to minimize the code changes needed
>> > > to handle multiple LRUs as well as reclaimable and non-reclaimable
>> > > lists. The new structure will be used in a following set of patches  
>> to
>> > > implement SGX EPC cgroups.
>
> Although briefly mentioned in the first patch, it would be better to put  
> more
> background about the "reclaimable" and "non-reclaimable" thing here,  
> focusing on
> _why_ we need multiple LRUs (presumably you mean two lists: reclaimable  
> and non-
> reclaimable).
>
Sure I can add a little more background to introduce the  
reclaimable/unreclaimable concept. But why we need multiple LRUs would be  
self-evident in later patches, not sure I will add details here.

>> > >
>> > > The changes to the structure needed for unreclaimable lists will be
>> > > added in later patches.
>> > >
>> > > Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> > > Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> > > Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> > >
>> > > V3:
>> > > Removed the helper functions and revised commit messages
>
> Please put change history into:
>
> ---
>   change history
> ---
>
> So it can be stripped away when applying the patch.
>
Will do that.

>> > > ---
>> > >  arch/x86/kernel/cpu/sgx/sgx.h | 17 +++++++++++++++++
>> > >  1 file changed, 17 insertions(+)
>> > >
>> > > diff --git a/arch/x86/kernel/cpu/sgx/sgx.h
>> > > b/arch/x86/kernel/cpu/sgx/sgx.h
>> > > index f6e3c5810eef..77fceba73a25 100644
>> > > --- a/arch/x86/kernel/cpu/sgx/sgx.h
>> > > +++ b/arch/x86/kernel/cpu/sgx/sgx.h
>> > > @@ -92,6 +92,23 @@ static inline void *sgx_get_epc_virt_addr(struct
>> > > sgx_epc_page *page)
>> > >  	return section->virt_addr + index * PAGE_SIZE;
>> > >  }
>> > >
>> > > +/*
>> > > + * This data structure wraps a list of reclaimable EPC pages, and a
>> > > list of
>> > > + * non-reclaimable EPC pages and is used to implement a LRU policy
>> > > during
>> > > + * reclamation.
>> > > + */
>
> I'd prefer to not mention the "non-reclaimable" thing in this patch, but  
> defer
> to the one actually introduces the "non-reclaimable" list.  Actually, I  
> don't
> think we even need this comment, given you have this in the structure:
>
> 	struct list_head reclaimable;
>

Agreed.

> Which already explains the "reclaimable" list.  I suppose the  
> non-reclaimable
> list would be named similarly thus need no comment either.
>
> Also, I am wondering why you need to split this out as a separate  
> patch.  It
> basically does nothing.  To me you should just merge this to the next  
> patch,

I think Kristen splitted the original patch based on Dave's comments:

https://lore.kernel.org/all/e71d76b2-4368-4627-abd4-2163e6786a20-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/

> which actually does what you claimed in the changelog:
>
> 	Introduce a data structure to wrap the existing reclaimable list and 
> 	its spinlock ...
>
> Then this can be an infrastructure change patch, which doesn't bring any
> functional change, to support the non-reclaimable list.
>
>
>> > > +struct sgx_epc_lru_lists {
>> > > +	/* Must acquire this lock to access */
>> > > +	spinlock_t lock;
>> >
>> > Isn't this self-explanatory, why the inline comment?
>>
>> I got a warning from the checkpatch script complaining this lock needs
>> comments.
>
> I suspected this, so I applied this patch, removed the comment,  
> generated a new
> patch, and run checkpatch.pl for it.  It didn't report any warning/error  
> in my
> testing.
>
> Are you sure you got a warning?

I did a reran and it's actually a "CHECK" I got:

$ ./scripts/checkpatch.pl --strict  
0001-x86-sgx-Add-struct-sgx_epc_lru_lists-to-encapsulate-.patch
CHECK: spinlock_t definition without comment
#41: FILE: arch/x86/kernel/cpu/sgx/sgx.h:101:
+       spinlock_t lock;

total: 0 errors, 0 warnings, 1 checks, 22 lines checked

Thanks
Haitao
