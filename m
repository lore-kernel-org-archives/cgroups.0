From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: Allow cpuset controller in default hierarchy
Date: Thu, 24 Aug 2017 08:02:22 -0700
Message-ID: <20170824150222.GQ491396@devbig577.frc2.facebook.com>
References: <1503585611-13496-1-git-send-email-longman@redhat.com>
 <20170824144322.GP491396@devbig577.frc2.facebook.com>
 <863b01d0-e724-dab6-258e-d5980f985938@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xSMRzXPlNvI+XBLYbZT9pZIt/lrURvvxQ/kI75gbZMA=;
        b=XkRauj+PbsxegS8yJzsVBrPulLfSvfAlQqpCQdB+LU4sN13ozmOWYWscf9BLCFV51K
         I0MnMqsz0ezbyzT6NHpt+E2idCvYwVZ396lZWTrnpbJ/hlrf/nSE9sor8S9DTIxkhMRV
         0jwEV5R1R0Mlkc/Ra7wKKI2b5f3ECNNPvf826bdcpq0RWxpfIwukwVP30xUCmWKfuINK
         G5uDQwHq+R/4NYo3CRYJWyAKdHW8viBc1IkCv4pqcfOrstPzEIe8hiYWR0Wh94yD4XIi
         XalGQwj7yrX1qD7Ezq/WMW4DQOyat2x7i9m1UTZJit85FjMrvJe+DimYsieTE+iuUF3X
         frpw==
Content-Disposition: inline
In-Reply-To: <863b01d0-e724-dab6-258e-d5980f985938-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Aug 24, 2017 at 10:56:21AM -0400, Waiman Long wrote:
> The main reason for sending out this patch is to figure out what exactly
> is in your mind before enabling cpuset in v2.
> 
> From my point of view, the exclusive setting makes cpuset behave more
> like a resource domain that a resource allocated to one cgroup won't be
> available for another cgroup. So we can argue it both ways whether it
> violates the basic hierarchy rules or not.

It's not even siblings interfering with other siblings.  The resource
knobs belong to the parent, right?  So, the only thing it's doing is
restricting the parent itself from creating certain configurations,
which can be argued to be a feature but it's a really weird policy
enforcement implemented in kernel.

> I will be in the Plumbers Conference next month and we can talk more
> about this. My goal is to make cgroup v2 ready for prime time hopefully
> by the end of the year.

Sure, the only thing I think we need for cpuset is cutting down the
interface to the minimal set which provides all the features to
userspace.

Thanks.

-- 
tejun
