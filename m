From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.13-fixes] cgroup: fix oops in cgroup init
 failure path
Date: Fri, 6 Dec 2013 22:04:17 +0400
Message-ID: <52A211A1.8040809@parallels.com>
References: <1386234006-1633-1-git-send-email-vdavydov@parallels.com> <20131205211814.GA29598@mtj.dyndns.org> <52A1766F.5090808@parallels.com> <20131206161312.GC13373@htj.dyndns.org> <20131206162503.GD13373@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131206162503.GD13373-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 12/06/2013 08:25 PM, Tejun Heo wrote:
> On Fri, Dec 06, 2013 at 11:13:12AM -0500, Tejun Heo wrote:
>>> Second, it's not clear to me why we need the CSS_ONLINE flag at all if
>>> we never assign css's that we fail to online to a cgroup. AFAIU we will
>>> never see such css's, because in all places we call offline_css(),
>>> namely cgroup_destroy_locked() (via kill_css()) and
>>> cgroup_unload_subsys(), we use cgroup_css() which will return NULL for them.
>> The whole thing is in flux and will look very different in near
>> future.  I actually had patches queued which deal with the issue you
>> spotted but they are being blocked on other changes ATM.  So, yeah,
>> there are some spurious stuff now.
> LOL, I found the patch.  It was posted and acked I just forgot to
> apply the whole series.  I'm a moron.
>
>   http://permalink.gmane.org/gmane.linux.kernel.containers/26804
>
> This should do it, right?  I'll update the patch description and
> repost the series.

If combined with the patch you've sent recently, this should do the trick.

Thanks.
