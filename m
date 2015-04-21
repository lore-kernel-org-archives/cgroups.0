From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 12/49] writeback: move backing_dev_info->bdi_stat[] into
 bdi_writeback
Date: Tue, 21 Apr 2015 11:02:29 -0400
Message-ID: <20150421150229.GA9455@htj.duckdns.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
 <1428350318-8215-13-git-send-email-tj@kernel.org>
 <20150420150231.GA17020@quack.suse.cz>
 <20150420175626.GB4206@htj.duckdns.org>
 <20150421085119.GA24278@quack.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zWd9chiozwM6uBIRWj5aQM3li5bIEW7M7NWdOIy0Qx4=;
        b=k1AUMiDlWM+UGMPJJ8Xj0Uz3WYPSdd/o/SJ+iJeuwsIP8GmOSLocS2HjVmFlx7ilK7
         RHfIudueeVWuikArU0F/6PUvi97I0yI6+kosFucPz/uJnDfNIrhF3Uw8rcslSJwPts/i
         dGZFY0NahXwZuFV6KvZiS1Q4rXEQ6hyJR+WRFS0GS74dHC+9sHM0nQnRYgfMJ6eX/6QS
         8e/68zSGYhA9tZfa2oTITluu1GslXmNU8EHcXIIRzl9WkEyOdCK/nRLCQG4uj4sjUNCQ
         Wp61wQ/05KqnkNOAgbGBWcCWoCsSoMtV9by865TeC9fqkXMuolnPSGu4pLRJ/6KzjTsD
         /pzA==
Content-Disposition: inline
In-Reply-To: <20150421085119.GA24278@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trond.myklebust@primarydata.com>

On Tue, Apr 21, 2015 at 10:51:19AM +0200, Jan Kara wrote:
>   I can easily understand what "initializing writeback structure" means but
> "exiting writeback structure" doesn't really make sense to me. OTOH
> "destroying writeback structure" does make sense to me. That's the only
> reason.

We have enough cases where "exit" is used that way starting with
module_exit() and all the accompanying __exit annotations and there
are quite a few others.  I think it's enough to establish "exit" as
the counterpart of "init" but I do agree that it felt a bit alien to
me at the beginning too.

In general, I've been sticking with create/destroy if the object
itself is being created or destroyed and init/exit if the object
itself stays put across init/exit which is the case here.  This isn't
quite universal but I think there exists enough of a pattern to make
it worthwhile to stick to it.  As such, I'd like to stick to the
current names if it isn't a big deal.

Thanks.

-- 
tejun
