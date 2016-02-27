From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: fix written mistake in warning message
Date: Sat, 27 Feb 2016 06:38:03 -0500
Message-ID: <20160227113803.GY3965@htj.duckdns.org>
References: <1456463258-6617-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SHjgy2WhCu+dgTvu+qLlxAZaovh4USHp/JFoZnjfHT8=;
        b=a8xkultXOB2l7+LhJeqP/V1SwfXbqYiMYTeuZgn94/nqnkIOKOlpLXV6BqKcaZ9foO
         nwBV04lPNS/BQjUEpySmPO7mzNeUVSBS/Dn5p99ePbNWIWM+1WZBcvOr2MN0w75JODWs
         Y+EkTNDDCIHgvIXLtm00Oc7XuZe8eIDr8CuJ+9bM2Y/aZdBkoI2XdNYyDFaRlu6dX6VM
         cvmCcqJq9zMyh4RDSXLiEjusc6gvz+KmTBNi/SChfAHMfcH2d/wM9CjNhqCTfL2hKUvf
         W/3l3+MKg9HZP0Lt+BaLLnxKXWusv6rB5v7sRIy35xkpAsVwV7Jmab2dFWRQ+AOvwmGg
         n67A==
Content-Disposition: inline
In-Reply-To: <1456463258-6617-1-git-send-email-lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Feb 26, 2016 at 01:07:38PM +0800, Xiubo Li wrote:
> There is written mistake about the print format name:id <--> %d:%s,
> which the name is 'char *' type and id is 'int' type. Change "name:id"
> to "id:name" instead to be consistent with "cgroup_subsys %d:%s".
> 
> Signed-off-by: Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>

Applied to cgroup/for-4.6.

Thanks.

-- 
tejun
