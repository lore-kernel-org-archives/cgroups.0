From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH -next] writeback: fix -Wformat compilation warnings
Date: Wed, 20 Nov 2019 14:56:18 -0500
Message-ID: <1574279778.9585.15.camel@lca.pw>
References: <20191114192118.GK4163745@devbig004.ftw2.facebook.com>
         <9D52EBB0-BE48-4C59-9145-857C3247B20D@lca.pw>
         <20191115145540.GP4163745@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6PqYdDpGGWCVE8hu3feKwX1cy6I6vx26jAUo36ByRBc=;
        b=MZEMAgymPpZPMZFpCP0c+tUdsx1npLc9lS3L/V9/tx62cvHYOeIPRnzn7p717XyhAm
         KHi54PubUolzF062CMNG+QkztdlBCa7wbspw1gLZmLlo3X0wlY5H6n6AEG6FRE0B/H23
         BwxTLLSFA3mRWpmL4bkoHrYY9LQUFF2xKADYrGrZEeFWj4DsouiRMvYEctSUBmdSDCVp
         WSC7oPn+3jSUTY+5KCv/PsFm9FRKMSZrcLZ9tTtROPTg0SMHdos/Y4JWidv7RMzCy7C2
         rY7CtlEh2VfFEDq1ay7a/Dz61hnBUhCGYvgtugs6v4hCrQuw8ClqztIVHOImNSN25+Hs
         9lcA==
In-Reply-To: <20191115145540.GP4163745@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: jack@suse.cz, gregkh@linuxfoundation.org, cgroups@vger.kernel.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com, linux-s390@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org

On Fri, 2019-11-15 at 06:55 -0800, Tejun Heo wrote:
> On Thu, Nov 14, 2019 at 07:26:21PM -0500, Qian Cai wrote:
> > 
> > 
> > > On Nov 14, 2019, at 2:21 PM, Tejun Heo <tj@kernel.org> wrote:
> > > 
> > > Acked-by: Tejun Heo <tj@kernel.org>
> > 
> > Tejun, suppose you will take this patch via your tree together with the series or should I Cc Andrew who normally handle this file?
> 
> Patches in this area usually goes through Jens's block tree.

I remember that last time Jens had no interests in picking up trivial patches
like this one. See the commit d1a445d3b86c ("include/trace/events/writeback.h:
fix -Wstringop-truncation warnings").

Andrew, care to pick up this again?

https://lore.kernel.org/lkml/1573751861-10303-1-git-send-email-cai@lca.pw/
