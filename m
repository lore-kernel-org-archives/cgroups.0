From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix fail path in cgroup_load_subsys()
Date: Thu, 12 Dec 2013 22:51:45 +0400
Message-ID: <52AA05C1.1070709@parallels.com>
References: <1386403085-24866-1-git-send-email-vdavydov@parallels.com> <20131212153536.GD32683@htj.dyndns.org> <20131212155523.GF32683@htj.dyndns.org> <52AA026C.3040605@parallels.com> <20131212184506.GK32683@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131212184506.GK32683-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On 12/12/2013 10:45 PM, Tejun Heo wrote:
> Hello,
>
> On Thu, Dec 12, 2013 at 10:37:32PM +0400, Vladimir Davydov wrote:
>> If so, I don't mind, but why? cgroup_unload_subsys() should never be
>> called without properly initialized css.
> Hmm.... I think it's generally preferable to reuse normal exit path
> for error handling as much as possible.  Plus, the normal cgroup init
> failure path behaves that way.  That said, it's more of a preference
> and if you have technical argument, I'd be happy to give in. :)

Got it, will do.

Thanks.
