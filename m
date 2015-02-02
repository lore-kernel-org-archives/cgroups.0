From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: CGROUPS: HowTo: perform force_empty
Date: Mon, 2 Feb 2015 13:15:20 +0100
Message-ID: <20150202121520.GB4583@dhcp22.suse.cz>
References: <002d01d03ece$1971ae10$4c550a30$@samsung.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=a9jnMUF9wZOVM1h8dpkFdXpdmQgWztw4tUN2vNdliRo=;
        b=uj5l6sQm5WPOl6wJAeYcI83mFntbbaB56wx78kzMraScZhcxml3N/FB7PYQ5JIMwgY
         TJ3qxlER8plw+dRAyQ+MGcqNtJc17KH4sqqOmlT0UEOV0fzFlf63ulyu7qyBrpArCSBJ
         V8Pxqz6nSGFoeGa85ypcsDGq1em2xnY2X2cio7S2HOmi5hcVh4Sjf1bCfMn1Qxqcbyac
         S2c5Ihi+CrDddDBs5IPgjkdiOAF7KPfhFiIEbKo2KA0mVN8EXS7ft6ZSdK3muE3Dnaqj
         DL849DsKqngCf0xbD2UOlwRyaJ1OsSf/wMZczEHPT05MvkcLyT7QpZcXYrX7xBkREGYm
         bNqg==
Content-Disposition: inline
In-Reply-To: <002d01d03ece$1971ae10$4c550a30$@samsung.com>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: PINTU KUMAR <pintu.k-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, cpgs-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org

On Mon 02-02-15 15:23:22, PINTU KUMAR wrote:
> Hi,
> 
> I have a question about memory cgroups under Linux kernel 3.10.
> Under: /sys/fs/cgroup/memory/:
> 
> I found, memory.force_empty.
> But, when I try to do the following it says invalid argument:
> # echo 0 > memory.force_empty
> sh: echo: write error: Invalid argument
> 
> It even fails with "echo 1"

It is not clear on which cgroup you are trying to invoke force_empty.
The knob is disabled for the root memcg so I suppose this is why you see
the failure. 

> I am using this command from the shell using the root login.
> Can you tell me how to execute the force_empty command.

You can echo anything to the knob to trigger the reclaim.

> Or, how to release all the memory under all cgroups and release it to the
> system?

Why would you use memcg API to release memory from the system as whole?
What are you trying to achieve?

> Under, mm/memcontrol.c , if I use the function: mem_cgroup_force_empty(struct
> mem_cgroup *memcg), will it help to release all memory?
> But, then, how to initialize the memcg data structure?
> Can you provide some example to use this API, from some other kernel
> sub-system.

mem_cgroup_force_empty is an internal memory controller functionality
which is not supposed to be used from other kernel subsystems. Why would
you want to force reclaim on memcg level from the kernel in the first
place?
-- 
Michal Hocko
SUSE Labs
