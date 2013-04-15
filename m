From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove cgrp->top_cgroup
Date: Sun, 14 Apr 2013 23:26:40 -0700
Message-ID: <20130415062640.GQ3050@htj.dyndns.org>
References: <516B9D41.8080508@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=SVvhqfj99K6Z4NbmQNq7pr2E6Db2YnZR5DSxEY9HK0s=;
        b=MhlzS3O9Vd5Os0Zm3hbqkZMTZYNqizKnz+ym/oRzFiCygzmpmPaImf/8CICcnc6aCQ
         hR/dx9cGGX41x2Ek+kJNcSMXX19eAuEXXnnaEcPw4SKS89JZGoW5k6YMECwhIjrjFLUo
         SOmZGDGvZY0QMLal4/03EyTJwjg2nOdubVQnqYMXgwzaNKdtwiHQHi/4aTJ5KMF42xLx
         QwnxhNO3ETLPugMuTIFY0L8FgviWPHFruJs5mIO5ppI4iOSywu4GtDL+DbtPn30tsX98
         nc4GWz7NH3kWadXMy6KAWD43mEoooyqP7RRzAaMOw8UzGeWM6+XpALE6gvFMJkgaP6wW
         vB9g==
Content-Disposition: inline
In-Reply-To: <516B9D41.8080508-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Apr 15, 2013 at 02:25:05PM +0800, Li Zefan wrote:
> It's not used, and it can be retrieved via cgrp->root->top_cgroup.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.10.  Thanks.

-- 
tejun
