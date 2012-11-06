From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Why does devices cgroup check for CAP_SYS_ADMIN explicitly?
Date: Tue, 6 Nov 2012 06:48:54 -0800
Message-ID: <20121106144854.GA30069@mtj.dyndns.org>
References: <20121106023845.GI19354@mtj.dyndns.org>
 <877gpzrlir.fsf@xmission.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=I83KhGd18qsONTD8f6sYUx7rYWEYzVK+HX/itdtP6bk=;
        b=euE94fZLBiAd2hNxPQVo4V+5DKeb+BElUb8llWohV7ilbUlBqEPuNduNGXiULjBJiu
         v+DBvbs7pdOsEy7h673b6rGfbkjK9pQX9LR2Lx8Ajc+gnPLnNe135xco8gyCNQ34WOIx
         7iSfQ8Qciyq+8hRIux7HrtqbSjDB+p7OKImDW884kmuecAOEshZ0NZAlC6OxyDcrJ+lx
         MXrzfUzbs25BBWOQDI1AbCmlbRDxRPJVfHSM8FnDkK2P1Yu+erZ4kHqfT21OXB+hb6/Q
         D7Gvc+rnU2v0yUuXpTjq49yap7su0VPy1spsY/ZPdMYNsrjn4+Z437MchP+ZbCuMGaDh
         0hSw==
Content-Disposition: inline
In-Reply-To: <877gpzrlir.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hey, Eric.

On Tue, Nov 06, 2012 at 03:58:04AM -0800, Eric W. Biederman wrote:
> > Why doesn't it follow the usual security enforced by cgroupfs
> > permissions?  Why is the explicit check necessary?
> 
> An almost more interesting question is why is cgroup one of the last
> pieces of code not using capabilities and instead lets you attach to any
> process simply if your uid == 0.

Because it has a filesystem as interface and most things w/ file
system interface depend on VFS for access policies.

> I don't know the history but the device cgroup testing for CAP_SYS_ADMIN
> makes a naive sort of sense to me.

If some different CAP_* is needed for cgroup (but why?), the right
thing to do is enforcing it uniformly from cgroup core instead of
doing it from individual controllers.  If there's no actual good
reason to keep this, I'll write up a patch to remove it.

Thanks.

-- 
tejun
