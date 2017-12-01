From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v13 5/7] mm, oom: add cgroup v2 mount option for
 cgroup-aware OOM killer
Date: Fri, 1 Dec 2017 13:15:38 +0000
Message-ID: <20171201131530.GA7741@castle.DHCP.thefacebook.com>
References: <20171130152824.1591-1-guro@fb.com>
 <20171130152824.1591-6-guro@fb.com>
 <20171201084113.47lnuo3diwxts732@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=HyT5Mgl/ePgtKIKXyWrArfKYY+mLV06rEFnwwf/4LzU=;
 b=RHV6AEIqmr1SXMqnGr6Y1tv6g/EPTQw3b0f/ErhZH/3+3m2u5viM0yBqjWugt8A1vKXO
 kEMDMaI9abWFlXHsTmLT3EkLOe/mIvL9zL+oHq5iIKvNDNIemM1ukT5ZqHQ/tF/aabg8
 8baqcrEfYmJPw/dNAowRdNoTktuq/efGHlc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HyT5Mgl/ePgtKIKXyWrArfKYY+mLV06rEFnwwf/4LzU=;
 b=dgoxjsvE7fK83sQDKyPrJ7H6ZpaTo9U7d+DDHnK7rnL4CC+F+RwebgFLDFkxXl0Fp32nw7ig8zZZzAn0LxS8VRLm96qMcQLWYzWtDVtdo49vDVW5BH5YSyDrJdXK3oqYgzJ+8Rb2IrllJDY6f+seUs1XztnJII3GOoV0zzPdXYs=
Content-Disposition: inline
In-Reply-To: <20171201084113.47lnuo3diwxts732@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Fri, Dec 01, 2017 at 09:41:13AM +0100, Michal Hocko wrote:
> On Thu 30-11-17 15:28:22, Roman Gushchin wrote:
> > Add a "groupoom" cgroup v2 mount option to enable the cgroup-aware
> > OOM killer. If not set, the OOM selection is performed in
> > a "traditional" per-process way.
> > 
> > The behavior can be changed dynamically by remounting the cgroupfs.
> 
> Is it ok to create oom_group if the option is not enabled? This looks
> confusing. I forgot all the details about how cgroup core creates file
> so I do not have a good idea how to fix this.

I don't think we do show/hide interface files dynamically.
Even for things like socket memory which can be disabled by the boot option,
we don't hide the corresponding stats entry.

So, maybe we just need to return -EAGAIN (or may be -ENOTSUP) on any read/write
attempt if option is not enabled?

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
