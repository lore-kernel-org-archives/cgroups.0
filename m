From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] cgroup: put controller Kconfig options in meaningful
 order
Date: Fri, 18 Dec 2015 12:45:08 -0500
Message-ID: <20151218174508.GL4026@mtj.duckdns.org>
References: <1450390797-4748-1-git-send-email-hannes@cmpxchg.org>
 <1450390797-4748-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=JP3BG1RY4SkW2EgsYtvE7NibL7b72eeoMDJ1aBfTGCs=;
        b=Z/oKsbqTj5Bkmdigbzv1WCAJSTOacEWiEppLkUVXudcF7a6s0wpNSKquZtYvi91fav
         NAHsOSxyXVSWHEwzOcx2V1p92h9iZV+1SpsvqdWZoXD356tfd0hYV/nOsVutZT9T5WEJ
         5xaCIXAkioSpEAo92FealNjbDJJxGlX+OVtHM3K9UNIR9JQz7gr+1Eh4I58e1jXXvHio
         pE7pYn+7q7X0gNjSgXQ2iBwrVkYyrm61lDlUA3jvPQUhEhmZRtW+VW2XUkd3+6GTeuQV
         g/8+m+aJhNuAP3ZXW/0crI47OWPqcicY8qUamUOH/Cr+SQYHARsWmVHOuW0hKljYj243
         XEZg==
Content-Disposition: inline
In-Reply-To: <1450390797-4748-3-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Dec 17, 2015 at 05:19:57PM -0500, Johannes Weiner wrote:
> To make it easier to quickly find what's needed list the basic
> resource controllers of cgroup2 first - io, memory, cpu - while
> pushing the more exotic and/or legacy controllers to the bottom.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Applied 1-2 to cgroup/for-4.5 w/ Li's suggestion applied.

Thanks.

-- 
tejun
