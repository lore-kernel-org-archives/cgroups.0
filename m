From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: memcg with kmem limit doesn't recover after disk i/o causes limit
 to be hit
Date: Fri, 18 Apr 2014 21:57:51 +0400
Message-ID: <5351679F.5040908@parallels.com>
References: <20140416154650.GA3034@alpha.arachsys.com> <20140418155939.GE4523@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140418155939.GE4523-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Richard Davies <richard-li8END47hbdWk0Htik3J/w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi Richard,

18.04.2014 19:59, Michal Hocko:
> [CC Vladimir]
> 
> On Wed 16-04-14 16:46:50, Richard Davies wrote:
>> Hi all,
>>
>> I have a simple reproducible test case in which untar in a memcg with a kmem
>> limit gets into trouble during heavy disk i/o (on ext3) and never properly
>> recovers. This is simplified from real world problems with heavy disk i/o
>> inside containers.
>>
>> I feel there are probably two bugs here
>> - the disk i/o is not successfully managed within the kmem limit
>> - the cgroup never recovers, despite the untar i/o process exiting

Unfortunately, work on per cgroup kmem limits is not completed yet.
Currently it lacks kmem reclaim on per cgroup memory pressure, which is
vital for using kmem limits in real life. Basically that means that if a
process inside a memory cgroup reaches its kmem limit, it will be
returned ENOMEM on any allocation attempt, and no attempt will be made
to reclaim old cached data.

In your case untar consumes all kmem available to the cgroup by
allocating memory for storing fs metadata (inodes, dentries). Those
metadata are left cached in memory after untar dies, because they can be
potentially used by other processes. As a result, any further attempt to
allocate kmem (e.g. to create a process) will fail. It should try to
reclaim the cached metadata instead, but this functionality is not
implemented yet.

In short, kmem limiting for memory cgroups is currently broken. Do not
use it. We are working on making it usable though.

Thanks.
