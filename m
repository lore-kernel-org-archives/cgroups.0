From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cpuset: Remove unused 'struct cpuset*' variable
Date: Mon, 28 Nov 2016 16:07:16 -0500
Message-ID: <20161128210716.GA12143@htj.duckdns.org>
References: <kirtika@chromium.org>
 <1480049712-17224-1-git-send-email-kirtika@chromium.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=SMVPBQd2qh8jsHIRJmTDmYYkNFS3ajG1pPwUiTWaeX8=;
        b=EQnNVPf9bPexKRgOt8TNOKwXUkXMM0xwdsi+gPnnQbGQ1cP9gGlyjB8dIn1aMAx2go
         jFwi+O4xxAcJL5JI5NbGNAleflV6+gNnm/fLelwqKW2hw6/i+X8MRIn369Yp/Oj5zMCf
         LQMPPXJ491xXZb+G77buXyaOQHiVafxY+DQ3cwM1mf3s3XWGPv7ky/oKicLhO1kF/+zx
         3RwmvDVnVCKajEfDfycUTdnThoIY91UVyrADjy6DyXj7LRmXsLOl9S2vBmwKwmTzNikK
         Yg/wZsDdapyr3tlPYi6sxXhAj/5n+AGaGKNd7mRJ8EGAvk76fRh4LlmfMDnfGic+VKXA
         ToFQ==
Content-Disposition: inline
In-Reply-To: <1480049712-17224-1-git-send-email-kirtika@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kirtika Ruchandani <kirtika@chromium.org>
Cc: Li Zefan <lizefan@huawei.com>, arnd@arndb.de, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Nov 24, 2016 at 08:55:12PM -0800, Kirtika Ruchandani wrote:
> 'struct cpuset* cs' that is set but not used, was introduced in commit
> 1f7dd3e5a6e4 ("cgroup: fix handling of multi-destination migration from subtree_control enabling").
> cpuset_cancel_attach() uses css_cs(css) instead. Compiling with W=1
> gives the folllowing harmless warning, which we'd like to fix to
> reduce the noise with W=1 in the kernel.
> 
> kernel/cpuset.c: In function ‘cpuset_cancel_attach’:
> kernel/cpuset.c:1502:17: warning: variable ‘cs’ set but not used [-Wunused-but-set-variable]
>   struct cpuset *cs;
>                  ^
> 
> Fixes: 1f7dd3e5a6e4 ("cgroup: fix handling of multi-destination migration from subtree_control enabling").
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Kirtika Ruchandani <kirtika@chromium.org>

Applied to cgroup/for-4.10.

Thanks.

-- 
tejun
