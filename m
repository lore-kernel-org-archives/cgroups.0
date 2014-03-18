From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: fix a failure path in create_css()
Date: Tue, 18 Mar 2014 12:12:25 -0400
Message-ID: <20140318161225.GD3642@htj.dyndns.org>
References: <53280BAC.5060404@huawei.com>
 <20140318152445.GA3642@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=uojHUgXDQUH89AzuIed7QAYvXEXQMZG3erAgO6oOlX4=;
        b=EF4d8rd1LWk/s9V3/XiyIlL1WK1Cxh1KXXG0eUWBP+0wjRL05VhhbPUUDUpmFgoa/g
         lPgFxx/C7l2T3DGcixSOiGkWZY+bMhLRgYHBkVYzuuFpn6PTd69G4EazOWl81G3xT4ga
         7/XFZo1pv13YbOIk7TweZdkhXlQ3NrCw5c32i/XHEOVfgsUkK0ANyVc98joMyzdzI1Jt
         N3OX9HnDfHOZTEvvqOLvrSEMMc9iZCn2/UGpcbvOY06Mj8zFpTpbtyquxoDP6xaQ9zHw
         plqHGDRE9X14YmH3kgpljl1LY6t5+pM7dbBklzSQ230C/zAfJg/ZkyMz7tvpUrPrzHYn
         3muQ==
Content-Disposition: inline
In-Reply-To: <20140318152445.GA3642@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Tue, Mar 18, 2014 at 11:24:45AM -0400, Tejun Heo wrote:
> On Tue, Mar 18, 2014 at 05:02:36PM +0800, Li Zefan wrote:
> > If online_css() fails, we should remove cgroup files belonging
> > to css->ss.
> > 
> > Signed-off-by: Li Zefan <lizefan@huawei.com>
> 
> Applied to libata/for-3.14-fixes.

Hmmm... didn't apply cleanly and generated build error.  Looks like
the patch was generated against for-3.15.  Can you please regenerate
the patch against for-3.14-fixes?

Thanks.

-- 
tejun
