From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.14] cgroup: fix fail path in cgroup_load_subsys()
Date: Fri, 13 Dec 2013 11:20:50 +0800
Message-ID: <52AA7D12.2070705@huawei.com>
References: <1386875828-5075-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386875828-5075-1-git-send-email-vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 2013/12/13 3:17, Vladimir Davydov wrote:
> Calling cgroup_unload_subsys() from cgroup_load_subsys() after
> online_css() failure will result in a NULL ptr dereference on attempt to
> offline_css(), because online_css() only assigns css to cgroup on
> success. Let's fix that by skipping calls to offline_css() and
> css_free() in cgroup_unload_subsys() if there is no css, and freeing css
> in cgroup_load_subsys() on online_css() failure.
> 
> Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

I don't have strong preference on which way to go.

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
