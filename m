From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 1/3] misc_cgroup: add support for nofile limit
Date: Tue, 27 Jul 2021 21:41:40 -1000
Message-ID: <YQEKNPrrOuyxTarN@mtj.duckdns.org>
References: <3fd94563b4949ffbfe10e7d18ac1df3852b103a6.1626966339.git.brookxu@tencent.com>
 <YP8ovYqISzKC43mt@mtj.duckdns.org>
 <b2ff6f80-8ec6-e260-ec42-2113e8ce0a18@gmail.com>
 <YQA1D1GRiF9+px/s@mtj.duckdns.org>
 <ca2bdc60-f117-e917-85b1-8c9ec0c6942f@gmail.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3gyKs31H8DmWFPMAtNTmsj5Y1115XQKa+6v265+MF98=;
        b=QPu+Xan/QfEel2lNwA6ZQhbMilq9UteGKnrllrkZPvNwLRhg0S3qj4s90qHn2xz5l8
         gTSMklmYaUeB6fQPHQZHVY9jPgtLDojxLzKnpdRSZioEB7reKaZgUPaMaIZ9eed02LuH
         PpJy0MsbsyXcon9DIIBmRgTe4UZ9bSc93nUgMeheh7F99nvyA5VCd4LCEPyJf1lSRwf0
         xjzGAPFL+1bDLKkPhTczAZtX5/upHfbIdvsDahSHga7KNj7W1A6bfjRrtqgHIHX30G4z
         8CaicVMaFgOhxTm1spcOTKAuqHil3FpknfxE9g0U9NbnlUOPYHw65wPWYlaNKuR8ueZH
         OxTw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <ca2bdc60-f117-e917-85b1-8c9ec0c6942f@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn@gmail.com>
Cc: viro@zeniv.linux.org.uk, lizefan.x@bytedance.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Wed, Jul 28, 2021 at 11:17:08AM +0800, brookxu wrote:
> Yeah we can adjust file-max through sysctl, but in many cases we adjust it according
> to the actual load of the machine, not for abnormal tasks. Another problem is that in
> practical applications, kmem_limit will cause some minor problems. In many cases,
> kmem_limit is disabled. Limit_in_bytes mainly counts user pages and pagecache, which
> may cause files_cache to be out of control. In this case, if file-max is set to MAX,
> we may have a risk in the abnormal scene, which prevents us from recovering from the
> abnormal scene. Maybe I missed something.

Kmem control is always on in cgroup2 and has been in wide production use for
years now. If there are problems with it, we need to fix them. That really
doesn't justify adding another feature.

Thanks.

-- 
tejun
