From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup, sched: restructure threadgroup locking and
 replace it with a percpu_rwsem
Date: Tue, 26 May 2015 20:34:07 -0400
Message-ID: <20150527003407.GM7099@htj.duckdns.org>
References: <1431549318-16756-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=l5DtLZSRqpYsGebRQsRbvt6K04fuxVySt/RHXWUs8Fw=;
        b=G+TpKzXFPzhiCIDEvtoFzq7QSzoe4H5l1QcMWlTtIT34Ft7rdwqThpf129AplhlQeL
         8mvDMz46vZn2y7cq5SRBYAGiPJIRQqqKZYc2lRZeVZrp+pZLwkZk1GnATpNm9pJAj729
         q7UIYsQrrIK9vh2wc0fuLc+Tkx9+j7vXwreOn3ShmB76pOFFhSP2F0klbINp1kgao3Fa
         sPvxuyx6wa3qCYgH68yfliyEg0xILTB0lAOgD8ZM3ETTbv8GHq0zLIX8+x/Q67ABe9Sq
         LdJAdS0aFMtq77aflMDyXjKKQztMFIy8dPLkZzpM0RCpAMikwFuDRTFNwsB975aF4w2Q
         XCAA==
Content-Disposition: inline
In-Reply-To: <1431549318-16756-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 13, 2015 at 04:35:15PM -0400, Tejun Heo wrote:
> threadgroup locking was added because cgroup needs threadgroups to
> stay stable across attach operations.  It was implemented as a
> per-signal_struct generic locking mechanism so that other users which
> require threadgroups stable across blocking operations can use it too;
> however, it hasn't grown any other use cases and still conditionalized
> on CONFIG_CGROUPS.

Applying to cgroups/for-4.2.

Thanks.

-- 
tejun
