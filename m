From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] rdmacg: Fixed uninitialized current resource usage
Date: Tue, 10 Jan 2017 12:53:02 -0500
Message-ID: <20170110175302.GB3814@htj.duckdns.org>
References: <1484070708-5422-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5TlfIzB5uije3P9ytJO67ZTDD80wa3VmIPanS6cZ4rw=;
        b=oxTEvvz6//6P94cXZ3ELk2xxmxNKjT3PfhNLQ4JuWYaoOWVPVv4NNVfjUmS7ssrnjp
         2fOuxOpYCvcKcrIardt6RwiZrG4/Z67CIaHuaUfjagbTuWpp36P0ok6RlM1/QLCZO7ZI
         Oem69TCm3CPQ0ci0doTXx4XmGqDI1z8QA4unQEvTdZrnNwFkUOSMrVijHtvZxHn2G4mF
         ngR4kgQAU0dZIWk5p4yilweqWOlkdD8DYRx4a+ngGwYDYB9kUAXhBRVYth7m1mTsTx3J
         NAZB47heYV2tBE56UzlI+LjrTwtuA+syqheCYiI9uTeaVHWiuKhZ+MYKCTbY1bcwP2b+
         TzjA==
Content-Disposition: inline
In-Reply-To: <1484070708-5422-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 10, 2017 at 05:51:48PM +0000, Parav Pandit wrote:
> Fixed warning reported by kbuild test robot.
> When reading current resource usage value, when no resources are
> allocated, its possible that it can report a uninitialized value
> for current resource usage.
> This fix avoids it by initializing it to zero as no resource is
> allocated.
> 
> Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-4.11-rdmacg.

Thanks.

-- 
tejun
