From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for
 kernel?5.7.0-rc5-51f14e2.cki (arm-next)
Date: Wed, 13 May 2020 11:51:14 -0400
Message-ID: <20200513155114.GF16815@mtj.duckdns.org>
References: <cki.495C39BD1A.T35Z6VDJPY@redhat.com>
 <20200513060321.GA17433@willie-the-truck>
 <1322199095.22739428.1589365183678.JavaMail.zimbra@redhat.com>
 <1039472143.12305448.1589384415559.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rLEeAmSBwjT3ETZ4wrXG/Y/gbcP+c03guOC0q4Y8fXA=;
        b=CxGZlnCeO8Z+6gWlkyNbL90JiSBlEzm6ThptrdmeTLYbrTmiUMlAF6eHDx9NV4zeGb
         6Rz3PQV5R2XN9pUf4xmN1IKVyaF3WVMHV2UboX5qGevLW946cEuuraERFw9eQEGrXbKC
         ZEtxxPGYbrPUoeWB24ML8Lrx5iuNxW9EkzdqgnkAEasHh2uQH+0JMGCCrdUhLWCvQxBk
         JnuFgJC9Q7HhNbdxW6kBxmZQg/NA4JNrsvfHwgltLePF6FTwiQ/6ToQYL4IHmpzv3H5S
         y/cem8PayEiSqD2aA8SYbHiKZP+VpyM2Tnbb7hjAsHqXaRo4rS7TuE99ktMAowj5sh3E
         V6OQ==
Content-Disposition: inline
In-Reply-To: <1039472143.12305448.1589384415559.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Stancek <jstancek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Veronika Kabatova <vkabatov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Memory Management <mm-qe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, CKI Project <cki-project-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, catalin marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, LTP List <ltp-cunTk1MwBs91InPhgRC9rw@public.gmane.org>

On Wed, May 13, 2020 at 11:40:15AM -0400, Jan Stancek wrote:
> In LTP issue above it was clear that memory controller is in use.
> Here it looks like some lingering reference to cpuset controller
> that can't be seen in sysfs.
> 
> It's triggered by podman tests actually:
> 1. run podman tests
> 2. mount -t cgroup -ocpuset cpuset /mnt/cpuset/ -> EBUSY
> 
> # mount | grep cgroup
> cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,seclabel)
> 
> # grep cpuset -r /sys/fs/cgroup/
> /sys/fs/cgroup/cgroup.controllers:cpuset cpu io memory pids
> 
> And yet, v1 cgroup fails to mount:
> 
> # mount -t cgroup -ocpuset cpuset /mnt/cpuset/
> mount: /mnt/cpuset: cpuset already mounted or mount point busy.

While if a regression it may point to a newly introduced behavior, in
general, dynamically reassigning cgroup controllers to a different version
hierarchy after active use is not something fully supported. From cgroup2
documentation:

  A controller can be moved across hierarchies only after the controller is
  no longer referenced in its current hierarchy. Because per-cgroup
  controller states are destroyed asynchronously and controllers may have
  lingering references, a controller may not show up immediately on the v2
  hierarchy after the final umount of the previous hierarchy. Similarly, a
  controller should be fully disabled to be moved out of the unified
  hierarchy and it may take some time for the disabled controller to become
  available for other hierarchies; furthermore, due to inter-controller
  dependencies, other controllers may need to be disabled too.

  While useful for development and manual configurations, moving controllers
  dynamically between the v2 and other hierarchies is strongly discouraged
  for production use. It is recommended to decide the hierarchies and
  controller associations before starting using the controllers after system
  boot.

Thanks.

-- 
tejun
