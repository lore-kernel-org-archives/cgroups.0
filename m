From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 05/15] blkcg: update blkg_lookup_create to do locking
Date: Fri, 31 Aug 2018 16:09:02 -0700
Message-ID: <20180831230902.GC1488037@devbig004.ftw2.facebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-6-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rfQ7fOszyBR4X33vZU2tgI2PHUvxIMFVG3y/OfXq9MQ=;
        b=FNNggnb5yomOQ0mqu9hb0yDwun8qu2kojMi+naMHGeksWzHBrFOMPNmSC6cXiXLbP9
         uKo0FUNisfOWa1qeH1xmuaT06fZdHgeWtlt2LwMr0P/mRlDFRFb0y6DuUYeJmOgPa0Bt
         UhSkwUU+5xEsrDFz+yAyASKEtXVgj4R5o1OK9h+yc/Ph7PpbT5E0SfknkmSCFQkZpcHB
         3vLllZtIntYjPI8NpaF3cqxkcaJWbXUGOFo5lbIVvahMvfDoHmFbiiNzNm7acRcKHIHE
         6FU5g+7xkea1cCD9YpahXhnjHaG1DOUE2vE0lJSI0lfKZ3t0hckMpIolrA3RZwhTk5pz
         DcTQ==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-6-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 30, 2018 at 09:53:46PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> To know when to create a blkg, the general pattern is to do a
> blkg_lookup and if that fails, lock and then do a lookup again and if
> that fails finally create. It doesn't make much sense for everyone who
> wants to do creation to write this themselves.
> 
> This changes blkg_lookup_create to do locking and implement this
> pattern. The old blkg_lookup_create is renamed to __blkg_lookup_create.
> If a call site wants to do its own error handling or already owns the
> queue lock, they can use __blkg_lookup_create.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

It looks a bit weird w/o actual users, might be worthwhile to mention
that future patches will add users.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
