From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2] cgroup: Introduce cgroup_detach_task().
Date: Mon, 25 Aug 2014 10:12:20 -0400
Message-ID: <20140825141220.GA31066@mtj.dyndns.org>
References: <1408966330-2374-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ghHvkT5voGgr00hpTv8KtM4jVmg8KRcEk251GAVXF+o=;
        b=odnbJiU56IXdqHR6CR+DTuhOyrJ3x053C6Pg1beje+8nJvBSIFrm+H8XYt1a8wDMwF
         4KOQ76HtugDXcdPUQJx6yFPiMaPaZk0jdfh5hRCwW8p/b3odZuB4GYZTqj7OE64LNR8g
         bsLxCWdp+W/3AO/EWgU5J8y8Ihe0Q4zMit80t+88CeGlEOsZ52IYitb+8+vzyVTbAeB2
         hc9t2a3/6yl82p7alwUGLLv6yFnBFWCEle6yWtNzqx657sDtBhFPuz4CfyjxBLQ0He6u
         QjMjddqZO+WnHLy36quxJtUI+aX5p9NqXEiNXhHxZntmGIPAccfoKb1vUIfKUhPZz372
         f4qA==
Content-Disposition: inline
In-Reply-To: <1408966330-2374-1-git-send-email-yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 25, 2014 at 07:32:10PM +0800, Dongsheng Yang wrote:
> Currently, the only method to detach a task from a cgroup is moving
> it to others. It looks not natrual to me.

Ummm... how is this different from moving it to the root cgroup?
"just because" usually isn't a good enough rationale.

Thanks.

-- 
tejun
