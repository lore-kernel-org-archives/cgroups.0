From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: don't destroy the default root
Date: Wed, 4 Jun 2014 21:22:27 -0400
Message-ID: <20140605012227.GC14370@mtj.dyndns.org>
References: <538EDD4F.9010403@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5QPXtw/SGNwUbQXm4r8idVdVz6fwb13nKoM6cVMpyTY=;
        b=qq/Z0JTACSroxJEaAZk5pYdDrCTUIKdjRsBZLf/Dj76WM05lvHEVs4Gk0hjS2q81nm
         rEwmN4Pn0T8uOGPAbamkPjbSdkI+Gbljkz2GFqBHCOxgjYgWU+zWYtf8I60DN+4llz2P
         eaiXDuEtFXpPKmTm8lY2tad9BUqgCmrL3+eFUW9xVuhYU5f7EP0/SchBGMAjzhjrJy0X
         5m7ya22gSeoJMA8I24jLQONWxgGVoarpAHzh+yg2LnsAVXSPUgaTrZFgc8gkwl+T0Qs6
         hcstymkcRoQd206gPz5k4jWFO3cTWYW1IegW0/1Exh3VDgnphqUiQJWId5ePqwIXO9f3
         kfIg==
Content-Disposition: inline
In-Reply-To: <538EDD4F.9010403-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jun 04, 2014 at 04:48:15PM +0800, Li Zefan wrote:
> The default root is allocated and initialized at boot phase, so we
> shouldn't destroy the default root when it's umounted, otherwise
> it will lead to disaster.
> 
> Just try mount and then umount the default root, and the kernel will
> crash immediately.
> 
> v2:
> - No need to check for CSS_NO_REF in cgroup_get/put(). (Tejun)
> - Better call cgroup_put() for the default root in kill_sb(). (Tejun)
> - Add a comment.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
