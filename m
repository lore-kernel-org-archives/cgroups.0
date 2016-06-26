From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: pids: show number of failed forks since limit
 reset
Date: Sun, 26 Jun 2016 21:34:41 +1000
Message-ID: <78d17b23-d712-7d9c-3655-34c646bc4897@suse.de>
References: <20160624030049.13341-1-asarai@suse.de>
 <20160624030049.13341-2-asarai@suse.de>
 <20160624153151.GQ3262@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160624153151.GQ3262-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Kenny Yu <kennyyu-b10kYP2dOMg@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> On Fri, Jun 24, 2016 at 01:00:48PM +1000, Aleksa Sarai wrote:
>> This allows users to dynamically adjust their limits based on how many
>> failed forks happened since they last reset their limits, otherwise they
>> would have to track (in a racy way) how many limit failures there were
>> since the last limit change manually. In addition, we log the first
>> failure since the limit was reset (which was the original semantics of
>> the patchset).
>
> Isn't that trivially achievable by reading the counter and then
> calculating the diff?  I don't think it matters all that much whether
> the log message is printed once per cgroup or per config-change.  It's
> just a hint for the admin to avoid setting her off on a wild goose
> chase.

If a user has a setup where they wait for notifications on changes to 
pids.event, and then auto-adjust the cgroup limits based on the number 
of failures you have a race condition between reading the pids.event 
file and then setting the new limit. Then, upon getting notified again 
there may have been many failed forks with the old limit set, so you 
might decide to bump up the limit again.

It's not a huge deal, I just though it could be useful to alleviate 
problems like the above.

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
