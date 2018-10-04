From: Tejun Heo <tj@kernel.org>
Subject: Re: Cgroup v2 bug: "domain invalid" node can't be converted to
 "threaded"
Date: Thu, 4 Oct 2018 13:29:47 -0700
Message-ID: <20181004202947.GL270328@devbig004.ftw2.facebook.com>
References: <CAKgNAkhHYCMn74TCNiMJ=ccLd7DcmXSbvw3CbZ1YREeG7iJM5g@mail.gmail.com>
 <20181002210741.GJ270328@devbig004.ftw2.facebook.com>
 <0cf4f9de-70d2-cf94-12d2-283759638e20@gmail.com>
 <20181004182017.GK270328@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YiK7lyO7b2aJXcB42eMi3FeR2xojGMX2RNKuvQuI354=;
        b=uaq2eOkFmUbNpetu1c60s5D+IqUxSSfO9pQxGrIUu7FY/ndIBVnRJNO8AUPjYhbWNh
         z+NtbTHPpUZdFauZoJ2a472aQ+407/2g+OFqcTQ3EcYu9uSJ2ewtoTWJzr+z1CbiBUq7
         EnO32/7sM2CdYIK3FnxrWlIxtQ5ytpPFFDs6Abt9ctobGJmPrsMIhu5hnXHMOZYu/xC4
         t9M/iyeTYH/Ok7uO7TsxkyVT9AQh5dSa8FaZFGMInPm062lOBTSlUeOfuQvlDTgORX+z
         7HPMr3x6kQGTnU78bnG2+2yeWAne7kNQVWFH2Q8eXw/wL38KeqmBOewcUpu5CUdOlUBq
         J8dw==
Content-Disposition: inline
In-Reply-To: <20181004182017.GK270328@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Amin Jamali <ajamali@pivotal.io>, Joao De Almeida Pereira <jpereira@pivotal.io>

On Thu, Oct 04, 2018 at 11:20:17AM -0700, Tejun Heo wrote:
> Subject: cgroup: Fix dom_cgrp propagation when enabling threaded mode
> 
> A cgroup which is already a threaded domain may be converted into a
> threaded cgroup if the prerequisite conditions are met.  When this
> happens, all threaded descendant should also have their ->dom_cgrp
> updated to the new threaded domain cgroup.  Unfortunately, this
> propagation was missing leading to the following failure.

Applied to cgroup/for-4.19-fixes w/ reported-bys added.

Thanks.

-- 
tejun
