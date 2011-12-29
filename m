From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix to allow mounting a hierarchy by name
Date: Thu, 29 Dec 2011 10:50:06 +0800
Message-ID: <4EFBD55E.5030106@cn.fujitsu.com>
References: <4EF9291D.7030208@cn.fujitsu.com> <20111227163535.GA17712@google.com> <4EFAB2E2.4040008@cn.fujitsu.com> <20111228163631.GN17712@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111228163631.GN17712-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Tejun Heo wrote:
> Hello, Li.
> 
> On Wed, Dec 28, 2011 at 02:10:42PM +0800, Li Zefan wrote:
>> The "name" option was introduced along with the "none" option, so we
>> can distinguish between different cgroup hierarchies which have no
>> bound subsystems, like this:
>>
>> 	# mount -t cgroup -o none,name=hier1 xxx /cgroup1
>> 	# mount -t cgroup -o none,name=hier2 xxx /cgroup2
>>
>> As the name is unique, we have this "mount by hierarchy name" feature.
> 
> I could be missing something but does that add anything other than
> naming convenience?
> 

The name option is necessary, otherwise how can we mount hierarchies
as shown in the above example?

>> It looks reasonable, but I guess few people know this feature. We can
>> live with it, as it only saves us some typing when mounting an existing
>> hierarchy. On the other hand, removing this small feature can hardly
>> result in code reduction.
> 
> If it's a redundant feature which has been broken over a year without
> anyone complaining, it really doesn't need to exist.  It might not
> save a lot of code but would save some WTH moments.
> 

The redundant feature is mouting existing hierarchies by specifying name
only, and the cleanup patch I sent has this feature removed in effect.

kernel/cgroup.c |   15 +++++++--------
1 files changed, 7 insertions(+), 8 deletions(-)

This is why I'm not so keen to remove the feature.
