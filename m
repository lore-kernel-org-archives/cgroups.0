From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.13-fixes] cgroup: fix oops in cgroup init
 failure path
Date: Fri, 6 Dec 2013 22:02:30 +0400
Message-ID: <52A21136.9090605@parallels.com>
References: <1386234006-1633-1-git-send-email-vdavydov@parallels.com> <20131205211814.GA29598@mtj.dyndns.org> <52A1766F.5090808@parallels.com> <20131206161312.GC13373@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131206161312.GC13373-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 12/06/2013 08:13 PM, Tejun Heo wrote:
> Hello, Vladimir.
>
> On Fri, Dec 06, 2013 at 11:02:07AM +0400, Vladimir Davydov wrote:
>> This patch fixes this bug, but I have a couple of questions regarding it.
>>
>> First, cgroup_load_subsys() also calls css_online(), and if it fails, it
>> calls cgroup_unload_subsys() to rollback. The latter function executes
>> the following command:
>>
>>     offline_css(cgroup_css(cgroup_dummy_top, ss));
>>
>> But since we failed to online_css(), cgroup_css() will return NULL
>> resulting in another oops.
> I don't think the root css onlining fails for any existing controllers
> but yeah that looks wrong.  Can you please send a patch?

Sure, I will send it soon.

Thanks.
