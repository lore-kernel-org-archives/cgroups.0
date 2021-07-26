From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 1/3] misc_cgroup: add support for nofile limit
Date: Mon, 26 Jul 2021 11:27:25 -1000
Message-ID: <YP8ovYqISzKC43mt@mtj.duckdns.org>
References: <3fd94563b4949ffbfe10e7d18ac1df3852b103a6.1626966339.git.brookxu@tencent.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JSRAHigjjv7jacJe2YWp7PNC+/ka4N08e26oEa0Aa9k=;
        b=vO1nimpqJXQrBZ4leSkrJbZ3YGN9W/wrYuISF3NMXbsvyu5WBRTVBPLgzSDPtziFHY
         65H0a01M7/XYZIgfxU4uK5mASWykWuPkZIBEVwxcNMsv33oYcbdpH3X/UEtBtxUBhHJ7
         KCiab6cMLIKyWwQv0u2adMUb3CABoGTf+7ucPvDa/5XAuRNrmBYhU9+Mu8oLct4KPSz5
         RyprRMzzHcB3avW1LFbxYoOEZPohajO1dR+/6UyfW4blYyGEKH41gU0Mcnuuv9TrlVDr
         yBkxT/UlBlptW8ZUfLXkjm5GpEWbBRfR3OCKYfmlOZHD7KBhURnkzjlm1hGSlBALOSK2
         mMxA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <3fd94563b4949ffbfe10e7d18ac1df3852b103a6.1626966339.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn@gmail.com>
Cc: viro@zeniv.linux.org.uk, lizefan.x@bytedance.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Thu, Jul 22, 2021 at 11:20:17PM +0800, brookxu wrote:
> From: Chunguang Xu <brookxu@tencent.com>
> 
> Since the global open files are limited, in order to avoid the
> abnormal behavior of some containers from generating too many
> files, causing other containers to be unavailable, we need to
> limit the open files of some containers.
> 
> v2: fix compile error while CONFIG_CGROUP_MISC not set.
> 
> Signed-off-by: Chunguang Xu <brookxu@tencent.com>
> Reported-by: kernel test robot <lkp@intel.com>

This is different from pid in that there's no actual limit on how many open
files there can be in the system other than the total amount of available
memory. I don't see why this would need a separate limit outside of memory
control. A couple machines I looked at all have file-max at LONG_MAX by
default too.

Thanks.

-- 
tejun
