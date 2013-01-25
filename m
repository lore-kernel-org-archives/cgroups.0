From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cpuset: fix cpuset_print_task_mems_allowed() vs
 rename() race
Date: Fri, 25 Jan 2013 08:51:54 -0800
Message-ID: <20130125165154.GB3081@htj.dyndns.org>
References: <51023D61.9000901@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=3q0I+EGdSbmFVWkBfDnLshK9NQ16WNyprgJDw+7i5gE=;
        b=fcoP8a077r3TIH/sr2OxKyVQvVgp2ZKnUFQ5ku0bWXAiGAOTRSjoAG4nQsGugn+wF+
         +SvgX0K4cXdZTIKfuhidO+FGlZX1OnV+rt2HS40mb47c04RHESJf5zLLz1pTzgZdHh0F
         6qsIXQgV3OIw4AFxnOy1Kj8yhxAUYPvDYUeyhpcU2d1/dt1+3f1lxtGNM6LAmf/VGyWW
         YjHf4/Os6EY88Gl7INLqGFH+xz7NufyI9Kzr8REd7nGMUAxeqwyfCpSnikTma7Fnr2AW
         Qqwq2jcYOLrQnGfqM0J5UUQB4CTvFsBRF9HGtE2EZPdpcjbKvqSF/dmEjlGu2paM/HON
         R+7w==
Content-Disposition: inline
In-Reply-To: <51023D61.9000901-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jan 25, 2013 at 04:08:01PM +0800, Li Zefan wrote:
> rename() will change dentry->d_name. The result of this race can
> be worse than seeing partially rewritten name, but we might access
> a stale pointer because rename() will re-allocate memory to hold
> a longer name.
> 
> It's safe in the protection of dentry->d_lock.
> 
> v2: check NULL dentry before acquiring dentry lock.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.8-fixes w/ stable cc'd.

Thanks.

-- 
tejun
