From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [v9 3/5] mm, oom: cgroup-aware OOM killer
Date: Tue, 3 Oct 2017 07:35:59 -0700
Message-ID: <20171003143559.GJ3301751@devbig577.frc2.facebook.com>
References: <20170927130936.8601-1-guro@fb.com>
 <20170927130936.8601-4-guro@fb.com>
 <20171003114848.gstdawonla2gmfio@dhcp22.suse.cz>
 <20171003123721.GA27919@castle.dhcp.TheFacebook.com>
 <20171003133623.hoskmd3fsh4t2phf@dhcp22.suse.cz>
 <20171003140841.GA29624@castle.DHCP.thefacebook.com>
 <20171003142246.xactdt7xddqdhvtu@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ylOrKRyrLWo3DgB5+vAQtZgDBTEv1vqGn/QYUX1mCkw=;
        b=tHppWYd+i/Xabbe2BdgTgTIXZceIqdp1F25D6vGR7tVjmx190HqSSpWjNSlS5WX33Z
         96ZY0ZeF3In28iXeFsFK62auweMN8JeXwpAjWUFf0vEpUYpXxQhhFx2VMwUDQniUR74q
         FS6iSjNAmE/CQqMk+S4cmS3RUoLztYfk2afQncJjF07FfFAeh5DsfBRLPXvkWVN6q7ko
         yFMv1qTXPBZBlpYjOKn2LKYVYDk6rNtJRSN1t8NGXjjzhizvZGQ3WD9VeVWr96X4DCcl
         CcvPPiCuCcCBba8eP3vBkz5tF05Tx9kn1KhUz3rz8W3pWFTgnC9fdSU7uk35eiteapl5
         m8Xw==
Content-Disposition: inline
In-Reply-To: <20171003142246.xactdt7xddqdhvtu-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Michal.

On Tue, Oct 03, 2017 at 04:22:46PM +0200, Michal Hocko wrote:
> On Tue 03-10-17 15:08:41, Roman Gushchin wrote:
> > On Tue, Oct 03, 2017 at 03:36:23PM +0200, Michal Hocko wrote:
> [...]
> > > I guess we want to inherit the value on the memcg creation but I agree
> > > that enforcing parent setting is weird. I will think about it some more
> > > but I agree that it is saner to only enforce per memcg value.
> > 
> > I'm not against, but we should come up with a good explanation, why we're
> > inheriting it; or not inherit.
> 
> Inheriting sounds like a less surprising behavior. Once you opt in for
> oom_group you can expect that descendants are going to assume the same
> unless they explicitly state otherwise.

Here's a counter example.

Let's say there's a container which hosts one main application, and
the container shares its host with other containers.

* Let's say the container is a regular containerized OS instance and
  can't really guarantee system integrity if one its processes gets
  randomly killed.

* However, the application that it's running inside an isolated cgroup
  is more intelligent and composed of multiple interchangeable
  processes and can treat killing of a random process as partial
  capacity loss.

When the host is setting up the outer container, it doesn't
necessarily know whether the containerized environment would be able
to handle partial OOM kills or not.  It's akin to panic_on_oom setting
at system level - it's the containerized instance itself which knows
whether it can handle partial OOM kills or not.  This is why this knob
should be delegatable.

Now, the container itself has group OOM set and the isolated main
application is starting up.  It obviously wants partial OOM kills
rather than group killing.  This is the same principle.  The
application which is being contained in the cgroup is the one which
knows how it can handle OOM conditions, not the outer environment, so
it obviously needs to be able to set the configuration it wants.

Thanks.

-- 
tejun
