From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.16] cgroup: add documentation about unified
 hierarchy
Date: Wed, 16 Apr 2014 13:16:18 -0700
Message-ID: <534EE512.5090905@infradead.org>
References: <20140414220917.GD1863@htj.dyndns.org> <534DB46D.7090207@infradead.org> <20140416135120.GI30990@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140416135120.GI30990-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Brandon Philips <brandon.philips-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>

On 04/16/2014 06:51 AM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Apr 15, 2014 at 03:36:29PM -0700, Randy Dunlap wrote:
>>> +depending on the specific controller.  IOW, hierarchy may be collapsed
>>
>> please spell out IOW
> 
> Updated, but is this really necessary?

It depends on who your audience is.  I probably think that the audience
is larger than you think it is.

>> I would prefer to see CPU instead of cpu (except when it refers to a
>> task or function).
> 
> cpu sometimes refer to the cpu controller.  Will use CPU when it's
> actually referring to the CPU.

OK, thanks.


-- 
~Randy
