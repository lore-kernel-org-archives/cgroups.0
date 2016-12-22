From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [cgroup:review-cgroup-reorg 7/13]
 kernel/cgroup/cgroup.c:4764:16: sparse: incompatible types in comparison
 expression (different address spaces)
Date: Thu, 22 Dec 2016 12:02:45 -0500
Message-ID: <20161222170245.GA31216@htj.duckdns.org>
References: <201612210610.PJMy3KLl%fengguang.wu@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D2eZ6oVMQRjZdi5rAOaowEldW4MqF8PCVRgvdPqTFaw=;
        b=UCsz/Pyj2sfJYCCY89He+x+oOFNU1FdRyfisNW0Jlb5zdOZoKO1lEqCrCwvp/ux3Px
         WQ7n+rE2VGD7qBZ+3on+jq5yvAsTCTCkaF26JucclGEdml6AMAzpaz5/4MA/iIV+iqko
         jZmxamZM4ixWEsUXmJ5uSe3rAJyVM3mDO/jK6nPyvHtekkgHtZhsL+tx2NJqZqa+H0Dw
         iZxqH+yvQg6eGo0UKJme5jJeCmvMY38XYhB0QQBnICoiwtgEuwVWXLePUBsmeoTUo/uC
         gvhCLQy0D4jXc8FE9XmvUyQxuYkxq+mkpMn2sAUMwMMG1oIXB0RDeA/eiSaOeTb8/CXH
         S6bg==
Content-Disposition: inline
In-Reply-To: <201612210610.PJMy3KLl%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Dec 21, 2016 at 06:19:38AM +0800, kbuild test robot wrote:
> Hi Tejun,
> 
> First bad commit (maybe != root cause):
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-reorg
> head:   3fd6a2eec6783bff033e553a3773c897a7f93109
> commit: 71f76f958ba552114971653cdb56e5d8ce0b9988 [7/13] cgroup: move cgroup files under kernel/cgroup/
> reproduce:
>         # apt-get install sparse
>         git checkout 71f76f958ba552114971653cdb56e5d8ce0b9988
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF=-D__CHECK_ENDIAN__
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
>    include/linux/compiler.h:253:8: sparse: attribute 'no_sanitize_address': unknown attribute
> >> kernel/cgroup/cgroup.c:4764:16: sparse: incompatible types in comparison expression (different address spaces)
>    kernel/cgroup/cgroup.c:6248:16: sparse: incompatible types in comparison expression (different address spaces)
> 
> vim +4764 kernel/cgroup/cgroup.c

Ah, okay, I should add explicit cast to rcu address space.  This isn't
new but is being counted as new due to the code move.  I'll queue up a
patch to fix them up.

Thanks.

-- 
tejun
