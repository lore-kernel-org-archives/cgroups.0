From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 03/18] memcontrol: present maximum used memory also for
 cgroup-v2
Date: Thu, 16 Jun 2016 12:27:50 +0200
Message-ID: <20160616102750.GG6836@dhcp22.suse.cz>
References: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
 <1465847065-3577-4-git-send-email-toiwoton@gmail.com>
 <20160614070130.GB5681@dhcp22.suse.cz>
 <b9d04ccd-28d2-993a-2a40-bbed7b6289d4@gmail.com>
 <20160614160410.GB14279@cmpxchg.org>
 <db6a51eb-d1f7-691b-11a6-ef0b7c1c9462@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <db6a51eb-d1f7-691b-11a6-ef0b7c1c9462-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue 14-06-16 17:15:06, Topi Miettinen wrote:
> On 06/14/16 16:04, Johannes Weiner wrote:
[...]
> > I didn't catch the coverletter, though. It makes sense to CC
> > recipients of any of those patches on the full series, including the
> > cover, since even though we are specialized in certain areas of the
> > code, many of us are interested in the whole picture of addressing a
> > problem, and not just the few bits in our area without more context.
> > 
> 
> Thank you for this nice explanation. I suppose "git send-email
> --cc-cmd=scripts/get_maintainer.pl" doesn't do this.

No it doesn't. What I do for this kind of series is the following. Put
an explicit CC (acked, reviews etc...) to each patch. git format-patch
$RANGE and then
$ git send-email --cc-cmd=./cc-cmd-only-cover.sh $DEFAULT_TO_CC --compose *.patch

$ cat cc-cmd-only-cover.sh
#!/bin/bash

if [[ $1 == *gitsendemail.msg* || $1 == *cover-letter* ]]; then
        grep '<.*@.*>' -h *.patch | sed 's/^.*: //' | sort | uniq
fi

A bit error prone because you have to cleanup any previous patch files
from the directory but works more or less well for me.

s 
> > As far as the memcg part of this series goes, one concern is that page
> > cache is trimmed back only when there is pressure, so in all but very
> > few cases the high watermark you are introducing will be pegged to the
> > configured limit. It doesn't give a whole lot of insight.
> > 
> 
> So using the high watermark would not give a very useful starting point
> for the user who wished to configure the memory limit? What else could
> be used instead?

we have an event notification mechanism. In v1 it is vmpressure and v2
you will get a notification when the high/max limit is hit or when we
hit the oom.
-- 
Michal Hocko
SUSE Labs
