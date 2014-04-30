From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: A problem with memory.oom_control
Date: Wed, 30 Apr 2014 10:56:25 +0200
Message-ID: <20140430085625.GB4357@dhcp22.suse.cz>
References: <CAGXs5wUdhEYQ-kGEPSD2A=OceZuA1tovLs04gPcRcqBPagQJCw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXs5wUdhEYQ-kGEPSD2A=OceZuA1tovLs04gPcRcqBPagQJCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 14-04-14 14:54:23, Kevin Wilson wrote:
> Hello,
> 
> First I hope this mailing list is the proper one for asking the
> following question:
> I do the following, as root,  on Fedora 20 with 3.12.7-300.fc20.x86_64 kernel:
> 
> create a cgroup called "0"
> /sys/fs/cgroup/memory/0
> 
> run:
> 
> echo "1" > /sys/fs/cgroup/memory/0/memory.oom_control
> bash: echo: write error: Invalid argument

JFYI: a patch[1] which changes this behavior is in mmotm tree already
and it will be probably merged into 3.15.

[1] https://lkml.org/lkml/2014/4/16/651

> Why am I having this error  ?
> 
> According to the documentation:
> 
> http://lxr.free-electrons.com/source/Documentation/cgroups/memory.txt
> this should work.
> 
> Regards,
> Kevin
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
