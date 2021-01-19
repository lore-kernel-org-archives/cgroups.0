From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/2] cgroup: update PSI file description in docs
Date: Tue, 19 Jan 2021 12:03:55 -0500
Message-ID: <YAcQ+/z0WkW61gL3@mtj.duckdns.org>
References: <20210116173634.1615875-1-odin@uged.al>
 <20210116173634.1615875-3-odin@uged.al>
 <YAcPMlxXVSuKgbvn@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hC/zpZbVc37tYw12xQlWmizImGmh0tgMQSzuFSnLUZU=;
        b=dNZ5VRxuAFPEt1xf96G3Ir7Dr2NVc6IpAUFuXbxqAJlgEzpm7dLaw4tl4xVf5ikq6o
         odlMxzqpBZ12BrXpEnIeub3bjQDSNuJGP5PACusqEryq+7xJzbH/nmLde+UGBIbaswaV
         xz6PYJfhtnsCHGCpWD6Pu4BFSJbVgpDYf742FotXAPTu/TQDyIyNo/2tX26sWhrs/R8s
         tsUayWWg2VW9XF0QOqrpqERWt2zK/YPCDJLhSpfmMK+pZq1HmXKfM3K/FOIld/68t06O
         I54pLIIoarsZZoeqOQnoY4BG9Ma+IdzUIRm9/h2f0iaAoYgsNmDzvGYI70EOxKRercif
         fgAw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YAcPMlxXVSuKgbvn@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Odin Ugedal <odin@uged.al>, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, dschatzberg@fb.com, surenb@google.com

On Tue, Jan 19, 2021 at 11:56:18AM -0500, Johannes Weiner wrote:
> On Sat, Jan 16, 2021 at 06:36:34PM +0100, Odin Ugedal wrote:
> > Update PSI file description in cgroup-v2 docs to reflect the current
> > implementation.
> > 
> > Signed-off-by: Odin Ugedal <odin@uged.al>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 63521cd36ce5..f638c9d3d9f2 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1029,7 +1029,7 @@ All time durations are in microseconds.
> >  	one number is written, $MAX is updated.
> >  
> >    cpu.pressure
> > -	A read-only nested-key file which exists on non-root cgroups.
> > +	A read-only nested-keyed file.
> 
> Could you please also change the 'read-only' to 'read-write'?
> 
> With that, please feel free to add:
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Applied w/ the suggested change.

Thanks.

-- 
tejun
