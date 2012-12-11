From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: performance drop after using blkcg
Date: Tue, 11 Dec 2012 07:14:12 -0800
Message-ID: <20121211151412.GG7084@htj.dyndns.org>
References: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
 <20121211142518.GA5580@redhat.com>
 <20121211142742.GE7084@htj.dyndns.org>
 <20121211144336.GB5580@redhat.com>
 <20121211144718.GF7084@htj.dyndns.org>
 <20121211150234.GC5580@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=OQSYU/MVtCC9pLzHs1Jay58kixHLE+NKKowbFy7+4nU=;
        b=pkxdzvJDucPKVCs+9NTmnnocs7LDvRIm78kVQQqX8yB/5LeNbpHadjQd1OPHazqfFb
         YbjTi0W6wqaGKp7zO8M3VJdYFggJq7Y6+mUyuQJehAjETAVW6irY9nwU1aR5fyQDuhI0
         GcNNF7iVRccUzDGiDdWuCEmki/TnGT6xJWlAbq5SxQiGR5DiVLBZg/ZnrqmT3oeWJRGG
         N/qeI3ekN2u+QxH5ZX2BhxULDsHltqbFhdxkB3Ev2xf7Sdtlbfo9tIygFW5H33NpuNOq
         HARGBbssf2ZqpK795RkcHtAdjR3VPK/zxq4dTlKns7EQVFrF/FHDPRI1ePDxJWgVRdy8
         z6RQ==
Content-Disposition: inline
In-Reply-To: <20121211150234.GC5580-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zhao Shuai <zhaoshuai-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello, Vivek.

On Tue, Dec 11, 2012 at 10:02:34AM -0500, Vivek Goyal wrote:
> cfq_group_served() {
>         if (iops_mode(cfqd))
>                 charge = cfqq->slice_dispatch;
> 	cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
> }
> 
> Isn't it effectively IOPS scheduling. One should get IOPS rate in proportion to
> their weight (as long as they can throw enough traffic at device to keep
> it busy). If not, can you please give more details about your proposal.

The problem is that we lose a lot of isolation w/o idling between
queues or groups.  This is because we switch between slices and while
a slice is in progress only ios belongint to that slice can be issued.
ie. higher priority cfqgs / cfqqs, after dispatching the ios they have
ready, lose their slice immmediately.  Lower priority slice takes over
and when hgiher priority ones get ready, they have to wait for the
lower priority one before submitting the new IOs.  In many cases, they
end up not being able to generate IOs any faster than the ones in
lower priority cfqqs/cfqgs.

This is becase we switch slices rather than iops.  We can make cfq
essentially switch iops by implementing very aggressive preemption but
I really don't see much point in that.  cfq is way too heavy and
ill-suited for high speed non-rot devices which are becoming more and
more consistent in terms of iops they can handle.

I think we need something better suited for the maturing non-rot
devices.  They're becoming very different from what cfq was built for
and we really shouldn't be maintaining several rb trees which need
full synchronization for each IO.  We're doing way too much and it
just isn't scalable.

Thanks.

-- 
tejun
