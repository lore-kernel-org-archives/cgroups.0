From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 04/10] cpuset: remove cpuset_test_cpumask()
Date: Fri, 19 Apr 2013 11:27:10 -0700
Message-ID: <20130419182710.GB13811@mtj.dyndns.org>
References: <517137A7.4020605@huawei.com>
 <517137E7.20505@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=rDGA1wvFlgK8XP+vHgH9n2mmjyLj1CbHtPzQBQqrnxw=;
        b=pOhNXCeZYXwxk4upxt+O/OHykmasBsVClMGqRZoz7MgWbqYqV2zT33DgJspq/E3a2y
         v011Rs83TRhIZ1k7gZwX3oMPipIxas8HdRflfZDrWXrAqQ7qVmchgtlXEpEuipd6EuV0
         7f2SNzEC7m+RnQfPo5r24WY9aW6K/3nrlpX0NyB86cZAGmHlzVYi1uXe56XyuK84kYvT
         cEmdBFzgBI0e5Yk3d/wFB6Mwr650KPL6q2WprqXvUZNYY7R6i0LUDdCvI8HVI8oaVrve
         rXdyBT40rxxBx18W2auRQOdElyyFEfwO+9hDYPOvkvDPg8mD+5BLlj89w7cx+MgaqJYB
         JIWw==
Content-Disposition: inline
In-Reply-To: <517137E7.20505-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Fri, Apr 19, 2013 at 08:26:15PM +0800, Li Zefan wrote:
> The test is done in set_cpus_allowed_ptr(), so it's redundant.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

For 0001-0004,

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

I'll apply these into for-3.11 once v3.10-rc1 drops.

Thanks.

-- 
tejun
