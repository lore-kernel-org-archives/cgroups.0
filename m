From: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 14/18] x86/sgx: Add EPC OOM path to forcefully reclaim
 EPC
Date: Mon, 12 Dec 2022 18:09:39 +0000
Message-ID: <Y5duYxIHtSpK1qkj@google.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-15-kristen@linux.intel.com>
 <Y5IBCOuF8X7jEK3+@kernel.org>
 <cb5abce531c1b14118de419ba68c2a501b016873.camel@linux.intel.com>
 <e5aff02b-713c-ccd8-7211-d07ff6d7adb2@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=caT/eR3o2xI61xv4gQNQ+fDkRVtZB1sOkBNJmlEN+N4=;
        b=btZ4GA2g/VsRjxBZWyd9Ot4NYl23XggbHAYppoWAJmTxlei8M5/a+b75/69vjs6/GH
         I6tP0ipoDef613AM61HoV+CINKngTjD8WS0TtXzjvi7PemuFIO0aVViEu8P6/zlMroeA
         /rz2PU13KL9/wCcPniQNnwBMvXDHGjycV7BnTq/mTjEiO803KNc18d/0d7ajvdY3QB7c
         0dxIjjg5xtkMMm5gLHj3U0CnOt1GX8A52AptPekUmyPv2lyy1JN1gm/Yf/39hMlDWIAm
         iDow4z0quQ16cubZl80/hIZjTver2Aez811DpWbpe/dWEi1fggZISJ8ob8bsgCwH30Wl
         Vy1Q==
Content-Disposition: inline
In-Reply-To: <e5aff02b-713c-ccd8-7211-d07ff6d7adb2-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Fri, Dec 09, 2022, Dave Hansen wrote:
> On 12/9/22 08:05, Kristen Carlson Accardi wrote:
> > Aside from that though, I don't think that killing enclaves makes sense
> > outside the context of cgroup limits. 
> 
> I think it makes a lot of sense in theory.  Whatever situation we get
> into with a cgroup's EPC we can also get into with the whole system's EPC.
> 
> *But*, it's orders of magnitude harder to hit on the whole system.

...

> If someone wants to extend this OOM support to system-wide EPC later, then go
> ahead.  But, I don't think it makes a lot of sense to invert this series for
> it.

+1 from the peanut gallery.  With VMM EPC oversubscription suport, no sane VMM
will oversubscribe VEPC pages.  And for VA pages, supporting swap of VA pages is
likely a more userspace-friendly approach if system-wide EPC OOM is a concern.
