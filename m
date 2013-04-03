From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroups: Documentation/cgroup/cgroup.txt - a trivial fix.
Date: Wed, 3 Apr 2013 14:03:53 -0700
Message-ID: <20130403210353.GA3411@htj.dyndns.org>
References: <1365010324-3900-1-git-send-email-ramirose@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=tQc/CT3MCckVNaHOOlAGNrLfOLLQ1ALY8QmEtDvIlSM=;
        b=it41uln/d4RtrGex6LB1J0etxQWgFHRf4hheKHV6qzcj1XRra4LLIX1w1eDQTM6TWt
         ie0LqV9GyPD3Fflt/HwkhdppAGPn+7XaUkJaZ/tLBdgvduV2aQ7Xxy8RjwP9rB3Jo+ZM
         lek6B7soq6/Y4ub1Ip5P17Duhxd89Doy27UU8JF8o9fUB4P5qDKm7+T1BLxpvyqjQiij
         pX4vPzY+FvkuP7mWIaJAPMMDg9CE428B244FWE5yPwolu/N0og+3FvJ+usUe3sLoyhOJ
         zqZ/N0/0EIh1OhxGWVH7YYx/Yx7Ca54QFsnD8owidKyxN/h41SNAfajpLCLy4W+ki8Os
         mjJQ==
Content-Disposition: inline
In-Reply-To: <1365010324-3900-1-git-send-email-ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Apr 03, 2013 at 08:32:04PM +0300, Rami Rosen wrote:
> This trivial patch removes a word which appears twice in 
> Documentation/cgroup/cgroup.txt.
> 
> Signed-off-by: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-3.10.  Thanks.

-- 
tejun
