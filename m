From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block/for-next] IO cost model based work-conserving
 porportional controller
Date: Fri, 14 Jun 2019 10:56:42 -0700
Message-ID: <20190614175642.GA657710@devbig004.ftw2.facebook.com>
References: <20190614015620.1587672-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rr4DhL8mkbmYJTu+prptdDL5l4mcP175r2QLE+Qn8CA=;
        b=cLJE6Rf50VcaPIRaV80FOsBwRwK4nUuYdTa5x8SSx7ww6xsZtzmNPaHRzNFTqODvt6
         /hDunowkAFc2MbCFwhosFbE8+tPmvxmQRmpC52XUQF980dU32Z/0oL5rfh3XNrTNYbFv
         KriO0fhfVsUT+A9lhgqJbmINYpztEe4MklT1Ldi/Vti1KUej1yYg4tDVt3hgO+0jTOpz
         5Fj80H6LyQIWI99RhAp20XnOEHvpU96YrUa8/k5wkGWwVitKTO6pO/6rPbClA3iQm2IW
         4fu7vDzS8uvA/oeFzyyU9Ar2Hi+EglXMSWAaTbVT0DVcRnsuLKZdJlnI/97tTg2cJhpu
         KCAA==
Content-Disposition: inline
In-Reply-To: <20190614015620.1587672-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org

On Thu, Jun 13, 2019 at 06:56:10PM -0700, Tejun Heo wrote:
...
> The patchset is also available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-iow

Updated patchset available in the following branch.  Just build fixes
and cosmetic changes for now.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-iow-v2

Thanks.

-- 
tejun
