From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 2/2] decrement static keys on real destroy time
Date: Thu, 17 May 2012 08:19:47 -0700
Message-ID: <20120517151947.GI21275@google.com>
References: <1336767077-25351-1-git-send-email-glommer@parallels.com>
 <1336767077-25351-3-git-send-email-glommer@parallels.com>
 <20120516140637.17741df6.akpm@linux-foundation.org>
 <4FB46B4C.3000307@parallels.com>
 <20120516223715.5d1b4385.akpm@linux-foundation.org>
 <4FB4CA4D.50608@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VpxeSh5Sog8MOVaa0E6Hj8mUA/BItUiXDmUI/OkYYJg=;
        b=T5r6v1w99UevrNNs7IYhLe/Hd3k2CbVfQxd6xdONk/U5Unl5ySryLcCy3x+1a9/o/H
         DGXCKYcEsySExMeEp+48AZF4UJKsJmbIiMVGguAbmDQZ9qt5QzIahbJk33+6c8VXO9iu
         zNmarlBM9OWgMEu8y72YwfJLuHkQNrs8AY8iK0tjs248hPcEcpDC+/j0zpinKkNVSZ7F
         u37K991NfZZ3POv1oHYPgjDU3PcrwRQeEpQhoXMx+jQazoQ3pOoeA26aL21T1P8HnwMl
         J7IIgFxXTiBkCuRR6L/imLme4J6XK2qag+pZzJbuLXJ09oLiywdSzMFvh953REM8ytAe
         eNPA==
Content-Disposition: inline
In-Reply-To: <4FB4CA4D.50608@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, netdev@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>

On Thu, May 17, 2012 at 01:52:13PM +0400, Glauber Costa wrote:
> Andrew is right. It seems we will need that mutex after all. Just
> this is not a race, and neither something that should belong in the
> static_branch interface.

Yeah, with a completely different comment.  It just needs to wrap
->activated alteration and static key inc/dec, right?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
