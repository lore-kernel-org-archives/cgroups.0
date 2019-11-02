From: Damian Tometzki <damian.tometzki@familie-tometzki.de>
Subject: Re: [PATCH] mm/memcontrol: update documentation about invoking oom
 killer
Date: Sat, 2 Nov 2019 17:02:53 +0100
Message-ID: <20191102160252.GA19103@freebsd.familie-tometzki.de>
References: <157270779336.1961.6528158720593572480.stgit@buzz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=familie-tometzki.de; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ef9ou+qj0vagMx1XNPM66HwZ5oa8tbdOa32pNN49rmM=;
        b=LvJWdLOfXa28+18z0vfIwt2vXO10BiJMLLj1cghAiBcYuUCfXtVKu+qQDkJuNiIsv2
         eg1QR09wz+rMzdgxFRcKQZHEuFmmsjf6ywdbbgGETt88yEgQvC3oFTsM6E2Ex0iCrTv1
         QcSSJgi0P+WBF8w8p3kW1exS+wO22ORwxawtc2wMk2xBPZS/Bf64+msLGc/BYX5H+xs8
         V7lPow+YCJoRbFlqGt3uBDaIQt9FpU6i4+/vE5m4j4Hd/ajoaeCjlywmBpqxCB+rbjKZ
         FecRb5+ftAldNmWA7D1jiQftbb2nUm3LlxyP/8W3YTmIe37KgZZqFlAn1lbQI8nlTl4V
         u6aw==
Content-Disposition: inline
In-Reply-To: <157270779336.1961.6528158720593572480.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.com>

On Sat, 02. Nov 18:16, Konstantin Khlebnikov wrote:
> Since commit 29ef680ae7c2 ("memcg, oom: move out_of_memory back to the
> charge path") memcg invokes oom killer not only for user page-faults.
> This means 0-order allocation will either succeed or task get killed.
> 
> Fixes: 8e675f7af507 ("mm/oom_kill: count global and memory cgroup oom kills")
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> ---
>  Documentation/admin-guide/cgroup-v2.rst |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 5361ebec3361..eb47815e137b 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1219,8 +1219,13 @@ PAGE_SIZE multiple when read back.
>  
>  		Failed allocation in its turn could be returned into
>  		userspace as -ENOMEM or silently ignored in cases like
> -		disk readahead.  For now OOM in memory cgroup kills
> -		tasks iff shortage has happened inside page fault.
> +		disk readahead.
> +
> +		Before 4.19 OOM in memory cgroup killed tasks iff
Hello Konstantin,

iff --> if :-)

Best regards
Damian


> +		shortage has happened inside page fault, random
> +		syscall may fail with ENOMEM or EFAULT. Since 4.19
> +		failed memory cgroup allocation invokes oom killer and
> +		keeps retrying until it succeeds.
>  
>  		This event is not raised if the OOM killer is not
>  		considered as an option, e.g. for failed high-order
> 
