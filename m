From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/24] cfq-iosched: add leaf_weight
Date: Tue, 8 Jan 2013 09:24:47 -0800
Message-ID: <20130108172447.GY3926@htj.dyndns.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-12-git-send-email-tj@kernel.org>
 <20130108153448.GB29635@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=wSxUnKKMHgz2kM7aYZ5RMzyMaCg5zMC7ezlG8FNRp6U=;
        b=hI6iQZd1mI5PUPAro1YEfbMGftkx81tISo7xx7GZSTNem0O/G6YBEyetaSmr0VRSjy
         DpfogbjIVSJ7i3I4rWSo6Z+ffdJPVcdPOOCwVtAUniBwLCsKEr5jFoNgRjTLHiYWdh/1
         humIrOUSWImSh19t6s3koV+/QcGT9YIVlhaG4PljkAqfHStiuImqstKW1kSW1GaWKl/O
         EPycSUvaeWjcMEJys0zShYKBAAyyNnhimN1vLD84AlNvCqMKA6i4R7xpK+YWoScqJaft
         rJFnPLLgHjAA2r4+hT3fdcQo//2haIYoFVaKFg5NWzKJWqEIb6CMiqlEUfjDO7mKrD8/
         E6uw==
Content-Disposition: inline
In-Reply-To: <20130108153448.GB29635-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hello, Vivek.

On Tue, Jan 08, 2013 at 10:34:48AM -0500, Vivek Goyal wrote:
> How does it help to map leaf weight to weight in root group. Old programs
> anyway don't know about leaf_weight. So nobody is going to update it. And
> if they update it, they better know what does it do.

Because what cfq does before this patchset in flat hierarchy is
basically treating root weight as the leaf weight.

       R:500
      /     \
     A:250  B:750

Ratio of R is computed as 500 / (500 + 250 + 750).  The root blkcg's
tasks are competinig with the children blkcgs.  This is currently the
only supported config and we don't want to break existing users, so
keeping root's weight and leaf_weight synchronized and ignoring root's
weight, which BTW can't mean anything anyway as it doesn't have a
parent or siblings, keeps the behavior unchanged for flat configs.

Thanks.

-- 
tejun
