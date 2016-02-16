From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: provide cgroup_nov1= to disable controllers in
 v1 mounts
Date: Tue, 16 Feb 2016 13:26:41 -0500
Message-ID: <20160216182641.GP3741@mtj.duckdns.org>
References: <1455145195-7553-1-git-send-email-hannes@cmpxchg.org>
 <20160211151707.GY3741@mtj.duckdns.org>
 <20160211183449.GA399@cmpxchg.org>
 <20160212200334.GA3965@htj.duckdns.org>
 <20160216182114.GA30548@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=F+fOL9oPjCsdUM5/lBCzRLYDGNIKXhbtX0eN/YlkVUY=;
        b=Ni9dHzRekC4QhiLKzzss7SSK6UkLrVAnxX4G+r9u4F6vks5brr8zVxz8Mgi486bGiM
         c13aYtZV2xVkD3vmtR0yef2OrFImPRhfPhbB1BfJ067IFHoEDRf8JdCQHsu7eCyKCz6y
         ZHHzIQjuW1vzItoL06JOJ9mpZFfnIzHrVnWi4/lzmm6w9mJtyJsUCHi2kIqP99nG1BB9
         W5KTih+LH2GNMUwsmNLE48pWHnGY5fkgjtihX1NG7BcevgSmdhw2lMN6P0v+1jLx+ysp
         QQon9pwrB2V/FpYdfQPpgUubty8N2WT5qZieJQHtORzBx+FOtr6Bn3cOdD0+jd8mubb5
         7rig==
Content-Disposition: inline
In-Reply-To: <20160216182114.GA30548@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Feb 16, 2016 at 01:21:14PM -0500, Johannes Weiner wrote:
> From 95ae2ca2211e0db4db63d2dd1b187e299d9490fb Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Tue, 16 Feb 2016 13:19:11 -0500
> Subject: [PATCH] cgroup: document cgroup_no_v1=
> 
> Add cgroup_no_v1= to kernel-parameters.txt, and a small blurb to
> cgroup-v2.txt section about transitioning from cgroup to cgroup2.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Applied to cgroup/for-4.6.

Thanks.

-- 
tejun
