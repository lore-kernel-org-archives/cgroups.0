From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 14/18] x86/sgx: Add EPC OOM path to forcefully reclaim
 EPC
Date: Mon, 26 Dec 2022 20:43:58 +0000
Message-ID: <Y6oHjrLCbDzWh7nE@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-15-kristen@linux.intel.com>
 <Y5IBCOuF8X7jEK3+@kernel.org>
 <cb5abce531c1b14118de419ba68c2a501b016873.camel@linux.intel.com>
 <e5aff02b-713c-ccd8-7211-d07ff6d7adb2@intel.com>
 <Y5duYxIHtSpK1qkj@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672087444;
        bh=VLhGkOHxbqetrgJSPLuZfKUGT1KN0pIDoxofw9mA2Jw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BaRZ3mCREa+kLUp5TDH7ap3HWYze/UUbPBAAOV501rVkFpg9IJfJfco0Mduf/PHuM
         WbmConD42iTDblIo9JtxYbuxDPU5LV969xNFTFJChhok3zLYN4OeG7Xh8XiSwbDDLq
         vFrxVIqMZU9AGAD/f1N5vbJsPUBuGgDPVdGNuv+w6DswNVS8v6JZItJmucQAi4BILf
         R9pBjahfOUYA9ib/VwrBG3df6NOyUcMYJ6isZYIyfjCS29DR4UU0RJf3ukanPAtPwd
         wjZUERuQRSJ4en+w/QHiEG/2bVBzhfMUrNPBsHyVpvLj1XLcpS8KRAoNi6F21B/S0Y
         Ru9W5pX2h0lYQ==
Content-Disposition: inline
In-Reply-To: <Y5duYxIHtSpK1qkj-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Mon, Dec 12, 2022 at 06:09:39PM +0000, Sean Christopherson wrote:
> On Fri, Dec 09, 2022, Dave Hansen wrote:
> > On 12/9/22 08:05, Kristen Carlson Accardi wrote:
> > > Aside from that though, I don't think that killing enclaves makes sense
> > > outside the context of cgroup limits. 
> > 
> > I think it makes a lot of sense in theory.  Whatever situation we get
> > into with a cgroup's EPC we can also get into with the whole system's EPC.
> > 
> > *But*, it's orders of magnitude harder to hit on the whole system.
> 
> ...
> 
> > If someone wants to extend this OOM support to system-wide EPC later, then go
> > ahead.  But, I don't think it makes a lot of sense to invert this series for
> > it.
> 
> +1 from the peanut gallery.  With VMM EPC oversubscription suport, no sane VMM
> will oversubscribe VEPC pages.  And for VA pages, supporting swap of VA pages is
> likely a more userspace-friendly approach if system-wide EPC OOM is a concern.

When swapping VA pages the topology of the VA page cache for swapped VA
pages is the main question. It is compromise between how long swap-in and
swap-out can take, and how generic solution it be, meaning how deep
hierarchies you want to build, or is just a flat list of parent VA pages
"good enough".

Also, there's the question whether it should be a global cache, per cgroup
and so forth.

Implementing any solution is not overly complicated. Locking in these
options is what puzzles me.

BR, Jarkko
