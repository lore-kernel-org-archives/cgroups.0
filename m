From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 1 Dec 2021 06:46:50 -1000
Message-ID: <Yaem+r/YZ9BNXv9R@slm.duckdns.org>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211018143619.205065-6-longman@redhat.com>
 <20211115193122.GA16798@blackbody.suse.cz>
 <8f68692b-bd8f-33fd-44ae-f6f83bf2dc00@redhat.com>
 <20211116175411.GA50019@blackbody.suse.cz>
 <293d7abf-aff6-fcd8-c999-b1dbda1cffb8@redhat.com>
 <YaZbXArNIMNvwJD/@slm.duckdns.org>
 <2347fe66-dc68-6d58-e63b-7ed2b8077b48@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a9iMR0CBR7MPcGZbowNZD3xNWW/iUgu7zwEMN81p5js=;
        b=jMRV0wsVPZIW6OEbb6hXpefzBZ0V0KHQo49RJDrJKlMu/xzDDqBxDRPNX4NbaJBUPL
         bv3xp8WqpGi+wlW/km8mda9bQxjfPh1P6BYcMqrCnNxnLYg0P2YgYO5evPSsgDBGESV5
         WDuUBUllOleYwxX0NXEGeT1Y9Wzxcv6SFmV74a2Ju2jaBZuToyZZEc0UrIPdiKM1YvR+
         9Fm5aDxg5tM9gYy0FTdf6ZtxvyXDInD9HlSQe+nwuD4fNGbNf5Edp7gDHd6R19zMSle+
         zN7e/vGb81iJkZMdAFJjQu04h2U3M8izjDnbGSxjOndsZpKRCPKMyY+p4/se9Zau9eU1
         XYSQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2347fe66-dc68-6d58-e63b-7ed2b8077b48-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Waiman.

On Tue, Nov 30, 2021 at 10:56:34PM -0500, Waiman Long wrote:
> > What happens if an isolated domain becomes invalid and then valid again due
> > to cpu hotplug? Does it go "root invalid" and then back to "isolated"?
>
> Yes, the current code allow recovering from an invalid state. In this
> particular case, the transition will be "isolated" --> "root invalid" -->
> "isolated".

Wouldn't it be clearer if it became "isolated invalid"?

> > While it isn't necessarily tied to this series, it's a big no-no to restrict
> > what a parent can do depending on what its descendants are doing. A cgroup
> > higher up in the hierarchy should be able to change configuration however it
> > sees fit as deligation breaks down otherwise.
> > 
> > Maybe you can argue that cpuset is special and shouldn't be subject to such
> > convention but I can't see strong enough justifications especially given
> > that most of these restrictions can be broken by hotplug operations anyway
> > and thus need code to handle those situations.
> 
> These are all pre-existing restrictions before the introduction of
> partition. These are checks done in validate_change(). I am just saying out
> loud the existing behavior. If you think that needs to be changed, I am fine
> with that. However, it will be a separate patch as it is not a behavior that
> is introduced by this series.

I see. It looks more problematic now with the addtion of the state
transition error reporting, more possible state transitions and, well,
actual documentation.

> Once an invalid partition is changed to "member", there is no way for a
> child invalid partition root to recover and become valid again. There is why
> I force them to become "member" also. I am OK if you believe it is better to
> keep them in the invalid state forever until we explicitly changed them to
> "member" eventually.

That's because we don't allow turning a cgroup with descendants into a
partition, right?

So, when we were first adding the partition support, the thinking was that
as it's pretty niche anyway, we can take some aberrations and restrictions,
but I don't think it's a good direction to be building up on top of those
like this and would much prefer to clean up the rules and restrictions. I
know that this has been going on for quite a while and am sorry that am
coming back to the same issue repeatedly which isn't necessarily caused by
the proposed change. What do you think?

Thanks.

-- 
tejun
