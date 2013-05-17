From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch v3 -mm 1/3] memcg: integrate soft reclaim tighter with
 zone shrinking code
Date: Fri, 17 May 2013 09:57:12 -0700
Message-ID: <20130517165712.GB12632@mtj.dyndns.org>
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz>
 <1368431172-6844-2-git-send-email-mhocko@suse.cz>
 <20130517160247.GA10023@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=pMc5umibOjP47YlbGynaJyF/zcMjgrnuOXz7H60DQtM=;
        b=Bdea1Ox9m8hzm20rMM+ZHx1CFwntgv/enaCWcAm2gb971B/uKHoYldhuY3+InCG/yQ
         pIGZyTKsAXFxki243ZmpO65mxZs5P50OYVswECGOVB7sr9T4CHQKBmf0CNN+NXExKcRc
         eMytZuhHLN84hyMXPRWndygUS2JBRac3PBblsD0HPCD2/68TIfAZmbDsgWg2e/MworNU
         Wo78GRFzJCHbFwI5ymxdPnq1qsB5f+/8uRezAfTE0g0xTvoibUrs0zSKxbyACIluPjqe
         87plmTWFeBZQxtM7gJlI9hTmeWTNTAgZCSqNX4iYbxjVTA5GYyJdEDJ7/KZk9V9bxIBm
         l1nA==
Content-Disposition: inline
In-Reply-To: <20130517160247.GA10023@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>, Glauber Costa <glommer@parallels.com>, Michel Lespinasse <walken@google.com>, Greg Thelen <gthelen@google.com>, Balbir Singh <bsingharora@gmail.com>

Hello, Johannes.

On Fri, May 17, 2013 at 12:02:47PM -0400, Johannes Weiner wrote:
> There are setups with thousands of groups that do not even use soft
> limits.  Having them pointlessly iterate over all of them for every
> couple of pages reclaimed is just not acceptable.

Hmmm... if the iteration is the problem, it shouldn't be difficult to
build list of children which should be iterated.  Would that make it
acceptable?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
