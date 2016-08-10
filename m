From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: make sure new tasks conform to the current
 config of the cpuset
Date: Tue, 9 Aug 2016 23:59:59 -0400
Message-ID: <20160810035959.GF25053@mtj.duckdns.org>
References: <57A94D0D.5040006@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2T3McDy6zIdDTP/dM7lcUqWzZMqVrd7FJbii4w9fvF4=;
        b=XopuHxK/S9llRiyU0reXC+KqpipWHKdPtXx2kE/dj78QO7z2FN/9MqGN49ScqrkbLY
         9rb0W0MZaLLWBG5jBt8vwZ9lPXPKnXoLFysVnvFjcJ2pO8oP5+8+rSnjDVBtG2eXDTwu
         MkNnDU+5OgDjF84uR04AzIt4IiJkCt+7jasUqpra8PLTFodkFJ5roOClVNaWN5hbtE5F
         D45mh52ippI03VSoQ2iENQPN3QuaPVnFIqQp052Kti2Rue88urU1NMzwUFkWuWDAuCAN
         HsSeV+doJRgwCSb5xdzAqQfOyeBzlyNQ28K8lLLadinp16NJNGftgHAgiw8knaj5D066
         w1ew==
Content-Disposition: inline
In-Reply-To: <57A94D0D.5040006-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Aug 09, 2016 at 11:25:01AM +0800, Zefan Li wrote:
> A new task inherits cpus_allowed and mems_allowed masks from its parent,
> but if someone changes cpuset's config by writing to cpuset.cpus/cpuset.mems
> before this new task is inserted into the cgroup's task list, the new task
> won't be updated accordingly.
> 
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-4.8-fixes w/ stable cc'd.

Thanks.

-- 
tejun
