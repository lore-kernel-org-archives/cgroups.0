From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Memory reclaim protection and cgroup nesting (desktop use)
Date: Thu, 5 Mar 2020 09:55:54 -0500
Message-ID: <20200305145554.GA5897@mtj.thefacebook.com>
References: <d4826b9e568f1ab7df19f94c409df11956a8e262.camel@sipsolutions.net>
 <20200304163044.GF189690@mtj.thefacebook.com>
 <4d3e00457bba40b25f3ac4fd376ba7306ffc4e68.camel@sipsolutions.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NOWIJylcLM+2xBd7NFNAk6brzU5tY0Fsm0nPExtQlys=;
        b=AQZExFJChAVsycjeW1vn8E/eFNQMwIQ/E1wOUbJyXyiI7yqeIO52aTGC2JoIicCOWZ
         1sUUROklG3EgdcJcdNxYI6oMbpXBFf8ZZJ+hBTfk499bLUpDrfe9aAm7NLl5daPr7MU1
         RlJ5LVkWr9PIBuZCoyWeiLsYf01bEW0/XfhNuL2n8J6BvqrYhd4C6dVjBnQDKjL7CVr2
         2iOP180GVHMGCeecqmRHLea0owluRkZIfYwVGJXE5GfQaGslPEOF3A1LVY4loo1c+GOI
         pxqQE+pv0oJwAhU/UAfSDyRJ/nllwVVp3it4CPf2Xz0zbfa0STQeJv8WIN+tRBFv0tj8
         0slQ==
Content-Disposition: inline
In-Reply-To: <4d3e00457bba40b25f3ac4fd376ba7306ffc4e68.camel-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello,

On Thu, Mar 05, 2020 at 02:13:58PM +0100, Benjamin Berg wrote:
> A major discussion point seemed to be that cgroups should be grouped by
> their resource management needs rather than a logical hierarchy. I
> think that the resource management needs actually map well enough to
> the logical hierarchy in our case. The hierarchy looks like:

Yeah, the two layouts share a lot of commonalities in most cases. It's
not like we usually wanna distribute resources completely unrelated to
how the system is composed logically.

>                          root
>                        /     \
>            system.slice       user.slice
>           /    |              |         \
>       cron  journal    user-1000.slice   user-1001.slice
>                               |                      \
>                       user-HmGangybm7RTDjBF/Jpztg@public.gmane.org            [SAME]
>                         |          |
>                    apps.slice   session.slice
>                        |             |
>                   unprotected    protected
> 
...
> I think this actually makes sense. Both from an hierarchical point of
> view and also for configuring resources. In particular the user-.slice
> layer is important, because this grouping allows us to dynamically
> adjust resource management. The obvious thing we can do there is to
> prioritise the currently active user while also lowering resource
> allocations for inactive users (e.g. graphical greeter still running in
> the background).

Changing memory limits dynamically can lead to pretty abrupt system
behaviors depending on how big the swing is but memory.low and io/cpu
weights should behave fine.

> Note, that from my point of view the scenario that most concerns me is
> a resource competition between session.slice and its siblings. This
> makes the hierarchy above even less important; we just need to give the
> user enough control to do resource allocations within their own
> subtree.
> 
> So, it seems to me that the suggested mount option should work well in
> our scenario.

Sounds great. In our experience, what would help quite a lot is using
per-application cgroups more (e.g. containing each application as user
services) so that one misbehaving command can't overwhelm the session
and eventually when oomd has to kick in, it can identify and kill only
the culprit application rather than the whole session.

Thanks.

-- 
tejun
