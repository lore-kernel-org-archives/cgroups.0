From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Mon, 02 Mar 2015 18:35:38 +0100
Message-ID: <1425317738.9880.17.camel@gmail.com>
References: <1424882288-2910-1-git-send-email-riel@redhat.com>
	 <1424882288-2910-3-git-send-email-riel@redhat.com>
	 <54EEFE15.3010005@huawei.com>
	 <20150226121231.6fcba7e8@annuminas.surriel.com>
	 <20150302090933.GH21418@twins.programming.kicks-ass.net>
	 <1425300290.5863.17.camel@gmail.com>
	 <20150302152924.GD17694@htj.duckdns.org>
	 <1425312177.12094.15.camel@gmail.com>
	 <20150302160903.GE17694@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=v2PvRNmkuPMqEbztaJeueeZiI/tqxfX5+NW4StYfJH0=;
        b=ONMUsQDWlT794E0+f6dkRTnUgB1cYUfx47ux7zaKwTvuZKgWeC2MSkPkMG7W3XfK0X
         iRoxfmLg9VRq4RfSdVnaXJfqwang/2RKvYueko+iGcsg8/B6CIAP9uXtbW/RhP+0T3EX
         i17tCLc1omebsv24W0BFoHyMKc1NglAUkbBmIW7CyLypj6fK9JgAb1dZDEcXTboy5N0X
         81Yew9zcp8BQE+RZ8kry7m5psqHKnmo9lcFYwUtH6g7p4eqWRifTPARtT/Ggk3ubnAhd
         w6tO86BT36wbChbCWvgg18YjeOTWLWNtG+iWCj9tgjigd4A34cYKOiE2Pm0vVvhug+D9
         j1dw==
In-Reply-To: <20150302160903.GE17694-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2015-03-02 at 11:09 -0500, Tejun Heo wrote:
> On Mon, Mar 02, 2015 at 05:02:57PM +0100, Mike Galbraith wrote:
> > Well, those are the only ones we can do anything about.  Dirt simple
> > diddling of the workqueue default mask as sched domains are
> > added/removed should do it I think.  Automatically moving any existing
> > unbound worker away from isolated cores at the same time would be a
> > bonus, most important is that no new threads sneak in.
> 
> Worker pools are immutable once created and configuraiton changes are
> achieved by creating new pools and draining old ones but at any rate
> making it follow config changes is almost trivial.  Figuring out
> configuration policy might take a bit of effort tho.  Can you point me
> to what specific configuration it should be following?

For cpusets, an exclusive set should become taboo to unbound workers
when load balancing is turned off.  The user making sched domains go
away is a not so subtle hint that he wants no random interference, as he
is trying to assume full responsibility for task placement therein.

In my trees, I let the user turn rt cpupri/push/pull off as well, as
that further reduces jitter.

	-Mike
