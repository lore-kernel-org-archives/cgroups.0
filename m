From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: make cgroup_event specific to
 memcg
Date: Wed, 7 Aug 2013 09:36:45 -0400
Message-ID: <20130807133645.GE27006@htj.dyndns.org>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
 <20130805160107.GM10146@dhcp22.suse.cz>
 <20130805162958.GF19631@mtj.dyndns.org>
 <20130805191641.GA24003@dhcp22.suse.cz>
 <20130805194431.GD23751@mtj.dyndns.org>
 <20130806155804.GC31138@dhcp22.suse.cz>
 <20130806161509.GB10779@mtj.dyndns.org>
 <20130807121836.GF8184@dhcp22.suse.cz>
 <20130807124321.GA27006@htj.dyndns.org>
 <20130807132613.GH8184@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=BbyT2q9x3CK73qT+N8xDUC3AuQ7hlbxSV2V8ZyyHm74=;
        b=nGpOInlIca9OPlOwU15/8d5aPZTO1wbIdrQZnblV7ls7MLYh6U1RZi4LeFjdB9M9CN
         nSkR+Jgab3sXPjvMqXryywZ+E/2PHpruz1N0wOGABZpRrsy+u1t68JylgRcbxt3X4P1P
         WnazswkAZAztRaia3nBDV03G/9ZqmwZX9WVB6FNGK/KSP8nlZ6qz1h1OKDO7AkM0nUK5
         OrybdByAXoThBFnhBo+1upjykZNGD61r/jMpUcN1ZVrvDPZ6It/Pxs5C0lbRspZdlaYK
         1dGDdIjzf8Phb7w8hcks9xU01mzfbC5FK0LiKRA9SRDtSeh7kJ0G3HwzTqRvgkdBUPgi
         4PiQ==
Content-Disposition: inline
In-Reply-To: <20130807132613.GH8184@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Aug 07, 2013 at 03:26:13PM +0200, Michal Hocko wrote:
> I would rather see it not changed unless it really is a big win in the
> cgroup core. So far I do not see anything like that (just look at
> __cgroup_from_dentry which needs to be exported to allow for the move).

The end goal is cleaning up cftype so that it becomes a thin wrapper
around seq_file and I'd really like to keep the interface minimal so
that it's difficult to misunderstand.

> You reduce the amount of code in cgroup.c, alright, but the code
> doesn't go away really. It just moves out of your sight and moves the
> same burden on somebody else without providing a new generic interface.

If the implementation details are all that you're objecting, I'll be
happy to restructure it.  I just didn't pay too much attention to it
because I considered it to be mostly deprecated.  I don't think it'll
be too much work and strongly think it'll be worth the effort.  Our
code base is extremely nasty is and I'll try to get any ounce of
cleanup I can get.

> If somebody needs a notification interface (and there is no one available
> right now) then you cannot prevent from such a pointless work anyway...

I'm gonna add one for freezer state transitions.  It'll be simple
"this file changed" thing and will probably apply that to at least oom
and vmpressure.  I'm relatively confident that it's gonna be pretty
simple and that's gonna be the cgroup event mechanism.

> cgroup_event_* don't sound memcg specific at all. They are playing with
> cgroup dentry reference counting and do a generic functionality which
> memcg doesn't need to know about.

Sure, I'll try to clean it up so that it doesn't meddle with cgroup
internals directly.

> I wouldn't object to having non-cgroup internals playing variant. I just
> do not think it makes sense to invest time to something that should go
> away long term.

I suppose it's priority thing.  To me, cleaning up cgroup core API is
quite important and I'd be happy to sink time and effort into it and
it's not like we can drop the event thing in a release cycle or two.
We'd have to carry it for years, so I think the effort is justified.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
