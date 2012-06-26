From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] fix bad behavior in use_hierarchy file
Date: Tue, 26 Jun 2012 13:10:25 +0200
Message-ID: <20120626111025.GE9566@tiehlicka.suse.cz>
References: <1340616061-1955-1-git-send-email-glommer@parallels.com>
 <20120625204908.GL3869@google.com>
 <20120626075653.GD6713@tiehlicka.suse.cz>
 <4FE98F97.6030406@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FE98F97.6030406-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue 26-06-12 14:31:51, Glauber Costa wrote:
> On 06/26/2012 11:56 AM, Michal Hocko wrote:
> >[Adding Ying to CC - they are using hierarchies AFAIU in their workloads]
> >
> >On Mon 25-06-12 13:49:08, Tejun Heo wrote:
> >[...]
> >>A bit of delta but is there any chance we can either deprecate
> >>.use_hierarhcy or at least make it global toggle instead of subtree
> >>thing?
> >
> >So what you are proposing is to have all subtrees of the root either
> >hierarchical or not, right?
> >
> >>This seems needlessly complicated. :(
> >
> >Toggle wouldn't help much I am afraid. We would still have to
> >distinguish (non)hierarchical cases. And I am not sure we can make
> >everything hierarchical easily.
> >Most users (from my experience) ignored use_hierarchy for some reasons
> >and the end results might be really unexpected for them if they used
> >deeper subtrees (which might be needed due to combination with other
> >controller(s)).
> >
> Do we have any idea about who those users are, and how is their
> setup commonly done?

Well, most of them use memory controller with combination of other
controller - usually cpuset or cpu - and memcg is used to cap the amount
of memory for each respective group. As I said most of those users
were not aware of use_hierarchy at all.

> We can propose work arounds here, but not without first knowing work
> arounds to what =p

No, please no workarounds. It will be even bigger mess.
Maybe a global switch is the first step in the right direction (on by
default). If somebody encounters any issue we can say it can be turned
off (something like one time switch) or advise on how to fix their
layout to fit hierarchy better. We can put WARN_ON_ONCE when the knob is
set to 0 in the second stage and finally remove the whole knob.

> One thing that would really influence this, for instance, is whether
> or not they limit at all levels in the tree, etc.

Yes and independently. But it's true that I haven't seen many of
them to be honest, people usually use a flat structures.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
