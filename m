From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/7] cgroup: rename cgroup_pidlist->mutex
Date: Wed, 31 Jul 2013 07:35:18 -0400
Message-ID: <20130731113518.GJ2810@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C818.4080308@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=r1WS82rB0V0a8G8qGV+3WdUK3vaZSNJ6ftoyX0sInH0=;
        b=YEqwigd5W+oD7sRlJQFAB8moUmwh7GeOKveGEUi8Hf1bqLy7u0PfExLhBSPvJnDkOm
         oFHcaWCVpz09YJZkbt+ibbGGS/aTUtonmhI3dy+1u6eiGT5Su27jHArszSP9glAOI2GT
         GaI3OxEltvSPbjecxcMJrcjC9XM9Otb8FIunPqAIYg42wHoEisNrPn/0Ew7r6FdO/T/M
         IX7DFZlTysiEW8MadVWvgd318zT+nSHvgKtdOJTFcFFegG0CKk7imDsjqJqDVf5PUMfR
         n1xcF/bGmFfS6SyDW1zhgPBlmTOjrzcx1QON8GJVgS9wp539afirhKgtVixJ7KzL0/4h
         QQ7A==
Content-Disposition: inline
In-Reply-To: <51F8C818.4080308-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 31, 2013 at 04:17:28PM +0800, Li Zefan wrote:
> It's a semaphore not a mutex.

It's not even a normal semaphore.  Maybe naming it rwsem is better?

Thanks.

-- 
tejun
