From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Date: Tue, 9 Jul 2013 06:16:46 -0700
Message-ID: <20130709131646.GC2478@htj.dyndns.org>
References: <20130708100046.14417.12932.stgit@zurg>
 <20130708170047.GA18600@mtj.dyndns.org>
 <20130708175201.GB9094@redhat.com>
 <20130708175607.GB18600@mtj.dyndns.org>
 <51DBC99F.4030301@openvz.org>
 <20130709125734.GA2478@htj.dyndns.org>
 <51DC0CE2.2050906@openvz.org>
 <20130709131605.GB2478@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=JtxsTalZ9glj0/16Fz3g21pf5K0vGmBHQMq0b0Y79ro=;
        b=baeNAxXNaiZ8pPUQUHTdgxQ88FB8rROUqLGVu+XxTFap2IZyAD6fvUf69HvdjjelWw
         Y3Hlu4DWwUpHl9ejJODVuHip+g5e13X+UXebSKAx5Xh2kpglepKFuKCsvcJGzE138COD
         K9Xe3460YjJboWlnu2g6kd/8x0O3/pHuF7RlY/Eg8NEXzcqRLYEleMLA5qjPh4TelTr2
         30iYpg5WvlITgWDqfug134rh68m9Hyliha8cI6SUqkYsYPD7TexE44KqRDsWVQ0NBZos
         q3HTU7woXNNchtyJF4dCYGzXXRaSvxEAg2Nk/LLG9nhpFZWOy0J/xhCPuT59LW9EGEZc
         09SA==
Content-Disposition: inline
In-Reply-To: <20130709131605.GB2478@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org, Jens Axboe <axboe@kernel.dk>

On Tue, Jul 09, 2013 at 06:16:05AM -0700, Tejun Heo wrote:
> On Tue, Jul 09, 2013 at 05:15:14PM +0400, Konstantin Khlebnikov wrote:
> > blkio controls block devices. not filesystems or superblocks or bdi or pagecache.
> > It's all about block layer and nothing more. Am I right?
> > 
> > So, you want to link some completely unrelated subsystems like NFS into the block layer?
> 
> Heh, yeah, sure, network QoS is completely unrelated to sockets too,
> right?

And, no, blkio wouldn't have anything to do with NFS.  Where did you
get that idea?

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
