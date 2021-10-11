From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: pthread_setschedparam returns 1 (Operation Not Permitted) after
 including docker in yocto build
Date: Mon, 11 Oct 2021 19:00:21 +0200
Message-ID: <20211011170021.GD61605@blackbody.suse.cz>
References: <CAFx0Op3b7KeAT0_Dd_eAMKh85=6qY_X6-BHGJdS2TN8UtJMytg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633971623; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aLHDu14dPkuXVPX0xo7np8SfCtAB89ZamcliK/6Zp4c=;
        b=TbwvUEE27w8fWTwyAdkBa3iSJCSHgH/lCnJSRE/f4xpYZI/5rJTWeoFVWWrM+abDdSd9Q+
        vMYfLlmpgA/Ie86xuV+ubP/XBviW55t/7QYj+8Ku5wy/OCZgecaDZt8QZHOFSmfU0NYTvz
        QvNUTSKUro8xYCLtWG6eR/U4yE3okIY=
Content-Disposition: inline
In-Reply-To: <CAFx0Op3b7KeAT0_Dd_eAMKh85=6qY_X6-BHGJdS2TN8UtJMytg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hans-Jacob Enemark <hjenemark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello.

On Sat, Sep 25, 2021 at 10:45:43PM +0200, Hans-Jacob Enemark <hjenemark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> For some reason it is no longer possible to set the priority and the
> scheduling policy of a running pthread inside the thread function
> itself - even with the app running as root..
> #define POLICY SCHED_FIFO

You use an RT scheduling policy.

It's not in your diff dump but my bet is on CONFIG_RT_GROUP_SCHED.
The non-root RT groups have zero RT runtime allocation by default,
therefore sched_setpriority would fail in such a cgroup.

(The changes in your setup might have modified whether any CPU cgroups
are created or only root cpu cgroup is present.)

HTH,
Michal
