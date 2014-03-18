From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: fix a failure path in create_css()
Date: Tue, 18 Mar 2014 17:22:55 -0400
Message-ID: <20140318212255.GC32357@mtj.dyndns.org>
References: <53280BAC.5060404@huawei.com>
 <20140318152445.GA3642@htj.dyndns.org>
 <20140318161225.GD3642@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=f4y6fFb/OvG71rX+vmBqOxPWUp/ptrtoBt/HLDeHIxY=;
        b=QSEyAPRWHR9GEIw2wFyJ2gy9NW5c1daSrBog+BdlN5Lf2+FxhT+Issv3thI2t13CIL
         LbGuq67duyNU68k3nQaFTYRSsiT4SQ74UuDO/qR5Udhy73iiDG3x7HTan4y/hQvutTPf
         VLbK/1LsojNBsaCnCZU97roM3yjvnE2xGvGhMQCHWtZudexZeOqj1qt1fTeW7gHce70G
         nSzF8W+rf9t7XCYwQveIph6NrHEXbDqUKMYzDF+57VuOsm8NvDLUdJSVR7v+DgMzP2kT
         r1gqNJBt6Fhycr4Ppa6x7lf7CUQwCVvd0y5RgEfNr/1wCIdo0Jq9HkmeqKaoIeDFi4vm
         NHYw==
Content-Disposition: inline
In-Reply-To: <20140318161225.GD3642@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Tue, Mar 18, 2014 at 12:12:25PM -0400, Tejun Heo wrote:
> On Tue, Mar 18, 2014 at 11:24:45AM -0400, Tejun Heo wrote:
> > On Tue, Mar 18, 2014 at 05:02:36PM +0800, Li Zefan wrote:
> > > If online_css() fails, we should remove cgroup files belonging
> > > to css->ss.
> > > 
> > > Signed-off-by: Li Zefan <lizefan@huawei.com>
> > 
> > Applied to libata/for-3.14-fixes.
> 
> Hmmm... didn't apply cleanly and generated build error.  Looks like
> the patch was generated against for-3.15.  Can you please regenerate
> the patch against for-3.14-fixes?

Never mind.  Fixed up and applied to for-3.14-fixes.

Thanks.

-- 
tejun
