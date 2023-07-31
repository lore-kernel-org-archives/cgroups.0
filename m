From: "Haitao Huang" <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 03/28] x86/sgx: Add 'struct sgx_epc_lru_lists' to
 encapsulate lru list(s)
Date: Mon, 31 Jul 2023 15:35:36 -0500
Message-ID: <op.18yrhmgswjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-4-haitao.huang@linux.intel.com>
 <CU4GHCJTRKLZ.1RK23NWPHJGNI@seitikki>
 <op.17794m01wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <4f5496d2e0ea8edba430e7de7304bdd840616146.camel@intel.com>
 <op.18lc2zw6wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <9ffb02a3344807f2c173fe8c7cb000cd6c7843b6.camel@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690835741; x=1722371741;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=il+OrpNJkCiZXQXCAjNwn2LSF5pF/7jhhD8JXlD/k1Q=;
  b=lM4ae2yqx264rXk/G+jjkyTYzh9nYppQPp5OBGQ0aftWry10fq33z0s8
   xT0bUdgFLJZ3sCc3wNI89yEzIig1womQcFH2gEBNkgT1n79GT/VD3cc57
   E1GgYOFcdFWx3MHAZ5nG5+zCEM5CxBA9873uPQZRbhjKVh0LiDU0t65Dl
   2WCMQM8u3JU+/9s6yU+ELO1mokaiW/0K4gAnKkM7o6Rn2R14gl/lxvcBg
   pUrRNZgrGVWwfwJhBAebSmQgn+0EMrmHXJrVY7FpR6OFQPW0CnkT2FeSb
   i8MlwaYAPf7+v2vO2SZR8xlio16I5bdoiQGB729BA/sarZZo69UpgtrIk
   A==;
In-Reply-To: <9ffb02a3344807f2c173fe8c7cb000cd6c7843b6.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Huang, Kai" <kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Chatre, Reinette" <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Li, Zhiquan1" <zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Christopherson,, Sean" <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, 24 Jul 2023 18:31:58 -0500, Huang, Kai <kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

...
>> > Although briefly mentioned in the first patch, it would be better to  
>> put
>> > more
>> > background about the "reclaimable" and "non-reclaimable" thing here,
>> > focusing on
>> > _why_ we need multiple LRUs (presumably you mean two lists:  
>> reclaimable
>> > and non-
>> > reclaimable).
>> >
>> Sure I can add a little more background to introduce the
>> reclaimable/unreclaimable concept. But why we need multiple LRUs would  
>> be
>> self-evident in later patches, not sure I will add details here.
>
> In this case people will need to go to that patch to get some idea  
> first.  It
> doesn't seem hurt if you can explain why you need multiple LRUs here  
> first.
>
Will add.

...
>
> I didn't get the CHECK in my testing.  Not sure why.
>
> Anyway, I guess the comment can be useful if it is to explain why we  
> need to use
> spinlock or whatever lock.  But
>
> 	/* Must acquire this lock to access */
>
> doesn't explain why at all, thus doesn't look helpful to me.
>
> I guess you either need a better comment, or just remove it (it's  
> obvious that a
> lot of kernel code doesn't have a comment around spinlock_t).
>

I'll remove the comments.
Thanks
Haitao
