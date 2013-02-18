From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH] cgroup: fail if monitored file and event_control are in
 different cgroup
Date: Mon, 18 Feb 2013 12:24:11 +0200
Message-ID: <20130218102411.GA3394@shutemov.name>
References: <5121C68F.1000309@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5121C68F.1000309-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Feb 18, 2013 at 02:13:35PM +0800, Li Zefan wrote:
> If we pass fd of memory.usage_in_bytes of cgroup A to cgroup.event_control
> of cgroup B, then we won't get memory usage notification from A but B!
> 
> What's worse, if A and B are in different mount hierarchy, we'll end up
> accessing NULL pointer!
> 
> Disallow this kind of invalid usage.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

-- 
 Kirill A. Shutemov
