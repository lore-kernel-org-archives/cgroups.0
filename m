From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] replace cgroup_lock with local lock in memcg
Date: Fri, 30 Nov 2012 07:52:28 -0800
Message-ID: <20121130155228.GE3873@htj.dyndns.org>
References: <1354282286-32278-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wNOwjUZrSDvVWY5P6nnXOZgF+tOW9KF6VVXS1heI04M=;
        b=d93m5uw03I2N17i7voeJxucbeJZGXrZTwkgEBJ3XrdPfxD020pXcZ8oTiK1Aq/RBti
         xxO3MCUxu2XIlk/JBJ9lPwidWssd8uLTSSDZ7UxEXpcUG4OoqyL2jUOczEae3pAL4u9u
         zbc4/XoeaER3dNPigxc9iQUBwK5AdG0XlXRCqqzUCrLUC4GkBpJ7LKkCTAon6N67S7Bd
         ZC/jQLWtWCIl8NJTSgrORKOvNSUu2Er5aM7Iinxq0DakEfxXDwAXduS+rUX6iQx2uScR
         QD0zWreLZBnG0FpwadCgmRIeSW4+CJH7HaAdtoANufiU4ISNIMTAfwNPZ0xflSdcWrtf
         bQXA==
Content-Disposition: inline
In-Reply-To: <1354282286-32278-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Hey, Glauber.

I don't know enough about memcg to be acking this but overall it looks
pretty good to me.

On Fri, Nov 30, 2012 at 05:31:22PM +0400, Glauber Costa wrote:
> For the problem of attaching tasks, I am using something similar to cpusets:
> when task attaching starts, we will flip a flag "attach_in_progress", that will
> be flipped down when it finishes. This way, all readers can know that a task is
> joining the group and take action accordingly. With this, we can guarantee that
> the behavior of move_charge_at_immigrate continues safe

Yeap, attach_in_progress is useful if there are some conditions which
shouldn't change between ->can_attach() and ->attach().  With the
immigrate thing gone, this no longer is necessary, right?

> Protecting against children creation requires a bit more work. For those, the
> calls to cgroup_lock() all live in handlers like mem_cgroup_hierarchy_write(),
> where we change a tunable in the group, that is hierarchy-related. For
> instance, the use_hierarchy flag cannot be changed if the cgroup already have
> children.
> 
> Furthermore, those values are propageted from the parent to the child when a
> new child is created. So if we don't lock like this, we can end up with the
> following situation:
> 
> A                                   B
>  memcg_css_alloc()                       mem_cgroup_hierarchy_write()
>  copy use hierarchy from parent          change use hierarchy in parent
>  finish creation.
> 
> This is mainly because during create, we are still not fully connected to the
> css tree. So all iterators and the such that we could use, will fail to show
> that the group has children.
> 
> My observation is that all of creation can proceed in parallel with those
> tasks, except value assignment. So what this patchseries does is to first move
> all value assignment that is dependent on parent values from css_alloc to
> css_online, where the iterators all work, and then we lock only the value
> assignment. This will guarantee that parent and children always have
> consistent values.

Right, exactly the reason ->css_online() exists.

Thanks a lot!

-- 
tejun
