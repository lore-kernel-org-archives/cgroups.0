From: PINTU KUMAR <pintu.k-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: CGROUPS: HowTo: perform force_empty
Date: Mon, 02 Feb 2015 15:23:22 +0530
Message-ID: <002d01d03ece$1971ae10$4c550a30$@samsung.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-language: en-us
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
Cc: cpgs-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org

Hi,

I have a question about memory cgroups under Linux kernel 3.10.
Under: /sys/fs/cgroup/memory/:

I found, memory.force_empty.
But, when I try to do the following it says invalid argument:
# echo 0 > memory.force_empty
sh: echo: write error: Invalid argument

It even fails with "echo 1"

I am using this command from the shell using the root login.
Can you tell me how to execute the force_empty command.

Or, how to release all the memory under all cgroups and release it to the
system?

Under, mm/memcontrol.c , if I use the function: mem_cgroup_force_empty(struct
mem_cgroup *memcg), will it help to release all memory?
But, then, how to initialize the memcg data structure?

Can you provide some example to use this API, from some other kernel sub-system.


Thank you.
Regards,
Pintu
