From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 07/11] blkcg: make request_queue bypassing on allocation
Date: Fri, 13 Apr 2012 13:47:10 -0700
Message-ID: <20120413204710.GF12233@google.com>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
 <1334347895-6268-8-git-send-email-tj@kernel.org>
 <20120413203205.GI26383@redhat.com>
 <20120413203726.GE12233@google.com>
 <20120413204446.GK26383@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zO7zbjoXFOZbAOqMM9mNhnZCW1pWtnT/8mYd3+3U/zg=;
        b=ChTDAFtMhJkntiSphUzv513CAhOSMJeFeVUXtbEe6lR6T7Gd2Lj/TAGtFIbASLFdMh
         Aax6JRbWtJkJU1S3z0w3OQbwsU3BJ8gIj01+xwyxqdNP8FD0Ok4b/6zEyvWnZY0+btUl
         8VXWPEMuNpUo7gwgcP31R9WJcB/81bWP2jXuTvk9otfoBV3/Rv+8my2ASP5d/nfliayi
         UNa8Hj8QxPfjrXJiRzrMSOz5moz7X0DBNHMfLVRMiO95QjgNJtVQPjvfusDmfqA5vZb8
         pXhqeQSMpxBcuTNxOICqUaKo1kf6zdHY5Knn9qtPAJjyIB1s8+lawOR/WPcOpJ5PuVKP
         /x6Q==
Content-Disposition: inline
In-Reply-To: <20120413204446.GK26383-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Fri, Apr 13, 2012 at 04:44:46PM -0400, Vivek Goyal wrote:
> On Fri, Apr 13, 2012 at 01:37:26PM -0700, Tejun Heo wrote:
> 
> [..]
> > blk_cleanup_queue() doesn't use blk_queue_bypass_start() to enter
> > bypass mode.
> 
> Oh now elevator_exit() has been moved into blk_release_queue(). But
> problem will still be there, isn't it? During driver init, most likely driver
> is holding last reference of the queue and blk_release_queue() will be called
> in the context of blk_cleanup_queue() causing the overhead?

Hmmm?  blk_cleanup_queue() will put the queue into bypassing mode
without going through synchronize_rcu() and all the following
bypassing operations just inc/decs bypass_depth without any draining
operation.

Thanks.

-- 
tejun
