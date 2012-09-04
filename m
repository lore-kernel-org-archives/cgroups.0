From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2] memcg: first step towards hierarchical controller
Date: Tue, 4 Sep 2012 12:29:42 +0400
Message-ID: <5045BBF6.5000900@parallels.com>
References: <1346687211-31848-1-git-send-email-glommer@parallels.com> <20120903164148.GS29217@decadent.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120903164148.GS29217-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


> 
>> +	  of the root memcg, regardless of their positioning in the tree.
>> +
>> +	  Use of flat hierarchies is highly discouraged, but has been the
>> +	  default for performance reasons for quite some time. Setting this flag
>> +	  to on will make hierarchical accounting the default. It is still
>> +	  possible to set it back to flat by writing 0 to the file
>> +	  memory.use_hierarchy, albeit discouraged. Distributors are encouraged
>> +	  to set this option.
> [...]
> 
> I don't think that 'default n' is effective encouragement!
> 
> Ben.
> 
If it were up to me, I would just flip it to 1. No option.
A bit of history here, is that people have a - quite valid - concern
that this will disrupt users using their own kernel, should they decide
to update, recompile and run.

Conditional on a Kconfig option, people reusing their .config will see
no change. Distros, otoh, are versioned. It is not unreasonable to
expect a behavior change when a major version flips.

The encouragement here comes not from the default, but from the
acknowledgment that his thing is totally broken, and we need to act to
fix it in a compatible way.
