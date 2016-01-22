From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Documentation: cgroup v1: remove section about subsystem
 as a module.
Date: Fri, 22 Jan 2016 11:11:31 -0500
Message-ID: <20160122161131.GI32380@htj.duckdns.org>
References: <1452779165-15567-1-git-send-email-rami.rosen@intel.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=EG+kWwpDrin5pQZD25GLJ5RyDQLtQaPBQm252M6YbOE=;
        b=vr/sWv6C369xwH0PCmI24rUZUjhmw1iJaok2tEHC5bJZap+wp35OV/P6bT8VjdlQ9R
         Wnd1Ige+nfpS2NgftZ1qglMQSFa0U/g2R5CwTXVkpiP5XStNOUf2RnUFNdxJPWHhmP9x
         zIX5wdE8tattlNm3hEEW790SyOwQO/jN3sWvjOEiOrWWXh2zvHC9+nGAGt4/8rwVw5Dn
         I23EhegXCAW71LviB29fy4EcvKDVkTUaBudvpmJH4A4wWABrLg1xUkMCJUMl8ymAHEXk
         GztOEggwoBstzCuUbmNgubos+YRTfIyPBlN90e9875/NB/74sANK1t5Tom4Jwn2TpSB8
         lQWg==
Content-Disposition: inline
In-Reply-To: <1452779165-15567-1-git-send-email-rami.rosen@intel.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rami Rosen <rami.rosen@intel.com>
Cc: cgroups@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net

On Thu, Jan 14, 2016 at 03:46:05PM +0200, Rami Rosen wrote:
> This patch removes the text relating to compiling cgroup as a module,
> since commit  3ed80a62bf95 ("cgroup: drop module support") makes this text not
> relevant anymore.
> 
> Signed-off-by: Rami Rosen <rami.rosen@intel.com>

Applied to cgroup/for-4.5-fixes.

Thanks.

-- 
tejun
