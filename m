From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2 2/3] blkcg: introduce io.sync_isolation
Date: Thu, 7 Mar 2019 17:11:27 -0500
Message-ID: <20190307221125.hy2j76m6tv7vnjpr@macbook-pro-91.dhcp.thefacebook.com>
References: <20190307180834.22008-1-andrea.righi@canonical.com>
 <20190307180834.22008-3-andrea.righi@canonical.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FHC23kKOOD8L5WKDG46G396bmkMA7Azge/SSFHjSA8k=;
        b=LCTOpdFAw92Re/ux6wXEumAMdp9TKQwpTrSs5Lh/Qfasc2H2gJ2JHORCOPqt1avoZp
         1tmaIxawMjWKMK8d+zD5JXjklFfimS9r/BqlbkyxHnTZO3x7cQwNnqJ6es6GzRicctNr
         EaB7LXmyAAXYzveD3svhTn+/IauwuK4QoRDoCm2/Sa1cRGHc3hk/h2+0fA/HPC4JljMg
         eiBJ55Ma79JLsP+jPuXuNBQYRQXn0ouq7/HS6Awte0dQHoJnfCAUHQbnT3JVi8TC+/t2
         IAmlCYL0po73tQ2RrijK8nFHuYWuO0Irn89uBprLX2gDt0zoB7NLVDWnzkdl4ndXwcmc
         424Q==
Content-Disposition: inline
In-Reply-To: <20190307180834.22008-3-andrea.righi@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrea Righi <andrea.righi@canonical.com>
Cc: Josef Bacik <josef@toxicpanda.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Paolo Valente <paolo.valente@linaro.org>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, Mar 07, 2019 at 07:08:33PM +0100, Andrea Righi wrote:
> Add a flag to the blkcg cgroups to make sync()'ers in a cgroup only be
> allowed to write out pages that have been dirtied by the cgroup itself.
> 
> This flag is disabled by default (meaning that we are not changing the
> previous behavior by default).
> 
> When this flag is enabled any cgroup can write out only dirty pages that
> belong to the cgroup itself (except for the root cgroup that would still
> be able to write out all pages globally).
> 
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
