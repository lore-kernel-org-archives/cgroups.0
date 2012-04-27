From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 8/9 v2] cgroup: avoid creating new cgroup under a
 cgroup being destroyed
Date: Fri, 27 Apr 2012 13:41:27 -0700
Message-ID: <20120427204127.GO26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
 <4F9A36DE.30301@jp.fujitsu.com>
 <20120427204035.GN26595@google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2YOZJJJhrO9ZFKkriNp3+o5xjX0+mhhKdZ3FOFrHhw4=;
        b=YIYnu4LsZmO03WALFKLXYfG1hZqmTK0fIDCwijBt93TPQb0Bqs9hdRp2ENOuxHrsp2
         dDPrjxdnmdSKr9iynaQbwUai7dM1RHtwiWwYyV3Anz2asfD6cai79/eMq5eNXnoK8Mhy
         rWcyrhjDHPemJV0RvoOHfKn8Ub5XzcT8lBrCWS2MTwycO2dquBZrT3gbRUTmTFDl+2a1
         CPWvffrp4SOSbBV5kEDrS8eF2AGFZbQUIDZUlUbuwQANJcZ2kid9+DdH8PG/jErzM2oC
         5GBCYLjPEiSaaUCSL1YLxhezyN07BX94V7lEd+BLMYFnWiDCfONX+VcWB89YrdRI8AZ5
         XVHQ==
Content-Disposition: inline
In-Reply-To: <20120427204035.GN26595@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Frederic Weisbecker <fweisbec@gmail.com>, Glauber Costa <glommer@parallels.com>, Han Ying <yinghan@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com

On Fri, Apr 27, 2012 at 01:40:35PM -0700, Tejun Heo wrote:
> stands.  The only change necessary is memcg's pre_destroy() not
> returning zero.

Umm.. that should have been "always returning zero". :)

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
