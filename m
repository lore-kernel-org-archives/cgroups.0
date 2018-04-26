From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-4.17 2/2] Subject: cgroup: Limit event
 generation frequency
Date: Thu, 26 Apr 2018 14:35:14 -0700
Message-ID: <20180426213514.GV1911913@devbig577.frc2.facebook.com>
References: <20180323194722.GE2149215@devbig577.frc2.facebook.com>
 <20180323194753.GF2149215@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g8dlQPSge40aMnv1pBkb8vhGJ6VgWEqkvQOVl6HmBW4=;
        b=NNFUeU8KxiQ2dOrtl38DUSuR/YHLXImGKfc5+2m+VeNoEImYUJTgBKNf1ZYD0oZ8mW
         2yX/HgjxbBs0/wGLGj6wn04y0xIMTXSezGY4wRrntC1DoukNW3I9DqprIEiRmJKXl2qv
         gpoeOnZLAA6L90IxnuAgmm5Eql7RPK3Q1rcLTJ1SgUPW83O4MOaACcl5RTKlxvk5R1S1
         nMLT0dCx+dVUMflMkw6o6Wyb38cXW/cL4YjR/YypDQEd7dgvwk48fLCPlQtguJxRfNjD
         +JYAui5a30eBQJQ6QtLxZvKNX9AHbsuLkSNVufYl83GELdxxu6vtQPgB835tkUxWvadB
         0xTA==
Content-Disposition: inline
In-Reply-To: <20180323194753.GF2149215@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org

On Fri, Mar 23, 2018 at 12:47:53PM -0700, Tejun Heo wrote:
> ".events" files generate file modified event to notify userland of
> possible new events.  Some of the events can be quite bursty
> (e.g. memory high event) and generating notification each time is
> costly and pointless.
> 
> This patch implements a event rate limit mechanism.  If a new
> notification is requested before 10ms has passed since the previous
> notification, the new notification is delayed till then.
> 
> As this only delays from the second notification on in a given close
> cluster of notifications, userland reactions to notifications
> shouldn't be delayed at all in most cases while avoiding notification
> storms.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Applied 1-2 to cgroup/for-4.18.

Thanks.

-- 
tejun
