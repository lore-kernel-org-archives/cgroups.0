From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: pids: show number of failed forks since
 limit reset
Date: Wed, 29 Jun 2016 11:33:49 -0400
Message-ID: <20160629153349.GA28719@htj.duckdns.org>
References: <20160624030049.13341-1-asarai@suse.de>
 <20160624030049.13341-2-asarai@suse.de>
 <20160624153151.GQ3262@mtj.duckdns.org>
 <78d17b23-d712-7d9c-3655-34c646bc4897@suse.de>
 <20160626234258.GJ9219@stj.duckdns.org>
 <ec289e47-9761-ff21-b264-1391aa22cfd4@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/ymrb4vsFDMgCAbFNexxJcXEeln8zrNAf9Evzwx/DKo=;
        b=aGnLfFBx1uYTkQyvSMfB/295wzmjmeZ64DXiNs7HReEa+70/MKFTJ8TEC8MevkU5nS
         LF/pQ250aDNJQ46pKWYEIjcUGw2TrTU8hNJzkJGGgnG60vT7sD9IzHNfFuKyKVTefpZm
         oTsYcRaTUAdUruy1ozaPFCv+bf87h3zuO0+BPz2p86fTujPqRWkkivihApgs9Pv9Nfcr
         kY0Uy59NDp+iTWWfpGYzEeC2mqrwpeqsXid7uXtc3xezJVZ3CjLfhnQLOA8u7bJyMjj9
         h/PEH0BK1saGctjSpHHDJVrYwSGy5MTXuhyM2kxBn86xFs4XdqUMN4HzIQHQbt/K3Qmo
         xUMg==
Content-Disposition: inline
In-Reply-To: <ec289e47-9761-ff21-b264-1391aa22cfd4-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Kenny Yu <kennyyu-b10kYP2dOMg@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Aleksa.

On Wed, Jun 29, 2016 at 03:10:26PM +1000, Aleksa Sarai wrote:
> Maybe I'm misunderstanding what the purpose of pids.events is meant to be.
> If it's just meant to be a "hint" to the administrator, then that seems like
> an awfully odd way of giving hints (the kernel logging should be enough for
> that). If it's meant so that the administrator can make policy decisions,

Kernel logging may be an enough hint for a human admin but is an awful
mechanism for any programs trying to monitor.

> then she won't know if the change in failures happened before or after she
> adjusted the limit.
> 
> I also don't see what you mean by "it can be avoided from userland". There's
> a race between changing pids.max and a process forking that causes
> pids.events to be updated.

First of all, a situation where a cgroup hits its limits and then can
proceed normally after the limit is lifted would be very rare.
Secondly, even in those corner cases, synchronization between config
update and event counter doesn't matter.  For dynamic adjustments to
work, fork failures have to be cleanly recoverable and thus the user
can just start monitoring after the config is bumped up - if it fails
again, adjust again; otherwise, it's all good.  It just doesn't
matter.

Thanks.

-- 
tejun
