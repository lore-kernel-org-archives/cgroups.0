From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v6 12/31] fs: convert inode and dentry shrinking to be
 node aware
Date: Fri, 17 May 2013 18:49:37 +0400
Message-ID: <51964381.8010406@parallels.com>
References: <1368382432-25462-1-git-send-email-glommer@openvz.org> <1368382432-25462-13-git-send-email-glommer@openvz.org> <20130514095200.GI29466@dastard> <5193A95E.70205@parallels.com> <20130516000216.GC24635@dastard> <5195302A.2090406@parallels.com> <20130517005134.GK24635@dastard> <5195DC59.8000205@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5195DC59.8000205-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 05/17/2013 11:29 AM, Glauber Costa wrote:
> Except that shrink_slab_node would also defer work, right?
> 
>> > The only thing I don't like about this is the extra nodemask needed,
>> > which, like the scan control, would have to sit on the stack.
>> > Suggestions for avoiding that problem are welcome.. :)
>> >
> I will try to come up with a patch to do all this, and then we can
> concretely discuss.
> You are also of course welcome to do so as well =)


All right.

I played a bit today with variations of this patch that will keep the
deferred count per node. I will rebase the whole series ontop of it (the
changes can get quite disruptive) and post. I want to believe that
after this, all our regression problems will be gone (famous last words).

As I have told you, I wasn't seeing problems like you are, and
speculated that this was due to the disk speeds. While this is true,
the patch I came up with makes my workload actually a lot better.
While my caches weren't being emptied, they were being slightly depleted
and then slowly filled again. With my new patch, it is almost
a straight line throughout the whole find run. There is a dent here and
there eventually, but it recovers quickly. It takes some time as well
for steady state to be reached, but once it is, we have all variables
in the equation (dentries, inodes, etc) basically flat. So I guess it
works, and I am confident that it will make your workload better.

My strategy is to modify the shrinker structure like this:

struct shrinker {
        int (*shrink)(struct shrinker *, struct shrink_control *sc);
        long (*count_objects)(struct shrinker *, struct shrink_control *sc);
        long (*scan_objects)(struct shrinker *, struct shrink_control *sc);

        int seeks;      /* seeks to recreate an obj */
        long batch;     /* reclaim batch size, 0 = default */
        unsigned long flags;

        /* These are for internal use */
        struct list_head list;
        atomic_long_t *nr_deferred; /* objs pending delete, per node */

        /* nodes being currently shrunk, only makes sense for NUMA
shrinkers */
        nodemask_t *nodes_shrinking;

};

We need memory allocation now for nr_deferred and nodes_shrinking, but
OTOH we use no stack, and can keep the size of this to be dynamically
adjusted depending on whether or not your shrinker is NUMA aware.

Guess that is it. Expect news soon.


