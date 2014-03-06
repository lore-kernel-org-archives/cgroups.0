From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch 00/11] userspace out of memory handling
Date: Thu, 6 Mar 2014 15:59:11 -0500
Message-ID: <20140306205911.GG14033@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <20140306204923.GF14033@htj.dyndns.org>
 <alpine.DEB.2.02.1403061254240.25499@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vkle3gcXESL3QlEvnfUZL35/pNjwuXGutzLeKB7mW9k=;
        b=fPAPmaYrkFlqD/lZGNwLHEYYoZtE0HeSalgnUTYzeec8s9oxQd0/l7jrSKUbiV2kts
         x1r5B5sWqioGBdzZP8ltq6MKqA4GdR6WwtYZK9oiJrHV7GD3UpKr2RFMliUM7ABeJl+T
         WVNMkTyKcOENjbRdru40QWk7Jheskku0RVJC/JgeI5kUErLxy2UB6DT0ENa9WHAfwQct
         WFbQsgK+yeqBV4Ppmg+SamXWqElTyovHFsFLyGFi3Yxd7KdEe3eA3PNfogRj86X/aLfN
         blK3nXkov0p+B9iIm2ntvjVD7JnEUCxrgTyfNZHne8RzZmCvgh1imjlFA6jp99K+nak9
         hW4w==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403061254240.25499-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jianguo Wu <wujianguo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 06, 2014 at 12:55:43PM -0800, David Rientjes wrote:
> > ISTR the conclusion last time was nack on the whole approach.  What
> > changed between then and now?  I can't detect any fundamental changes
> > from the description.
> > 
> 
> This includes system oom handling alongside memcg oom handling.  If you 
> have specific objections, please let us know, thanks!

Umm, that wasn't the bulk of objection, was it?  We were discussion
the whole premise of userland oom handling and the conclusion, at
best, was that you couldn't show that it was actually necessary and
most other people disliked the idea.  Just changing a part of it and
resubmitting doesn't really change the whole situation.  If you want
to continue the discussion on the basic approach, please do continue
that on the original thread so that we don't lose the context.  I'm
gonna nack the respective patches so that they don't get picked up by
accident for now.

Thanks.

-- 
tejun
