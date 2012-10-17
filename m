From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [REGRESSION] cgroup: notify_on_release may not be triggered in
 some cases
Date: Tue, 16 Oct 2012 17:11:42 -0700
Message-ID: <20121017001142.GN16166@google.com>
References: <20121004163716.64dae034dab9eafa2b6e6a8f@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DE0El2IuxIxNymubicqdBEiqC8BAIT2Wouz8qhKXOsM=;
        b=vXjtEliEzFP48qth+39fY6S6ovkVyD89oj14qBPBz/ZKrk5TzczQsL/ity+OgXkncA
         kCghkzk+qqVhx6JNCuvCWwa/oECRMXkZ9rknyfGcMWIkHoaZikTmmjevELQi1k1C9Gm0
         Q816e4n38Ht1viA0YDEQyT8cZ9oC4yqKkPyIrKLhC9rJQ6+XyeAma+j11JYYXQ504+e9
         vdg2WaYR2i6VBGbUMSQtNRLzj+/tm9owg5ZO1b4UHbOAtsEMEczHqzCBh81gcRrZX9R9
         oQWR4upZMeAW6nJ8JFmKyjABtcDX5KWkWG1bs0/Iocmtf2Ij3W1AyQZ8lAl7F9NFAseQ
         LtRQ==
Content-Disposition: inline
In-Reply-To: <20121004163716.64dae034dab9eafa2b6e6a8f-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ben Blum <bblum-OM76b2Iv3yLQjUSlxSEPGw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello,

On Thu, Oct 04, 2012 at 04:37:16PM +0900, Daisuke Nishimura wrote:
> notify_on_release must be triggered when the last process in a cgroup is
> move to another. But if the first(and only) process in a cgroup is moved to
> another, notify_on_release is not triggered.
> 
> 	# mkdir /cgroup/cpu/SRC
> 	# mkdir /cgroup/cpu/DST
> 	#
> 	# echo 1 >/cgroup/cpu/SRC/notify_on_release
> 	# echo 1 >/cgroup/cpu/DST/notify_on_release
> 	#
> 	# sleep 300 &
> 	[1] 8629
> 	#
> 	# echo 8629 >/cgroup/cpu/SRC/tasks
> 	# echo 8629 >/cgroup/cpu/DST/tasks
> 	-> notify_on_release for /SRC must be triggered at this point,
> 	   but it isn't.
> 
> This is because put_css_set() is called before setting CGRP_RELEASABLE
> in cgroup_task_migrate(), and is a regression introduce by the
> commit:74a1166d(cgroups: make procs file writable), which was merged
> into v3.0.
> 
> Cc: Ben Blum <bblum-OM76b2Iv3yLQjUSlxSEPGw@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.0.x and later
> Signed-off-by: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>

Applied to cgroup/for-3.7-fixes w/ Li's ack added.

Thanks!

-- 
tejun
