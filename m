From: "Haitao Huang" <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] cgroup/misc: Fix an overflow
Date: Mon, 17 Jul 2023 20:11:15 -0500
Message-ID: <op.1786w1rxwjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230717184719.85523-1-haitao.huang@linux.intel.com>
 <CU4OCLEHU1S5.359W394902648@seitikki> <ZLWPN_xyGFrqqJkV@slm.duckdns.org>
 <op.178pr1qewjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <op.178te0tbwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <ZLWmdBfcuPUBtk1K@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689642680; x=1721178680;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=Lpk4z7Si/3sJDEec7U0+YSQmEoYtkOEGFvzlCcA0Bno=;
  b=YMNzPblQmZLmAEpKO1lvk56hqWN2JrdflBG28OUUGjsMNiHAIfytH919
   UfOpwe2PYttnHpGXTtkFzU6ZcITtBu+JjVgBkEJsE0n9pQs5JaJCsLiaM
   AKu/01FF/LKsxvldrseSIQuggn3rRdnMKatjlzed9fotCiq6wwSnQ1NBD
   uYzSf9yMGGeg5VlulRzsJVDNz90CSqVGZ2T20ONZe9ki4xiUa50IMT8y0
   IF2/PT4fFcC+mNJeK90sMUZ6RN2ZF2D7I4qzEFx+lnekZVUhTd2/4t1yE
   z8zw9S1a1pRYH9+W8PBeVGr4xzHsSg6ascJMhVsqSlN4Yorm2ixJ61Tvx
   g==;
In-Reply-To: <ZLWmdBfcuPUBtk1K-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

Hi
On Mon, 17 Jul 2023 15:37:08 -0500, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> Hello,
>
> On Mon, Jul 17, 2023 at 03:19:38PM -0500, Haitao Huang wrote:
>> Actually, we are using atomic_long_t for 'current' which is the same  
>> width
>> as long defined by arch/compiler. So new_usage should be long to be
>> consistent?
>
> We can use atomic64_t, right? It's slower on 32bit machines but I think  
> it'd
> be better to guarantee resource counter range than micro-optimizing  
> charge
> operations. None of the current users are hot enough for this to matter  
> and
> if somebody becomes that hot, the difference between atomic_t and  
> atomic64_t
> isn't gonna matter that much. We'd need to batch allocations per-cpu and  
> so
> on.
>
>> ditto for event counter. Only max is plain unsigned long but I think it  
>> is
>> also OK as it only compared with 'current' without any arithmetic ops
>> involved.
>> Did I miss something here?
>
> I'm saying that it'd be better to make everything explicitly 64bit.
>

Thanks for the explanation. I think I got it and sent it as a separate  
patch now just to be sure.
BR
Haitao
