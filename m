From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 14/18] x86/sgx: Add EPC OOM path to forcefully reclaim
 EPC
Date: Fri, 9 Dec 2022 08:22:26 -0800
Message-ID: <e5aff02b-713c-ccd8-7211-d07ff6d7adb2@intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-15-kristen@linux.intel.com>
 <Y5IBCOuF8X7jEK3+@kernel.org>
 <cb5abce531c1b14118de419ba68c2a501b016873.camel@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670602952; x=1702138952;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iQwVqHB9rC9aTwo4Z445IcUifA5rNpwqLqEuyYsANns=;
  b=MfIU6d/730wqghMxeJTBwiLhdIjCe5UmOtnoB/UBGfO495Qhq43G57BE
   sys8Se8M3EZhhpM2tFvIh8rQrp0pqqNDl7tVM+zZM4BoUFSpuFG/Tp2qW
   FV9jRZz6RPphCtmmAs0ElwXm8Mvz2XppoWQAhsTSeS48z+LRmYMgNqGwI
   w6QuBTbswIoKRaA0hI8g7je/ahzE5s/YENCu+gInTBxOUjrZUjIolzHwv
   ygt18rXP/zSFAQM3M9PlNWhOYIbI8/unPJfwl3MjMq1djjaYpHQhbdTPl
   C73oMeJ40V6NAJ1EmSh7cebeU87cTnuYk/brfHsMFucHGwt5f9eotfGUn
   g==;
Content-Language: en-US
In-Reply-To: <cb5abce531c1b14118de419ba68c2a501b016873.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 12/9/22 08:05, Kristen Carlson Accardi wrote:
> Aside from that though, I don't think that killing enclaves makes sense
> outside the context of cgroup limits. 

I think it makes a lot of sense in theory.  Whatever situation we get
into with a cgroup's EPC we can also get into with the whole system's EPC.

*But*, it's orders of magnitude harder to hit on the whole system.
Basically, it has to be at a point where all of the EPC is consumed in
non-SGX-swappable page types like SECS or VEPC pages.  That's
_possible_, of course, but it's really hard to create because one VEPC
page can hold the info of several (32??) swapped-out EPC pages.

So, you'd need roughly 4GB of swapped-out normal enclave memory to
exhaust a system with 128MB of total enclave memory.

OOM handling *much* necessary in practice if you have a cgroup with some
modestly sized enclaves and a very tiny EPC limit.  If someone wants to
extend this OOM support to system-wide EPC later, then go ahead.  But, I
don't think it makes a lot of sense to invert this series for it.
