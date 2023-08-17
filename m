From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Thu, 17 Aug 2023 11:57:02 -1000
Message-ID: <ZN6Xrsssr4Pys8YQ@slm.duckdns.org>
References: <ZN5WkbPelHUSTXOA@work>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692309424; x=1692914224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z0omXZny2n+CByL2k7ciGeHHMSQ9u/agRJB2cjviSi4=;
        b=hr056v+KwQCD7KsAAiffnt/3sSt1kTIcf8ne4SKRK1o44FszUJAWCBrFUQsZHgYJDd
         bTx5INJz3ICUgZz0sm7keyITgp8HsgzZ5fohuetFK5lXFrlPf34LBKJauHkvKMfd+HWR
         rSkXHrHmvgzDtHH9FbA4JhNetRxt06m8trUlP4HeA8yKYy4R9AoHI/uo/u4JVQy+wmR+
         NRbSgaY2wzwBttQN0mjQtVyq6GMvxh+wPKKLjiow1eQwe/MqfXp0XZ08TJ0tD85qGHep
         zaK8DfYd9FSX3Ds78+mMzfluB+IRK6o7PCoOqHPsCa8To8OnwauvRZPsxxGUDk3gt1Bu
         GyAw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <ZN5WkbPelHUSTXOA@work>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org

On Thu, Aug 17, 2023 at 11:19:13AM -0600, Gustavo A. R. Silva wrote:
> Change the notation from pointer-to-array to pointer-to-pointer.
> With this, we avoid the compiler complaining about trying
> to access a region of size zero as an argument during function
> calls.
> 
> This is a workaround to prevent the compiler complaining about
> accessing an array of size zero when evaluating the arguments
> of a couple of function calls. See below:
> 
> kernel/cgroup/cgroup.c: In function 'find_css_set':
> kernel/cgroup/cgroup.c:1206:16: warning: 'find_existing_css_set' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
>  1206 |         cset = find_existing_css_set(old_cset, cgrp, template);
>       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> kernel/cgroup/cgroup.c:1206:16: note: referencing argument 3 of type 'struct cgroup_subsys_state *[0]'
> kernel/cgroup/cgroup.c:1071:24: note: in a call to function 'find_existing_css_set'
>  1071 | static struct css_set *find_existing_css_set(struct css_set *old_cset,
>       |                        ^~~~~~~~~~~~~~~~~~~~~
> 
> With the change to pointer-to-pointer, the functions are not prevented
> from being executed, and they will do what they have to do when
> CGROUP_SUBSYS_COUNT == 0.
> 
> Address the following -Wstringop-overflow warnings seen when
> built with ARM architecture and aspeed_g4_defconfig configuration
> (notice that under this configuration CGROUP_SUBSYS_COUNT == 0):
> 
> kernel/cgroup/cgroup.c:1208:16: warning: 'find_existing_css_set' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:1258:15: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:6089:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:6153:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> 
> This results in no differences in binary output.
> 
> Link: https://github.com/KSPP/linux/issues/316
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
