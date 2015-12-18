From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: clean up the kernel configuration menu
 nomenclature
Date: Fri, 18 Dec 2015 12:39:23 -0500
Message-ID: <20151218173923.GK4026@mtj.duckdns.org>
References: <1450390797-4748-1-git-send-email-hannes@cmpxchg.org>
 <1450390797-4748-2-git-send-email-hannes@cmpxchg.org>
 <56736E07.4000300@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ozxPQUwGe0D0f/hrfzFKcGizdKflZ/DVhTMSCz6oBfE=;
        b=s7uMFk9LaWnax7T8aiQeBg3bQN6nsKV45d34pKFfneb/pLRVOGtmcR9S9nVaOs2o8p
         prC+Qj9IZ6ewcTbW242b8TzSb4Pr+WOcWr+TBvjVnZdhSXNhdmfCxm+CdPktT/4exVRC
         Fo6LFBo3B5ooAiunCrcXys4XEqM5UIKb8vaXonfC5QUSut+mIhRAHVBm9MHrm8D2LAjF
         q0pXTe3wMjXENZxsvRhNNe2VYpp5uCSnpWy3tXiP3rUulu/xrHemeQgcITPzfAzqxZcj
         4H3x52bf53wfgcysWiPBVo3dqT5xQPRCeV+QDbREiseX4lN8z4utNwlyL2LFKcvv4r7S
         5iUA==
Content-Disposition: inline
In-Reply-To: <56736E07.4000300-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Dec 18, 2015 at 10:23:03AM +0800, Zefan Li wrote:
> >  config CGROUP_DEBUG
> >-	bool "Example debug cgroup subsystem"
> >+	bool "Example controller"
> 
> But not all cgroup subsystems are controllers, which are debug, perf and
> cpuacct. I'm fine the other changes.

I think it's fine to call all of them controllers.  Let's use that as
the external facing noun to call all cgroup subsystems.  It is a lot
more specific and better describes the main purpose.

Thanks.

-- 
tejun
