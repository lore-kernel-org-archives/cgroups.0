From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Wed, 3 Apr 2013 14:33:34 -0700
Message-ID: <20130403213334.GE3411@htj.dyndns.org>
References: <1364373399-17397-1-git-send-email-mhocko@suse.cz>
 <20130327145727.GD29052@cmpxchg.org>
 <20130327151104.GK16579@dhcp22.suse.cz>
 <51530E1E.3010100@parallels.com>
 <20130327153220.GL16579@dhcp22.suse.cz>
 <20130327173223.GQ16579@dhcp22.suse.cz>
 <20130328074814.GA3018@dhcp22.suse.cz>
 <20130402082648.GB24345@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=xi4PDUuAi242zLB2u4J8sbxPp+66/4wRvfV+gkF/OTY=;
        b=GzImv8lyvs/UbDCDMFoSsRECce3DZ/hzgCbhf+emGpP4S4KvRZ0mEkcA77mAF85T6P
         bKHQ6rGY0boufdv/FOKoSVQLU9JUGpki70IaVoIto85wETVcYZk8ES2w1AVYGnSML7Ab
         qYh3R1gl1JDLy3dceZVXB7FQLXH1vU/YawrGBqNU9X3mRjiHGqWX/A5LVxQd3+M0MekQ
         mf5rOvJbCcjiGqkZyLMrXQGx4y17/4AfP5p2JAdALhsYmX8VnqgtPrs+LA1dzi0VALHk
         zlWIuHPF6xg7MbF8nh5DijDni60YVCcKzeYc6c5o0vWy3ttfmSEAIDKuWL9gjun3ZY9G
         yaxQ==
Content-Disposition: inline
In-Reply-To: <20130402082648.GB24345-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Apr 02, 2013 at 10:26:48AM +0200, Michal Hocko wrote:
> Tejun,
> could you take this one please?

Aye aye, applied to cgroup/for-3.10.

Thanks.

-- 
tejun
