From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] blk-throttle: fix race between blkcg_bio_issue_check
 and cgroup_rmdir
Date: Mon, 12 Feb 2018 09:11:43 -0800
Message-ID: <20180212171143.GY695913@devbig577.frc2.facebook.com>
References: <6f136c90-faa9-4bc0-b02f-3a112b4d8360@linux.alibaba.com>
 <20180207213811.GF695913@devbig577.frc2.facebook.com>
 <b590caed-1423-4776-966d-cd9e346a8ea1@linux.alibaba.com>
 <20180208152307.GL695913@devbig577.frc2.facebook.com>
 <aac95b90-786d-95bf-b93d-87ecca79f846@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UMGQgKqt2hwyp3UZtA68X9YZoUDF22nyNyDW0UGg9XY=;
        b=NyWL47L+XziC6gIyok9yYe1VCPN1t2WvYwOQ1+/Q2Dz+stP6Fkoxe3Ho9XEpaGC+TF
         bzXKRLVJ1Z8FPPfFXgy7NUqjNTVUyVdjxNFB2Ty3PlVDrtwXMzM/nmL+yibcuXEz9amz
         1s4ctG3LesVHgNKU+rbmqWnsW+AztBiJtF1Dc1BmBQxchZuVD0nV5h+iuGV8fPyKpW35
         JCnjlfQGDIZ59M5OwdLw1ZxkO336S8l503QxpK8r3Unzdm6U6SkSfWmeYCYequIGgZMV
         uM18Zb+B923PHIXkuHAqwL9EIrhk5mMW0w3J08FXOI7Qgtfb8hcXjDOdQvoqgu5EiWiq
         yfmA==
Content-Disposition: inline
In-Reply-To: <aac95b90-786d-95bf-b93d-87ecca79f846-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, xuejiufei <jiufei.xue-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Caspar Zhang <caspar-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Joseph.

On Fri, Feb 09, 2018 at 10:15:19AM +0800, Joseph Qi wrote:
> IIUC, we have to identify it is in blkcg_css_offline now which will
> blkg_put. Since percpu_ref_kill_and_confirm in kill_css will set flag
> __PERCPU_REF_DEAD, so we can use this to avoid the race. IOW, if
> __PERCPU_REF_DEAD is set now, we know blkcg css is in offline and
> continue access blkg may risk double free. Thus we choose to skip these
> ios.
> I don't get how css_tryget works since it doesn't care the flag
> __PERCPU_REF_DEAD. Also css_tryget can't prevent blkcg_css from
> offlining since the race happens blkcg_css_offline is in progress.
> Am I missing something here?

Once marked dead, the ref is in atomic mode and css_tryget() would hit
the atomic counter.  Here, we don't care about the offlining and
draining.  A draining memcg can still have a lot of memory to be
written back attached to it and we don't want punt all of them to the
root cgroup.

Thanks.

-- 
tejun
