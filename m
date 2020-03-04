From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Memory reclaim protection and cgroup nesting (desktop use)
Date: Wed, 4 Mar 2020 12:10:51 -0500
Message-ID: <20200304171051.GK189690@mtj.thefacebook.com>
References: <d4826b9e568f1ab7df19f94c409df11956a8e262.camel@sipsolutions.net>
 <20200304163044.GF189690@mtj.thefacebook.com>
 <20200304100231.2213a982@lwn.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uJ4VaOT8ap7MxQeWLu8CCH/zVyGcddyQFtuX8XLS83o=;
        b=Ioqv49nh9KevXjhnxkj76lUa5agqAyWoNdQwNoK3ELZT0L51uwZ2B7Syx0TwAkE+Mz
         mcKI8Aahv7+UWuWm7XN0bBc651JpTVnSxqYKq2gK47zVeuiuzSA2GqRCPXTnSMS02jsw
         dfLgm2hx5jBnCGeOttvdzZm+zgH0t4DKxQa5UrEZD9ppjI0zUySfFvz0iseRDyx2xH4b
         fSfALl7/Q0czeWPCqjd2ygT2o2l+JUMyrwrFdQaWErJKL9GIw/Foltu/S8HJVLHE26+H
         qJ5hjmDhcqUSz+IcL80NJya72/F5sUobdUZzc1vMFsWpsym1bL41Y4G9uzoONJxREw86
         xsug==
Content-Disposition: inline
In-Reply-To: <20200304100231.2213a982-T1hC0tSOHrs@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed, Mar 04, 2020 at 10:02:31AM -0700, Jonathan Corbet wrote:
> On Wed, 4 Mar 2020 11:30:44 -0500
> Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > > (In a realistic scenario I expect to have swap and then reserving maybe
> > > a few hundred MiB; DAMON might help with finding good values.)  
> > 
> > What's DAMON?
> 
> 	https://lwn.net/Articles/812707/

Ah, thanks a lot for the link. That's neat. For determining workload
size, we're using senpai:

 https://github.com/facebookincubator/senpai

Thanks.

-- 
tejun
