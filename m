From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix cgroup_path() vs rename() race
Date: Fri, 25 Jan 2013 08:42:42 -0800
Message-ID: <20130125164242.GA3081@htj.dyndns.org>
References: <51022FC7.5020607@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=vTq62LKNbpdszNsrvCI0SnY152s2vTOztiOxBsn8Sn0=;
        b=Biv2EszprsGMYEbkZkcn1nIssLOJ+frJlfuo1yC6fgHzGZgtJqrnTEiq9KJ3pE15Mw
         2nWxbT8s6xAeJheNd0FOD2nQS2ZirGmakUi8nWLKYRUCNGyxtgbg4IBouAeyOUiZfcUn
         PZREQwBR+ARirRb8JDi+o5zeEVFTw92S5mqULPIm47j9DLUwF5CfGuZywnlZb6/7/c0r
         LNXh5J0Qkl+NWvFoRII3GMJ3HIPtnKMMCdoOVp14baMF0gvkmXuX5F/4gnEA3uqY2CZ5
         xUKGFhOILZY4+FByCt8Tm1psuoOKbISRZWlwE+OJTv5tMmjEbZKoygUiB7XvonDqHnqk
         auNA==
Content-Disposition: inline
In-Reply-To: <51022FC7.5020607-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jan 25, 2013 at 03:09:59PM +0800, Li Zefan wrote:
> rename() will change dentry->d_name. The result of this race can
> be worse than seeing partially rewritten name, but we might access
> a stale pointer because rename() will re-allocate memory to hold
> a longer name.
> 
> Use dentry_path_raw(), and this vfs API will take care of lockings.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Urgh... why do we even support rename?  :(

Applying to cgroup/for-3.8-fixes w/ stable cc'd.

Thanks.

-- 
tejun
