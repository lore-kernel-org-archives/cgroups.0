From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/11] cpuset: apply cs->real_{cpus,mems}_allowed
Date: Wed, 21 Aug 2013 10:01:51 -0400
Message-ID: <20130821140151.GF19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148F9C.2080600@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RM6oG77ANc7Lb56nSvmn8tUpfCNYAm82YcZ8ZXM1PfQ=;
        b=lYh/NwJswNF+OB3yfx730v91uTbAwRlBdvEXBqR//MCz79MMOorH3BstenijOezg+W
         fW7Dv4PdVt++0MqkakE6tqjuICcZMKmGxmnJa1IqOiMHiVLrMNrLBPWeNXb34YqcL43/
         6SyHvbjbXBb5vkzGg2T7nAOesCqKcxRpRVdT6oCGKOkG+HDDoj/DU15gL+mXau4YyhBj
         K/OIsqKIjJLc0vr3A/loyC+NJpgn0iK9AODMBfEBw6lH9azih/aITxHPdOIj/yu4Z031
         ok6qikurl+FM9qf4qrK2ai9XF4ZQ9Hve83RkKE2gokt43vRD5/CigPDxbqBLKYUdNYwP
         Dziw==
Content-Disposition: inline
In-Reply-To: <52148F9C.2080600-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

On Wed, Aug 21, 2013 at 05:59:56PM +0800, Li Zefan wrote:
> Now we can use cs->real{cpus,mems}_allowed as effective masks. It's
> used whenever:
> 
> - we update tasks' cpus_allowed/mems_allowed,
> - we want to retrieve tasks_cs(tsk)'s cpus_allowed/mems_allowed.
> 
> They actually replace effective_{cpu,node}mask_cpuset().

I think it'd be great if this and the previous patch descriptions
explain that the effective masks equal configured sans the offline
cpus / mems except when the result is empty, in which case it takes on
the nearest ancestor whose intersection isn't empty, and that the
result equals the computed masks from
effective_{cpu,node}mask_cpuset().

Thanks.

-- 
tejun
