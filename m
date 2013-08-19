From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: change cgroup_from_id() to css_from_id()
Date: Mon, 19 Aug 2013 09:53:53 -0400
Message-ID: <20130819135353.GC6176@htj.dyndns.org>
References: <520DCF2C.1020903@huawei.com>
 <20130816170659.GM2505@htj.dyndns.org>
 <52117D64.1010709@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=sLVg8PvyZg3xfwF0mmnvAFa2YvrIKIe9UAU//n7i+IY=;
        b=ro+3OU5NyDjk8ZtZcalq8QwTW0Iz4KVqeGyofQnc48h5DThu4lF+agCV6g76Rq6/Dj
         XIhK2z3l/Yy2vZip8cFwuFzFd8TOaHx0d10oZKuXuZL4hQWBOAxB3wy2g+6jF0UIEl3E
         D1TTXX9DC/XvHsWN+fJ2/foHckxpEQpA8JM1yi8DaB0ICMzSCWz+aNotgXr0NdD76knV
         JbbGRLgJYh7Rr3473owPs3z+TLYmUfHrFxaHOdOgS6Qogd/DgLr1ij7OUKUfR04lFBmP
         wsYtQGzDxtdcdIUjx/l0tqhhG+uQFtAGh2gZaorwBiZ804Dt2RpK0YLXcGqUBxm9iBps
         yqyw==
Content-Disposition: inline
In-Reply-To: <52117D64.1010709-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Aug 19, 2013 at 10:05:24AM +0800, Li Zefan wrote:
> Now we want cgroup core to always provide the css to use to the
> subsystems, so change this API to css_from_id().
> 
> Uninline css_from_id(), because it's getting bigger and cgroup_css()
> has been unexported.
> 
> While at it, remove the #ifdef, and shuffle the order of the args.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
