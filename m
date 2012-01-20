From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: move struct cgroup_pidlist out from the
 header file
Date: Fri, 20 Jan 2012 09:31:11 -0800
Message-ID: <20120120173111.GB3336@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4F18E651.2000109@cn.fujitsu.com>
 <4F18E673.9070306@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=EYX03DFTHnQjodncvLWflGmlBPKshpzG5AOvHGD2APA=;
        b=FW/uTqKDSN8Zw/9wyTU+cVi8uUhvyyFkq5LmpLCZQ7jaP+081yGhNIacCq/pcMSykW
         1Z20Bc3LBPk5ZI7N7bMdj9AEJ2wm2YiC64lM09Jz7hc3hEe02zTqPMhv6UJwZHcez7PV
         HDzY/Rp1XoO0nHxrrcTqePqzYXPvCBUIH7/DM=
Content-Disposition: inline
In-Reply-To: <4F18E673.9070306-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jan 20, 2012 at 11:58:43AM +0800, Li Zefan wrote:
> It's internally used only.
> 
> Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

Both applied to cgroup/for-3.4.  Thanks!

-- 
tejun
