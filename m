From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/3] kernfs: introduce kernfs_pin_sb()
Date: Fri, 27 Jun 2014 11:01:41 -0400
Message-ID: <20140627150141.GB4044@htj.dyndns.org>
References: <53AD18D0.3090100@huawei.com>
 <53AD18F8.4050501@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4y8kW+72FzO+0NBG/jaKvSruvu9aLkpFzf8sPV8SwI4=;
        b=lAVGhaZ/9ROKPY4jdV3Mk/xjrCeOqV/vVRhfhxnN3H1ufglJ1mFKu+31HmhzQL5DUR
         MDSJpLcZddJedjJ83I2xtbEo+mI7hQCvI/A/UJQKmrZ2pYtwGjyD70umjhViK8p+YjMO
         6sHrvWlcwtl1NpEsDTnyK26mxUEUEO5rccwqHhUiJEb9OqFlj1j9u4RykchDReCI943k
         nNIrLLuLbZWk/w7siyUHOulwz/bGxrozDHyOTQ6AD3ENrr94Z57P6rGCIfaPJ1h8JjSL
         FmQ48/RLqpGK1bNuwX8xhlXekOZ+g75MgyD7B9KBMh7Wm1lqxqsfdfisRCgQ3ENk0qNe
         Nflw==
Content-Disposition: inline
In-Reply-To: <53AD18F8.4050501-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

On Fri, Jun 27, 2014 at 03:10:48PM +0800, Li Zefan wrote:
> kernfs_pin_sb() tries to get a refcnt of the superblock.
> 
> This will be used by cgroupfs.

Greg, this is pretty much cgroup specific due to the way cgroup
dynamically manages multiple hierarchies.  Can I route this through
cgroup/for-3.16-fixes w/ stable cc'd?

Thanks.

-- 
tejun
