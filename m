From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup, cpuset: remove cgroup_subsys->post_clone()
Date: Mon, 19 Nov 2012 08:36:51 -0800
Message-ID: <20121119163651.GF15971@htj.dyndns.org>
References: <20121113202714.GA21185@mtj.dyndns.org>
 <20121113202745.GB21185@mtj.dyndns.org>
 <50A9C649.9080602@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lqjrZYunHBdWjZZaRo2PEiweDa5xL03jmcoOeYivLII=;
        b=tDPqYA/clvgQ/ZKrED4NkemFOeKd8IgtZKxThs6cJHCVbzHBc57P5yoUWiJVQM0TxZ
         5voLIa++TQjHyHrb/riTeb7c6howk0qdqv6BQGtIQOuTuN2OApJXTo5NbUf5U6jv4I9b
         gD7Qtagg5K4kw6zgOkguITM4fPQs9sQN9ZDKKUTRAPekIHbVqLr2yag9Shph14v46iAy
         jkQ3MnQnGA+J6AIeMnpEgcn6yFyCZMmCyYAhNvDmkOi42Z6SnlVIYMds3SjGO6S1FK6P
         GxvuYKSZbMkKypljoYyMXOphmKkK1//E127zimOAljQAWvT6ewP6i0xVpSyzsvGm0qB9
         Am/Q==
Content-Disposition: inline
In-Reply-To: <50A9C649.9080602-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Original-patch-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> > Original-patch: <1351686554-22592-2-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> > Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> 
> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Both patches applied to cgroup/for-3.8.  Thanks.

-- 
tejun
