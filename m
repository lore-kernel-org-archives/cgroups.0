From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 05/10] cpuset: don't update tasks' cpumask and nodemask
 in an empty cpuset
Date: Fri, 19 Apr 2013 11:36:18 -0700
Message-ID: <20130419183618.GC13811@mtj.dyndns.org>
References: <517137A7.4020605@huawei.com>
 <51713819.8050708@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=TKF86EBin2msPEce+5Gsmfi0c1DTqhMkgWd+3PbcxbA=;
        b=XQ+YG52v9Fr4krQ5uVVNcNMkXngje39XhZpqEZFQJ47ky1oKSBZPnxuqPi9W4y+zod
         jO1lcYMx2xwuT2cmThLUTHoSGd4TzDu/8dHgNDbb/UBKMOfU17gByoZaHHaG+Xmflngr
         uQ18gm90Xz2x/Cq1agQ/UbmdONf6Py+MEvz3PTOPsZq2Zgw27Tqn1LlZ8yvXhlhFbxFC
         n763LoUM5MUCQ39/9H82VexMLhmgKe/VH7UcZanAwqfGUtXVRvI+/EHdOaq0yHWy/P6d
         RIAWhwhxl1veSXIG6WtrxyawShWWEydCwM7GL9GWrGNoXsulTqOVvB2+71K7sJs8XdVF
         I6pQ==
Content-Disposition: inline
In-Reply-To: <51713819.8050708-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Hello, Li.

On Fri, Apr 19, 2013 at 08:27:05PM +0800, Li Zefan wrote:
> I think this was introduced unintentionally when cpuset hotplug was
> made asynchronous. Fortunately it does no harm, as updating tasks'
> cpumask will just return failure and there's a guarantee_online_mems()
> when updating nodemask, and then the tasks will be moved to an ancestor
> cpuset.

Yeah, which will update the masks to the proper values anyway, so it
was intentionally written that way as it didn't really matter either
way.  I suppose this helps future changes?  Maybe update the
description a bit?

Thanks.

-- 
tejun
