From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.13-fixes] cgroup: fix oops in cgroup init
 failure path
Date: Mon, 9 Dec 2013 17:10:46 +0800
Message-ID: <52A58916.4070708@huawei.com>
References: <1386234006-1633-1-git-send-email-vdavydov@parallels.com> <20131205211814.GA29598@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131205211814.GA29598-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 2013/12/6 5:18, Tejun Heo wrote:
> Hello, Vladimir.
> 
> Thanks a lot for the report and fix; however, I really wanna make sure
> that only online css's become visible, so I wrote up a different fix.
> Can you please test this one?
> 

Oh, I spotted this bug when reviewing a bug fix months ago.

http://lkml.org/lkml/2013/9/2/135

but that bug fix didn't go into mainline and it still exists even after
the below fix.

This is your updated fix that fixes both bugs.

http://lkml.org/lkml/2013/9/3/502
