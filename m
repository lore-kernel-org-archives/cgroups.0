From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: minor tweak for logic to get cgroup css
Date: Mon, 8 Jul 2019 10:31:37 -0700
Message-ID: <20190708173137.GH657710@devbig004.ftw2.facebook.com>
References: <20190703020749.22988-1-rocking@whu.edu.cn>
 <20190708164243.GE657710@devbig004.ftw2.facebook.com>
 <20190708172944.GA24662@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F3Z8ODmIuThf6qIMsRJ9IwagYSAnPtGl9RN+7VHHChg=;
        b=aqE1xvZMtT7tlMKN0uI2aPhS+B7q7NPQx57ZzTXE3rm2BGvJMUQYHZdGbsSR+ZNHfg
         KfCyif2Z5T+CAzVEI8+uNEiuZ86jaLvvcnbumD1DftZwskChw61iCaejgttVDYeo+puX
         EMcYe4mqQRkut1balpM3jphqF+6LvTpJVgsDGjeKNcaL2HrtEEceP6faQACtVF2GbCnH
         EnfW9OChjLrUTnLaic14bALWa2BZWvwWjb4HbOhssw6ZZDbanIOucVyKb3DXFQID3zzN
         6PaxqH4Gy69wl4Cd+/ST6a+M1Yks+kZdteW72v8EtAfrgEC6A0/zqxo7tvMMEc0VlKUl
         /AcA==
Content-Disposition: inline
In-Reply-To: <20190708172944.GA24662@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Peng Wang <rocking@whu.edu.cn>, "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, Jul 08, 2019 at 05:29:49PM +0000, Roman Gushchin wrote:
> On Mon, Jul 08, 2019 at 09:42:43AM -0700, Tejun Heo wrote:
> > On Wed, Jul 03, 2019 at 10:07:49AM +0800, Peng Wang wrote:
> > > We could only handle the case that css exists
> > > and css_try_get_online() fails.
> > 
> > As css_tryget_online() can't handle NULL input, this is a bug fix.
> > Can you please clarify that in the description?
> 
> -       if (!css || !css_tryget_online(css))
> +       if (css && !css_tryget_online(css))
> 
> If css == NULL, !css is true, and the second part of the || statement
> will not be evaluated. So it's not a bug fix.

Ah right, it's just confusing.  Will apply after the merge window.

Thanks.

-- 
tejun
