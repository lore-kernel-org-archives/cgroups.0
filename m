From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.12] cgroup: make cgroup_event specific
 to memcg
Date: Mon, 26 Aug 2013 17:15:36 +0300
Message-ID: <20130826141536.GA14985@shutemov.name>
References: <1376582550-12548-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1376582550-12548-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Thu, Aug 15, 2013 at 12:02:18PM -0400, Tejun Heo wrote:
> Hello,
> 
> Changes from the last take[L] are
> 
> * Event handling updated such that it doesn't require meddling with
>   internals not normally exposed outside cgroup core proper.  dentry
>   reference counting is replaced with css one and cftype handling is
>   completely gone.  Hopefully, this addresses Michal's complaints.
> 
> * Further simplifications.
> 
> * Rebased on top of the current cgroup/for-3.12 and pending patches.
> 
> Like many other things in cgroup, cgroup_event is way too flexible and
> complex - it strives to provide completely flexible event monitoring
> facility in cgroup proper which allows any number of users to monitor
> custom events.  This essentially is a layering violation and leads to
> weird issues like worrying about event API mis/abuse from userland in
> cgroup controller event source implementation.

Blame me. When I added the interface I hoped events will be much more
useful. Like for delivering 'last task in the cgroup leaves' signals.
But you are right it's too easy to abuse the interface.

Few questions before I'll ack the patchset:
What's the plan if we will need a similar capability in the future?
How would you implement memory thresholds today?

-- 
 Kirill A. Shutemov
