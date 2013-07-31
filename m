From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/7] cgroup: remove sparse tags from offline_css()
Date: Wed, 31 Jul 2013 06:42:12 -0400
Message-ID: <20130731104212.GG2810@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C7E8.1080909@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ZZTEjko+SFYmyJ7lFX9Yzr3i3zeJAS0s3LaBnNMQf1s=;
        b=ncQ5AqaFUaeIJqpRmZuzkJnu19AOqigZs5tiB+KUAKrWu/NAi+wL95kXGW4O7qaf+D
         45d/D4Bn+G0LhFES4dSe9MuKMixeATNJJaM6gpCQVJLYVGOy0yAEb/dnuv9lCSVnyos3
         KhAGxVFUu2NzKr5X5aZMFTQkN2rI2T/hZM4TWwiiJK9AH6d+B2WrKpDiqauHwIi+GV9l
         u01YZYlwgw6JId9+ZQ2AWD1VY6EnZey7nQMUutkz5+mTl24uBf0kIpz+VE3c3xqZl/FN
         DemYi/vhHr69VE6LUzjZ8UKhJ4CyN78DHFE11mgCgXA1IyQaN5IFLeXypq5REEbyNSVn
         eYhg==
Content-Disposition: inline
In-Reply-To: <51F8C7E8.1080909-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 31, 2013 at 04:16:40PM +0800, Li Zefan wrote:
> This should have been removed in commit d7eeac1913ff
> ("cgroup: hold cgroup_mutex before calling css_offline").
> 
> While at it, update the comments.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
