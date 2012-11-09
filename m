From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/9 v3] cgroup: add cgroup_subsys->post_create()
Date: Fri, 9 Nov 2012 09:22:11 -0800
Message-ID: <20121109172211.GB2711@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-2-git-send-email-tj@kernel.org>
 <20121108190715.GD9672@htj.dyndns.org>
 <509CE472.9040504@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=F7KVo3x5dw9HdS3yCi8tlW4uhlkvotF+vKjzriAeGNE=;
        b=ok53LI4CO3vGjGpwlp0AUWDi3SA5+7agM97sHoaNw5Z0htHjfsRiLF/KkXrZUvyVnF
         Xgpv6ZlaBnynoyNxPik/Ps0H+nsW4PTtWHpjyig2xKlLcCGvbVPBpgv0lbpIyWiyq6uz
         X6PkfyG2VXM14RZAzjF1rWvHyR/fQnIswsD5udvElfbX5k3xoMVRYwh3cIB5CabRlkhO
         Xi8WprbnERwwZc8Hk7qduuuaQ+DY3v9at4S22UEqf066DZZPvFTD09ZuRRaN1FXCBmes
         pk0rv1L0+QvQszm34eUNewqQoIPUc/vqopp5G0iSZPW8rND35XyovubnNkWyP7yZZkpE
         mXTA==
Content-Disposition: inline
In-Reply-To: <509CE472.9040504-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Hey, Daniel.

On Fri, Nov 09, 2012 at 12:09:38PM +0100, Daniel Wagner wrote:
> On 08.11.2012 20:07, Tejun Heo wrote:> Subject: cgroup: add
> cgroup_subsys->post_create()
> >
> > Currently, there's no way for a controller to find out whether a new
> > cgroup finished all ->create() allocatinos successfully and is
> > considered "live" by cgroup.
> 
> I'd like add hierarchy support to net_prio and the first thing to
> do is to get rid of get_prioidx(). It looks like it would be nice to

Ooh, I'm already working on it.  I *think* I should be able to post
the patches later today or early next week.

> be able to use use_id and post_create() for this but as I read the
> code this might not work because the netdev might access resources
> allocated between create() and post_create(). So my question is
> would it make sense to move
> 
> cgroup_create():
> 
> 		if (ss->use_id) {
> 			err = alloc_css_id(ss, parent, cgrp);
> 			if (err)
> 				goto err_destroy;
> 		}
> 
> part before create() or add some protection between create() and
> post_create() callback in net_prio. I have a patch but I see
> I could drop it completely if post_create() is there.

Glauber had about similar question about css_id and I need to think
more about it but currently I think I want to phase out css IDs.  It's
an id of the wrong thing (CSSes don't need IDs, cgroups do) and
unnecessarily duplicates its own hierarchy when the hierarchy of
cgroups already exists.  Once memcontrol moves away from walking using
css_ids, I *think* I'll try to kill it.

I'll add cgroup ID (no hierarchy funnies, just a single ida allocated
number) so that it can be used for cgroup indexing.  Glauber, that
should solve your problem too, right?

Thanks.

-- 
tejun
