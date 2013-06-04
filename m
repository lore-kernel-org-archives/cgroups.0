From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch v4] Soft limit rework
Date: Tue, 4 Jun 2013 21:57:56 +0530
Message-ID: <CAKTCnz=CMbhhROPV4iC6_XPuu_8J53ZMTdXtY_bevPjG+B-+mw@mail.gmail.com>
References: <1370254735-13012-1-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=MK+See2MrMf174R9l8juDRjSE5vex52B8vFs1lVGqQE=;
        b=kft1odDXX8Vxrjx7WJc4MqaEbOXtaY+Gmh7+acNWK+sVwAP6k9kbdR2AvmpdeHXPF7
         YipKBUMOxRgN1i1mxzyeo2IxNLAIPSBkCMFt63RjYeZwFSe/MAZ+QZW+wtc81/rq0OKK
         dhiPZavZWCnrhZbpu7LXwoREojdIp5m/wYXzt97lKNi/tT/bACV2NTE87vr0Wub8NpM5
         DZylTBTes0nrMCXpAx2oAeplszYudVpOtpyuqgjTRFhXgd7BsRdJdQlApgfpPzIWyfKT
         b65xFI2Cs5dc6eLaZ0EvvBtLcDGhojVnZpbChB5h9+Utw/4OrMU4xMIeN6FuJkVXHCOl
         TlgA==
In-Reply-To: <1370254735-13012-1-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon, Jun 3, 2013 at 3:48 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> Hi,
>
> This is the fourth version of the patchset.
>
> Summary of versions:
> The first version has been posted here: http://permalink.gmane.org/gmane.linux.kernel.mm/97973
> (lkml wasn't CCed at the time so I cannot find it in lwn.net
> archives). There were no major objections. The second version
> has been posted here http://lwn.net/Articles/548191/ as a part
> of a longer and spicier thread which started after LSF here:
> https://lwn.net/Articles/548192/
> Version number 3 has been posted here http://lwn.net/Articles/550409/
> Johannes was worried about setups with thousands of memcgs and the
> tree walk overhead for the soft reclaim pass without anybody in excess.
>
> Changes between RFC (aka V1) -> V2
> As there were no major objections there were only some minor cleanups
> since the last version and I have moved "memcg: Ignore soft limit until
> it is explicitly specified" to the end of the series.
>
> Changes between V2 -> V3
> No changes in the code since the last version. I have just rebased the
> series on top of the current mmotm tree. The most controversial part
> has been dropped (the last patch "memcg: Ignore soft limit until it is
> explicitly specified") so there are no semantical changes to the soft
> limit behavior. This makes this work mostly a code clean up and code
> reorganization. Nevertheless, this is enough to make the soft limit work
> more efficiently according to my testing and groups above the soft limit
> are reclaimed much less as a result.
>
> Changes between V3->V4
> Added some Reviewed-bys but the biggest change comes from Johannes
> concern about the tree traversal overhead with a huge number of memcgs
> (http://thread.gmane.org/gmane.linux.kernel.cgroups/7307/focus=100326)
> and this version addresses this problem by augmenting the memcg tree
> with the number of over soft limit children at each level of the
> hierarchy. See more bellow.
>
> The basic idea is quite simple. Pull soft reclaim into shrink_zone in
> the first step and get rid of the previous soft reclaim infrastructure.
> shrink_zone is done in two passes now. First it tries to do the soft
> limit reclaim and it falls back to reclaim-all mode if no group is over
> the limit or no pages have been scanned. The second pass happens at the
> same priority so the only time we waste is the memcg tree walk which
> has been updated in the third step to have only negligible overhead.
>

Hi, Michal

I've just looked at this (I am yet to review the series), but the
intention of the changes do not read out clearly. Or may be I quite
outdated on the subject :)

Balbir
