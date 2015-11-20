From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: pids_free double free.
Date: Fri, 20 Nov 2015 15:48:13 -0500
Message-ID: <20151120204813.GB1574@mtj.duckdns.org>
References: <20151120041836.GA18390@codemonkey.org.uk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=SywJHhqcGBzY19GObtSfPLs7utFbjqeYHQAUqbdflc4=;
        b=RPGTRtTqwnrykRFAHRe5/c0aQQsdrgTUWetluuEIJvsDmtylGQn+kbPXFYcaiTom05
         BZJBE2E4PfztD7TsTOU9u/5fmiHmzmKUDkE5LGIFdCBhexo2QAICFV/HnGHnP7XJbrQl
         tEIGmFipwZr74OKpSjW921VtB9Luv9h4Bzlm1pcI7fa+MB6+zaHYLulurh5mYdhFipYD
         MNFoOsn6/JBQkrufaGaWh0i4Op77+edLG7zIFNIwzAK2Ixq6Kaa11p1n4FB9kWIGS7rY
         EnGY/uarqxYTyGCLFEVvCyKRnp9y9IaUSKi4vsn8xZwPPt/O7QViCzUGc1wSRrfEE1le
         oqdg==
Content-Disposition: inline
In-Reply-To: <20151120041836.GA18390-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Dave.

On Thu, Nov 19, 2015 at 11:18:36PM -0500, Dave Jones wrote:
> One of my debian boxes got a systemd update. After rebooting,
> I started seeing a use-after-free trace, followed by a lockup.
> 
> I have two slightly different traces from separate boots,
> which may give some clue as to how it's getting free'd in two ways..
> 
> http://codemonkey.org.uk/junk/IMG_0474.jpg
> http://codemonkey.org.uk/junk/IMG_0476.jpg
> 
> This isn't new, I booted back to 4.3, and hit slab debugging warnings
> from the same code.  (At the least it was broken differently)
> 
> The WARN_ON referenced in the 2nd trace is this..
> 
> static void pids_cancel(struct pids_cgroup *pids, int num)
> {
>         /*  
>          * A negative count (or overflow for that matter) is invalid,
>          * and indicates a bug in the `pids` controller proper.
>          */
>         WARN_ON_ONCE(atomic64_add_negative(-num, &pids->counter));
> }

I *think* I know what's going on.  Zombies don't pin the css so if the
cgroup gets removed, the free path may end up operating on a css which
has already been freed.  Will look more into it.

Thanks.

-- 
tejun
