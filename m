From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: workqueue usage in vmpressure
Date: Wed, 10 Jul 2013 11:42:54 -0700
Message-ID: <20130710184254.GA16979@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=SkcAChrubZEMJD8y3THfB1CbO6SITBPtYm0Nar+1LUw=;
        b=mrQUYidCjyosKua/Zyhz/kp2ap2Rr2CclByfwB3z4SGMkBYaX2A+pB/zjrZF9V2L6/
         b9HSJMDZF6F96U/cV7PPBGXxvroQy+/j3jC2sIbwLrMe8f4jzE7VmYxLgOLkvzsXxBSw
         xMlGM+BMJJ7fhmu71d0QfJ0QAuILFr97cX6VLjiLOhHxXSNoCBbwaQ9AhZJZm+kR3lCV
         bonwgJjQb3adercc5zpGkNAlJVFwsCc0/FzfjMD/rkcPDGgCSG1x0TGUFp726bXT/l1d
         +wFgk7osKh9jl2a0kzG3P9pN578iiWee0WJXNTXdE6spUh2OoQ/8ALz8G9mIkQoUMJIr
         L7oQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello, guys.

While auditing cgroup_subsys_state() usages, I noticed something weird
in vmpressure.  vmpressure() schedules vmpr->work where vmpr is
embedded in mem_cgroup but I can't find where it's flushed / canceled?
What prevents the memcg going away while the work item is pending or
in flight?

Thanks.

-- 
tejun
