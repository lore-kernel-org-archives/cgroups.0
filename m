From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [GIT PULL] cgroup fixes for v3.17-rc6
Date: Tue, 23 Sep 2014 14:45:27 +0800
Message-ID: <54211707.8090604@huawei.com>
References: <20140923063353.GK11740@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140923063353.GK11740-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014/9/23 14:33, Tejun Heo wrote:
> Hello, Linus.
> 
> One late fix for cgroup.  I was waiting for another set of fixes for a
> long-standing obscure cpuset bug but am not sure whether they'll be
> ready before v3.17 release.  This one is a simple fix for a mutex
> unlock balance bug, which is detected by coccinelle and probably won't
> trigger in the wild, introduced during this devel cycle.
> 

It was introduced in 3.14, and it was detected by my eyes, not coccinelle. ;)
