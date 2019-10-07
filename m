From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: short-circuit current_cgns_cgroup_from_root() on
 the default hierarchy
Date: Mon, 7 Oct 2019 07:04:33 -0700
Message-ID: <20191007140433.GC3404308@devbig004.ftw2.facebook.com>
References: <20190929080658.11430-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mpNfxUl1mCUdiXjigudrtwHaG1qAsCzBGZZW+s8y3Fo=;
        b=Um7Uzaoy6WSIMMNIRXztMQowXtuRFa7RULiv7B9t5bBMGNXcozcvndCrdDyXlOfiPZ
         Lq0/fy/VmhNyhoH8BCKnypBZ9GOl99U+VqFX4quLcIYC4A7UfXN7mJ+pQMgphzZ1QYrf
         A/n3W1h5crEuesmUr9jYQI3o9hXR3So2qOBxqrINQ6fMNRHiu3yzeTePxIBzBYG85aPR
         13AUWabvuF7GX2ePud2dCkGuJ9eyq4PBNikP2XbLEwE/o2gQHCK1pn2lPIxnlnAa+aR/
         1J/kuQnVSnRHCp/SYbYipfo5WDD9cKYEKq/tqOGNoWBdpADyvE5Lqi7i26hK9O9eB2lo
         ikqw==
Content-Disposition: inline
In-Reply-To: <20190929080658.11430-1-linmiaohe@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, mingfangsen@huawei.com

On Sun, Sep 29, 2019 at 04:06:58PM +0800, Miaohe Lin wrote:
> Like commit 13d82fb77abb ("cgroup: short-circuit cset_cgroup_from_root() on
> the default hierarchy"), short-circuit current_cgns_cgroup_from_root() on
> the default hierarchy.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied to cgroup/for-5.5.

Thanks.

-- 
tejun
