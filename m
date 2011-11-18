From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: cgroup memory limit problems
Date: Fri, 18 Nov 2011 10:13:08 +0100
Message-ID: <20111118091308.GB5157@tiehlicka.suse.cz>
References: <201111092157.06819.arekm@maven.pl>
 <CAKTCnzmHk1U6fP+jrw2Rq3dLwU30gyocRBp2QpQVHAbU=x5uSA@mail.gmail.com>
 <201111092358.58079.arekm@maven.pl>
 <20111110091012.0ce7d719.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111110091012.0ce7d719.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm-evZBlRFTdvA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Sorry to reply late

On Thu 10-11-11 09:10:12, KAMEZAWA Hiroyuki wrote:
> On Wed, 9 Nov 2011 23:58:57 +0100
[...]
> If you can, please try the latest kernels.
> 
> recent 2 commits
> 
> commit 79dfdaccd1d5b40ff7cf4a35a0e63696ebb78b4d
> " memcg: make oom_lock 0 and 1 based rather than counter "

This one needs a follow up fix (23751be0094012eb6b4756fa80ca54b3eb83069f
"memcg: fix hierarchical oom locking")

> commit 1d65f86db14806cf7b1218c7b4ecb8b4db5af27d
> "  mm: preallocate page before lock_page() at filemap COW"
> 
> are works well against fork-bomb under memcg. In my test, make -j under
> swapless memcg hangs (or takes long time) to be oom-killed.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
