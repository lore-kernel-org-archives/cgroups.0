From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: remove unused member "cgrp_ancestor_id_storage"
 in struct cgroup_root
Date: Tue, 27 Nov 2018 01:28:59 -0800
Message-ID: <20181127092859.GC2509588@devbig004.ftw2.facebook.com>
References: <20181127065357.28130-1-rocking@whu.edu.cn>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3tECLqTkzFOjFCy4pDgJ59MTjzCv98LoBr5PspWdCgI=;
        b=qVMdZIudvMC2OTME8ZOMUm3eUfKK2siVbKT9hbBaUVdfwBf82p3ZwW2TKTtnM9tcC8
         4Sqk0nsKeO+zhMu41M5Tg50V9ko29928unxXxSmVG6t3MKssXScO6iBmQoKfZb9q4L+o
         8MxbLLBXU9PTSPbIKsXmXUTASbAyb1Bvbi/ffYkkb+ENjb+/azKEP179lglIiNu56qBf
         9T5PQ00+Oot5PqqKEjhd0/o06J5KiJ0G6DznoNn/r4qaftEfebbq9Q83+mSLYpcbaThc
         cIQzJ8xcKmd/YIBfQzU51LLrLRgS8DETxKpx1Zvswcfdj3hprAMqTPV/Km/YhNOPN0jk
         iuDg==
Content-Disposition: inline
In-Reply-To: <20181127065357.28130-1-rocking@whu.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peng Wang <rocking@whu.edu.cn>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 27, 2018 at 02:53:57PM +0800, Peng Wang wrote:
> "cgrp_ancestor_id_storage" is not used, so let's clean it up.

It is being used.

Thanks.

-- 
tejun
